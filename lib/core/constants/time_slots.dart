class TimeSlot {
  final int id;
  final String nameEn;
  final String nameAr;
  final String startTime;
  final String endTime;
  final String displayTime;

  const TimeSlot({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.startTime,
    required this.endTime,
    required this.displayTime,
  });

  String getLocalizedName(String locale) {
    return locale == 'ar' ? nameAr : nameEn;
  }
}

class TimeSlots {
  static const List<TimeSlot> all = [
    TimeSlot(
      id: 1,
      nameEn: 'Early Morning',
      nameAr: 'الصباح الباكر',
      startTime: '06:00:00',
      endTime: '09:00:00',
      displayTime: '6:00 AM - 9:00 AM',
    ),
    TimeSlot(
      id: 2,
      nameEn: 'Before Noon',
      nameAr: 'قبل الظهر',
      startTime: '10:00:00',
      endTime: '13:00:00',
      displayTime: '10:00 AM - 1:00 PM',
    ),
    TimeSlot(
      id: 3,
      nameEn: 'Afternoon',
      nameAr: 'بعد الظهر',
      startTime: '13:00:00',
      endTime: '17:00:00',
      displayTime: '1:00 PM - 5:00 PM',
    ),
    TimeSlot(
      id: 4,
      nameEn: 'Evening',
      nameAr: 'المساء',
      startTime: '17:00:00',
      endTime: '21:00:00',
      displayTime: '5:00 PM - 9:00 PM',
    ),
    TimeSlot(
      id: 5,
      nameEn: 'Night',
      nameAr: 'الليل',
      startTime: '20:00:00',
      endTime: '23:59:00',
      displayTime: '8:00 PM - 11:59 PM',
    ),
  ];

  static TimeSlot? getById(int id) {
    try {
      return all.firstWhere((slot) => slot.id == id);
    } catch (e) {
      return null;
    }
  }

  static String getDisplayTime(int id) {
    final slot = getById(id);
    return slot?.displayTime ?? 'Unknown';
  }

  static String getLocalizedName(int id, String locale) {
    final slot = getById(id);
    return slot?.getLocalizedName(locale) ?? 'Unknown';
  }
}
