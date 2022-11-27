## Full stack demo using Dart Functions Framework and Cloud Run 

This is a demo of full stack application with **Dart**

The **backend** is a Dart function app that call the [moviedb API](https://www.themoviedb.org/) using the [Functions Framework for Dart](https://github.com/GoogleCloudPlatform/functions-framework-dart/). It serves an HTTP endpoint that accepts a JSON-encoded request body and returns a JSON-encoded response body. For the demo, the function is hosted on localhost and on Cloud Run, a fully managed serverless platform on Google Cloud.


### Build and deploy the backend

Change directory to backend.

    cd backend

#### Local machine

You can run the function on your local machine by entering:

    dart run build_runner build --delete-conflicting-outputs
    dart run bin/server.dart --port=8080 --target=function

Output:

    Listening on :8080

#### Cloud Run

If you have created a Google Cloud project and updated your local gcloud configuration with the project ID, you can deploy the backend in a single step.

For example, assuming your project ID is dart-demo and you want to deploy the function as a service called greeting, enter: