fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios tests
```
fastlane ios tests
```

### ios increase_build
```
fastlane ios increase_build
```
Increase build number
### ios increase_version
```
fastlane ios increase_version
```
Increase version and build number
### ios beta
```
fastlane ios beta
```
TestFlight deployment to itunes connect
### ios release
```
fastlane ios release
```
Deploy a new version to the App Store
### ios screenshots
```
fastlane ios screenshots
```
Screenshots
### ios localize
```
fastlane ios localize
```
Localize
### ios update_lokalise
```
fastlane ios update_lokalise
```

### ios update_itunes
```
fastlane ios update_itunes
```


----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
