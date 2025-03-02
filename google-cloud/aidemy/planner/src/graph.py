import logging
from langchain_google_vertexai import ChatVertexAI
from langchain_core.messages import HumanMessage, SystemMessage
from langgraph.graph import StateGraph, START, END, MessagesState
from langgraph.prebuilt import ToolNode, tools_condition
from langgraph.checkpoint.memory import MemorySaver
from tool_book import recommend_book
from tool_curriculums import get_curriculum
from tool_search import search_latest_resource
from utils import get_llm, get_required_env_var

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Define tools
tools = [get_curriculum, search_latest_resource, recommend_book]

# Configuration 
project_id = get_required_env_var("GOOGLE_CLOUD_PROJECT")

    
def determine_tool(state: MessagesState):
    """
    Determine which tool to use next or if we should generate the final teaching plan.
    """
    llm = get_llm(project_id)
    
    sys_msg = SystemMessage(
        content=(
            """You are a helpful teaching assistant that helps teachers prepare for classes.
            
            PROCESS:
            1. First, gather all the necessary information using available tools:
               - Get the relevant curriculum with get_curriculum
               - Find book recommendations with recommend_book
               - Search for latest teaching resources with search_latest_resource
            
            2. After gathering all necessary information, create a comprehensive 3-week teaching plan.
            
            3. When you have enough information, don't call any more tools. Instead, synthesize the information 
               into a detailed teaching plan with specific activities for each week.
               
            4. Your final teaching plan should include:
               - Learning objectives based on the curriculum
               - Week-by-week breakdown of topics
               - Recommended readings/activities from the books
               - Suggested resources to use in class
               - Assessment strategies
            """
        )
    )

    llm_with_tools = llm.bind_tools(tools)
    return {"messages": llm_with_tools.invoke([sys_msg] + state["messages"])}

def should_continue(state: MessagesState) -> str:
    """
    Determine if we should continue calling tools or generate the final teaching plan.
    """
    last_message = state["messages"][-1]
    
    # If the last message doesn't call a tool, we're done
    if not last_message.tool_calls:
        return "gen_teaching_plan"
    
    # If it calls a tool, continue with tool execution
    return "tools"

def generate_teaching_plan(state: MessagesState):
    """
    Generate the final teaching plan based on collected information.
    """
    try:
        llm = get_llm(project_id)
        
        # Extract information gathered so far
        curriculum_info = "Not available"
        book_info = []
        resource_info = "Not available"
        
        # Extract the original user request from the first message
        original_request = ""
        year = "5"  # Default
        subject = "Mathematics"  # Default
        topic = "Geometry"  # Default
        
        if state["messages"] and hasattr(state["messages"][0], 'content'):
            original_request = state["messages"][0].content
            logger.info(f"Original request: {original_request[:100]}...")
            
            # Try to extract year, subject and topic from the request
            if "year" in original_request.lower():
                # Look for patterns like "year 6" or "year 7"
                import re
                year_match = re.search(r'year\s+(\d+)', original_request.lower())
                if year_match:
                    year = year_match.group(1)
            
            # Extract subject - check for common subject names
            subject_keywords = {
                "mathematics": "Mathematics",
                "math": "Mathematics",
                "english": "English",
                "science": "Science",
                "computer science": "Computer Science",
                "history": "History",
                "geography": "Geography"
            }
            
            for keyword, proper_name in subject_keywords.items():
                if keyword in original_request.lower():
                    subject = proper_name
                    break
                    
            # Try to extract a specific topic - this is usually mentioned after the subject
            # or as part of the "covering" phrase
            if "covering" in original_request.lower():
                covering_parts = original_request.lower().split("covering")[1].split()
                if covering_parts:
                    topic = covering_parts[0].strip(",.: ").capitalize()
            elif "focus" in original_request.lower():
                focus_parts = original_request.lower().split("focus")[1].split()
                if focus_parts and len(focus_parts) > 1:
                    topic = focus_parts[1].strip(",.: ").capitalize()
            elif "geometry" in original_request.lower():
                topic = "Geometry"
            elif "algebra" in original_request.lower():
                topic = "Algebra"
        
        # Process previous messages to extract tool results
        for msg in state["messages"]:
            if hasattr(msg, 'tool_call_id') and hasattr(msg, 'content'):
                content = msg.content
                if isinstance(content, str) and "curriculum" in content.lower():
                    curriculum_info = content
                elif isinstance(content, list) and len(content) > 0:
                    # Handle book info
                    book_info = content
                elif isinstance(content, str) and len(content) > 300:
                    resource_info = content
        
        # Format book information more readably
        formatted_books = "No books available"
        if book_info and isinstance(book_info, list):
            book_entries = []
            for book in book_info:
                if isinstance(book, dict) and "bookname" in book:
                    title = book.get("bookname", "Unknown")
                    author = book.get("author", "Unknown")
                    book_entries.append(f"- {title} by {author}")
            if book_entries:
                formatted_books = "\n".join(book_entries)
        
        # Log what we found
        logger.info(f"Creating teaching plan for Year {year} {subject} on {topic}")
        
        # Create a dynamic prompt based on the actual request
        prompt_content = f"""
Create a 3-week teaching plan for Year {year} {subject} focusing on {topic}.

Curriculum information:
{curriculum_info}

Recommended books:
{formatted_books}

Teaching resources:
{resource_info}

Your teaching plan should include:
1. Clear learning objectives based on the curriculum
2. Week-by-week breakdown of topics and activities
3. Suggested assessments for each week
4. Integration of recommended books and resources
5. Ideas for interactive activities and projects

Please format the plan clearly with sections for each week in markdown format.
"""
        
        try:
            # Use a HumanMessage for better compatibility
            human_msg = HumanMessage(content=prompt_content)
            
            # Generate with LLM
            plan_message = llm.invoke([human_msg])
            return {"messages": state["messages"] + [plan_message]}
        except Exception as e:
            logger.error(f"LLM generation failed: {str(e)}")
            
            # Handle different error types
            if "400" in str(e) or "contents field is required" in str(e):
                logger.warning("Empty content error, using fallback plan")
            elif "429" in str(e) or "Resource exhausted" in str(e):
                logger.warning("Rate limit hit, using fallback plan")
            else:
                logger.warning(f"Unknown error, using fallback plan: {e}")
            
            # Create a fallback plan with the extracted details
            fallback_plan = create_fallback_teaching_plan(
                curriculum_info, 
                book_info, 
                resource_info,
                year=year,
                subject=subject,
                topic=topic
            )
            return {"messages": state["messages"] + [HumanMessage(content=fallback_plan)]}
            
    except Exception as e:
        logger.error(f"Error in generate_teaching_plan: {e}")
        # Create a generic fallback plan
        fallback_plan = create_fallback_teaching_plan("", [], "")
        return {"messages": state["messages"] + [HumanMessage(content=fallback_plan)]}

