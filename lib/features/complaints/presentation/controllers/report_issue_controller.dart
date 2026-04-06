import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/services/firestore_complaint_service.dart';
import '../../../../core/services/image_service.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/services/storage_service.dart';

class ReportIssueController extends ChangeNotifier {
  ReportIssueController(
    this._complaintService,
    this._storageService,
    this._locationService,
    this._imageService,
  ) : _uuid = const Uuid();

  final FirestoreComplaintService _complaintService;
  final StorageService _storageService;
  final LocationService _locationService;
  final ImageService _imageService;
  final Uuid _uuid;

  bool isSubmitting = false;
  String? selectedIssueType;
  XFile? selectedImage;
  double? latitude;
  double? longitude;
  String? errorMessage;

  Future<void> detectLocation() async {
    try {
      final position = await _locationService.getCurrentPosition();
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      errorMessage = 'Location error: $e';
    }
    notifyListeners();
  }

  Future<void> capturePhoto() async {
    selectedImage = await _imageService.pickFromCamera();
    notifyListeners();
  }

  Future<void> uploadPhoto() async {
    selectedImage = await _imageService.pickFromGallery();
    notifyListeners();
  }

  Future<bool> submitComplaint({
    required String userId,
    required String issueType,
    required String description,
  }) async {
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      if (description.trim().isEmpty) {
        throw Exception('Please add a short description.');
      }
      if (latitude == null || longitude == null) {
        throw Exception('Please detect your location first.');
      }

      final complaintId = _uuid.v4();

      // Try uploading image, but don't block submission if it fails
      String imageUrl = '';
      if (selectedImage != null) {
        try {
          imageUrl = await _storageService.uploadComplaintImage(
            imageFile: selectedImage!,
            complaintId: complaintId,
          ).timeout(const Duration(seconds: 15));
        } catch (e) {
          if (kDebugMode) debugPrint('Image upload failed: $e');
          // Continue without image
        }
      }

      await _complaintService.createComplaint(
        complaintId: complaintId,
        userId: userId,
        issueType: issueType,
        description: description,
        latitude: latitude!,
        longitude: longitude!,
        imageUrl: imageUrl,
      );
      return true;
    } catch (error) {
      errorMessage = error.toString();
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
