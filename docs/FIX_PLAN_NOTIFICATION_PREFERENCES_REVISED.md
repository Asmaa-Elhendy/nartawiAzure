# 🔧 FIX PLAN: Notification Preferences (REVISED)

**Issue #3:** Low Coupon Alerts and Wallet Balance Alerts missing  
**Status:** ✅ Backend Confirmed - Ready for Implementation  
**Date:** January 12, 2026 10:35 PM  
**Approach:** Simplified - Add 4 fields only, restore legacy SettingCard UI

---

## ✅ BACKEND CONFIRMATION COMPLETE

### **Confirmed Field Names (camelCase):**
```json
{
  "lowCouponsAlerts": true,
  "lowCouponsThreshold": 100,
  "walletBalanceAlerts": true,
  "walletBalanceThreshold": 100.00,
  "disputes": true,
  "orderUpdates": true,
  "system": true,
  "promotions": true,
  "pushEnabled": true,
  "emailEnabled": false
}
```

### **Database Columns (confirmed):**
- `LOW_COUPONS_ALERTS` (bit)
- `LOW_COUPONS_THRESHOLD` (int)
- `WALLET_BALANCE_ALERTS` (bit)
- `WALLET_BALANCE_THRESHOLD` (decimal(18,2))

---

## 🎯 IMPLEMENTATION STRATEGY

### **Phase 1: Update Data Model** (30 minutes)
**File:** `lib/features/notification/data/datasources/notification_preferences_datasource.dart`

**Add 4 new fields only:**
1. `lowCouponsAlerts` (bool)
2. `lowCouponsThreshold` (int)
3. `walletBalanceAlerts` (bool)
4. `walletBalanceThreshold` (double)

**Hardcode static values in toJson():**
- `disputes: true`
- `orderUpdates: true`
- `system: true`
- `promotions: true`
- `pushEnabled: true`
- `emailEnabled: false`

**No dynamic state for these - they're always true/false as specified**

---

### **Phase 2: Restore Legacy UI** (45 minutes)
**File:** `lib/features/profile/presentation/pages/settings.dart`

**Replace current M1.0.4 SwitchListTile widgets with legacy SettingCard widgets:**

```dart
Text(
  'Notification Preferences',
  style: TextStyle(fontWeight: FontWeight.w700, fontSize: screenWidth * .04),
),
SettingCard(
  title: 'Low Coupon Alerts',
  description: 'Get notified when your coupon balance is running low',
  quantityLabel: 'Coupons',
  isIncrease: true,  // Shows threshold input
),
SettingCard(
  title: 'Wallet Balance Alerts',
  description: 'Get alerts when your wallet balance is low',
  quantityLabel: 'QAR',
  isIncrease: true,  // Shows threshold input
),
SettingCard(
  title: 'Order Updates',
  description: 'Receive notifications about your order status',
  quantityLabel: '',
  isIncrease: false,  // Toggle only, no threshold
),
SettingCard(
  title: 'Refill Updates',
  description: 'Get notified when your bottles have been refilled',
  quantityLabel: '',
  isIncrease: false,  // Toggle only, no threshold
),
SettingCard(
  title: 'Promotions & Offers',
  description: 'Receive notifications about promotions and special offers',
  quantityLabel: '',
  isIncrease: false,  // Toggle only, no threshold
),
```

**Why restore legacy UI?**
- ✅ Signed-off UI design must NOT be changed
- ✅ `SettingCard` widget already exists and matches design
- ❌ M1.0.4 incorrectly replaced it with SwitchListTile

---

## 📝 DETAILED IMPLEMENTATION

### **PHASE 1: Data Model Changes**

#### **File: `notification_preferences_datasource.dart`**

**Step 1: Update NotificationPreferences class**

