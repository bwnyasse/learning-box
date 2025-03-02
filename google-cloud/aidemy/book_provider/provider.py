import functions_framework
from flask import jsonify
from langchain_google_vertexai import ChatVertexAI
from langchain_core.output_parsers import JsonOutputParser
from langchain_core.prompts import PromptTemplate
from pydantic import BaseModel, Field
import os

class Book(BaseModel):
    bookname: str = Field(description="Name of the book")
    author: str = Field(description="Name of the author")
    publisher: str = Field(description="Name of the publisher")
    publishing_date: str = Field(description="Date of publishing")

def get_llm():
    """Creates and returns the LLM instance with proper project configuration."""
    project_id = os.environ.get("GOOGLE_CLOUD_PROJECT")
    if not project_id:
        raise ValueError("GOOGLE_CLOUD_PROJECT environment variable not set")
    
    return ChatVertexAI(
        model_name="gemini-2.0-flash", 
        project=project_id,
        convert_system_message_to_human=True
    )

def get_recommended_book(category):
    """
    Generates a single book recommendation using LangChain and Vertex AI.
    
    Args:
        category (str): Book category to generate recommendation for
        
    Returns:
        dict: A dictionary containing the book recommendation
    """
    parser = JsonOutputParser(pydantic_object=Book)
    
    prompt = PromptTemplate(
        template="Generate a book recommendation for the category: {category}.\n{format_instructions}",
        input_variables=["category"],
        partial_variables={"format_instructions": parser.get_format_instructions()},
    )
    
    llm = get_llm()
    chain = prompt | llm | parser
    return chain.invoke({"category": category})

@functions_framework.http
def recommend_books(request):
    """HTTP Cloud Function that generates book recommendations."""
    # Handle CORS preflight requests
    if request.method == 'OPTIONS':
        headers = {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST',
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Max-Age': '3600'
        }
        return ('', 204, headers)

    # CORS headers for actual response
    headers = {'Access-Control-Allow-Origin': '*'}
    
    try:
        # Get parameters from either JSON body or query parameters
        request_json = request.get_json(silent=True)
        
        if request_json and 'category' in request_json and 'number_of_book' in request_json:
            category = request_json['category']
            number_of_book = int(request_json['number_of_book'])
        elif request.args and 'category' in request.args and 'number_of_book' in request.args:
            category = request.args.get('category')
            number_of_book = int(request.args.get('number_of_book'))
        else:
            error_response = jsonify({"error": "Missing category or number_of_book parameters"})
            for key, value in headers.items():
                error_response.headers[key] = value
            return error_response, 400

        # Generate the requested number of book recommendations
        recommendations = []
        for _ in range(number_of_book):
            book = get_recommended_book(category)
            recommendations.append(book)
        
        # Create the response with jsonify for pretty formatting
        response = jsonify(recommendations)
        
        # Add CORS headers
        for key, value in headers.items():
            response.headers[key] = value
            
        return response
        
    except ValueError as ve:
        error_response = jsonify({"error": str(ve)})
        for key, value in headers.items():
            error_response.headers[key] = value
        return error_response, 400
        
    except Exception as e:
        error_response = jsonify({"error": str(e)})
        for key, value in headers.items():
            error_response.headers[key] = value
        return error_response, 500