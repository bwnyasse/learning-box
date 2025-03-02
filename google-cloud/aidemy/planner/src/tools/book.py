import logging
import os
import requests
from langchain_google_vertexai import ChatVertexAI
from tenacity import retry, stop_after_attempt, wait_exponential, retry_if_exception_type

from utils.helpers import get_llm, get_required_env_var

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

#  configuration from environment variables
project_id = get_required_env_var("GOOGLE_CLOUD_PROJECT")
book_provider_url = get_required_env_var("BOOK_PROVIDER_URL")      # API endpoint

@retry(
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=1, min=2, max=10),
    retry=retry_if_exception_type(requests.exceptions.RequestException)
)
def call_book_service(category, number_of_books=2):
    """Call the book service with retry logic"""
    
    # Ensure the URL has the correct schema
    url = book_provider_url
    if not url.startswith(('http://', 'https://')):
        url = f"https://{url}"

    logger.info(f"Calling book service at URL: {url}")
        
    headers = {"Content-Type": "application/json"}
    data = {"category": category, "number_of_book": number_of_books}
    
    try:
        # Use a session for better connection reuse
        with requests.Session() as session:
            # Set a shorter timeout - sometimes this helps with hanging connections
            response = session.post(
                url,
                headers=headers,
                json=data,
                timeout=8  # Shorter timeout can sometimes help
            )
            
            response.raise_for_status()
            return response.json()
            
    except requests.exceptions.Timeout:
        logger.error(f"Timeout when calling book service for category: {category}")
        return []
    except requests.exceptions.RequestException as e:
        logger.error(f"Error calling book recommendation API: {e}")
        return []
    except Exception as e:
        logger.error(f"Unexpected error in call_book_service: {e}")
        return []
            

def recommend_book(query: str):
    """
    Get a list of recommended books from an API endpoint
    
    Args:
        query: User's request string
    """

    try:
        llm = get_llm(project_id)

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