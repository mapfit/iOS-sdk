
# Mapfit iOS SDK
![alt text](https://github.com/mapfit/iOS-sdk/blob/master/READMEImage.png)

## Features

- [x] Create a map
- [x] Add a marker to your map

## Requirements

- iOS 11.0+
- Xcode 9

## Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `Mapfit` by adding it to your `Podfile`:

```ruby
platform :ios, '11.0'
use_frameworks!
pod 'Mapfit'
```

## Usage example

```swift
import Mapfit
```

## Set your API Key

[Get an API Key](https://mapfit.com/getstarted)
```swift
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      MFTManager.sharedManager.apiKey = "API_KEY"
      return true
    }
}
```



## Create your map

```swift
let mapView = MFTMapView(frame: view.bounds)
view.addSubview(mapView)
```


## Add a marker to your map

```swift
let marker = mapView.addMarker(position:  CLLocationCoordinate2D(latitude: 40.74699, longitude: -73.98742))
```
## [Full Documentation](https://ios.mapfit.com/docs)


