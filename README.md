# Workshop iOS

## Technology Stack
* Xcode 11.3
* Swift 5
* Cocoapods

## Notable Dependencies
* Alamofire (Network)
* SwiftyJSON (JSON Utility)
* Kingfisher (Image Downloader)
* TOCropViewController (Photo Editor)
* IQKeyboardManagerSwift (Keyboard Manager)
* SVProgressHUD (HUD)
* Hue (Color Scheme)
* Repeat (Debouncer and Throttler)

## Usage
Here's the instruction of how to run this repository.
* Clone this [repository](https://github.com/awijaya09/workshop-ios.git).
* Install [Xcode](https://developer.apple.com/xcode/).
* Install [Cocoapods](https://cocoapods.org/).
* Open downloaded repository.
* Run `pod install` .
* Open `workshop.xcworkspace`, to open project in Xcode.
* Run `⌘ + R` to run the app.

## Workshop Content
Workshop content being seperated in each branch, which contains step by step creating it in each commit. The goal of the workshop is to make MovieCatalog application based on this [user interface](https://www.figma.com/file/ZG6wxGLa05GcUtO7Hdm8Lv/Mobile-iOS-Test-Case).
You can follow these branches for step by step process:
1. [Starter](https://github.com/rasyadh/workshop-ios/tree/starter) 
	> Starter structure folder and codes of project.
2. [Layouting Storyboard and View Controller](https://github.com/rasyadh/workshop-ios/tree/layouting-storyboard-and-view-controller) 
	> Start layouting in storyboard and connect the outlet and action to the view controller. 
3. [Navigation and Pass Data](https://github.com/rasyadh/workshop-ios/tree/navigation-and-pass-data) 
	> Navigate to other view controller using segue and navigation controller. Passing data other view controller and pass back data to parent view controller using protocol
4. [UITableView and UITableViewCell](https://github.com/rasyadh/workshop-ios/tree/tableview-and-tableview-cell) 
	> Basic usage and setup of UITbleView and UITableView Cell. Using custom reusable UITableViewCell class. Multi section UITableViewCell.
