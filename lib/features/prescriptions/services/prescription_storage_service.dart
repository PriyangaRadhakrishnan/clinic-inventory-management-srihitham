import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class PrescriptionStorageService {
  final FirebaseStorage _storage;

  PrescriptionStorageService({
    FirebaseStorage? storage,
  }) : _storage = storage ?? FirebaseStorage.instance;

  /// Uploads an image file to Firebase Storage under the patient/visit path structure.
  ///
  /// Naming pattern: `prescriptions/patients/{patientId}/visits/{visitId}/{prescriptionId}_{timestamp}.{extension}`
  /// Automatically attaches metadata: `patientId`, `visitId`, `prescriptionId`, and custom `contentType`.
  Future<String> uploadImage({
    required File file,
    required String patientId,
    required String visitId,
    required String prescriptionId,
  }) async {
    try {
      final extension = _getFileExtension(file.path);
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final extSuffix = extension.isNotEmpty ? '.$extension' : '';
      final path =
          'prescriptions/patients/$patientId/visits/$visitId/${prescriptionId}_$timestamp$extSuffix';

      final ref = _storage.ref(path);
      final contentType = _getImageContentType(extension);
      final metadata = SettableMetadata(
        contentType: contentType,
        customMetadata: {
          'patientId': patientId,
          'visitId': visitId,
          'prescriptionId': prescriptionId,
        },
      );

      final uploadTask = await ref.putFile(file, metadata);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw Exception('Firebase Storage error uploading image: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error uploading image: $e');
    }
  }

  /// Uploads a PDF file to Firebase Storage under the patient/visit path structure.
  ///
  /// Naming pattern: `prescriptions/patients/{patientId}/visits/{visitId}/{prescriptionId}_{timestamp}.{extension}`
  /// Automatically attaches metadata: `patientId`, `visitId`, `prescriptionId`, and `contentType` as 'application/pdf'.
  Future<String> uploadPdf({
    required File file,
    required String patientId,
    required String visitId,
    required String prescriptionId,
  }) async {
    try {
      final extension = _getFileExtension(file.path);
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final extSuffix = extension.isNotEmpty ? '.$extension' : '';
      final path =
          'prescriptions/patients/$patientId/visits/$visitId/${prescriptionId}_$timestamp$extSuffix';

      final ref = _storage.ref(path);
      final metadata = SettableMetadata(
        contentType: 'application/pdf',
        customMetadata: {
          'patientId': patientId,
          'visitId': visitId,
          'prescriptionId': prescriptionId,
        },
      );

      final uploadTask = await ref.putFile(file, metadata);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw Exception('Firebase Storage error uploading PDF: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error uploading PDF: $e');
    }
  }

  /// Deletes the file matching the specified download URL from Firebase Storage.
  Future<void> deleteFile(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } on FirebaseException catch (e) {
      throw Exception('Firebase Storage error deleting file: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error deleting file: $e');
    }
  }

  String _getFileExtension(String filePath) {
    final fileName = filePath.split('/').last.split('\\').last;
    final dotIndex = fileName.lastIndexOf('.');
    return dotIndex != -1 ? fileName.substring(dotIndex + 1) : '';
  }

  String? _getImageContentType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      default:
        return 'image/jpeg'; // Fallback default for images
    }
  }
}
