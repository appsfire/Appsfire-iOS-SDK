#Appsfire AdUnit and MoPub Mediation

Appsfire's AdUnit integration with MoPub is quite easy. MoPub provides a simple way with custom events to plug their SDK with our AdUnit.

##Quick Start
1. First you **need** to install the Appsfire SDK in order to use the Appsfire AdUnit. If you are not familiar with it, you can take a look at the MoPub Mediation Demo project bundled in this package.

2. In your Xcode project, **import** the two following files : `AFMoPubInterstitialCustomEvent.h` and `AFMoPubInterstitialCustomEvent.m`. This is the pre-configured class which will be automatically instantiated by the MoPub SDK. The procedure to implement it is described in the [MoPub wiki](https://github.com/mopub/mopub-ios-sdk/wiki/Custom-Events#quick-start-for-interstitials).

3. On the MoPub web interface, create a network with the *"Custom Native Network"* type. Place the class name `AFMoPubInterstitialCustomEvent` in the *Custom Event Class* column under the *Set Up Your Inventory* section.

    In order to choose which Ad unit you want to display, you also need to add a *Custom Event Class Data*, the field next to the *Custom Event Class* one. This is simply a JSON payload.

    You can specify the type of the Ad Unit with the `type` key and the 2 possible choices are:  
    - `sushi`  
    - `uramaki`

    You can also specify if you want to use the count down timer just before showing the Ad with the `timer` key which is should be `0` or `1`.

    Example of payload:  
    - Show the **Sushi** ad unit without the timer : `{"type" : "sushi", "timer" : 0}`  
    - Show the **Uramaki** ad unit with the timer : `{"type" : "uramaki", "timer" : 1}`  

##Release Notes

**1.2**  
Improved notification of MoPub when no ads are available.

**1.1**  
Fixed a potential issue where the ads would not get triggered during the lifetime of an app.

**1.0**  
Initial release.
