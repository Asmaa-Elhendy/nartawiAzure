import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/colors.dart';
import '../../domain/models/dispute_model.dart';

class DisputeStatusModal extends StatelessWidget {
  final Dispute dispute;

  const DisputeStatusModal({
    Key? key,
    required this.dispute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.7,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * .05),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dispute Details',
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
                SizedBox(height: screenHeight * .02),

                _buildStatusBadge(screenWidth),
                SizedBox(height: screenHeight * .02),

                Text(
                  'Dispute Reason',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: screenWidth * .038,
                  ),
                ),
                SizedBox(height: screenHeight * .01),
                Text(
                  dispute.description,
                  style: TextStyle(
                    fontSize: screenWidth * .035,
                    color: Colors.grey[700],
                  ),
                ),

                if (dispute.resolution != null && dispute.resolution!.isNotEmpty) ...[
                  SizedBox(height: screenHeight * .02),
                  Text(
                    'Resolution',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * .038,
                    ),
                  ),
                  SizedBox(height: screenHeight * .01),
                  Text(
                    dispute.resolution!,
                    style: TextStyle(
                      fontSize: screenWidth * .035,
                      color: Colors.grey[700],
                    ),
                  ),
                ],

                SizedBox(height: screenHeight * .02),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Submitted',
                      style: TextStyle(
                        fontSize: screenWidth * .032,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      _formatDate(dispute.createdAt),
                      style: TextStyle(
                        fontSize: screenWidth * .032,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                if (dispute.resolvedAt != null) ...[
                  SizedBox(height: screenHeight * .01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Resolved',
                        style: TextStyle(
                          fontSize: screenWidth * .032,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        _formatDate(dispute.resolvedAt!),
                        style: TextStyle(
                          fontSize: screenWidth * .032,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],

                if (dispute.photoUrls.isNotEmpty) ...[
                  SizedBox(height: screenHeight * .02),
                  Text(
                    'Evidence Photos',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * .038,
                    ),
                  ),
                  SizedBox(height: screenHeight * .01),
                  Wrap(
                    spacing: screenWidth * .02,
                    runSpacing: screenHeight * .01,
                    children: dispute.photoUrls.take(3).map((url) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          url,
                          width: screenWidth * .25,
                          height: screenWidth * .25,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: screenWidth * .25,
                            height: screenWidth * .25,
                            color: Colors.grey[300],
                            child: Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],

                SizedBox(height: screenHeight * .025),

                SizedBox(
                  width: double.infinity,
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
                      'Close',
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
        ),
      ),
    );
  }

  Widget _buildStatusBadge(double screenWidth) {
    Color badgeColor;
    String statusText;

    switch (dispute.status) {
      case DisputeStatus.resolved:
        badgeColor = Colors.green;
        statusText = 'Dispute Resolved';
        break;
      case DisputeStatus.rejected:
        badgeColor = Colors.red;
        statusText = 'Dispute Rejected';
        break;
      case DisputeStatus.responded:
        badgeColor = Colors.orange;
        statusText = 'Dispute Responded';
        break;
      case DisputeStatus.open:
      default:
        badgeColor = Colors.blue;
        statusText = 'Dispute Open';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * .04,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: screenWidth * .035,
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return DateFormat('MMM d, y').format(dt);
  }
}