def create_fallback_teaching_plan(curriculum_info, book_info, resource_info, year="5", subject="Mathematics", topic="Geometry"):
    """Create a fallback teaching plan without making API calls"""
    
    # Extract book titles if available
    book_titles = []
    if isinstance(book_info, list):
        for book in book_info:
            if isinstance(book, dict) and "bookname" in book:
                book_titles.append(book.get("bookname", ""))
    
    # Create a dynamic generic plan
    plan = f"""
# 3-Week Teaching Plan for Year {year} {subject}: {topic} [FALLBACK PLAN]

## Learning Objectives
- Understand key concepts in {topic}
- Develop skills in applying {subject} principles to {topic}
- Engage with {topic} through practical activities
- Assess progress through various assessment methods

## Week 1: Introduction to {topic}
### Day 1-2: Foundational Concepts
- Introduce basic {topic} terminology and concepts
- Explore key principles through guided examples
- Activity: Hands-on exploration of {topic}

### Day 3-4: Building Understanding
- Expand on foundational concepts
- Connect {topic} to real-world applications
- Activity: Collaborative group work

### Day 5: Assessment
- Quiz on basic concepts
- Reflection on learning so far

## Week 2: Developing Skills
### Day 1-2: Intermediate Concepts
- Introduce more complex aspects of {topic}
- Guided practice with increasing difficulty
- Activity: Problem-solving tasks

### Day 3-4: Applying Knowledge
- Connect concepts to broader {subject} curriculum
- Independent practice
- Activity: Creative application tasks

### Day 5: Assessment
- Mid-unit assessment
- Peer evaluation activities

## Week 3: Mastery and Application
### Day 1-2: Advanced Concepts
- Challenging applications of {topic}
- Cross-curricular connections
- Activity: Complex problem-solving

### Day 3-4: Project Work
- Apply learning to a culminating project
- Integration of all concepts
- Activity: Project development

### Day 5: Final Assessment
- Project presentations
- Final unit assessment
- Reflection and next steps
"""

    # Add curriculum information if available
    if curriculum_info and curriculum_info != "Not available":
        curriculum_section = f"\n\n## Curriculum Information\nThis plan aligns with the following curriculum:\n{curriculum_info}\n"
        plan += curriculum_section
        
    # Add book recommendations if available
    if book_titles:
        book_section = "\n\n## Recommended Books\n"
        for title in book_titles:
            book_section += f"- {title}\n"
        plan += book_section
    
    # Add note about the plan
    plan += "\n\n*Note: This is a fallback teaching plan generated due to API limitations. The information from your curriculum and book recommendations has been incorporated where available.*"
    
    return plan

def prep_class(prep_needs):
    """
    Create a teaching plan based on user requirements.
    
    Args:
        prep_needs: User's request string specifying subject, year level, etc.
        
    Returns:
        str: A comprehensive teaching plan
    """
    logger.info(f"Creating teaching plan for: {prep_needs}")
    
    # Convert string input to proper HumanMessage
    if isinstance(prep_needs, str):
        prep_needs = [HumanMessage(content=prep_needs)]

    # Build the graph
    builder = StateGraph(MessagesState)

    # Add nodes    
    builder.add_node("determine_tool", determine_tool)
    builder.add_node("tools", ToolNode(tools))
    builder.add_node("gen_teaching_plan", generate_teaching_plan)

    # Add edges
    builder.add_edge(START, "determine_tool")
    builder.add_conditional_edges(
        "determine_tool",
        should_continue,
        {
            "tools": "tools",
            "gen_teaching_plan": "gen_teaching_plan"
        }
    )
    builder.add_edge("tools", "determine_tool")
    builder.add_edge("gen_teaching_plan", END)

    # Create memory and compile graph
    memory = MemorySaver()
    graph = builder.compile(checkpointer=memory)

    # Execute the graph
    config = {"configurable": {"thread_id": "1"}}
    
    try:
        messages = graph.invoke({"messages": prep_needs}, config)
        
        logger.info("Teaching plan generation completed successfully")
        
        # Extract the teaching plan from the final message
        teaching_plan = messages["messages"][-1].content
        return teaching_plan
        
    except Exception as e:
        logger.error(f"Error generating teaching plan: {e}")
        return f"Error generating teaching plan: {str(e)}"

if __name__ == "__main__":
    request = "I'm doing a course for year 5 on subject Mathematics in Geometry. I need the school curriculum, book recommendations, and latest resources to create a 3-week teaching plan."
    teaching_plan = prep_class(request)
    print("\n\nFINAL TEACHING PLAN:")
    print(teaching_plan)