# Space-X-Launches-App

## Description
The Space-X Launches App interacts with the [SpaceX API](https://github.com/r-spacex/SpaceX-API) to retrieve all past launches. It displays the launches in a list on the main screen, featuring a small image on the left, the launch name on top, the date of the launch below, and the success status on the right.

The app includes a sorting feature in the top toolbar, allowing users to sort by name, date, or success state in both ascending and descending order. The sorting preference is persistent across app restarts. Additionally, there is a text input for filtering launches by name and a settings button to change the app's language (currently supporting Czech and English).

Selecting a launch cell opens a details view that presents a larger version of the launch image, along with the name, flight number, launch date, success state, any failures, and relevant links that can be opened in the default browser.

## Features
- Sorting and filtering options
- Landscape and dark/light mode support
- Persistent sort settings
- MVVM architecture with UIKit and SwiftUI

## Screenshots

<p align="center">
  <img src="screenshots/Launch screen.png" alt="Launch Screen" height="300" style="margin-right: 10px;">
  <img src="screenshots/Data loading error.png" alt="Data Loading Error" height="300" style="margin-right: 10px;">
  <img src="screenshots/Main screen.png" alt="Main Screen" height="300" style="margin-right: 10px;">
  <img src="screenshots/Detail screen.png" alt="Detail Screen" height="300">
</p>

## Technologies Used
- **SwiftLint**: For maintaining code quality.
- **RequestsQueue**: [RequestsQueue](https://github.com/StepanFriedl/RequestsQueue.git) for handling internet connection issues by queuing requests.
- **SDWebImage**: For downloading and caching images.

This project uses UIKit with Interface Builder and follows the MVVM pattern, utilizing UINavigationController for navigation. The details screen is built using SwiftUI.

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/StepanFriedl/StepanFriedl-Space-X-Launches-App.git
   ```
2. Navigate into the cloned repository directory:
   ```bash 
   cd StepanFriedl-Space-X-Launches-App/ 
   ```
3. Switch to the develop branch:
   ```bash
   git checkout develop
   ```
4. Create a new branch from develop:
   ```bash
   git checkout -b your-feature-branch
   ```
5. Navigate into the project directory:
   ```bash 
   cd Space-X-Launches-App
   ```
6. If you do not have CocoaPods installed, run:
   ```bash 
   sudo gem install cocoapods
   ```
7. If you do not have SwiftLint installed, run:
   ```bash 
   brew install swiftlint
   ```
8. Install the pods:
   ```bash 
   pod install
   ```
9. Open the workspace:
   ```bash 
   open Space-X-Launches-App.xcworkspace
   ```   
## Usage
Open the app and wait for the data to load. If an error occurs, use the "Try Again" button that appears alongside the error message. Once the data is received, you can sort, filter, and navigate to the details view by clicking any launch row. In the details screen, any present links can be tapped to open in the device’s default browser.

## Contributing
Contributions are welcome! Please follow these steps:
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/Space-X-Launches-App.git
   ```
2. Switch to the develop branch:
   ```bash 
   git checkout develop
   ```
3. Create a new branch from develop:
   ```bash 
   git checkout -b your-feature-branch
   ```
4. Make your changes and commit them:
   ```bash
   git add .
   git commit -m "Describe your changes"
   ```
5. Push your branch to the repository:
   ```bash 
   git push origin your-feature-branch
   ```
6. Submit a pull request with a clear description of your changes.

## License
This project is licensed under the MIT License.

## Acknowledgements
- Thanks to [Reachability.swift](https://github.com/ashleymills/Reachability.swift.git) for providing network reachability support.
- Thanks to [SDWebImage](https://github.com/SDWebImage/SDWebImage.git) for image downloading and caching functionality.
- Icons used in the app are provided by [Flaticon](https://www.flaticon.com/).

## Contact
For any questions or suggestions, feel free to reach out via GitHub or visit my [About Me page](https://github.com/StepanFriedl).
