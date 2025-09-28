import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

/// Extracts a font asset to a writable directory and returns the directory path.
///
/// This function is necessary because native libraries like libass need a real
/// file path, but Flutter assets are bundled virtually.
///
/// Returns the path to the directory containing the font file, which can be
/// passed to libass's `sub-fonts-dir` property.
Future<String> getLibassFontsDir() async {
  // The name of the font file as it is in the assets/fonts folder.
  const String fontAssetName = 'subfont.ttf';

  // Get the application support directory, a safe place to store internal files.
  final Directory supportDir = await getApplicationSupportDirectory();

  // Create a subdirectory for our fonts to keep things organized.
  final Directory fontsDir = Directory('${supportDir.path}/ass_fonts');
  if (!await fontsDir.exists()) {
    await fontsDir.create(recursive: true);
  }

  // Define the full path for the font file in the new directory.
  final File fontFile = File('${fontsDir.path}/$fontAssetName');

  // Check if the font file already exists to avoid copying it on every launch.
  if (!await fontFile.exists()) {
    try {
      // Load the font asset from the Flutter bundle.
      final ByteData data = await rootBundle.load('assets/fonts/$fontAssetName');
      final List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write the font data to the file system.
      await fontFile.writeAsBytes(bytes, flush: true);
      print('✅ Font asset successfully extracted to: ${fontFile.path}');
      print('📁 Font directory for libass: ${fontsDir.path}');
    } catch (e) {
      print('❌ Error extracting font asset: $e');
      // If extraction fails, return the base support directory as a fallback.
      // libass might not find the font, but the app won't crash.
      return supportDir.path;
    }
  } else {
    print('✅ Font file already exists: ${fontFile.path}');
    print('📁 Font directory for libass: ${fontsDir.path}');
  }

  // Return the path to the DIRECTORY containing the fonts.
  return fontsDir.path;
}