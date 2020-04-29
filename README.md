# Farms2

## Prerequisits

- Install Xcode: https://developer.apple.com/xcode/
- Install CocoaPods: https://realm.io/docs/swift/latest
- Create Realm Cloud Instance: https://realm.io/products/realm-platform
- Install Realm Studio: https://realm.io/products/realm-studio/

## Deployment Procedure

- Clone repo
- Change into the Farms2 folder: ```cd Farms2```
- Update the pods ```pod update``` 
- open farms2.xcworkspace with Xcode
- Selet the Constants.swift file
- Add your Realm Cloud instance here -> ```static let MY_INSTANCE_ADDRESS = "YOUR-REALM-NAME-HERE.cloud.realm.io" ```

## Demo

- Start the iPhone simulator in Xcode
- Open Realm Studio and connecto to your Realm Cloud Instance
- Place Realm Studio next to the iPhone simulator
- Push the Signup button and show the user being created in the Realm Studio
- Add a new item via the iPhone and show the the item being created in the Realm Cloud
- Change the name field in Realm Studio and watch the change on the iPhone

__Note:__ There is a limitation with SwiftUI, when deleting items in a realm -> This app will crash! I haven't implemented a workaround, as this should be fixed within the next release.


Let me know what you think and what could be improved! 
