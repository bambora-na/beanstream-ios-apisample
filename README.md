<img src="http://www.beanstream.com/wp-content/uploads/2015/08/Beanstream-logo.png" />
# Beanstream iOS SDK Sample App
The demo apps purpose is to serve as an example of how to use the Beanstream SDK for iOS. Here we have a simple 'e-commerce' style app that facilitates the sale of any number of golden eggs the only available product. A user indicates the number of golden eggs to be purchased at a price of $USD 1.00 and a running total that is converted to the devices locale specific country currency is displayed along with a fictitious sales tax of 5%.

This app has been written in Swift to allow the example code to be as consice as possible and to demonstrate support for Swift. The demo app was setup to use CocoaPoads to automate management of dependencies. These dependencies include ReactiveCocoa, MBProgessHUD, Money and most importantly Beanstream.SDK. An unmanaged dependency called [Beanstream SDK API Simulator](https://github.com/Beanstream-DRWP/beanstream-ios-apisimulator) exists that you need to install manually.

Note that the Beanstream SDK itself has CocoaPods specified dependencies that include AFNetworking v2.6.0.

To be able to compile this project you can clone the git source repo to a working directory. As dependencies you will also need to clone the Beanstream API Simulator repo and then ensure all other dependencies are installed via CocoaPods.

Requirement: First install [CocoaPods](https://cocoapods.org).

The following projects should be cloned into the same root directory.

## 1.) Setup Beanstream SDK API Simulator

```
> git clone https://github.com/Beanstream-DRWP/beanstream-ios-apisimulator.git
```

Note that the default resulting directory name "beanstream-ios-apisimulator" should be maintained for a referenced relative directory path to resolve correctly.

### Optional: Only if you wish to be able to build the simulator

```
> cd beanstream-ios-apisimulator
> pod install
> open APISimulator.xcworkspace
```

## 2.) Setup Beanstream SDK Demo

```
> git clone https://github.com/Beanstream-DRWP/beanstream-ios-apisample.git
> cd beanstream-ios-apisample
> pod install
> open GoldenEggs.xcworkspace
```

The demo project has simply created a reference to the main APISimulator source directory to be able to import its BICBeanstreamAPISimulator.h in the GoldenEggs-Bridging-Header.h. The BICBeanstreamAPISimulator class extends and overrides all needed methods in the BICBeanstreamAPI class (which is what you would use in an actual production mode app).

For more info on how to use the Beanstream SDK check out [developer.beanstream.com](http://developer.beanstream.com).
