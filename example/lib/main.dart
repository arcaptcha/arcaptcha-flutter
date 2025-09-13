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
      title: 'ArCaptcha Demo',
      home: const ArCaptchaHome(),
    );
  }
}

class ArCaptchaHome extends StatelessWidget {
  const ArCaptchaHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ArCaptcha Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Initialize with your site key
                Arcaptcha.init(
                  siteKey: 'd6ggpvy684',
                  theme: 'dark',
                  lang: 'en',
                  size: 'normal', // visible captcha
                );

                final result = await Arcaptcha.show(context);
                debugPrint("Captcha result: $result");
                
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
              child: const Text('Show Captcha (Visible)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Initialize with invisible captcha
                Arcaptcha.init(
                  siteKey: 'd6ggpvy684',
                  theme: 'light',
                  lang: 'en',
                  size: 'invisible', // invisible captcha
                );

                final result = await Arcaptcha.show(context);
                debugPrint("Invisible Captcha result: $result");
                
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
              child: const Text('Show Captcha (Invisible)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Initialize and then execute programmatically
                Arcaptcha.init(
                  siteKey: 'd6ggpvy684',
                  theme: 'dark',
                  lang: 'en',
                  size: 'invisible',
                );

                // Show the captcha first
                final result = await Arcaptcha.show(context);
                
                // Then execute it programmatically
                await Arcaptcha.execute();
                
                debugPrint("Programmatic execution result: $result");
                
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
              child: const Text('Show Captcha + Execute'),
            ),
          ],
        ),
      ),
    );
  }
}