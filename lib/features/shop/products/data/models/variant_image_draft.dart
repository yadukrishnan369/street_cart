import 'dart:io';

class VariantImageDraft {
  final String colorName;

  // Each entry is either a File to upload or a String existing URL
  final List<dynamic> imagesOrFiles;

  final Map<String, int> sizes;

  const VariantImageDraft({
    required this.colorName,
    required this.imagesOrFiles,
    required this.sizes,
  });

  List<File> get newFiles => imagesOrFiles.whereType<File>().toList();

  List<String> get existingUrls => imagesOrFiles.whereType<String>().toList();
}
