# DataFetcherService

DataFetcherService is a Dart application that showcases the usage of Google Cloud resources using the Dart programming language. It demonstrates how to build a scalable and portable Google Cloud pipeline to fetch stock data from the Twelve Data API, store it in Google Cloud Storage, and utilize Cloud Datastore for configuration management.

## Requirements

- Dart SDK
- Google Cloud Platform account
- Twelve Data API credentials
- Service account credentials for Google Cloud Platform

## Getting Started

1. Obtain Twelve Data API credentials:

Sign up for an account on the Twelve Data platform (https://twelvedata.com/) and obtain your API token.
Replace the placeholder in the sa-key-twelvedata file with your actual Twelve Data API token. This file is used to store the API key securely.

2. Provide Service Account Credentials:

Replace the sa-key.json file with the service account credentials JSON file corresponding to your Google Cloud Platform project. This file contains the necessary credentials for authentication.

3. Install dependencies:

    dart pub get

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.