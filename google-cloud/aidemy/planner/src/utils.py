import os
import time
import random
from langchain_google_vertexai import ChatVertexAI

def get_llm(project_id):
    """Creates and returns the LLM instance with proper project configuration."""
    
    # Add a small random delay to help avoid rate limits
    time.sleep(random.uniform(2.0, 3.0))   
    
    return ChatVertexAI(
        model_name="gemini-2.0-flash", 
        project=project_id,
        convert_system_message_to_human=True,
        temperature=0.2,  # Lower temperature for more consistent results
        max_output_tokens=1024,  # Control token usage  
    )
    
def get_required_env_var(var_name):
    """
    Get a required environment variable or raise an error if it's not set
    
    Args:
        var_name: Name of the environment variable
        
    Returns:
        str: Value of the environment variable
        
    Raises:
        ValueError: If the environment variable is not set
    """
    value = os.environ.get(var_name)
    if not value:
        raise ValueError(f"Missing required environment variable: {var_name}")
    return value