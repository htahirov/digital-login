import 'dart:async';
import 'dart:developer' as logger;
import 'package:flutter/services.dart';

import 'helpers/uuid_helper.dart';

/// A singleton class responsible for managing digital login authentication.
class DigitalLoginController {
  /// Private constructor to enforce singleton pattern.
  DigitalLoginController._() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  /// The single instance of [DigitalLoginController].
  static DigitalLoginController? _instance;

  /// Returns the singleton instance of [DigitalLoginController].
  static DigitalLoginController get instance =>
      _instance ??= DigitalLoginController._();

  /// The method channel used for communication with the native platform.
  static const _channel = MethodChannel('digital_login');

  /// A stream controller that emits received authentication codes.
  final _digitalCodeController = StreamController<String>();

  /// A stream that provides authentication codes when received.
  Stream<String> get digitalCodeStream => _digitalCodeController.stream;

  /// Handles incoming method calls from the native platform.
  Future<void> _handleMethodCall(MethodCall call) async {
    if (call.method == 'onCodeReceived' && call.arguments != null) {
      _digitalCodeController.add(call.arguments);
    }
  }

  /// Initiates the digital login process by invoking a native method.
  ///
  /// Requires:
  /// - [url] - The login endpoint.
  /// - [clientId] - The application client ID.
  /// - [redirectUri] - The URI to redirect after login.
  /// - [scope] - The requested authentication scope (default: `'openid certificate'`).
  /// - [responseType] - The response type (default: `'code'`).
  /// - [scheme] - The custom scheme for deep linking.
  Future<void> performLogin({
    required String url,
    required String clientId,
    required String redirectUri,
    String scope = 'openid certificate',
    String responseType = 'code',
    required String scheme,
  }) async {
    try {
      // Generate a unique session ID for tracking the login session.
      final sessionId = UuidHelper.generateUuid();
      logger.log('Generated Session UUID: $sessionId');

      // Invoke the native method with required parameters.
      await _channel.invokeMethod(
        'performLogin',
        {
          'url': url,
          'clientId': clientId,
          'redirectUri': redirectUri,
          'scope': scope,
          'sessionId': sessionId,
          'responseType': responseType,
          'scheme': scheme,
        },
      );
    } on PlatformException catch (e) {
      logger.log('Failed to perform login: ${e.message}');
    }
  }

  /// Disposes the stream controller to release resources.
  void dispose() => _digitalCodeController.close();
}
