# DeloitteExercise

Please download latest build from `main` branch 

## How to get started
This project does not need any external libraries, please just open `Flickr.xcodeproj` under `App` folder.

# Architecture

- SwiftUI + Combine with MVVM implementation
- Coordinator for navigation is not needed in SwiftUI, all navigations are defined and fixed at compile time.
- `AppState` to define app level state and all views's states are defined in its view model.
- Native SwiftUI dependency injection
- Custom networking layer(Requestable, Fetchable) built on generic and combine
- Simple implementation for DependencyMap to manage DataProvider, NetworkHandler
- Unit tests for appstate and network services
- Build with SOLID principle in mind

# Features

- Simple photo search using Flickr API
- Pagination when user scroll to the bottom
- Detail view with horizontal card view

![](<https://github.com/andykkt/DeloitteExercise/blob/main/Documents/screenshot_onboarding.png>)
![](<https://github.com/andykkt/DeloitteExercise/blob/main/Documents/screenshot_search.png>)
![](<https://github.com/andykkt/DeloitteExercise/blob/main/Documents/screenshot_colums.png>)

# Known issues
- Detail view should download original image and show
- More error handling is needed
- Purgable cache should be implemented for images
