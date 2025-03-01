#!/bin/bash

setup_permission() {
    echo "Setting up service account permissions..."
    # Setup service account permission

    PROJECT_ID=$(gcloud config get project)
    SERVICE_ACCOUNT_NAME=$(gcloud compute project-info describe --format="value(defaultServiceAccount)")

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
        storage.googleapis.com \
        run.googleapis.com \
        artifactregistry.googleapis.com \
        aiplatform.googleapis.com \
        eventarc.googleapis.com \
        sqladmin.googleapis.com \
        secretmanager.googleapis.com \
        cloudbuild.googleapis.com \
        cloudresourcemanager.googleapis.com \
        cloudfunctions.googleapis.com
    echo "Project setup and service enabling complete."
}

test_book_provider_agent() {
    PROJECT_ID=$(gcloud config get project)
    echo "Setting up project $PROJECT_ID"
    BOOK_PROVIDER_URL=$(gcloud run services describe book-provider --region=us-central1 --project=$PROJECT_ID --format="value(status.url)")
    echo "Book Provider Url : $BOOK_PROVIDER_URL"
    
    curl -X POST -H "Content-Type: application/json" -d '{"category": "Games", "number_of_book": 2}' $BOOK_PROVIDER_URL
}

usage() {
    echo "Usage: $0 [--setup-permission] [--setup-project] [--test-book-provider-agent]"
    exit 1
}

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
    --setup-permission)
        echo "Option --setup-permission selected: Setting up permissions."
        setup_permission
        shift # past argument
        ;;
    --setup-project)
        echo "Option --setup-project selected: Setting up project."
        setup_project
        shift # past argument
        ;;
    --test-book-provider-agent)
        echo "Option --test-book-provider-agent selected: Test Book Provider Agent."
        test_book_provider_agent
        shift # past argument
        ;;
    -h | --help)
        usage
        ;;
    *)
        usage
        ;;
    esac
done
