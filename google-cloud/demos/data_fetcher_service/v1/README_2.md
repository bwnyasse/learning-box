# WIP - Stock Portfolio Tracker Demo App

This project is a demo application that showcases the usage of Google Cloud Resources through a real-world use case. The goal is to build an application that helps track stocks in a financial portfolio using data fetched from the IEXCloud API and processed in Google Cloud.

## Prerequisites

Before running the demo app, ensure that you have the following prerequisites:

- Google Cloud Platform (GCP) account
- Basic knowledge of Google Cloud services (Cloud Run, Cloud Storage, BigQuery, Cloud Scheduler)
- Familiarity with a programming language 

## Getting Started

To get started with the demo app, follow these steps:

1. Clone or download this repository to your local machine.
2. Set up your Google Cloud project by creating a new project or using an existing one.
3. Enable the necessary APIs in your project:
   - Cloud Run API
   - Cloud Storage API
   - BigQuery API
   - Cloud Scheduler API
   - IEXCloud API (sign up for an account and obtain an API key)
4. Install any dependencies required for the project (e.g., Python packages).
5. Configure your Google Cloud credentials on your local machine.
6. Update the necessary configuration files with your project-specific information (e.g., API keys, bucket names).
7. Deploy the application to Cloud Run using the provided deployment script.
8. Set up the necessary Cloud Scheduler jobs to fetch stock data at regular intervals.
9. Create a BigQuery dataset and tables to store the processed stock data.
10. Run the application and start tracking your stock portfolio!

## Architecture

The demo app utilizes the following Google Cloud resources and services:

- **Cloud Run**: Hosts the web application for tracking stocks and serves API endpoints.
- **Cloud Storage**: Stores any required files, such as configuration files or static assets.
- **BigQuery**: Stores and analyzes the processed stock data.
- **Cloud Scheduler**: Triggers the periodic fetching of stock data from the IEXCloud API.

The application workflow can be summarized as follows:

1. User interacts with the web application to track their stock portfolio.
2. The application fetches the stock data from the IEXCloud API.
3. The fetched data is processed and stored in BigQuery.
4. Users can view and analyze their stock portfolio data through the web application.

## Contributing

If you'd like to contribute to this demo app, please follow the guidelines outlined in the [CONTRIBUTING.md](CONTRIBUTING.md) file.

## License

This demo app is licensed under the [MIT License](LICENSE).

## Acknowledgments

Special thanks to the creators and maintainers of the following libraries and services used in this project:

- Google Cloud Platform
- IEXCloud API

## Resources

Here are some recommended resources to learn more about the technologies used in this demo app:

- [Google Cloud Documentation](https://cloud.google.com/docs)
- [IEXCloud Documentation](https://iexcloud.io/docs)

Feel free to customize this README according to your specific requirements. Remember to include any additional instructions, guidelines, or code samples as needed. Enjoy exploring the demo app!
