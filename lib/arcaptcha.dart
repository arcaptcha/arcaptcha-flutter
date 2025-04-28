library arcaptcha;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

String? _siteKey;
String? _theme;
String? _color;
String? _errorPrint;
String? _lang;
String? _size;
String? _domain;

WebViewController? _currentController;

class Arcaptcha {
  static void init({
    required String siteKey,
    String? theme,
    String? color,
    String? errorPrint,
    String? lang,
    String? size,
    String? domain,
  }) {
    _siteKey = siteKey;
    _theme = theme;
    _color = color;
    _errorPrint = errorPrint;
    _lang = lang;
    _size = size;
    _domain = domain ?? 'localhost';
  }

  static Future<String?> show(
    BuildContext context, {
    void Function(String token)? onSuccess,
    void Function(String error)? onError,
  }) async {
    if (_siteKey == null) {
      throw Exception('Arcaptcha not initialized. Call Arcaptcha.init() first.');
    }
    final token = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => const _ArcaptchaWebView(),
      ),
    );
    return token;
  }

  static Future<void> execute() async {
    if (_size == 'invisible' && _currentController != null) {
      await _currentController!.runJavaScript("window.postMessage('executeCaptcha');");
    }
  }
}

class _ArcaptchaWebView extends StatefulWidget {
  const _ArcaptchaWebView();

  @override
  State<_ArcaptchaWebView> createState() => _ArcaptchaWebViewState();
}

