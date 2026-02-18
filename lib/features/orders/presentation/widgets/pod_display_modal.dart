import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/colors.dart';
import '../../domain/models/order_confirmation_model.dart';

class PODDisplayModal extends StatelessWidget {
  final OrderConfirmation pod;
  final VoidCallback onDispute;

  const PODDisplayModal({
    Key? key,
    required this.pod,
    required this.onDispute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.8,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * .05),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Show Delivery Photos',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: screenWidth * .045,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, size: screenWidth * .05),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * .01),

                Text(
                  'Proof Of Order Delivery',
                  style: TextStyle(
                    fontSize: screenWidth * .035,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: screenHeight * .02),

                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    pod.photoUrl,
                    height: screenHeight * .35,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: screenHeight * .35,
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(color: AppColors.primary,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: screenHeight * .35,
                        color: Colors.grey[200],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                color: Colors.red, size: 48),
                            SizedBox(height: 8),
                            Text(
                              'Failed to load image',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: screenHeight * .02),

                Text(
                  pod.deliveryPersonName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: screenWidth * .04,
                  ),
                ),
                SizedBox(height: screenHeight * .005),

                Text(
                  _formatDate(pod.confirmedAt),
                  style: TextStyle(
                    fontSize: screenWidth * .032,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: screenHeight * .025),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * .018,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Done',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * .03),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onDispute();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * .018,
                          ),
                          side: BorderSide(color: AppColors.primary, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Dispute',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
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

  String _formatDate(DateTime dt) {
    return DateFormat('d MMM y \'at\' h:mm a').format(dt);
  }
}
