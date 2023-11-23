# Flutter Invoice Application with DocumentAI

This project demonstrates the integration of Google Cloud's DocumentAI with a Flutter-based invoice parser application. The application is split into two main components: a backend service that interfaces with DocumentAI and a Flutter UI for displaying the parsed invoice data.

## Project Structure
- `/backend`: Contains the Dart-based backend service.
- `/ui`: Contains the Flutter application.

## Getting Started
To get started with this project, clone the repository and navigate into each sub-directory (`backend` and `ui`) to set up and run the respective parts of the application.

## Contributing
Contributions to this project are welcome! Please read the contribution guidelines in each sub-directory for more information.

## License
This project is licensed under the MIT License - see the LICENSE file in each sub-directory for details.



# DEMO 

fvm flutter run -d chrome --web-renderer html --web-browser-flag "--disable-web-security" 

dart bin/main.dart processDocumentWithFormParser -p f2ffeccf6bdc85ae -f example/input/form.pdf