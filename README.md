# Beanstream iOS SDK Demo
This is an iOS demo app to serve as a simple example of using the Beanstream iOS SDK. This app has been written in Swift to allow the example code to be as consice as possible and to demonstrate first class support for Swift.

The demo app was setup to use CocoaPoads to automate management of dependencies. These dependencies include ReactiveCocoa, MBProgessHUD, Money and most importantly Beanstream.SDK. An unmanaged dependency called BeanstreamAPISimulator exists that you need to install manually.

To be able to do the following first install [CocoaPods](https://cocoapods.org).

The following projects should be cloned into the same root directory.

## 1.) Setup Beanstream API Simulator

```
> git clone https://stash.beanstream.com/scm/ios/beanstreamios.sdk.apisimulator.git
```

Note that the default resulting directory name "beanstreamios.sdk.apisimulator" should be maintained.

### Optional: Only if you wish to be able to build the simulator

```
> cd beanstreamios.sdk.apisimulator
> pod install
> open APISimulator.xcworkspace
```

## 2.) Setup Beanstream SDK Demo

```
> git clone https://github.com/Beanstream-DRWP/beanstream-ios-sdk-demo.git
> cd beanstream-ios-sdk-demo
> pod install
> open GoldenEggs.xcworkspace
```

The demo project has simply created a reference to the main APISimulator source directory to be able to import its BICBeanstreamAPISimulator.h in the GoldenEggs-Bridging-Header.h. The BICBeanstreamAPISimulator class extends and overrides all needed methods in the BICBeanstreamAPI class (which is what you would use in an actual production mode app).

For more info on how to use the Beanstream SDK check out [developer.beanstream.com](http://developer.beanstream.com).
