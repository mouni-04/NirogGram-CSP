import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/services/image_service.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/responsive_page.dart';

class CameraUploadPage extends StatefulWidget {
  const CameraUploadPage({super.key});

  @override
  State<CameraUploadPage> createState() => _CameraUploadPageState();
}

class _CameraUploadPageState extends State<CameraUploadPage> {
  final ImageService _imageService = sl();
  XFile? _selectedImage;
  Uint8List? _imageBytes;
  bool _loading = false;

  Future<void> _pickFromCamera() async {
    setState(() => _loading = true);
    final file = await _imageService.pickFromCamera();
    if (file != null) {
      final bytes = await file.readAsBytes();
      setState(() {
        _selectedImage = file;
        _imageBytes = bytes;
      });
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _pickFromGallery() async {
    setState(() => _loading = true);
    final file = await _imageService.pickFromGallery();
    if (file != null) {
      final bytes = await file.readAsBytes();
      setState(() {
        _selectedImage = file;
        _imageBytes = bytes;
      });
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera / Image Upload')),
      body: ResponsivePage(
        child: Column(
          children: [
            Expanded(
              child: Card(
                child: Center(
                  child: _imageBytes == null
                      ? const Text('No image selected')
                      : Image.memory(_imageBytes!, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _loading ? null : _pickFromCamera,
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Camera'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _loading ? null : _pickFromGallery,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Gallery'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: 'Use this image',
              isLoading: _loading,
              onPressed: _selectedImage == null
                  ? null
                  : () => Navigator.pop(context, _selectedImage),
            ),
          ],
        ),
      ),
    );
  }
}
