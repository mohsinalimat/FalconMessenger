
<p align="center">
 <img src="https://raw.githubusercontent.com/RMizin/PigeonMessenger/master/Pigeon-project/Assets.xcassets/roundedPigeon.imageset/roundedPigeon%402x.png" width="310"/>
</p> 



# Falcon Messenger

Falcon Messenger is a simple cloud-based messaging app.

<a target="_blank" href="https://itunes.apple.com/app/id1313765714"><img src="http://www.binpress.com/uploads/store33364/itunes-app-store-logo.png" width="290" height="100" alt="App Store" /></a>



## Features

- Synchronization<br>
Your messages sync seamlessly across any number of your devices.

- Cloud-based<br>
You will not lose any of your data when you change your mobile phone or re-install the app. All you need is to re-authenticate with your phone number.

- Personal cloud storage<br>
You can store text, photos, videos and voice messages in the cloud, by sending them to your personal storage and get access to your data across all of your devices. 

- Simple authentication process<br>
Falcon uses your phone number for authentication. No emails and passwords.
Also, it makes possible for you to send messages, photos, and videos to people who are in your phone contacts and have Falcon.

- Night mode<br>


## User Interface
### Day color theme
<p align="center">

 <img src="https://raw.githubusercontent.com/RMizin/FalconMessenger/master/Screenshots/WelcomeiPhoneX.png" width="171"/>
 <img src="https://raw.githubusercontent.com/RMizin/FalconMessenger/master/Screenshots/ContactsiPhoneX.png" width="171"/>
 <img src="https://raw.githubusercontent.com/RMizin/FalconMessenger/master/Screenshots/ChatsiphoneX.png" width="171"/>
 <img src="https://raw.githubusercontent.com/RMizin/FalconMessenger/master/Screenshots/ChatLogiPhoneX.png" width="171"/>
 <img src="https://raw.githubusercontent.com/RMizin/FalconMessenger/master/Screenshots/SettingsiPhoneX.png" width="171"/>
</p>

### Night color theme
<p align="center">
 <img src="https://raw.githubusercontent.com/RMizin/FalconMessenger/master/Screenshots/BlackWelcomeIPhoneX.png" width="171"/>
 <img src="https://raw.githubusercontent.com/RMizin/FalconMessenger/master/Screenshots/BlackContactsIPhoneX.png" width="171"/>
 <img src="https://raw.githubusercontent.com/RMizin/FalconMessenger/master/Screenshots/BlackChatsIPhoneX.png" width="171"/>
 <img src="https://raw.githubusercontent.com/RMizin/FalconMessenger/master/Screenshots/BlackChatLogIPhoneX.png" width="171"/>
 <img src="https://raw.githubusercontent.com/RMizin/FalconMessenger/master/Screenshots/BlackSettingsIPhoneX.png" width="171"/>
</p> 


## How to run the app
Follow these simple steps:

1. Open the Pigeon-project.xcworkspace in Xcode.
2. Change the Bundle Identifier to match your domain.
3. Go to Firebase and create new project.
4. Select "Add Firebase to your iOS app" option, type the bundle Identifier & click continue.

5. Download "GoogleService-Info.plist" file and add to the project. Make sure file name is "GoogleService-Info.plist".
6. Go to Firebase Console, select your project, choose "Authentication" from left menu
7. Select "SIGN-IN METHOD" and enable "Phone" option.

Note before last step:<i> if you don't have cocoapods installed on your computer, you have to install it first. You can do it by opening the terminal and running "sudo gem install cocoapods" (without quotation marks), then do the step №8. If you already have cocoapods installed, ignore this note.</i>

8. Open the terminal, navigate to project folder and run "pod update" (without quotation marks).


## Compatibility
Falcon Messenger is written in Swift 4 and requires iOS 10.0 or later.


## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE.md](https://github.com/RMizin/FalconMessenger/blob/master/LICENSE) file for details

Permissions of this strong copyleft license are conditioned on making available complete source code of licensed works and modifications, which include larger works using a licensed work, under the same license. Copyright and license notices must be preserved. Contributors provide an express grant of patent rights.
