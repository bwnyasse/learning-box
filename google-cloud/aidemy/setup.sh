setup_permission() {
    echo "Setting up service account permissions..."
    # Setup service account permission

    export PROJECT_ID=$(gcloud config get project)
    export SERVICE_ACCOUNT_NAME=$(gcloud compute project-info describe --format="value(defaultServiceAccount)")

    echo "Here's your SERVICE_ACCOUNT_NAME: $SERVICE_ACCOUNT_NAME"

    # Grant Permissions 👉Cloud Storage (Read/Write):
    echo "Granting Cloud Storage permissions..."
    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member="serviceAccount:$SERVICE_ACCOUNT_NAME" \
        --role="roles/storage.objectAdmin"

    # 👉Pub/Sub (Publish/Receive):
    echo "Granting Pub/Sub permissions..."
    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member="serviceAccount:$SERVICE_ACCOUNT_NAME" \
        --role="roles/pubsub.publisher"

    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member="serviceAccount:$SERVICE_ACCOUNT_NAME" \
        --role="roles/pubsub.subscriber"

    # 👉Cloud SQL (Read/Write):
    echo "Granting Cloud SQL permissions..."
    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member="serviceAccount:$SERVICE_ACCOUNT_NAME" \
        --role="roles/cloudsql.editor"

    # 👉Eventarc (Receive Events):
    echo "Granting Eventarc permissions..."
    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member="serviceAccount:$SERVICE_ACCOUNT_NAME" \
        --role="roles/iam.serviceAccountTokenCreator"

    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member="serviceAccount:$SERVICE_ACCOUNT_NAME" \
        --role="roles/eventarc.eventReceiver"

    # 👉Vertex AI (User):
    echo "Granting Vertex AI permissions..."
    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member="serviceAccount:$SERVICE_ACCOUNT_NAME" \
        --role="roles/aiplatform.user"

    # 👉Secret Manager (Read):
    echo "Granting Secret Manager permissions..."
    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member="serviceAccount:$SERVICE_ACCOUNT_NAME" \
        --role="roles/secretmanager.secretAccessor"
    echo "Service account permissions setup complete."
}

setup_project() {
    echo "Setting up project and enabling services..."
    gcloud config set project atlantean-petal-452219-q6

    echo "Enabling required services..."
    gcloud services enable compute.googleapis.com \
                        storage.googleapis.com  \
                        run.googleapis.com  \
                        artifactregistry.googleapis.com  \
                        aiplatform.googleapis.com \
                        eventarc.googleapis.com \
                        sqladmin.googleapis.com \
                        secretmanager.googleapis.com \
                        cloudbuild.googleapis.com \
                        cloudresourcemanager.googleapis.com \
                        cloudfunctions.googleapis.com
    echo "Project setup and service enabling complete."
}

while getopts ":sp" opt; do
    case ${opt} in
    s)
        echo "Option -s selected: Setting up permissions."
        setup_permission
        ;;
    p)
        echo "Option -p selected: Setting up project."
        setup_project
        ;;
    *)
        echo "Usage: $0 [-s] [-p]"
        exit 1
        ;;
    esac
done

if [ $OPTIND -eq 1 ]; then
    echo "No options were passed. Usage: $0 [-s] [-p]"
fi


