# hOme
IoT project for the home on iOS (iPad) using Swift.
I started this project to learn Swift and iOS development. 
The project goal is for the App to be a "control center" for the home. It currently can control IR devices using IRKit, 
and take input from the flic bluetooth buttons. It is also possible to program commands in a schedule based on day of the week and time.
Currently all data saving is done in iCloud with CloudKit.

## Current status
Project still under early development phase, the first version of the model is mostly finished but the UI is not.
As I am still learning Swift some parts might be redone new ways I learned.

### About unit tests: 
I want to add them and work by TDD but the current version of the flic library does not compile on the simulator, 
so unit tests cannot compile. When this problem will be resolved on the flic side, adding the tests will be a priority.

## Libraries
* [Alamofire](https://github.com/Alamofire/Alamofire): used to communicate with the IRKits 
* [fliclib](https://github.com/50ButtonsEach/fliclib-ios): used for the connection with the flic buttons 
* CloudKit: used to save the data in iCloud

## Hardware
This is currently an iPad App. It runs on the iPad and needs to be always at the front, iPad awake.

* [IRKit](http://getirkit.com/en/) : opensource infrared remote controller. I use it to control IR appliances (Air conditioning, lights, TV, etc..) 
* [flic](https://flic.io): bluetooth buttons used to trigger commands.

## Miscelanious
* All sources are check using [SwiftLint](https://github.com/realm/SwiftLint)
 
## Authors
* **Yoann Coldefy** - *initial work* - [luinily](https://github.com/luinily)

IoT project for the home on iOS using Swift.
