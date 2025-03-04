import logging
import os
from flask import Flask, app, json, jsonify, render_template, request
from google.cloud import pubsub_v1
from agents.planner import prep_class
from utils.helpers import get_required_env_var

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

#  configuration from environment variables
project_id = get_required_env_var("GOOGLE_CLOUD_PROJECT")

app = Flask(__name__)

def send_plan_event(teaching_plan:str):
    """
    Send the teaching event to the topic called plan
    
    Args:
        teaching_plan: teaching plan
    """
    publisher = pubsub_v1.PublisherClient()
    print(f"-------------> Sending event to topic plan: {teaching_plan}")
    topic_path = publisher.topic_path(project_id, "plan")

    message_data = {"teaching_plan": teaching_plan} 
    data = json.dumps(message_data).encode("utf-8") 

    future = publisher.publish(topic_path, data)

    return f"Published message ID: {future.result()}"


@app.route('/', methods=['GET', 'POST'])
def index():
    subjects = ['English', 'Mathematics', 'Science', 'Computer Science']
    years = list(range(5, 8))

    if request.method == 'POST':
        try:
            selected_year = int(request.form['year'])
            selected_subject = request.form['subject']
            addon_request = request.form['addon']

            logger.info(f"Generating teaching plan for Year {selected_year}, Subject: {selected_subject}")
            
            # Create a detailed prompt for prep_class
            prompt = f"""For a year {selected_year} course on {selected_subject} covering {addon_request}, 
            Incorporate the school curriculum, 
            book recommendations, 
            and relevant online resources aligned with the curriculum outcome. 
            Generate a highly detailed, day-by-day 3-week teaching plan.
            Return the teaching plan in markdown format.
            """
            
            # Call prep_class to get teaching plan and assignment
            teaching_plan = prep_class(prompt)
            
            logger.info(f"Teaching plan generated successfully: {len(teaching_plan)} characters")
            
            send_plan_event(teaching_plan)
            
            logger.info(f"Sending the teaching event to the topic called plan")
                        
            return jsonify({'teaching_plan': teaching_plan})
        
        except Exception as e:
            logger.error(f"Error generating teaching plan: {e}")
            return jsonify({
                'error': 'An error occurred generating the teaching plan',
                'details': str(e)
            }), 500
    
    # Initial GET request - just render the template
    return render_template('index.html', years=years, subjects=subjects, teaching_plan=None, assignment=None)

if __name__ == "__main__":
    # Get PORT from environment variable
    port = int(os.environ.get("PORT", 8080))
    
    # Log the port we're using
    logger.info(f"Starting server on port {port}")
    
    # Run with host="0.0.0.0" to make it accessible outside the container
    app.run(debug=False, host="0.0.0.0", port=port)