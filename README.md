# Comic Book Application based on Marvel API
This is a comic book application for iOS that lets you search for comics based on the Marvel API - https://developer.marvel.com

I also implemented this application in Android with 100% feature parity:
https://github.com/thomasquinto/comic-book-android

## Screenshots
<img src="https://github.com/thomasquinto/comic-book-ios/assets/217340/34fe773a-026a-414a-9e2d-c26f6ebedee3" width="160"/>
<img src="https://github.com/thomasquinto/comic-book-ios/assets/217340/e34e939f-2033-46c0-b0b1-2c8ec200b46d" width="160"/>
<img src="https://github.com/thomasquinto/comic-book-ios/assets/217340/bc0e483c-6698-4cad-b2d3-9a610bb6539f" width="160"/>
<img src="https://github.com/thomasquinto/comic-book-ios/assets/217340/28a5e196-718e-4931-9db1-5a6dc90fea45" width="160"/>
<img src="https://github.com/thomasquinto/comic-book-ios/assets/217340/b31f7dbe-deea-40a7-895e-57d7fa30cd81" width="160"/>

## Features
- Browse comics, characters, creators, series and more from the entire Marvel comics catalog
- Search by keyword
- Bookmark comics, characters, etc to your custom Favorites list

## Tools and Frameworks Used
- 100% Swift using the latest frameworks
  - SwiftUI
  - SwiftData for local storage
  - URLSession for network API calls
  - Async/Await for concurrency
 
## Implementation Details
- Based on a Clean Architecture design with these basic layers
  - Domain
  - Data
    - Local
    - Remote
  - Presentation
    - MVVM
- Supports portrait and landscape modes
- Supports dark and light modes
- Supports phone and tablet screen sizes
- Supports infinite scrolling and pull-to-refresh

## Setup
1. Clone the repository
2. Register to get your own public and private Marvel API keys here: https://developer.marvel.com
3. Copy and paste your keys to this file: https://github.com/thomasquinto/comic-book-ios/blob/main/ComicBook/Data/Remote/ComicBookRemote.swift
4. Build the application in Xcode
   
