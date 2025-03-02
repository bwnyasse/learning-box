import logging
import os
import requests
from langchain_google_vertexai import ChatVertexAI
from tenacity import retry, stop_after_attempt, wait_exponential, retry_if_exception_type

from utils import get_required_env_var

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

#  configuration from environment variables
project_id = get_required_env_var("GOOGLE_CLOUD_PROJECT")
book_provider_url = os.environ.get("BOOK_PROVIDER_URL")      # API endpoint

def get_llm():
    """Creates and returns the LLM instance with proper project configuration."""    
    return ChatVertexAI(
        model_name="gemini-2.0-flash", 
        project=project_id,
        convert_system_message_to_human=True
    )

@retry(
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=1, min=2, max=10),
    retry=retry_if_exception_type(requests.exceptions.RequestException)
)
def call_book_service(category, number_of_books=2):
    """Call the book service with retry logic"""
    headers = {"Content-Type": "application/json"}
    data = {"category": category, "number_of_book": number_of_books}
    
    response = requests.post(
        book_provider_url,
        headers=headers,
        json=data,
        timeout=15  # Extended timeout
    )
    response.raise_for_status()
    return response.json()

def recommend_book(query: str):
    """
    Get a list of recommended books from an API endpoint
    
    Args:
        query: User's request string
    """

    try:
        llm = get_llm()

        prompt = f"""The user is trying to plan an education course, you are the teaching assistant. 
        Help define the category of what the user requested to teach.
        
        Choose a specific and accurate category that would yield good book recommendations.
        Respond with the category using one or two words maximum.

        user request: {query}
        Category:
        """
        logger.info(f"Extracting category from user query...")
        response = llm.invoke(prompt)
        category = response.content.strip()
        logger.info(f"CATEGORY RESPONSE: {category}")
        
        # Call the book recommendation API with retry logic
        logger.info(f"Requesting book recommendations for category: {category}")
        books = call_book_service(category, 2)
        
        return books

    except Exception as e:
        logger.info(f"Error in recommend_book: {e}")
        # Return empty list as fallback
        return []


if __name__ == "__main__":
    result = recommend_book("I'm doing a course for my 5th grade student on Math Geometry, I'll need to recommend few books come up with a teach plan, few quizzes and also a homework assignment.")
    logger.info(result)