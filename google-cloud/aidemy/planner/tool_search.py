import logging
import os
from google import genai
from google.genai.types import Tool, GenerateContentConfig, GoogleSearch

from utils import get_required_env_var

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


# configuration 
project_id = get_required_env_var("GOOGLE_CLOUD_PROJECT")
location = os.environ.get("GOOGLE_CLOUD_REGION", "us-central1")  
gemini_model_name="gemini-2.0-flash"

# Initialize the Google Search tool
google_search_tool = Tool(
    google_search = GoogleSearch()
)

def search_latest_resource(search_text: str, curriculum: str, subject: str, year: int):
    """
    Get latest information from the internet using Google Search and Gemini
    
    Args:
        search_text: User's search query string
        curriculum: Curriculum details string
        subject: Subject area string
        year: Academic year/grade level integer
        
    Returns:
        dict: Processed response with search results
    """
    try:
        # Format the search query to include all context
        enhanced_query = (
            f"{search_text} in the context of year {year} and subject {subject} "
            f"with following curriculum detail: {curriculum}"
        )
        logger.info(f"Enhanced search query: {enhanced_query}")
        
        # Initialize the Gemini client with Vertex AI in express mode
        client = genai.Client(vertexai=True, project=project_id, location=location)
        
        # Call the Gemini API with Google Search tool
        response = client.models.generate_content(
            model=gemini_model_name,
            contents=search_text,
            config=GenerateContentConfig(
                tools=[google_search_tool],
                response_modalities=["TEXT"],
            )
        )
        # Log success but not the full response
        logger.info(f"Successfully received response from Gemini API")
        
            # Process and return the response
        if hasattr(response, 'candidates') and response.candidates:
            return response
        else:
            logger.warning("Received empty response from Gemini API")
            return {"error": "No results found"}
    
    except Exception as e:
        logger.error(f"Error in search_latest_resource: {e}")
        return {"error": str(e)}

def extract_text_from_response(response):
    """
    Extract text content from Gemini API response
    
    Args:
        response: Gemini API response object
        
    Returns:
        str: Combined text from response parts
    """
    if hasattr(response, 'candidates') and response.candidates:
        texts = []
        for part in response.candidates[0].content.parts:
            if hasattr(part, 'text'):
                texts.append(part.text)
        return "\n".join(texts)
    return "No results found"

if __name__ == "__main__":
    response = search_latest_resource(
        "What are the syllabus for Year 6 Mathematics?", 
        "Expanding on fractions, ratios, algebraic thinking, and problem-solving strategies.", 
        "Mathematics", 
        6
    )
    
    # Extract and log the text content
    result_text = extract_text_from_response(response)
    logger.info("Search Results:")
    logger.info(result_text)