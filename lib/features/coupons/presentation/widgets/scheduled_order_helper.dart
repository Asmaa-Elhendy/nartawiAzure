import 'package:flutter/material.dart';
import '../../data/models/scheduled_order_model.dart';
import '../../domain/models/bundle_purchase.dart';
import '../provider/coupon_controller.dart';
import '../../../../core/constants/time_slots.dart';

class ScheduledOrderHelper {
  static Future<int?> selectDeliveryAddress(BuildContext context) async {
    return await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Delivery Address'),
        content: const Text(
          'Address selection dialog will be implemented.\n\n'
          'For now, please ensure you have a default address set in your profile.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, 1),
            child: const Text('Use Default Address'),
          ),
        ],
      ),
    );
  }

  static Future<bool> confirmScheduleCreation(
    BuildContext context, {
    required int weeklyFrequency,
    required int bottlesPerDelivery,
    required Set<int> selectedDays,
    required int timeSlotId,
  }) async {
    final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final selectedDayNames = selectedDays.map((d) => dayNames[d]).join(', ');
    final timeSlotName = TimeSlots.getById(timeSlotId)?.displayTime ?? 'Unknown';

    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Schedule'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Weekly Frequency: $weeklyFrequency day(s)'),
            const SizedBox(height: 8),
            Text('Bottles Per Delivery: $bottlesPerDelivery'),
            const SizedBox(height: 8),
            Text('Preferred Days: $selectedDayNames'),
            const SizedBox(height: 8),
            Text('Time Slot: $timeSlotName'),
            const SizedBox(height: 16),
            const Text(
              'Your schedule will be sent for vendor approval.',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    ) ?? false;
  }

  static Future<bool> confirmScheduleDeletion(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Schedule?'),
        content: const Text(
          'Are you sure you want to cancel this scheduled delivery?\n\n'
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    ) ?? false;
  }

  static void showScheduleStatus(
    BuildContext context, {
    required ScheduledOrderModel schedule,
  }) {
    String statusMessage = '';
    Color statusColor = Colors.blue;

    switch (schedule.approvalStatus?.toLowerCase()) {
      case 'pending':
        statusMessage = 'Your schedule is pending vendor approval.';
        statusColor = Colors.orange;
        break;
      case 'approved':
        statusMessage = 'Your schedule has been approved!';
        statusColor = Colors.green;
        break;
      case 'rejected':
        statusMessage = 'Your schedule was rejected.\nReason: ${schedule.rejectionReason ?? "No reason provided"}';
        statusColor = Colors.red;
        break;
      default:
        statusMessage = 'Status: ${schedule.approvalStatus ?? "Unknown"}';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: statusColor),
            const SizedBox(width: 8),
            const Text('Schedule Status'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(statusMessage),
            const SizedBox(height: 16),
            if (schedule.vendorNotes != null && schedule.vendorNotes!.isNotEmpty) ...[
              const Text(
                'Vendor Notes:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(schedule.vendorNotes!),
              const SizedBox(height: 16),
            ],
            if (schedule.nextScheduledDelivery != null) ...[
              const Text(
                'Next Scheduled Delivery:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                schedule.nextScheduledDelivery!.toLocal().toString().split('.')[0],
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  static String getApprovalStatusDisplay(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return 'Pending Approval';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      default:
        return status ?? 'Unknown';
    }
  }

  static Color getApprovalStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  static Future<void> saveSchedule({
    required BuildContext context,
    required CouponsController controller,
    required BundlePurchase bundle,
    required int weeklyFrequency,
    required int bottlesPerDelivery,
    required Set<int> selectedDays,
    required int timeSlotId,
    required bool autoRenewEnabled,
    int? lowBalanceThreshold,
    ScheduledOrderModel? existingSchedule,
  }) async {
    if (weeklyFrequency <= 0 || weeklyFrequency > 7) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Weekly frequency must be between 1-7 days'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedDays.length != weeklyFrequency) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select exactly $weeklyFrequency day(s)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final confirmed = await confirmScheduleCreation(
      context,
      weeklyFrequency: weeklyFrequency,
      bottlesPerDelivery: bottlesPerDelivery,
      selectedDays: selectedDays,
      timeSlotId: timeSlotId,
    );

    if (!confirmed) return;

    final addressId = await selectDeliveryAddress(context);
    if (addressId == null) return;

    final scheduleEntries = selectedDays.map((dayIndex) {
      return ScheduleEntry(
        dayOfWeek: dayIndex,
        timeSlotId: timeSlotId,
      );
    }).toList();

    try {
      if (existingSchedule != null) {
        final updated = await controller.updateScheduledOrder(
          id: existingSchedule.id,
          weeklyFrequency: weeklyFrequency,
          bottlesPerDelivery: bottlesPerDelivery,
          schedule: scheduleEntries,
          deliveryAddressId: addressId,
          autoRenewEnabled: autoRenewEnabled,
          lowBalanceThreshold: lowBalanceThreshold,
        );

        if (updated != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Schedule updated! Pending vendor approval.'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          throw Exception(controller.schedulesError ?? 'Failed to update schedule');
        }
      } else {
        final created = await controller.createScheduledOrder(
          bundlePurchaseId: bundle.id,
          weeklyFrequency: weeklyFrequency,
          bottlesPerDelivery: bottlesPerDelivery,
          schedule: scheduleEntries,
          deliveryAddressId: addressId,
          autoRenewEnabled: autoRenewEnabled,
          lowBalanceThreshold: lowBalanceThreshold,
        );

        if (created != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Schedule created! Pending vendor approval.'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          throw Exception(controller.schedulesError ?? 'Failed to create schedule');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  static Future<void> deleteSchedule({
    required BuildContext context,
    required CouponsController controller,
    required ScheduledOrderModel schedule,
  }) async {
    final confirmed = await confirmScheduleDeletion(context);
    if (!confirmed) return;

    final success = await controller.deleteScheduledOrder(schedule.id);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Schedule cancelled successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.schedulesError ?? 'Failed to cancel schedule'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