```dart
class NotificationPreferences {
  // ✅ NEW: Alert fields only
  final bool lowCouponsAlerts;
  final int lowCouponsThreshold;
  final bool walletBalanceAlerts;
  final double walletBalanceThreshold;

  NotificationPreferences({
    required this.lowCouponsAlerts,
    required this.lowCouponsThreshold,
    required this.walletBalanceAlerts,
    required this.walletBalanceThreshold,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      lowCouponsAlerts: json['lowCouponsAlerts'] as bool? ?? true,
      lowCouponsThreshold: json['lowCouponsThreshold'] as int? ?? 100,
      walletBalanceAlerts: json['walletBalanceAlerts'] as bool? ?? true,
      walletBalanceThreshold: (json['walletBalanceThreshold'] as num?)?.toDouble() ?? 100.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // Dynamic alert fields
      'lowCouponsAlerts': lowCouponsAlerts,
      'lowCouponsThreshold': lowCouponsThreshold,
      'walletBalanceAlerts': walletBalanceAlerts,
      'walletBalanceThreshold': walletBalanceThreshold,
      
      // Static hardcoded values (as per user specification)
      'disputes': true,
      'orderUpdates': true,
      'system': true,
      'promotions': true,
      'pushEnabled': true,
      'emailEnabled': false,
    };
  }
}
```

**Impact:** Model now has only 4 dynamic fields, rest are static

---

### **PHASE 2: UI Changes**

#### **File: `settings.dart`**

**Step 1: Update state variables**

Remove all the M1.0.4 variables and add only the 4 needed:

```dart
class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late NotificationPreferencesDataSourceImpl _prefsDataSource;

  // Only 4 state variables needed
  bool _lowCouponsAlerts = true;
  int _lowCouponsThreshold = 100;
  bool _walletBalanceAlerts = true;
  double _walletBalanceThreshold = 100.0;
  
  bool _isLoadingPrefs = true;
  
  // ... rest of code
}
```

**Step 2: Update _loadPreferences() method**

```dart
Future<void> _loadPreferences() async {
  try {
    final prefs = await _prefsDataSource.getPreferences();
    if (mounted) {
      setState(() {
        _lowCouponsAlerts = prefs.lowCouponsAlerts;
        _lowCouponsThreshold = prefs.lowCouponsThreshold;
        _walletBalanceAlerts = prefs.walletBalanceAlerts;
        _walletBalanceThreshold = prefs.walletBalanceThreshold;
        _isLoadingPrefs = false;
      });
    }
  } catch (e) {
    print('Error loading preferences: $e');
    if (mounted) {
      setState(() => _isLoadingPrefs = false);
    }
  }
}
```

**Step 3: Update _updatePreferences() method**

```dart
Future<void> _updatePreferences() async {
  try {
    final prefs = NotificationPreferences(
      lowCouponsAlerts: _lowCouponsAlerts,
      lowCouponsThreshold: _lowCouponsThreshold,
      walletBalanceAlerts: _walletBalanceAlerts,
      walletBalanceThreshold: _walletBalanceThreshold,
    );

    await _prefsDataSource.updatePreferences(prefs);
  } catch (e) {
    print('Error updating preferences: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save preferences')),
      );
    }
  }
}
```

**Step 4: Replace UI section - Remove M1.0.4 SwitchListTiles**

Find the current "Notification Preferences" section (lines ~127-241 in settings.dart) and replace with:

```dart
Text(
  'Notification Preferences',
  style: TextStyle(fontWeight: FontWeight.w700, fontSize: screenWidth * .04),
),
SizedBox(height: screenHeight * .01),

if (_isLoadingPrefs)
  Center(
    child: Padding(
      padding: EdgeInsets.all(20),
      child: CircularProgressIndicator(),
    ),
  )
else ...[
  SettingCard(
    title: 'Low Coupon Alerts',
    description: 'Get notified when your coupon balance is running low',
    quantityLabel: 'Coupons',
    isIncrease: true,
  ),
  SettingCard(
    title: 'Wallet Balance Alerts',
    description: 'Get alerts when your wallet balance is low',
    quantityLabel: 'QAR',
    isIncrease: true,
  ),
  SettingCard(
    title: 'Order Updates',
    description: 'Receive notifications about your order status',
    quantityLabel: '',
    isIncrease: false,
  ),
  SettingCard(
    title: 'Refill Updates',
    description: 'Get notified when your bottles have been refilled',
    quantityLabel: '',
    isIncrease: false,
  ),
  SettingCard(
    title: 'Promotions & Offers',
    description: 'Receive notifications about promotions and special offers',
    quantityLabel: '',
    isIncrease: false,
  ),
],
```

