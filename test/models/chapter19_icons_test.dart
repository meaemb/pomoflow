import 'dart:io';
import 'package:test/test.dart';

void main() {
  group('Chapter 19 - Platform Specific Assets', () {

    test('Android launcher icons exist', () {
      // check if icons for android exist
      final iconHdpi = File('android/app/src/main/res/mipmap-hdpi/ic_launcher.png');
      final iconMdpi = File('android/app/src/main/res/mipmap-mdpi/ic_launcher.png');
      final iconXhdpi = File('android/app/src/main/res/mipmap-xhdpi/ic_launcher.png');
      final iconXxhdpi = File('android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png');
      final iconXxxhdpi = File('android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png');

      expect(iconHdpi.existsSync(), isTrue);
      expect(iconMdpi.existsSync(), isTrue);
      expect(iconXhdpi.existsSync(), isTrue);
      expect(iconXxhdpi.existsSync(), isTrue);
      expect(iconXxxhdpi.existsSync(), isTrue);
    });

    test('Android app name is set', () {
      // checking AndroidManifest.xml
      final manifestFile = File('android/app/src/main/AndroidManifest.xml');
      expect(manifestFile.existsSync(), isTrue);

      final content = manifestFile.readAsStringSync();
      expect(content.contains('android:label="PomoFlow"'), isTrue);
    });

    test('Windows app icon exists', () {
      // check icon of Windows
      final windowsIcon = File('windows/runner/resources/app_icon.ico');
      expect(windowsIcon.existsSync(), isTrue);
    });

    test('Web favicon exists', () {
      // check favicon for Web
      final favicon = File('web/favicon.png');
      expect(favicon.existsSync(), isTrue);
    });

    test('Web title is set in index.html', () {
      // check the title of Web
      final indexHtml = File('web/index.html');
      expect(indexHtml.existsSync(), isTrue);

      final content = indexHtml.readAsStringSync();
      expect(content.contains('<title>PomoFlow</title>'), isTrue);
    });

    test('App title is set in main.dart', () {
      // check the title of MaterialApp
      final mainDart = File('lib/main.dart');
      expect(mainDart.existsSync(), isTrue);

      final content = mainDart.readAsStringSync();
      expect(content.contains('title: \'PomoFlow\''), isTrue);
    });
  });
}