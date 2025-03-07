import Flutter
import UIKit
import SafariServices

/// The main class for the Digital Login Flutter plugin.
/// This plugin handles authentication using a web-based login system
/// and manages deep linking to return the authentication code to Flutter.
public class DigitalLoginPlugin: NSObject, FlutterPlugin {
    
    /// The scheme used for deep linking.
    private var scheme: String = ""

    /// The method channel for communicating with Flutter.
    private var channel: FlutterMethodChannel

    /// Registers the plugin with Flutter.
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "digital_login", binaryMessenger: registrar.messenger())
        let instance = DigitalLoginPlugin(channel: channel)
        
        // Register the instance as a method call delegate.
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        // Register to handle deep linking via application delegate.
        registrar.addApplicationDelegate(instance)
    }

    /// Initializes the plugin with the provided method channel.
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }

    /// Handles method calls from Flutter.
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "performLogin" {
            // Extract parameters from the method call.
            guard let args = call.arguments as? [String: Any],
                  let url = args["url"] as? String,
                  let clientId = args["clientId"] as? String,
                  let redirectUri = args["redirectUri"] as? String,
                  let scope = args["scope"] as? String,
                  let sessionId = args["sessionId"] as? String,
                  let responseType = args["responseType"] as? String,
                  let scheme = args["scheme"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required arguments", details: nil))
                return
            }
            
            // Store the scheme for deep linking.
            self.scheme = scheme

            // Perform the login process.
            performLogin(url: url, clientId: clientId, redirectUri: redirectUri, scope: scope, sessionId: sessionId, responseType: responseType)

            // Return success (Flutter expects an async response).
            result(nil)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    /// Constructs the digital login URL and opens it in SafariViewController.
    private func performLogin(url: String, clientId: String, redirectUri: String, scope: String, sessionId: String, responseType: String) {
        let loginUrl = getDigitalUrl(url: url, clientId: clientId, redirectUri: redirectUri, scope: scope, sessionId: sessionId, responseType: responseType)

        // Open the URL in SafariViewController.
        if let url = URL(string: loginUrl) {
            let vc = SFSafariViewController(url: url)
            
            if let topController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                // Find the topmost visible view controller.
                var visibleController = topController
                while let presentedViewController = visibleController.presentedViewController {
                    visibleController = presentedViewController
                }

                // Present SafariViewController as a modal.
                vc.modalPresentationStyle = .pageSheet
                visibleController.present(vc, animated: true, completion: nil)
            } else {
                print("Failed to find topmost view controller")
            }
        }
    }

    /// Constructs the digital login URL with the required parameters.
    private func getDigitalUrl(url: String, clientId: String, redirectUri: String, scope: String, sessionId: String, responseType: String) -> String {
        return "\(url)client_id=\(clientId)&redirect_uri=\(redirectUri)&response_type=\(responseType)&state=\(sessionId)&scope=\(scope)"
    }

    /// Handles deep linking when returning from the web authentication.
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Check if the URL scheme matches the expected deep link scheme.
        if url.scheme == scheme {
            // Extract the authorization code from the URL.
            if let code = url.queryItems?["code"] {
                // Send the received code to Flutter via the method channel.
                channel.invokeMethod("onCodeReceived", arguments: code)
            }

            // Dismiss SafariViewController if it's open.
            if let topController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController?.presentedViewController,
               topController is SFSafariViewController {
                topController.dismiss(animated: true, completion: nil)
            }
            return true
        }
        return false
    }
}

/// An extension for extracting query parameters from a URL.
extension URL {
    var queryItems: [String: String]? {
        var items = [String: String]()
        if let components = URLComponents(url: self, resolvingAgainstBaseURL: false) {
            components.queryItems?.forEach { items[$0.name] = $0.value }
        }
        return items
    }
}