class _ArcaptchaWebViewState extends State<_ArcaptchaWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    final html = '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <script src="https://widget.arcaptcha.ir/1/api.js?domain=${_domain}" async defer></script>
        </head>
        <body>

        <!-- Loader -->
        <div id="loader" style="
          position: fixed;
          top: 0; left: 0;
          width: 100%; height: 100%;
          background: white;
          display: flex;
          align-items: center;
          justify-content: center;
          z-index: 9999;
        ">
          <span class="loader"></span>
        </div>

        <!-- Arcaptcha widget -->
        <div class="arcaptcha"
          data-site-key="$_siteKey"
          data-theme="$_theme"
          data-color="$_color"
          data-error-print="$_errorPrint"
          data-lang="$_lang"
          data-size="$_size"
          data-callback="onVerified"
          data-error-callback="onError">
        </div>

        <!-- Loader CSS -->
        <style>
          .loader {
            font-size: 10px;
            width: 1em;
            height: 1em;
            border-radius: 50%;
            position: relative;
            text-indent: -9999em;
            animation: mulShdSpin 1.1s infinite ease;
            transform: translateZ(0);
          }
          @keyframes mulShdSpin {
            0%, 100% {
              box-shadow: 0em -2.6em 0em 0em #000, 1.8em -1.8em 0 0em rgba(0,0,0,0.2), 2.5em 0em 0 0em rgba(0,0,0,0.2), 1.75em 1.75em 0 0em rgba(0,0,0,0.2), 0em 2.5em 0 0em rgba(0,0,0,0.2), -1.8em 1.8em 0 0em rgba(0,0,0,0.2), -2.6em 0em 0 0em rgba(0,0,0,0.5), -1.8em -1.8em 0 0em rgba(0,0,0,0.7);
            }
            12.5% {
              box-shadow: 0em -2.6em 0em 0em rgba(0,0,0,0.7), 1.8em -1.8em 0 0em #000, 2.5em 0em 0 0em rgba(0,0,0,0.2), 1.75em 1.75em 0 0em rgba(0,0,0,0.2), 0em 2.5em 0 0em rgba(0,0,0,0.2), -1.8em 1.8em 0 0em rgba(0,0,0,0.2), -2.6em 0em 0 0em rgba(0,0,0,0.2), -1.8em -1.8em 0 0em rgba(0,0,0,0.5);
            }
            25% {
              box-shadow: 0em -2.6em 0em 0em rgba(0,0,0,0.5), 1.8em -1.8em 0 0em rgba(0,0,0,0.7), 2.5em 0em 0 0em #000, 1.75em 1.75em 0 0em rgba(0,0,0,0.2), 0em 2.5em 0 0em rgba(0,0,0,0.2), -1.8em 1.8em 0 0em rgba(0,0,0,0.2), -2.6em 0em 0 0em rgba(0,0,0,0.2), -1.8em -1.8em 0 0em rgba(0,0,0,0.2);
            }
            37.5% {
              box-shadow: 0em -2.6em 0em 0em rgba(0,0,0,0.2), 1.8em -1.8em 0 0em rgba(0,0,0,0.5), 2.5em 0em 0 0em rgba(0,0,0,0.7), 1.75em 1.75em 0 0em #000, 0em 2.5em 0 0em rgba(0,0,0,0.2), -1.8em 1.8em 0 0em rgba(0,0,0,0.2), -2.6em 0em 0 0em rgba(0,0,0,0.2), -1.8em -1.8em 0 0em rgba(0,0,0,0.2);
            }
            50% {
              box-shadow: 0em -2.6em 0em 0em rgba(0,0,0,0.2), 1.8em -1.8em 0 0em rgba(0,0,0,0.2), 2.5em 0em 0 0em rgba(0,0,0,0.5), 1.75em 1.75em 0 0em rgba(0,0,0,0.7), 0em 2.5em 0 0em #000, -1.8em 1.8em 0 0em rgba(0,0,0,0.2), -2.6em 0em 0 0em rgba(0,0,0,0.2), -1.8em -1.8em 0 0em rgba(0,0,0,0.2);
            }
            62.5% {
              box-shadow: 0em -2.6em 0em 0em rgba(0,0,0,0.2), 1.8em -1.8em 0 0em rgba(0,0,0,0.2), 2.5em 0em 0 0em rgba(0,0,0,0.2), 1.75em 1.75em 0 0em rgba(0,0,0,0.5), 0em 2.5em 0 0em rgba(0,0,0,0.7), -1.8em 1.8em 0 0em #000, -2.6em 0em 0 0em rgba(0,0,0,0.2), -1.8em -1.8em 0 0em rgba(0,0,0,0.2);
            }
            75% {
              box-shadow: 0em -2.6em 0em 0em rgba(0,0,0,0.2), 1.8em -1.8em 0 0em rgba(0,0,0,0.2), 2.5em 0em 0 0em rgba(0,0,0,0.2), 1.75em 1.75em 0 0em rgba(0,0,0,0.2), 0em 2.5em 0 0em rgba(0,0,0,0.5), -1.8em 1.8em 0 0em rgba(0,0,0,0.7), -2.6em 0em 0 0em #000, -1.8em -1.8em 0 0em rgba(0,0,0,0.2);
            }
            87.5% {
              box-shadow: 0em -2.6em 0em 0em rgba(0,0,0,0.2), 1.8em -1.8em 0 0em rgba(0,0,0,0.2), 2.5em 0em 0 0em rgba(0,0,0,0.2), 1.75em 1.75em 0 0em rgba(0,0,0,0.2), 0em 2.5em 0 0em rgba(0,0,0,0.2), -1.8em 1.8em 0 0em rgba(0,0,0,0.5), -2.6em 0em 0 0em rgba(0,0,0,0.7), -1.8em -1.8em 0 0em #000;
            }
          }
        </style>

        <script>
          function post(type, payload = null) {
            if (window.Captcha) {
              Captcha.postMessage(JSON.stringify({ type, payload }));
            }
          }

          function onVerified(token) {
            post('success', token);
          }

          function onError(error) {
            post('error', error);
          }

          const checkInterval = setInterval(() => {
            if (typeof arcaptcha !== 'undefined' && typeof arcaptcha.execute === 'function') {
              clearInterval(checkInterval);
              const loader = document.getElementById('loader');
              if (loader) {
                loader.style.display = 'none';
              }
            }
          }, 50);

          window.addEventListener('message', (event) => {
            if (event.data === 'executeCaptcha') {
              setTimeout(() => {
                if (typeof arcaptcha !== 'undefined' && typeof arcaptcha.execute === 'function') {
                  try {
                    arcaptcha.execute();
                    post('execute-called');

                    const loader = document.getElementById('loader');
                    if (loader) {
                      loader.style.display = 'none';
                    }

                  } catch (err) {
                    onError('Arcaptcha execute failed: ' + err.toString());
                  }
                } else {
                  onError('Arcaptcha not ready.');
                }
              }, 500);
            }
          });
        </script> 
      </body>

      </html>
    ''';

    _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..addJavaScriptChannel(
      'Captcha',
      onMessageReceived: (message) {
        final data = jsonDecode(message.message);
        final type = data['type'];
        final payload = data['payload'];

        if (type == 'success') {
          Navigator.of(context).pop(payload);
        } else if (type == 'error') {
          debugPrint('Arcaptcha error: $payload');
        }
      },
    )
    ..setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (url) {
          if (_size == 'invisible') {
            _controller.runJavaScript("window.postMessage('executeCaptcha');");
          }
        },
      ),
    )
    ..loadHtmlString(html);

    _currentController = _controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Arcaptcha')),
      body: WebViewWidget(controller: _controller),
    );
  }
}