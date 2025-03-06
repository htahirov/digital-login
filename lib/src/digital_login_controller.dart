import 'dart:async';
import 'dart:developer' as logger;

import 'package:flutter/services.dart';

import 'helpers/uuid_helper.dart';

class DigitalLoginController {
  DigitalLoginController._() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  static DigitalLoginController? _instance;

  static DigitalLoginController get instance =>
      _instance ??= DigitalLoginController._();

  static const _channel = MethodChannel('digital_login');
  final _digitalCodeController = StreamController<String>();

  Stream<String> get digitalCodeStream => _digitalCodeController.stream;

  Future<void> _handleMethodCall(MethodCall call) async {
    if (call.method == 'onCodeReceived' && call.arguments != null) {
      _digitalCodeController.add(call.arguments);
    }
  }

  Future<void> performLogin({
    required String url,
    required String clientId,
    required String redirectUri,
    String scope = 'openid certificate',
    String responseType = 'code',
    required String scheme,
  }) async {
    try {
      final sessionId = UuidHelper.generateUuid();
      logger.log('UUID: $sessionId');
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

  void dispose() => _digitalCodeController.close();
}
