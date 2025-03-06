## DIGITAL Login Plugin for Flutter [digital_login]
The DIGITAL Login Plugin simplifies the integration of Azerbaijan's digital login system, provided by Digital Login, into your Flutter applications. With this plugin, developers can enable secure and streamlined login flows using DIGITAL Login, allowing users to authenticate via the national digital ID system.

![digital-login-page-image](https://github.com/user-attachments/assets/2fb804be-1535-4928-b2cc-ad2749bcde51)

### Key Features:
- Easy Integration: Just provide your clientId, redirectUri, and deep linking scheme, and you're good to go!
- Platform Support: Seamlessly works on both Android and iOS.
- Deep Linking: Supports deep linking to handle login redirects back to your app.
### Getting Started:
##### Step 1: Configure Deep Linking
For Android, ensure deep linking is enabled by adding the following to your AndroidManifest.xml:
```xml
<manifest ...>
  <application ...>
    ...
    <!-- Deep linking configuration for handling login redirects back to the app -->
    <meta-data android:name="flutter_deeplinking_enabled" android:value="true" />
    <intent-filter android:autoVerify="true">
      <action android:name="android.intent.action.VIEW" />
      <category android:name="android.intent.category.DEFAULT" />
      <category android:name="android.intent.category.BROWSABLE" />
      <data android:scheme="your_scheme" android:host="your_host" />
    </intent-filter>
    ...
  </application>
</manifest>
```

For iOS, configure URL schemes in your Info.plist:
```xml
<plist>
  <dict>
    ...
    <!-- URL Schemes for Deep Linking -->
    <key>CFBundleURLTypes</key>
    <array>
      <dict>
        <key>CFBundleURLSchemes</key>
        <array>
          <string>your_scheme</string> <!-- Replace with your custom scheme -->
        </array>
      </dict>
    </array>
    ...
  </dict>
</plist>
```

##### Step 2: Install the Plugin
Add the following dependency in your pubspec.yaml:
```yaml
dependencies:
  digital_login: <latest_version>
```
  
##### Step 3: Implement Digital Login
Here's an example of how to use the Digital Login Plugin:
```dart
import 'package:flutter/material.dart';
import 'dart:developer' as logger;
import 'package:digital_login/digital_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _digitalLoginController = DigitalLoginController.instance;

  @override
  void initState() {
    super.initState();

    // Listen for Digital code from the stream
    _digitalLoginController.digitalCodeStream.listen((code) {
      logger.log('Digital code received: $code');
      // Handle login success here
    });
  }

  @override
  void dispose() {
    _digitalLoginController.dispose();
    super.dispose();
  }

  void _startLogin() => _digitalLoginController.performLogin(
        url: 'your digital login base url', // base URL for the digital login
        clientId: 'your clientId', // which application is requesting
        redirectUri: 'your redirectUri', // deep link uri
        scheme: 'your scheme', // deep link scheme
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _startLogin,
          child: const Text('Digital Login'),
        ),
      ),
    );
  }
}
```

### How it Works:
##### Developers only need to provide:
- ClientId from Digital Login (for identification of their app). [Digital login gives you]
- RedirectUri (the deep link URI configured in the app). [You give them]
- DigitalLoginPlugin handles the login process and returns the authentication code via stream.

Deep Linking ensures the user is brought back to the app after successful login via the web browser.  
