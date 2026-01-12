# 🔧 FIX PLAN: Notification Preferences - Missing Fields (REVISED)

**Issue:** Notification Preferences model missing fields for Low Coupon Alerts and Wallet Balance Alerts  
**Severity:** MEDIUM - Feature Incomplete  
**Discovered:** Code review of M1.0.4 commit  
**Status:** ✅ Backend Confirmed - Ready for Implementation  
**Updated:** January 12, 2026 10:35 PM - Revised based on user feedback

---

## ✅ REVISED APPROACH (User Confirmed)

### **Backend Confirmation Received**

**Q1:** Does backend support `lowCouponsAlerts` + `lowCouponsThreshold`?  
✅ **YES** - Fields added to database, entity, DTO, and API

**Q2:** Does backend support `walletBalanceAlerts` + `walletBalanceThreshold`?  
✅ **YES** - Fields added to database, entity, DTO, and API

**Q3:** Exact field names (camelCase for JSON)?  
```json
{
  "lowCouponsAlerts": true,
  "lowCouponsThreshold": 100,
  "walletBalanceAlerts": true,
  "walletBalanceThreshold": 100.00
}
```

**Q4:** Database columns (UPPER_SNAKE_CASE)?  
- `LOW_COUPONS_ALERTS` (bit)
- `LOW_COUPONS_THRESHOLD` (int)
- `WALLET_BALANCE_ALERTS` (bit)  
- `WALLET_BALANCE_THRESHOLD` (decimal(18,2))

### **Implementation Strategy**

