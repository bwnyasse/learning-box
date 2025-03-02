import logging
import os
from flask import Flask, app, jsonify, render_template, request

from graph import prep_class

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

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
    port = int(os.environ.get("PORT", 8080))
    logger.info(f"Starting server on port {port}")
    app.run(debug=True, host="0.0.0.0", port=port)