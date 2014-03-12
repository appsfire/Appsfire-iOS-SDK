BurstlyAppsfireAdaptor
=======================
Appsfire's AdUnit (interstitial) integration with Burstly is quite easy. Burstly provides a simple way, via custom adaptors, to plug their SDK with ours.

###Integration
1. This assumes that you already have installed the **iOS Burstly SDK**. If this is not the case, please refer to the vendor's [Documentation](http://quickstart.burstly.com/ios-guide).

1. **Install** the iOS Appsfire SDK in order to use the Appsfire AdUnit. There is a documentation bundled with the Appsfire SDK. You can also take a look at the Burstly Mediation Demo project which will give you an integration preview.

1. In your Xcode project, **import** the two following files :
    - `BurstlyAppsfireAdaptor.h`
    - `BurstlyAppsfireAdaptor.m`
    - `BurstlyAppsfireInterstitial.h`
    - `BurstlyAppsfireInterstitial.m`

    Those are pre-configured class which will be automatically instantiated by the Burstly SDK. If you are curious, the procedure to implement them is described in the Burstly AdaptorToolKit [Guide](https://github.com/burstly/AdaptorToolKit/tree/master/iOS).

1. Finally, on the SkyRocket dashboard, **create a new Manual Network** with the following configuration :
    <p align="center"><img src="readme-assets/burstly-manual-network.png"/></p>
    >Note: Don't pay attention to the warning message in the JSON field, it's necessary for the Burstly SDK to find our custom adaptor and present the AdUnit.

	In the "*Edit JSON Data*" field make sure to enter a string with the good format. The format should be: `Appsfire` + `?` + `JSON`.

    With the JSON payload you will be able to specify the type of the Ad Unit with the `type` key and the current possible choices are:  
    - `sushi`  
    - `uramaki`

    You can also specify if you want to use the count down timer just before showing the Ad with the `timer` key which is should be `0` or `1`.

    Example of payload:  
    - Show the **Sushi** ad unit without the timer: `Appsfire?{"type":"sushi","timer":0}`  
    - Show the **Uramaki** ad unit with the timer: `Appsfire?{"type":"uramaki","timer":1}`

    You can also use `Appsfire?{}` and by default this will use the Sushi format without the timer.

1. To make sure you've correctly configured the Manual Network, you can **run** the AdMob Mediation Demo project with your own Burstly App Id and Zone Id and try to see a test Appsfire AdUnit.

###Release Notes

**1.2**  
Improved notification of Burstly when no ads are available.

**1.1**  
Fixed a potential issue where the ads would not get triggered during the lifetime of an app.

**1.0**  
Initial release.
