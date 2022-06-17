# Flutter app template

This is a minimal flutter starter template to speed up the beginning of a new flutter app. Below is a detailed list of all the things already preconfigured within this template. Note: some of the preconfigured things need some additional setup to work. Instructions are further down on this file!


<details> 
  <summary style="font-size:20px">What is preconfigured?</summary>

  ### Startup logic, splash screen and loading screen.
  - A way to easily add asyncronouse code that needs to run before opening the app. While the code runs, a loading indicator or splash screen is shown to the user.

  ### Firebase setup
  - The following firebase services are configured, and available with minimal configuration:
    * Firebase authentication
    * Firebase firestore
    * Firebase storage
    * Firebase dynamic links
    * Firebase messaging
    * Firebase in app messaging
    * Firebase remote config
    * Firebase cloud functions
    * Firebase crashlytics
    * Firebase analytics

  ### App localizations
  - App localizations are preconfigured with support for english


  ### Get -packages preconfigured
  - Service locator
  - Local storage service
  - Routing
  - Snackbar

  ### Permission handling
  - Easy way to handle your apps permissions with preconfigured functions

  ### Linting
  - Linting is set up with the most important rules

  ### Scaling
  - Scaling content based on the used device is made easy. This way the app can look exactly the same on all of the devices.

  ### Dynamic theming
  - Easily create both light/dark theme for your app
  - App theme will automatically change depending on your devices theme preferences

  ### Most used widgets premade
  - `InputField`: Allows you to easily customize the already made template of how all the input fields should look in your app.
  - `Button`: Allows you to easily customize the already made template of how all the buttons should look in your app.
  - `Dialog`: Allows you to easily customize the already made template of how all the dialogs should look in your app.
  - `Snackbar`: Allows you to easily customize the already made template of how all the snackbars should look in your app.

  ### Other useful pub.dev packages preconfigured
  - `statusbarz`: The color of the apps statusbar is automatically changed (based on the background color) when new route is pushed/popped.
  - `flutter_bloc`: Easy and lightweight state managment
  - `cached_network_image`: Maintains an image cache, so recently loaded images don't have to load from the internet again.
  - `logger`: Generate easy to read logs to the console.
  - `vibrate`: Handle device vibrations with preconfigured `VibrationService`


</details>


<details>
  <summary style="font-size:20px">1. Setup project (required)</summary>

  Note: You can also create the new app using GitHub templates. This repo is marked as a template in GitHub, so you can create your new repo completely on github.com. When using GitHub templates, after cloning the newly created repo, you can skip to step 5 in the "Setup project" category. For more info on GitHub templates, see https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template
  ### 1. Clone the repository:
  ```
  git clone https://github.com/O-Hannonen/template.git
  ```
  ### 2. Open the newly cloned directory:
  ```
  cd template
  ```
  ### 3. Rename the directory to your preference:
  ```
  mv ../template/ ../appname/
  ```

  ## 4. Create a new remote repository for your project, and change the remote (optional):
  ```
  git remote set-url origin www.github.com/appname.git
  ```

  ### 5. Open your new project in VSCode:
  ```
  code .
  ```

  ### 6. In `.android/app/src/main/AndroidManifest.xml`, change your package name and label to fit your app:
  ```
  <!-- Set this: -->
  package="your.domain.appname">

  ... 
  <!-- Change this: -->
  android:label="appname"
  ```

  ### 7. In `.ios/Runner/Info.plist`, change `CFBundleDisplayName` and `CFBundleName` to fit your app:
  ```
  <!-- Change this: -->
    <key>CFBundleDisplayName</key>
    <string>Appname</string>

  ... 
  <!-- Change this: -->
    <key>CFBundleName</key>
    <string>appname</string>
  ```

  ### 8. On the first line of `pubspec.yaml`, change `name` to fit your app.

  ### 9. Create missing pieces of the flutter project:
  ```
  flutter create --org your.domain --project-name appname .
  ```

  ### 10. Change `minSdkVersion` in `.android/app/build.gradle` to 19 or above.
  Change from: 
  ```
  minSdkVersion flutter.minSdkVersion
  ```
  To:
  ```
  minSdkVersion 19
  ```

  ### 11. Rename project imports
  In VSCode, use the search and replace tool. Search for `import 'package:template` and replace all the occurances with your new project name `import 'package:your-name-here`.

  ### 12. Get the packages:
  ```
  flutter pub get
  ```
</details>


<details>
  <summary style="font-size:20px">2. Setup splash screen (optional)</summary>

  ### 1. Replace `./assets/splash_screen.png` with your own splash screen image

  ### 2. Run the following command: 
  ```
  flutter pub run flutter_native_splash:create
  ```
</details>


<details>
  <summary style="font-size:20px">3. Setup localizations (optional)</summary>

  ### 1. Download Flutter Intl extension for VSCode: https://marketplace.visualstudio.com/items?itemName=localizely.flutter-intl

  ### 2. Now you can add key-value pairs to `./lib/l10n/intl_en.arb`, and reference them:
  ```
  L.of(context).myKey
  ```
  or
  ```
  L.current.myKey
  ```

    ## How to add new locales
    1. In VScode, press cmd+shift+P
    2. Type in 'Flutter Intl: Add locale' and press enter
    3. Type in your locale code (eg. en_GB) and press enter
    4. In `Info.plist`, add your new locale, like so:
      
  ```
      <key>CFBundleLocalizations</key>
        <array>
          <string>en</string>
          <!-- Add locale here, like so: -->
          <string>en_GB</string>
        </array>
  ``` 
</details>


<details>
  <summary style="font-size:20px">4. Setup firebase (optional)</summary>

  ### 1.  In the terminal, run
  ``` 
  flutterfire configure
  ``` 


  ### 2. Uncomment the `options` parameter in `./lib/misc/initialize.dart`:
  ``` 
  await Firebase.initializeApp(
          /// When enabling Firebase, make sure to uncomment the line below.
          // options: DefaultFirebaseOptions.currentPlatform,
  );
  ``` 

  ### 3. Set the following variable from `false` to `true` in `./lib/misc/constants.dart`:
  ```
    const kEnableFirebase = false; /// Change this to true
  ```


  ### 4. Enable specific services
  This template contains boilerplate code for many of the firebase services. To enable the service, pleace see the related boilerplate file under `./lib/services/`. A list of supported services and their corresponding boilerplate files are listed below:
  * Firebase analytics : `analytics_service.dart`
  * Firebase authentication : `authentication_service.dart`
  * Firebase cloud functions : `cloud_functions_service.dart`
  * Firebase crashlytics : `crashlytics_service.dart`
  * Firebase dynamic links : `dynamic_links_service.dart`
  * Firebase cloud firestore : `firestore_service.dart`
  * Firebase in-app messaging : `in_app_messaging_service.dart`
  * Firebase cloud messaging : `cloud_messaging_service.dart`
  * Firebase remote config : `remote_config_service.dart`

  To enable a specific service, please open the corresponding boilerplate file and follow the instructions at the top of the file.
</details>






