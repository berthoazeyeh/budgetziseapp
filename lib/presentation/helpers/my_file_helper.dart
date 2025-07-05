// import 'package:image_picker/image_picker.dart' show XFile;

// final class MyFileHelper {
//   const MyFileHelper();

//   final imageExtensions = const [
//     'jpg',
//     'jpeg',
//     'png',
//     'gif',
//     'bmp',
//     'webp',
//     'tiff',
//     'svg',
//   ];

//   final videoExtensions = const [
//     'mp4',
//     'mov',
//     'avi',
//     'mkv',
//     'webm',
//     'wmv',
//     'flv',
//   ];

//   final audioExtensions = const [
//     'mp3',
//     'wav',
//     'aac',
//     'ogg',
//     'flac',
//     'm4a',
//   ];

//   bool isImage(String filePath) {
//     final extension = filePath.split('.').last.toLowerCase();

//     return imageExtensions.contains(extension);
//   }

//   bool isVideo(String filePath) {
//     final extension = filePath.split('.').last.toLowerCase();

//     return videoExtensions.contains(extension);
//   }

//   bool isAllowedImageFileType(XFile file) {
//     // Get file metadata
//     final mimeType = file.mimeType?.toLowerCase();
//     if (mimeType != null) return _isValidImageMimeType(mimeType);

//     return _isValidImageExtension(
//       _getFileExtension(file.path),
//       imageExtensions,
//     );
//   }

//   String _getFileExtension(String path) {
//     try {
//       return path.split('.').last.toLowerCase();
//     } catch (e) {
//       return '';
//     }
//   }

//   bool _isValidImageMimeType(String mimeType) {
//     // Check if any allowed type matches the MIME type
//     return imageExtensions.any(
//       (type) => mimeType == 'image/${type.toLowerCase()}',
//     );
//   }

//   bool _isValidImageExtension(String extension, List<String> allowed) {
//     return imageExtensions.contains(extension.toLowerCase());
//   }
// }
