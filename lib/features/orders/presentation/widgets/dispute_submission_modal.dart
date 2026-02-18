import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newwwwwwww/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../../../core/theme/colors.dart';
import '../provider/dispute_controller.dart';

class DisputeSubmissionModal extends StatefulWidget {
  final int orderId;

  const DisputeSubmissionModal({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  State<DisputeSubmissionModal> createState() => _DisputeSubmissionModalState();
}

class _DisputeSubmissionModalState extends State<DisputeSubmissionModal> {
  final TextEditingController _descriptionController = TextEditingController();
  final List<XFile> _claimPhotos = [];
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImagesFromGallery() async {
    if (_claimPhotos.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maximum 5 photos allowed')),
      );
      return;
    }

    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          final remainingSlots = 5 - _claimPhotos.length;
          _claimPhotos.addAll(images.take(remainingSlots));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick images: $e')),
      );
    }
  }

  Future<void> _takePhoto() async {
    if (_claimPhotos.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maximum 5 photos allowed')),
      );
      return;
    }

    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (photo != null) {
        setState(() {
          _claimPhotos.add(photo);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to capture photo: $e')),
      );
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _claimPhotos.removeAt(index);
    });
  }

  Future<void> _submitDispute() async {
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please describe the issue')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final controller = Provider.of<DisputeController>(context, listen: false);

      final success = await controller.createDispute(
        orderId: widget.orderId,
        description: _descriptionController.text.trim(),
        photos: _claimPhotos.isNotEmpty ? _claimPhotos : null,
      );

      setState(() => _isSubmitting = false);

      if (success) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dispute submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit dispute: ${controller.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * .04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dispute',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth * .045,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: AppColors.backgrounHome),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(screenWidth * .04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Write Your Dispute Here',
                      style: TextStyle(
                        fontSize: screenWidth * .035,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: screenHeight * .015),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * .03,
                        vertical: screenHeight * .01,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.favouriteProductCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.BorderAnddividerAndIconColor,
                        ),
                      ),
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write Your Dispute Here, Explaining All Your Reasons',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: screenWidth * .032,
                          ),
                        ),
                        style: TextStyle(fontSize: screenWidth * .035),
                      ),
                    ),

                    SizedBox(height: screenHeight * .025),

                    if (_claimPhotos.isNotEmpty) ...[
                      Wrap(
                        spacing: screenWidth * .02,
                        runSpacing: screenHeight * .01,
                        children: _claimPhotos.asMap().entries.map((entry) {
                          return _buildPhotoThumbnail(
                            entry.value,
                            entry.key,
                            screenWidth,
                            screenHeight,
                          );
                        }).toList(),
                      ),
                      SizedBox(height: screenHeight * .02),
                    ],

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isSubmitting ? null : _pickImagesFromGallery,
                            icon: Icon(Icons.photo_library, size: screenWidth * .05),
                            label: Text('Upload Photo'),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * .015,
                              ),
                              side: BorderSide(color: AppColors.primary),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * .03),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isSubmitting ? null : _takePhoto,
                            icon: Icon(Icons.camera_alt, size: screenWidth * .05),
                            label: Text('Take Photo'),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * .015,
                              ),
                              side: BorderSide(color: AppColors.primary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(height: 1, color: AppColors.backgrounHome),
            Padding(
              padding: EdgeInsets.all(screenWidth * .04),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * .018,
                        ),
                        side: BorderSide(color: Colors.grey),
                      ),
                      child: Text('Cancel', style: TextStyle(color: Colors.grey[700])),
                    ),
                  ),
                  SizedBox(width: screenWidth * .03),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitDispute,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * .018,
                        ),
                      ),
                      child: _isSubmitting
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                             AppLocalizations.of(context)!.dispute,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoThumbnail(
    XFile photo,
    int index,
    double screenWidth,
    double screenHeight,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(photo.path),
            width: screenWidth * .28,
            height: screenWidth * .28,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: -5,
          right: -5,
          child: GestureDetector(
            onTap: () => _removePhoto(index),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
