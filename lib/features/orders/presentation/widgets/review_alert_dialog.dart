import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dio/dio.dart';
import '../../../../core/theme/colors.dart';
import '../../../home/presentation/provider/supplier_reviews_controller.dart';
import 'cancel_order_buttons.dart';
import 'custom_text_field_alert.dart';
import 'package:newwwwwwww/core/services/dio_service.dart';

class ReviewAlertDialog extends StatefulWidget {
  final int orderId;
  final int supplierId;
  final String supplierName;
  
  const ReviewAlertDialog({
    super.key,
    required this.orderId,
    required this.supplierId,
    required this.supplierName,
  });

  @override
  State<ReviewAlertDialog> createState() => _ReviewAlertDialogState();
}

class _ReviewAlertDialogState extends State<ReviewAlertDialog> {
  late SupplierReviewsController _controller;
  
  double _orderRating = 0;
  double _sellerRating = 0;
  double _deliveryRating = 0;
  
  final TextEditingController _orderCommentController = TextEditingController();
  final TextEditingController _sellerCommentController = TextEditingController();
  final TextEditingController _deliveryCommentController = TextEditingController();
  
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _controller = SupplierReviewsController(dio: DioService.dio);
  }

  @override
  void dispose() {
    _orderCommentController.dispose();
    _sellerCommentController.dispose();
    _deliveryCommentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_sellerRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please rate the seller'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final avgRating = ((_orderRating + _sellerRating + _deliveryRating) / 3).round();
    
    final combinedComment = [
      if (_orderCommentController.text.isNotEmpty) 
        'Order: ${_orderCommentController.text}',
      if (_sellerCommentController.text.isNotEmpty) 
        'Seller: ${_sellerCommentController.text}',
      if (_deliveryCommentController.text.isNotEmpty) 
        'Delivery: ${_deliveryCommentController.text}',
    ].join(' | ');

    final success = await _controller.submitReview(
      orderId: widget.orderId,
      supplierId: widget.supplierId,
      rating: avgRating,
      comment: combinedComment.isNotEmpty ? combinedComment : null,
    );

    setState(() => _isSubmitting = false);

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Thank you for your review!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_controller.error ?? 'Failed to submit review'),
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
      // Use Dialog instead of AlertDialog
      backgroundColor: AppColors.backgroundAlert,
      insetPadding: EdgeInsets.all(16), // controls distance from screen edges
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.94, // 90% screen width
        height: MediaQuery.of(context).size.height * 0.7, // adjust height
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * .02,
            horizontal: screenWidth * .05,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Leave Review',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: screenWidth * .04,
                          ),
                        ),
                        Text(
                          widget.supplierName,
                          style: TextStyle(
                            fontSize: screenWidth * .035,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        size: screenWidth * .05,
                        color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * .01),

_buildRatingSection(
                  'Order Experience',
                  _orderRating,
                  (rating) => setState(() => _orderRating = rating),
                  _orderCommentController,
                  screenWidth,
                  screenHeight,
                ),
                _buildRatingSection(
                  'Seller Experience',
                  _sellerRating,
                  (rating) => setState(() => _sellerRating = rating),
                  _sellerCommentController,
                  screenWidth,
                  screenHeight,
                ),
                _buildRatingSection(
                  'Delivery Experience',
                  _deliveryRating,
                  (rating) => setState(() => _deliveryRating = rating),
                  _deliveryCommentController,
                  screenWidth,
                  screenHeight,
                ),
SizedBox(height: screenHeight * .02),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitReview,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: _isSubmitting
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Submit Review',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

  Widget _buildRatingSection(
    String title,
    double rating,
    Function(double) onRatingChanged,
    TextEditingController commentController,
    double screenWidth,
    double screenHeight,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: screenWidth * .04,
          ),
        ),
        SizedBox(height: 8),
        RatingBar(
          initialRating: rating,
          maxRating: 5,
          glow: false,
          allowHalfRating: false,
          itemSize: screenWidth * .07,
          itemPadding: EdgeInsets.symmetric(horizontal: screenWidth * .01),
          ratingWidget: RatingWidget(
            full: Icon(Icons.star, color: Colors.amber),
            half: Icon(Icons.star_half, color: Colors.amber),
            empty: Icon(Icons.star_border, color: Colors.amber),
          ),
          onRatingUpdate: onRatingChanged,
        ),
        SizedBox(height: 8),
        TextField(
          controller: commentController,
          decoration: InputDecoration(
            hintText: 'Write your review here (optional)',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(12),
          ),
          maxLines: 2,
          maxLength: 300,
        ),
        SizedBox(height: screenHeight * .01),
      ],
    );
  }

