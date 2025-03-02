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
        
        # Print the entire state
        logger.info(f"State has {len(state['messages'])} messages")
        
        # Process previous messages to extract tool results
        for i, msg in enumerate(state["messages"]):
            logger.info(f"Message {i} type: {type(msg).__name__}")
            
            if hasattr(msg, 'content'):
                logger.info(f"Message {i} content type: {type(msg.content).__name__}")
                if isinstance(msg.content, str):
                    logger.info(f"Message {i} content length: {len(msg.content)}")
                elif isinstance(msg.content, list):
                    logger.info(f"Message {i} content is a list of {len(msg.content)} items")
            
            if hasattr(msg, 'tool_call_id') and hasattr(msg, 'content'):
                content = msg.content
                if isinstance(content, str) and "curriculum" in content.lower():
                    curriculum_info = content
                    logger.info(f"Found curriculum info: {content[:100]}...")
                elif isinstance(content, list) and len(content) > 0:
                    # Handle book info
                    book_info = content
                    logger.info(f"Found book info with {len(content)} items")
                elif isinstance(content, str) and len(content) > 300:
                    resource_info = content
                    logger.info(f"Found resource info: {content[:100]}...")
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
        
        # Create a content-rich prompt that won't be empty
        prompt_content = f"""
Create a 3-week teaching plan for Year 5 Mathematics focusing on Geometry.

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

Please format the plan clearly with sections for each week.
"""
       
        logger.info(f"Generated prompt content length: {len(prompt_content)}")
        
        try:
            # Try using a HumanMessage instead of SystemMessage
            human_msg = HumanMessage(content=prompt_content)
            logger.info(f"Attempting to invoke LLM with HumanMessage")
            
            # Try to generate with LLM
            plan_message = llm.invoke([human_msg])
            logger.info(f"Successfully generated plan with LLM")
            return {"messages": state["messages"] + [plan_message]}
        except Exception as e:
            logger.error(f"LLM generation failed: {str(e)}")
            if "400" in str(e) or "contents field is required" in str(e):
                logger.warning("Empty content error, using fallback plan")
                fallback_plan = create_fallback_teaching_plan(curriculum_info, book_info, resource_info)
                return {"messages": state["messages"] + [HumanMessage(content=fallback_plan)]}
            elif "429" in str(e) or "Resource exhausted" in str(e):
                logger.warning("Rate limit hit, using fallback plan")
                fallback_plan = create_fallback_teaching_plan(curriculum_info, book_info, resource_info)
                return {"messages": state["messages"] + [HumanMessage(content=fallback_plan)]}
            else:
                # Re-raise if it's not a rate limit error
                raise
            
    except Exception as e:
        logger.error(f"Error in generate_teaching_plan: {e}")
        # Create a generic fallback plan
        fallback_plan = create_fallback_teaching_plan("", [], "")
        return {"messages": state["messages"] + [HumanMessage(content=fallback_plan)]}

def create_fallback_teaching_plan(curriculum_info, book_info, resource_info):
    """Create a fallback teaching plan without making API calls"""
    
    # Extract book titles if available
    book_titles = []
    if isinstance(book_info, list):
        for book in book_info:
            if isinstance(book, dict) and "bookname" in book:
                book_titles.append(book.get("bookname", ""))
    
    # Create a generic plan
    plan = """
# 3-Week Teaching Plan for Year 5 Mathematics: Geometry [FALLBACK PLAN]

## Learning Objectives
- Identify and describe properties of 2D and 3D shapes
- Recognize and measure angles
- Calculate perimeter and area of regular shapes
- Solve problems involving geometry concepts

## Week 1: Introduction to Shapes
### Day 1-2: Properties of 2D Shapes
- Identify and classify polygons
- Explore properties of triangles, quadrilaterals, and circles
- Activity: Shape hunt in the classroom

### Day 3-4: Properties of 3D Shapes
- Identify and classify 3D shapes
- Explore properties of cubes, cuboids, spheres, cylinders
- Activity: Building 3D shapes with nets

### Day 5: Assessment
- Quiz on shape properties
- Hands-on shape sorting activity

## Week 2: Angles and Measurements
### Day 1-2: Understanding Angles
- Types of angles: acute, right, obtuse, reflex
- Measuring angles with protractors
- Activity: Finding angles in the environment

### Day 3-4: Angle Problems
- Angles on a straight line
- Angles around a point
- Activity: Creating angle puzzles

### Day 5: Assessment
- Angle measurement quiz
- Problem-solving with angles

## Week 3: Perimeter and Area
### Day 1-2: Perimeter
- Calculating perimeter of rectangles and composite shapes
- Problem solving with perimeter
- Activity: Designing garden borders

### Day 3-4: Area
- Area of rectangles and squares
- Area of composite shapes
- Activity: Designing floor plans

### Day 5: Final Project
- Students create a "Geometry in My World" poster
- Presentation of projects
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
    plan += "\n\n*Note: This is a general teaching plan. Adapt as needed based on your specific classroom needs and available resources.*"
    
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