---

## ⚠️ IMPORTANT: SettingCard Widget Integration

**The SettingCard widget needs modifications to work with notification preferences:**

Currently `SettingCard` has:
- Internal `_isSwitched` state (line 25)
- Internal `ProductQuantityBloc` for threshold (lines 26-45)

**We need to:**
1. Add callbacks to `SettingCard` constructor for external state management
2. Pass toggle state and threshold values FROM parent (settings.dart)
3. Call parent's `_updatePreferences()` when values change

**Modified SettingCard constructor needed:**
```dart
class SettingCard extends StatefulWidget {
  final String title;
  final String description;
  final String quantityLabel;
  final bool isIncrease;
  
  // ✅ NEW: External state management
  final bool? switchValue;
  final int? initialThreshold;
  final Function(bool)? onSwitchChanged;
  final Function(int)? onThresholdChanged;
  
  SettingCard({
    required this.title,
    required this.description,
    required this.quantityLabel,
    this.isIncrease = true,
    this.switchValue,
    this.initialThreshold,
    this.onSwitchChanged,
    this.onThresholdChanged,
  });
}
```

**OR simpler approach:** Create a new widget `NotificationSettingCard` specifically for this use case.

---

## 📁 FILES TO MODIFY

| # | File | Action | Lines |
|---|------|--------|-------|
| 1 | `notification_preferences_datasource.dart` | Replace entire model class | 4-38 |
| 2 | `settings.dart` | Update state variables | 27-32 |
| 3 | `settings.dart` | Update _loadPreferences | 41-60 |
| 4 | `settings.dart` | Update _updatePreferences | 62-81 |
| 5 | `settings.dart` | Replace UI section with SettingCards | 127-241 |
| 6 | `setting_card.dart` (optional) | Add callbacks for external state | 12-17 |

**Total:** 2-3 files, ~150 lines of changes

---

## 🧪 TESTING CHECKLIST

- [ ] Load preferences from backend on settings screen open
- [ ] Low Coupon Alerts toggle works
- [ ] Low Coupon threshold input works (saves on change)
- [ ] Wallet Balance Alerts toggle works
- [ ] Wallet Balance threshold input works (saves on change)
- [ ] Order Updates toggle works (no threshold shown)
- [ ] Refill Updates toggle works (no threshold shown)
- [ ] Promotions toggle works (no threshold shown)
- [ ] Backend receives correct JSON with all 10 fields
- [ ] Hardcoded fields (disputes, orderUpdates, etc.) always true/false
- [ ] Refresh screen and verify values persist

---

## ⏱️ IMPLEMENTATION TIME

| Phase | Time |
|-------|------|
| Phase 1: Data model | 30 min |
| Phase 2: Settings UI | 45 min |
| SettingCard modifications | 30 min |
| Testing | 30 min |
| **Total** | **2.25 hours** |

---

## 🚀 NEXT STEPS

**Ready to proceed with implementation?**

1. I can implement Phase 1 (data model) immediately
2. Then implement Phase 2 (UI changes with SettingCard)
3. Handle SettingCard widget integration challenge

**Question:** Should I:
- **Option A:** Modify existing `SettingCard` widget to accept callbacks?
- **Option B:** Create new `NotificationSettingCard` widget for this use case?
- **Option C:** You'll handle SettingCard integration separately?

Let me know and I'll proceed with the implementation!

---

**Status:** 🟢 Ready to implement  
**Blocked:** None - Backend confirmed, approach clarified  
**Estimated completion:** 2.25 hours
