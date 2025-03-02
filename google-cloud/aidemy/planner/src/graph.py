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
        
        # Check if we have messages
        if not state["messages"]:
            return {"messages": state["messages"] + [HumanMessage(content="Unable to generate teaching plan due to insufficient information.")]}
        
        # Process previous messages to extract tool results
        for msg in state["messages"]:
            if hasattr(msg, 'tool_call_id') and hasattr(msg, 'content'):
                content = msg.content
                if isinstance(content, str) and "curriculum" in content.lower():
                    curriculum_info = content
                elif isinstance(content, list) and len(content) > 0 and "bookname" in str(content):
                    book_info = content
                elif isinstance(content, str) and len(content) > 300:  # Assuming resources have longer content
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
        
        # Create a simpler prompt with specific content
        prompt = f"""
        Create a 3-week teaching plan for Year 5 Mathematics focusing on Geometry.
        
        Curriculum information:
        {curriculum_info}
        
        Recommended books:
        {formatted_books}
        
        Teaching resources:
        {resource_info}
        
        Include learning objectives, weekly activities, and assessment strategies.
        """
        
        # Use a simple text prompt instead of relying on previous message context
        sys_msg = SystemMessage(content=prompt)
        
        # Generate the teaching plan
        plan_message = llm.invoke([sys_msg])
        return {"messages": state["messages"] + [plan_message]}
        
    except Exception as e:
        logger.error(f"Error in generate_teaching_plan: {e}")
        # Include the traceback for better debugging
        import traceback
        logger.error(f"Traceback: {traceback.format_exc()}")
        # Return a simple error message
        error_message = HumanMessage(content=f"Error generating teaching plan: {str(e)}")
        return {"messages": state["messages"] + [error_message]}

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