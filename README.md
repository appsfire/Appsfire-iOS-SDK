Appsfire for iOS
================

**Modified**: 2014-03-11  
**SDK Version**: 2.2

## Contains
* Appsfire iOS SDK
  * AppsfireSDK.h
  * AppsfireAdSDK.h
  * AppsfireSDKConstants.h
  * libAppsfireSDK.a
  * Sashimi
* Sample App
  * AppsfireSDK-examples


## Getting Started with Appsfire
The Appsfire iOS SDK is the cornerstone of the Appsfire network.

It provides the functionalities for monetizing your mobile application: it facilitates inserting native mobile ads into you iOS application using native iOS APIs. You can choose one of our ad units (Sushi, Uramaki and Sashimi), or create a new custom ad format (based on the Sashimi Ad Unit). Be sure to read our [full documentation](http://docs.appsfire.com/sdk/ios/integration-reference/Introduction).

It also helps you engage with your users by sending push and in-app notifications.

- Please visit our [website](http://appsfire.com) to learn more about our ad units and products.<br />
- Please visit our [online documentation](http://docs.appsfire.com/sdk/ios/integration-reference/Introduction) to learn how to integrate our SDK into your app.<br />
- Check out the full [API specification](http://docs.appsfire.com/sdk/ios/api-reference/) to have a detailed understanding of our SDK.

## Installation

In order to get started, please be sure you've done the following:

1. Registered on [Appsfire website](http://www.appsfire.com/) and accepted our Terms Of Use
2. Registered your app on our [Dashboard](http://dashboard.appsfire.com/) and generated an SDK key for your app
3. Grabbed our latest version of the SDK, either using CocoaPods, or downloading the SDK from our [Dashboard](http://dashboard.appsfire.com/app/doc)


### CocoaPods

The recommended approach for installing `AppsfireSDK` is via the [CocoaPods](http://cocoapods.org/) package manager, as it provides flexible dependency management and dead simple installation.
For best results, it is recommended that you install via CocoaPods >= **0.28.0** using Git >= **1.8.0** installed via Homebrew.

Install CocoaPods if not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```

Change to the directory of your Xcode project:

``` bash
$ cd /path/to/MyProject
$ touch Podfile
$ edit Podfile
```

Edit your Podfile and add AppsfireSDK:

``` bash
platform :ios, '5.1.1'
pod 'AppsfireSDK', '~> 2.2.0'
```

Install into your Xcode project:

``` bash
$ pod install
```

Open your project in Xcode from the .xcworkspace file (not the usual project file)

``` bash
$ open MyProject.xcworkspace
```

Please note that if your installation fails, it may be because you are installing with a version of Git lower than CocoaPods is expecting. Please ensure that you are running Git >= **1.8.0** by executing `git --version`. You can get a full picture of the installation details by executing `pod install --verbose`.

### Manual Install

For manual install, please refer to our [online documentation](http://docs.appsfire.com/sdk/ios/integration-reference/).

## Sample Application
Included is a sample app to use as example and for help on Appsfire integration. This basic application allows users to test our different ad units (Monetization Features) and our Notification Wall / Feedback Form (Engagement Features).

## Contact Us
If you encounter any issues, do not hesitate to contact our happy support team at support@appsfire.com.

## Change Logs
### Version 2.2
**Release date**: March 11, 2014

* New ad format: Sashimi (in-streams ads)
* Specify the features you are using to improve the user experience
* Added support for 64-bit iOS applications

### Version 2.1.1
**Release date**: January 10, 2014

* Workaround bug fix to prevent app crash in cases where the storeKit component is displayed in landscape-only iPhone apps
* Improved flushing of data

### Version 2.1.0
**Release date**: January 2, 2014

* New ad format: Uramaki
* Sushi is supporting devices in landscape

### Version 2.0.2
**Release date**: December 16, 2013

* Fixed a bug with notification wall for landscape-only apps

### Version 2.0.1
**Release date**: December 5, 2013

* Fixed a bug with the capping in monetization sdk

### Version 2.0
**Release date**: November 21, 2013

* Monetization SDK
* New, flat design for iOS 7
