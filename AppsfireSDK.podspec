Pod::Spec.new do |spec|
  spec.name            = 'AppsfireSDK'
  spec.version         = '2.7.7'
  spec.license         = 'Commercial'
  spec.summary         = 'Appsfire iOS SDK'
  spec.description     = 'The Appsfire SDK for iOS enables you to natively monetize your applications and engage with your users.'
  spec.homepage        = 'http://www.appsfire.com/'
  spec.author          = { 'Appsfire' => 'http://www.appsfire.com/' }
  spec.source          = { :git => 'https://github.com/appsfire/Appsfire-iOS-SDK.git', :tag => '2.7.7' }
  spec.platform        = :ios, '6.0'
  spec.source_files    = 'AppsfireSDK/**/*.{h,m}'
  spec.preserve_paths  = 'AppsfireSDK/*.a'
  spec.library         = 'AppsfireSDK'
  spec.xcconfig        =  { 'LIBRARY_SEARCH_PATHS' => '"$(PODS_ROOT)/AppsfireSDK/AppsfireSDK"' }
  spec.weak_frameworks = 'AdSupport', 'StoreKit'
  spec.frameworks      = 'Accelerate', 'CoreGraphics', 'CoreText', 'Foundation', 'QuartzCore', 'Security', 'SystemConfiguration', 'MapKit', 'CoreLocation', 'UIKit'
  spec.requires_arc    = true
end
