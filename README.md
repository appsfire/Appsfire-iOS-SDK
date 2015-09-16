Appsfire for iOS
================

**Modified**: 2015-09-15  
**SDK Version**: 2.7.6

## Getting Started with Appsfire
The Appsfire iOS SDK is the cornerstone of the Appsfire network.

It provides the functionalities for monetizing your mobile application: it facilitates inserting native mobile ads into you iOS application using native iOS APIs. You can choose one of our ad units (Sushi, Uramaki and Sashimi), or create a new custom ad format (based on the Sashimi Ad Unit). Be sure to read our [full documentation](http://docs.appsfire.com/sdk/ios/integration-reference/Introduction).

It also helps you engage with your users by sending push and in-app notifications.

- Please visit our [website](http://appsfire.com) to learn more about our ad units and products.
- Please visit our [online documentation](http://docs.appsfire.com/sdk/ios/integration-reference/Introduction) to learn how to integrate our SDK into your app.
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
platform :ios, '6.0'
pod 'AppsfireSDK', '~> 2.7.6'
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

### Version 2.7.7
**Release date**: September 16, 2015
<ul>
<li>iOS 9 support.</li>
</ul>

### Version 2.7.3
**Release date**: June 1, 2015
<ul>
<li>Bug fixes.</li>
</ul>

### Version 2.7.2
**Release date**: May 11, 2015
<ul>
<li>Add isFree, localizedPrice to AFNativeAd.</li>
</ul>

### Version 2.7.1
**Release date**: April 16, 2015
<ul>
<li>Solved an issue affecting the report of the impression with Native Ads feature.</li>
</ul>

### Version 2.7.0
**Release date**: April 15, 2015
<ul>
	<li>Added Native Ad system to get ads medata only, and to support more mediation systems.</li>
	<li>Added Himono: our banner format.</li>
	<li>Some other updates and bug fixes.</li>
</ul>

### Version 2.6.0
**Release date**: March 11, 2015
<ul>
    <li>Removed Mediation feature. Please note it will not longer be supported after May 1.</li>
    <li>Stopped supporting armv7s architecture (deprecated since Xcode 6).</li>
    <li>The package now contains the bridge for swift (header file).</li>
    <li>Some other updates and bug fixes.</li>
</ul>

### Version 2.5.1
**Release date**: December 1, 2014
<ul>
	<li>Our Ad Badge is now dynamic and becoming international! French is the first supported language ("Ad" is translated to "Pub" for devices in French). More languages to come soon.</li>
	<li>Visual improvements in Appsfire interstitial ad units: the fade-out transition for Sushi and Uramaki on iOS 7+ now takes into account the current app context (and not the context of the app before the ad was displayed).</li>
	<li>Sashimi ad format: the number of Sashimi Ads returned by our SDK (<code>numberOfSashimiAdsAvailableForFormat:</code>) was wrong when Cross Promotion was enabled. It is now fixed!</li>
	<li>Some other updates and bug fixes</li>
</ul>

### Version 2.5.0
**Release date**: October 8, 2014
<ul>
	<li>Mediation.</li>
	<li>Carousel for sashimi.</li>
</ul>

### Version 2.4.1
**Release date**: September 10, 2014
<ul>
	<li>Appsfire SDK is now compatible with iOS 8, iPhone 6 and iPhone 6+.</li>
	<li>Appsfire SDK should be used with Xcode 6.</li>
	<li>Here and there user interface adjustments.</li>
	<li>Removed deprecated methods.</li>
</ul>

###Version 2.4.0
**Release date** : August 12, 2014
- New design for the Sushi (interstitial ad format).
- In App purchase Ad Removal Prompt: we now offer an easy way to display alert views to users to inform them about the possibility to remove ads in your application.
- Sashimi: Custom Sashimi can now be built using Interface Builder. Please read our <a href="http://docs.appsfire.com/sdk/ios/integration-reference/Monetization_Features/In-stream_ads_(Sashimi_&_Udon_Noodle)/Custom_mode/Implementation">dedicated section</a> to learn how.
- Udon Noodle: Ads are now dismissed when scrolling up. We also added support for UITableView with multiple sections.

**Side note regarding iOS 8 compatibility**: We began updating our SDK for iOS 8. However note that we won't release a full-compatible library for iOS 8 until Apple allows publishers to submit an application built with Xcode 6. In the meantime you shouldn't have any problem as you can't submit a build with Xcode 6! And thus, any special iOS 8 UI/UX behaviour won't be visible. Stay tuned!

###Version 2.3.1
**Release date** : April 28, 2014
- Brichter-San is renamed Udon Noodle. Please read our [migration notes](http://docs.appsfire.com/sdk/ios/integration-reference/Upgrading/From_2,3_to_2,3,1).

###Version 2.3.0
**Release date** : April 24, 2014

- New ad format: Brichter-San (Pull-to-Refresh control)
- Sashimi: fixed a bug that sometimes prevented the view to react to user's tap
- Updates and bug fixes for other ad units

###Version 2.2.2
**Release date** : March 20, 2014

- Monetization is now the default feature. Please read our [migration note](http://docs.appsfire.com/sdk/ios/integration-reference/Upgrading/From_2,2_to_2,2,2) if you use **Engagement** features in your application.
- Custom Sashimi's minimal size is now 30pt x 30pt (previously was 75pt x 75pt).
- Added `forceDismissalOfModalAd`. You can now force the dismissal of a modal ad.

### Version 2.2
**Release date**: March 11, 2014

- New ad format: Sashimi (in-streams ads)
- Specify the features you are using to improve the user experience
- Added support for 64-bit iOS applications

### Version 2.1.1
**Release date**: January 10, 2014

- Workaround bug fix to prevent app crash in cases where the storeKit component is displayed in landscape-only iPhone apps
- Improved flushing of data

### Version 2.1.0
**Release date**: January 2, 2014

- New ad format: Uramaki
- Sushi is supporting devices in landscape

### Version 2.0.2
**Release date**: December 16, 2013

- Fixed a bug with notification wall for landscape-only apps

### Version 2.0.1
**Release date**: December 5, 2013

- Fixed a bug with the capping in monetization sdk

### Version 2.0
**Release date**: November 21, 2013

- Monetization SDK
- New, flat design for iOS 7
