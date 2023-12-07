#import functions_framework
from google.cloud import bigquery
from sqlalchemy import *
from sqlalchemy.engine import create_engine
from sqlalchemy.schema import *
import os
from langchain.agents import create_sql_agent
from langchain.agents.agent_toolkits import SQLDatabaseToolkit
from langchain.sql_database import SQLDatabase
from langchain.llms.openai import OpenAI
from langchain.llms import VertexAI
from langchain.agents import AgentExecutor

import json
import re
import vertexai

def remove_ansi_escape_codes(text):
    # ANSI escape code regex
    ansi_escape = re.compile(r'\x1B[@-_][0-?]*[ -/]*[@-~]')
    return ansi_escape.sub('', text)

def parse_response_to_json(text):
    # Initialize the structure
    response_json = {
        "ai": [],
        "final_answer": ""
    }

    current_ai_entry = {"thought": "", "action": "", "action_input": ""}
    lines = text.split('\n')
    for line in lines:
        cleaned_line = remove_ansi_escape_codes(line)

        thought_match = re.match(r'^Thought: (.+)', cleaned_line)
        action_match = re.match(r'^Action: (.+)', cleaned_line)
        action_input_match = re.match(r'^Action Input: (.+)', cleaned_line)
        final_answer_match = re.match(r'^Final Answer: (.+)', cleaned_line)

        if thought_match:
            if current_ai_entry["thought"]:  # If there's already a thought in the current entry, append it and start a new one
                response_json["ai"].append(current_ai_entry)
                current_ai_entry = {"thought": "", "action": "", "action_input": ""}

            current_ai_entry["thought"] = thought_match.group(1)

        if action_match:
            current_ai_entry["action"] = action_match.group(1)

        if action_input_match:
            current_ai_entry["action_input"] = action_input_match.group(1)

        if final_answer_match:
            response_json["final_answer"] = final_answer_match.group(1)

    # Append the last AI entry if it's not empty
    if current_ai_entry["thought"] or current_ai_entry["action"] or current_ai_entry["action_input"]:
        response_json["ai"].append(current_ai_entry)

    return json.dumps(response_json, indent=2)

import sys
import io
from contextlib import redirect_stdout

def capture_console_output(func, *args, **kwargs):
    f = io.StringIO()
    with redirect_stdout(f):
        func(*args, **kwargs)
    return f.getvalue()

#@functions_framework.http
def query_agent(request):
    request_json = request.get_json(silent=True)
    request_args = request.args

    # Extract 'prompt' and 'option' from the request JSON
    if request_json:
        prompt = request_json.get('prompt')
        option = request_json.get('option')
    else:
        return 'Invalid request', 400

    if not prompt:
        return 'No prompt provided', 400

    # Setup and authentication (use Secret Manager for OpenAI key)

    # Init Vertex AI
    project_id = "learning-box-369917"
    vertexai.init(project=project_id, location="northamerica-northeast1")

    # Read the OpenAI secret key from the file
    with open('/app/sa-key-openai.txt', 'r') as file:
        openai_secret_key = file.read().strip()  # strip() to remove any trailing newline or spaces
    
    os.environ["OPENAI_API_KEY"] = openai_secret_key
    
    # Initialize llm based on the selected option
    if option == 'open_ai':
        llm = OpenAI(model="text-davinci-003", temperature=0)
    elif option == 'vertex_ai':
        llm = VertexAI(model_name="text-bison@001", temperature=0)
    else:
        raise ValueError("Invalid option selected")

    # Initialize LangChain agent with your specific configurations
    dataset = "langchain_test_churn_table" 
    sqlalchemy_url = f'bigquery://{project_id}/{dataset}?credentials_path=/app/sa-key-langchain-test-over-bigquery.json'
    db = SQLDatabase.from_uri(sqlalchemy_url)
    
    toolkit = SQLDatabaseToolkit(db=db, llm=llm)
    agent_executor = create_sql_agent(
        llm=llm,
        toolkit=toolkit,
        verbose=True,
        top_k=1000,
    )

    # Execute and respond
    response_text = capture_console_output(agent_executor.run, {prompt})
    json_output = parse_response_to_json(response_text)
    #return json.dumps(json_output)
    return response_text