**Phase 1: Data Model**
- Add ONLY 4 new fields: `lowCouponsAlerts`, `lowCouponsThreshold`, `walletBalanceAlerts`, `walletBalanceThreshold`
- Hardcode static values in `toJson()`: `disputes: true`, `orderUpdates: true`, `system: true`, `promotions: true`, `pushEnabled: true`, `emailEnabled: false`
- Remove all dynamic state for non-alert preferences (user doesn't want toggles for these)

**Phase 2: UI - Restore Legacy Design**
- Use signed-off `SettingCard` widget (NOT new SwitchListTile approach)
- 5 SettingCard widgets:
  1. Low Coupon Alerts (toggle + threshold)
  2. Wallet Balance Alerts (toggle + threshold)
  3. Order Updates (toggle only, no threshold)
  4. Refill Updates (toggle only, no threshold)
  5. Promotions & Offers (toggle only, no threshold)

**Why Legacy UI?**
- Signed-off UI design must NOT be changed
- Original `SettingCard` widget already exists and matches design
- Previous M1.0.4 implementation incorrectly replaced it with SwitchListTile

---

## 🎯 EXECUTIVE SUMMARY

### **The Problem**

The `NotificationPreferences` model is **incomplete** and doesn't match either:
1. **UI Design Specification** (`settings.png`)
2. **Backend API Contract** (COMPREHENSIVE_BACKEND_RESPONSES_PART2.md)

**Current Implementation (WRONG):**
- Only 5 notification preferences implemented
- Missing Low Coupon Alerts toggle + threshold
- Missing Wallet Balance Alerts toggle + threshold
- Missing backend API fields (pushEnabled, emailEnabled, smsEnabled)
- Field name mismatch: `marketing` vs `marketingMessages`

**Expected Implementation (CORRECT):**
- Should have 7+ notification preferences
- Should include Low Coupon Alerts with threshold setting
- Should include Wallet Balance Alerts with threshold setting
- Should match backend API field names exactly

---

## 🔍 DETAILED INVESTIGATION FINDINGS

### **1. UI Design Specification Analysis**

**Source:** QA Report - `docs/QA/QA_REPORT_MODULE_PROFILE_SETTINGS.md` (Lines 343-352)

**UI Design (`settings.png`) Requirements:**
```
Notification Preferences section:
- Low Coupon Alerts (toggle + threshold)          ❌ MISSING
- Wallet Balance Alerts (toggle + threshold)      ❌ MISSING
- Order Updates (toggle)                          ✅ Implemented
- Refill Updates (toggle)                         ✅ Implemented (as scheduledOrderReminders)
- Promotions & Offers (toggle)                    ⚠️ Implemented (wrong name: "marketing")
```

**Key Finding:** UI design specifies **LOW COUPON ALERTS** and **WALLET BALANCE ALERTS** with threshold values, but these are completely missing from the implementation.

---

### **2. Backend API Contract Analysis**

**Source:** `docs/COMPREHENSIVE_BACKEND_RESPONSES_PART2.md` (Lines 721-737)

**Backend API Payload:**
```json
{
  "orderUpdates": true,
  "scheduledOrderReminders": true,
  "disputeUpdates": true,
  "systemNotifications": true,
  "marketingMessages": false,           // ❌ Mobile sends "marketing"
  "pushEnabled": true,                  // ❌ MISSING in mobile
  "emailEnabled": true,                 // ❌ MISSING in mobile
  "smsEnabled": false                   // ❌ MISSING in mobile
}
```

**Endpoint:** 
- `GET /api/v1/client/notifications/preferences`
- `PUT /api/v1/client/notifications/preferences`

**Key Finding:** Backend supports 8 fields, but mobile only sends 5 fields.

---

### **3. Current Mobile Implementation Analysis**

#### **File 1: `notification_preferences_datasource.dart`**

**Current Model (INCOMPLETE):**
```dart
class NotificationPreferences {
  final bool orderUpdates;              // ✅ Matches backend
  final bool scheduledOrderReminders;   // ✅ Matches backend
  final bool disputeUpdates;            // ✅ Matches backend
  final bool marketing;                 // ❌ Should be "marketingMessages"
  final bool systemNotifications;       // ✅ Matches backend
  
  // ❌ MISSING FIELDS:
  // final bool lowCouponsAlerts;
  // final int? lowCouponsThreshold;
  // final bool walletBalanceAlerts;
  // final int? walletBalanceThreshold;
  // final bool pushEnabled;
  // final bool emailEnabled;
  // final bool smsEnabled;
}
```

**Current toJson() (INCOMPLETE):**
```dart
Map<String, dynamic> toJson() {
  return {
    'orderUpdates': orderUpdates,
    'scheduledOrderReminders': scheduledOrderReminders,
    'disputeUpdates': disputeUpdates,
    'marketing': marketing,                    // ❌ Wrong key name
    'systemNotifications': systemNotifications,
    // ❌ Missing all other fields
  };
}
```

#### **File 2: `settings.dart`**

**Current State Variables (INCOMPLETE):**
```dart
bool _orderUpdates = true;
bool _scheduledOrderReminders = true;
bool _disputeUpdates = true;
bool _marketing = false;
bool _systemNotifications = true;
bool _isLoadingPrefs = true;

// ❌ MISSING:
// bool _lowCouponsAlerts = true;
// int _lowCouponsThreshold = 5;
// bool _walletBalanceAlerts = true;
// int _walletBalanceThreshold = 10;
// bool _pushEnabled = true;
// bool _emailEnabled = true;
// bool _smsEnabled = false;
```

**Current UI (INCOMPLETE):**
- Only 5 SwitchListTile widgets
- No Low Coupon Alerts section
- No Wallet Balance Alerts section
- No threshold input fields

---

## 📊 IMPACT ASSESSMENT

### **Missing Features:**

1. **Low Coupon Alerts** ❌
   - **What it is:** Notify user when coupon balance falls below threshold
   - **UI Element:** Toggle + threshold number input
   - **Backend Field:** TBD (need to confirm with backend)
   - **User Impact:** Users can't set low coupon warnings

2. **Wallet Balance Alerts** ❌
   - **What it is:** Notify user when wallet balance falls below threshold
   - **UI Element:** Toggle + threshold number input
   - **Backend Field:** TBD (need to confirm with backend)
   - **User Impact:** Users can't set low wallet warnings

3. **Channel Preferences** ❌
   - **Missing:** `pushEnabled`, `emailEnabled`, `smsEnabled`
   - **UI Element:** Not in UI design (backend only?)
   - **User Impact:** Can't control notification channels

4. **Field Name Mismatch** ⚠️
   - **Current:** `marketing`
   - **Backend expects:** `marketingMessages`
   - **Impact:** Backend may not save marketing preferences correctly

---

## 🔧 COMPREHENSIVE FIX PLAN

### **CRITICAL QUESTION FOR BACKEND TEAM:**

Before implementing, we need backend team to confirm:

**Q1:** Does the backend support `lowCouponsAlerts` and `lowCouponsThreshold` fields?
**Q2:** Does the backend support `walletBalanceAlerts` and `walletBalanceThreshold` fields?
**Q3:** Should mobile UI include channel preferences (push/email/SMS toggles)?
**Q4:** What are the exact field names in the backend API for all preferences?

**Expected Backend Response Format:**
```json
{
  "orderUpdates": true,
  "scheduledOrderReminders": true,
  "disputeUpdates": true,
  "systemNotifications": true,
  "marketingMessages": false,
  "lowCouponsAlerts": true,          // ❓ Confirm this exists
  "lowCouponsThreshold": 5,          // ❓ Confirm this exists
  "walletBalanceAlerts": true,       // ❓ Confirm this exists
  "walletBalanceThreshold": 10,      // ❓ Confirm this exists
  "pushEnabled": true,
  "emailEnabled": true,
  "smsEnabled": false
}
```

---

### **Phase 1: Update Data Model** (30 minutes)

#### **File: `notification_preferences_datasource.dart`**

**Change 1: Update NotificationPreferences class**

```dart
class NotificationPreferences {
  // Existing fields
  final bool orderUpdates;
  final bool scheduledOrderReminders;
  final bool disputeUpdates;
  final bool marketingMessages;        // ✅ RENAMED from "marketing"
  final bool systemNotifications;
  
  // ✅ NEW: Alert fields
  final bool lowCouponsAlerts;
  final int? lowCouponsThreshold;
  final bool walletBalanceAlerts;
  final int? walletBalanceThreshold;
  
  // ✅ NEW: Channel preferences
  final bool pushEnabled;
  final bool emailEnabled;
  final bool smsEnabled;

  NotificationPreferences({
    required this.orderUpdates,
    required this.scheduledOrderReminders,
    required this.disputeUpdates,
    required this.marketingMessages,
    required this.systemNotifications,
    required this.lowCouponsAlerts,
    this.lowCouponsThreshold,
    required this.walletBalanceAlerts,
    this.walletBalanceThreshold,
    required this.pushEnabled,
    required this.emailEnabled,
    required this.smsEnabled,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      orderUpdates: json['orderUpdates'] as bool? ?? true,
      scheduledOrderReminders: json['scheduledOrderReminders'] as bool? ?? true,
      disputeUpdates: json['disputeUpdates'] as bool? ?? true,
      marketingMessages: json['marketingMessages'] as bool? ?? false,  // ✅ RENAMED
      systemNotifications: json['systemNotifications'] as bool? ?? true,
      lowCouponsAlerts: json['lowCouponsAlerts'] as bool? ?? true,      // ✅ NEW
      lowCouponsThreshold: json['lowCouponsThreshold'] as int?,         // ✅ NEW
      walletBalanceAlerts: json['walletBalanceAlerts'] as bool? ?? true, // ✅ NEW
      walletBalanceThreshold: json['walletBalanceThreshold'] as int?,   // ✅ NEW
      pushEnabled: json['pushEnabled'] as bool? ?? true,                // ✅ NEW
      emailEnabled: json['emailEnabled'] as bool? ?? true,              // ✅ NEW
      smsEnabled: json['smsEnabled'] as bool? ?? false,                 // ✅ NEW
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderUpdates': orderUpdates,
      'scheduledOrderReminders': scheduledOrderReminders,
      'disputeUpdates': disputeUpdates,
      'marketingMessages': marketingMessages,                           // ✅ RENAMED
      'systemNotifications': systemNotifications,
      'lowCouponsAlerts': lowCouponsAlerts,                             // ✅ NEW
      if (lowCouponsThreshold != null) 
        'lowCouponsThreshold': lowCouponsThreshold,                     // ✅ NEW
      'walletBalanceAlerts': walletBalanceAlerts,                       // ✅ NEW
      if (walletBalanceThreshold != null) 
        'walletBalanceThreshold': walletBalanceThreshold,               // ✅ NEW
      'pushEnabled': pushEnabled,                                       // ✅ NEW
      'emailEnabled': emailEnabled,                                     // ✅ NEW
      'smsEnabled': smsEnabled,                                         // ✅ NEW
    };
  }
}
```

**Impact:** Data model now matches backend API contract

---

### **Phase 2: Update Settings Screen** (60 minutes)

#### **File: `settings.dart`**

**Change 1: Add new state variables**

```dart
class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late NotificationPreferencesDataSourceImpl _prefsDataSource;

  // Existing
  bool _orderUpdates = true;
  bool _scheduledOrderReminders = true;
  bool _disputeUpdates = true;
  bool _marketingMessages = false;           // ✅ RENAMED
  bool _systemNotifications = true;
  
  // ✅ NEW: Alert preferences
  bool _lowCouponsAlerts = true;
  int _lowCouponsThreshold = 5;
  bool _walletBalanceAlerts = true;
  int _walletBalanceThreshold = 10;
  
  // ✅ NEW: Channel preferences (optional - may not show in UI)
  bool _pushEnabled = true;
  bool _emailEnabled = true;
  bool _smsEnabled = false;
  
  bool _isLoadingPrefs = true;
  
  // ... rest of code
}
```

**Change 2: Update _loadPreferences() method**

```dart
Future<void> _loadPreferences() async {
  try {
    final prefs = await _prefsDataSource.getPreferences();
    if (mounted) {
      setState(() {
        _orderUpdates = prefs.orderUpdates;
        _scheduledOrderReminders = prefs.scheduledOrderReminders;
        _disputeUpdates = prefs.disputeUpdates;
        _marketingMessages = prefs.marketingMessages;             // ✅ RENAMED
        _systemNotifications = prefs.systemNotifications;
        _lowCouponsAlerts = prefs.lowCouponsAlerts;               // ✅ NEW
        _lowCouponsThreshold = prefs.lowCouponsThreshold ?? 5;    // ✅ NEW
        _walletBalanceAlerts = prefs.walletBalanceAlerts;         // ✅ NEW
        _walletBalanceThreshold = prefs.walletBalanceThreshold ?? 10; // ✅ NEW
        _pushEnabled = prefs.pushEnabled;                         // ✅ NEW
        _emailEnabled = prefs.emailEnabled;                       // ✅ NEW
        _smsEnabled = prefs.smsEnabled;                           // ✅ NEW
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

**Change 3: Update _updatePreferences() method**

```dart
Future<void> _updatePreferences() async {
  try {
    final prefs = NotificationPreferences(
      orderUpdates: _orderUpdates,
      scheduledOrderReminders: _scheduledOrderReminders,
      disputeUpdates: _disputeUpdates,
      marketingMessages: _marketingMessages,                    // ✅ RENAMED
      systemNotifications: _systemNotifications,
      lowCouponsAlerts: _lowCouponsAlerts,                      // ✅ NEW
      lowCouponsThreshold: _lowCouponsThreshold,                // ✅ NEW
      walletBalanceAlerts: _walletBalanceAlerts,                // ✅ NEW
      walletBalanceThreshold: _walletBalanceThreshold,          // ✅ NEW
      pushEnabled: _pushEnabled,                                // ✅ NEW
      emailEnabled: _emailEnabled,                              // ✅ NEW
      smsEnabled: _smsEnabled,                                  // ✅ NEW
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

**Change 4: Add Low Coupon Alerts UI widget**

```dart
// Add after existing SwitchListTiles, before Marketing & Promotions

Container(
  margin: EdgeInsets.symmetric(vertical: screenHeight * .005),
  padding: EdgeInsets.all(screenWidth * .03),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    color: AppColors.whiteColor,
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SwitchListTile(
        title: Text(
          'Low Coupon Alerts',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('Get notified when coupons are running low'),
        value: _lowCouponsAlerts,
        onChanged: (value) {
          setState(() => _lowCouponsAlerts = value);
          _updatePreferences();
        },
      ),
      if (_lowCouponsAlerts) ...[
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * .04,
            vertical: screenHeight * .01,
          ),
          child: Row(
            children: [
              Text(
                'Notify when below:',
                style: TextStyle(fontSize: screenWidth * .035),
              ),
              SizedBox(width: screenWidth * .02),
              Container(
                width: screenWidth * .2,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '5',
                    suffix: Text('coupons'),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: screenWidth * .02,
                      vertical: screenHeight * .01,
                    ),
                  ),
                  controller: TextEditingController(
                    text: _lowCouponsThreshold.toString(),
                  ),
                  onChanged: (value) {
                    final threshold = int.tryParse(value);
                    if (threshold != null && threshold > 0) {
                      setState(() => _lowCouponsThreshold = threshold);
                      _updatePreferences();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ],
  ),
),
```

**Change 5: Add Wallet Balance Alerts UI widget**

```dart
// Add after Low Coupon Alerts

Container(
  margin: EdgeInsets.symmetric(vertical: screenHeight * .005),
  padding: EdgeInsets.all(screenWidth * .03),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    color: AppColors.whiteColor,
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SwitchListTile(
        title: Text(
          'Wallet Balance Alerts',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('Get notified when wallet balance is low'),
        value: _walletBalanceAlerts,
        onChanged: (value) {
          setState(() => _walletBalanceAlerts = value);
          _updatePreferences();
        },
      ),
      if (_walletBalanceAlerts) ...[
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * .04,
            vertical: screenHeight * .01,
          ),
          child: Row(
            children: [
              Text(
                'Notify when below:',
                style: TextStyle(fontSize: screenWidth * .035),
              ),
              SizedBox(width: screenWidth * .02),
              Container(
                width: screenWidth * .2,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '10',
                    suffix: Text('QAR'),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: screenWidth * .02,
                      vertical: screenHeight * .01,
                    ),
                  ),
                  controller: TextEditingController(
                    text: _walletBalanceThreshold.toString(),
                  ),
                  onChanged: (value) {
                    final threshold = int.tryParse(value);
                    if (threshold != null && threshold > 0) {
                      setState(() => _walletBalanceThreshold = threshold);
                      _updatePreferences();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ],
  ),
),
```

**Change 6: Update Marketing toggle title**

```dart
// Find the Marketing SwitchListTile and ensure variable name is correct
SwitchListTile(
  title: Text(
    'Marketing & Promotions',
    style: TextStyle(fontWeight: FontWeight.w600),
  ),
  subtitle: Text('Special offers and deals'),
  value: _marketingMessages,  // ✅ RENAMED variable
  onChanged: (value) {
    setState(() => _marketingMessages = value);  // ✅ RENAMED
    _updatePreferences();
  },
),
```

**Impact:** UI now matches design specification and includes all preference types

---

## 📁 IMPACTED FILES

| File | Lines | Changes | Impact |
|------|-------|---------|--------|
| `notification_preferences_datasource.dart` | 4-38 | Add 7 new fields to model | 🔴 HIGH |
| `notification_preferences_datasource.dart` | 19-37 | Update fromJson/toJson | 🔴 HIGH |
| `settings.dart` | 27-32 | Add 7 new state variables | 🔴 HIGH |
| `settings.dart` | 41-60 | Update _loadPreferences | 🟡 MEDIUM |
| `settings.dart` | 62-81 | Update _updatePreferences | 🟡 MEDIUM |
| `settings.dart` | 140-240 | Add 2 new UI sections | 🔴 HIGH |

**Total:** 2 files, ~200 lines of code changes

---

## ⚠️ CRITICAL DEPENDENCIES

### **Backend Team Confirmation Required:**

**BEFORE implementing, backend team MUST confirm:**

1. ✅ Field names match exactly (especially `marketingMessages` vs `marketing`)
2. ❓ Does backend support `lowCouponsAlerts` + `lowCouponsThreshold`?
3. ❓ Does backend support `walletBalanceAlerts` + `walletBalanceThreshold`?
4. ❓ Should UI include push/email/SMS toggles or are they backend-only?
5. ❓ What are default values for new fields?
6. ❓ Are threshold values stored per user in database?

**Suggested Backend Team Query:**
```
Please provide the COMPLETE notification preferences schema including:
1. All field names (exact casing)
2. All field types (bool, int, string, etc.)
3. Default values for each field
4. Which fields are optional vs required
5. Example GET response payload
6. Example PUT request payload

Specifically confirm:
- lowCouponsAlerts (bool) + lowCouponsThreshold (int?)
- walletBalanceAlerts (bool) + walletBalanceThreshold (int?)
- Channel preferences (pushEnabled, emailEnabled, smsEnabled)
```

---

## 🧪 TESTING CHECKLIST

### **After Implementation:**

- [ ] Load preferences from backend
- [ ] Verify all 12 fields populate correctly
- [ ] Toggle Low Coupon Alerts on/off
- [ ] Set Low Coupon Threshold (e.g., 3 coupons)
- [ ] Save and verify threshold persists
- [ ] Toggle Wallet Balance Alerts on/off
- [ ] Set Wallet Balance Threshold (e.g., 20 QAR)
- [ ] Save and verify threshold persists
- [ ] Verify Marketing renamed to marketingMessages
- [ ] Test all existing toggles still work
- [ ] Verify backend receives all 12 fields
- [ ] Test error handling for invalid thresholds

---

## 📊 IMPLEMENTATION EFFORT

| Phase | Task | Time |
|-------|------|------|
| **Phase 1** | Update data model | 30 min |
| **Phase 2** | Update settings screen variables | 15 min |
| **Phase 2** | Update load/save methods | 15 min |
| **Phase 2** | Add Low Coupon Alerts UI | 20 min |
| **Phase 2** | Add Wallet Balance Alerts UI | 20 min |
| **Testing** | Integration testing | 30 min |
| **Total** | | **2.5 hours** |

**Additional:** Backend coordination time (varies)

---

## 🚦 RECOMMENDED APPROACH

### **Option A: Full Implementation (Recommended if backend confirms)**
1. Confirm backend supports all fields
2. Implement all 7 new fields
3. Add Low Coupon + Wallet Balance UI
4. Test thoroughly
5. Deploy

**Pros:** Complete feature, matches UI design  
**Cons:** Requires backend confirmation  
**Time:** 2.5 hours

### **Option B: Partial Implementation (If backend unclear)**
1. Fix `marketing` → `marketingMessages` rename
2. Add channel preferences (push/email/SMS) to model
3. Leave alert thresholds for later
4. Document as known limitation

**Pros:** Quick fix, no backend changes needed  
**Cons:** UI still incomplete  
**Time:** 30 minutes

---

## 📋 SUMMARY

### **Current State:**
- ❌ Only 5 preference fields implemented
- ❌ Missing Low Coupon Alerts + threshold
- ❌ Missing Wallet Balance Alerts + threshold
- ⚠️ Field name mismatch (`marketing` vs `marketingMessages`)
- ❌ Missing channel preferences (push/email/SMS)

### **Target State:**
- ✅ 12 preference fields implemented
- ✅ Low Coupon Alerts with threshold input
- ✅ Wallet Balance Alerts with threshold input
- ✅ All field names match backend API
- ✅ Complete UI matching design spec

### **Next Steps:**
1. **Immediate:** Contact backend team for field confirmation
2. **After confirmation:** Implement Phase 1 + Phase 2
3. **Testing:** Verify all fields save/load correctly
4. **Deploy:** Include in next commit with Issues #1 and #2

---

**Status:** 🟡 **BLOCKED - Awaiting Backend Confirmation**  
**Priority:** MEDIUM (Feature incomplete, not critical bug)  
**Effort:** 2.5 hours (after backend confirms)

---

*Investigation completed by Cascade AI - January 12, 2026 9:50 PM*
