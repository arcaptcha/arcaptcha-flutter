# Arcaptcha Flutter Plugin

Arcaptcha is a Flutter plugin which allows you to integrate the Arcaptcha widget into your Flutter app, which offers a secure and effective way of verifying users. With this plugin, you can display a CAPTCHA for verification, either in visible or invisible modes, and handle the successful verification or error states. This plugin provides flexibility to customize the appearance and behavior of the CAPTCHA widget directly from your Flutter app.

## Getting Started

To use the `arcaptcha` plugin in your Flutter project, follow these steps:

1. **Add the Dependency**

   Open the `pubspec.yaml` file in your Flutter project and add the following dependency:

   ```yaml
   dependencies:
     arcaptcha:
        git:
            url: https://github.com/arcaptcha/arcaptcha-flutter.git

2. **Initialize Arcaptcha**<br>
    Before using the Arcaptcha widget, you must import it and then initialize it with your **site key** and optionally customize its settings such as theme, size, color and language.

    ```dart
    import 'package:arcaptcha/arcaptcha.dart';
    ```
    then 

    ```dart
    Arcaptcha.init(
        siteKey: "<your site key>", // Required. Your public API site key.
        theme: "light",             // Optional. Set the theme of widget. Defualts to light
        color: "blue",              // Optional. Set color of every colored element in widget.
        errorPrint: "1",            // Optional. Enable error messages at the bottom of the checkbox.
        lang: "en",                 // Optional. Set language of widget . Defaults to fa
        size: "normal",             // Optional. Set size of the widget. Options: 'normal' | 'invisible'. Default is 'normal'.
    );
    ```
3. **Display ARcaptcha**<br>
    To display the captcha, use the Arcaptcha.show() method. This will open the captcha in a WebView.
    ```dart 
    final result = await Arcaptcha.show(context);
    ```
4. **Handling the Result**<br>
    1. Successful Captcha: <br>
    If the user successfully solves the captcha, the result will be a unique token that can be used for verification.<br>
    Example:
        ```plaintext
        flutter: CAPTCHA result: 910036544655114230735492473541
        ```

    2. Captcha Error: <br>
    If there is any error while solving the captcha (e.g., incorrect answer, invalid site key, etc.), an error message will be returned. The error contains a code and a message indicating what went wrong.<br>
    Example:
        ```plaintext
        flutter: Arcaptcha error: {code: 203, message: answer-wrong-error}
        ```

    3. User Cancels or Skips the Captcha: <br>
    f the user decides not to solve the captcha and exits the widget without completing it, the result will be null, indicating that the captcha was not solved.<br>
    Example:
        ```plaintext
        flutter: CAPTCHA result: null
        ```
        The token is returned and printed (you can use this token for verification).



## Configuration
The only way to configure ARCaptcha is to set custom attributes on the ARCaptcha container 'div'. You're already required to do this with data-site-key, but there are a handful of other optional attributes that enable more customization.<br>

| Attribute    | Render option | Value | Description |
| ------------ | ------------- | ----- | ----------- |
| data-site-key | site_key | your site key | Required. Your public API site key. |
| data-size | size	 | normal or inivisible | Optional. Set the size of the widget. Defaults to normal. |
| data-theme | theme | light or dark | Optional. Set the theme of widget. Defualts to light |
| data-color | color | color name or hex code | Optional. Set color of every colored element in widget. |
| data-error-print | error_print | 0 or 1 | Optional. Disable or enable error messages at the bottom of checkbox. Defaults to 0(enabled) |
| data-lang | lang | en or fa | Optional. Set language of widget . Defaults to fa |

