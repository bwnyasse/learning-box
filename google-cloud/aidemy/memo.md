# Create a new project folder

    mkdir my_project
    cd my_project

# Create a virtual environment

    python3.11 -m venv .venv

# Activate the virtual environment

    source .venv/bin/activate

# Install pip-tools

    pip install pip-tools

# Create requirements.in

    # requirements.in
    requests
    pandas
    pytest

# Generate requirements.txt

    pip-compile requirements.in

#  Install all dependencies

    pip-sync requirements.txt

# Adding New Dependencies

    # Add to requirements.in
    echo "matplotlib" >> requirements.in

    # Regenerate requirements.txt
    pip-compile requirements.in

    # Synchronize environment
    pip-sync requirements.txt

# Removing Dependencies

    # Edit requirements.in and remove the package
    # For example, remove "pandas" from requirements.in

    # Regenerate requirements.txt
    pip-compile requirements.in

    # Synchronize environment (this removes pandas and its unique dependencies)
    pip-sync requirements.txt

# Deactivate it ( if needed )

    source deactivate

# Building and push the image to cloud run 

    docker build --platform linux/amd64 -t gcr.io/${PROJECT_ID}/aidemy-planner .
    docker tag gcr.io/${PROJECT_ID}/aidemy-planner us-central1-docker.pkg.dev/${PROJECT_ID}/agent-repository/aidemy-planner
    docker push us-central1-docker.pkg.dev/${PROJECT_ID}/agent-repository/aidemy-planner