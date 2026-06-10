import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:clinic_inventory/features/prescriptions/services/prescription_storage_service.dart';

void main() {
  late MockFirebaseStorage mockStorage;
  late PrescriptionStorageService storageService;
  late File dummyImageFile;
  late File dummyPdfFile;

  setUp(() {
    mockStorage = MockFirebaseStorage();
    storageService = PrescriptionStorageService(storage: mockStorage);

    // Create simple local temp files for mock uploads
    dummyImageFile = File('temp_test_image.png');
    dummyImageFile.writeAsBytesSync([0, 1, 2, 3]);

    dummyPdfFile = File('temp_test_doc.pdf');
    dummyPdfFile.writeAsBytesSync([4, 5, 6, 7]);
  });

  tearDown(() {
    if (dummyImageFile.existsSync()) {
      dummyImageFile.deleteSync();
    }
    if (dummyPdfFile.existsSync()) {
      dummyPdfFile.deleteSync();
    }
  });

  /// Resilient helper to locate the uploaded reference despite dynamic timestamps.
  Future<Reference?> findUploadedReference({
    required String patientId,
    required String visitId,
    required String prescriptionId,
    required String extension,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    for (int offset in [-2, -1, 0, 1, 2]) {
      final path =
          'prescriptions/patients/$patientId/visits/$visitId/${prescriptionId}_${now + offset}.$extension';
      try {
        final ref = mockStorage.ref(path);
        // Verify existence of metadata
        await ref.getMetadata();
        return ref;
      } catch (_) {
        // Continue searching
      }
    }
    return null;
  }

  group('PrescriptionStorageService Tests', () {
    test('Image upload path generation and metadata attachments', () async {
      const patientId = 'SH20250001';
      const visitId = 'SH20250001_V0002';
      const prescriptionId = 'P0001';

      final downloadUrl = await storageService.uploadImage(
        file: dummyImageFile,
        patientId: patientId,
        visitId: visitId,
        prescriptionId: prescriptionId,
      );

      expect(downloadUrl, isNotEmpty);

      final ref = await findUploadedReference(
        patientId: patientId,
        visitId: visitId,
        prescriptionId: prescriptionId,
        extension: 'png',
      );

      expect(ref, isNotNull);
      expect(ref!.name, contains('P0001_'));

      final metadata = await ref.getMetadata();
      expect(metadata.contentType, 'image/png');
      expect(metadata.customMetadata?['patientId'], patientId);
      expect(metadata.customMetadata?['visitId'], visitId);
      expect(metadata.customMetadata?['prescriptionId'], prescriptionId);
    });

    test('PDF upload path generation and metadata attachments', () async {
      const patientId = 'SH20250001';
      const visitId = 'SH20250001_V0002';
      const prescriptionId = 'P0002';

      final downloadUrl = await storageService.uploadPdf(
        file: dummyPdfFile,
        patientId: patientId,
        visitId: visitId,
        prescriptionId: prescriptionId,
      );

      expect(downloadUrl, isNotEmpty);

      final ref = await findUploadedReference(
        patientId: patientId,
        visitId: visitId,
        prescriptionId: prescriptionId,
        extension: 'pdf',
      );

      expect(ref, isNotNull);
      expect(ref!.name, contains('P0002_'));

      final metadata = await ref.getMetadata();
      expect(metadata.contentType, 'application/pdf');
      expect(metadata.customMetadata?['patientId'], patientId);
      expect(metadata.customMetadata?['visitId'], visitId);
      expect(metadata.customMetadata?['prescriptionId'], prescriptionId);
    });

    test('File deletion handling removes uploaded files', () async {
      const patientId = 'SH20250001';
      const visitId = 'SH20250001_V0002';
      const prescriptionId = 'P0003';

      final downloadUrl = await storageService.uploadImage(
        file: dummyImageFile,
        patientId: patientId,
        visitId: visitId,
        prescriptionId: prescriptionId,
      );

      final ref = await findUploadedReference(
        patientId: patientId,
        visitId: visitId,
        prescriptionId: prescriptionId,
        extension: 'png',
      );
      expect(ref, isNotNull);

      // Perform deletion
      await storageService.deleteFile(downloadUrl);

      // Verify reference no longer exists / throws error on metadata retrieval
      expect(() async => await ref!.getMetadata(), throwsA(anything));
    });

    test('Error handling behavior for invalid file URLs during deletion', () async {
      expect(
        () async => await storageService.deleteFile('invalid-url-format'),
        throwsException,
      );
    });
  });
}
