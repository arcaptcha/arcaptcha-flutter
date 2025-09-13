import 'package:flutter/material.dart';
import 'package:arcaptcha/arcaptcha.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arcaptcha Demo',
      home: const ArcaptchaHome(),
    );
  }
}

class ArcaptchaHome extends StatelessWidget {
  const ArcaptchaHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Arcaptcha Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            Arcaptcha.init(
              siteKey: 'Your site key',
              theme: 'dark',
              lang: 'en',
              // color: 'red',
              size: 'invisible'
            );

            final result = await Arcaptcha.show(context);
            print('CAPTCHA result: $result');
            if (context.mounted) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('CAPTCHA Token'),
                  content: Text(result ?? 'No token received'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
          },
          child: const Text('Verify Captcha'),
        ),
      ),
    );
  }
}