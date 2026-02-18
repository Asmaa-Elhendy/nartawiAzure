import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../core/services/dio_service.dart';
import '../../../../core/services/language_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../../../home/presentation/widgets/main_screen_widgets/suppliers/build_info_button.dart';
import '../../../coupons/presentation/widgets/custom_text.dart';

import '../../../notification/data/datasources/notification_preferences_datasource.dart';
import '../widgets/change password.dart';
import '../widgets/setting_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late NotificationPreferencesDataSourceImpl _prefsDataSource;

  // Only 4 dynamic preferences for alerts
  bool _lowCouponsAlerts = true;
  int _lowCouponsThreshold = 100;

  bool _walletBalanceAlerts = true;
  double _walletBalanceThreshold = 100.0;

  bool _isLoadingPrefs = true;

  // Language
  String _selectedLanguage = '';

  @override
  void initState() {
    super.initState();
    _prefsDataSource = NotificationPreferencesDataSourceImpl(dio: DioService.dio);
    _loadPreferences();
    
    // Add language change listener using ValueNotifier
    LanguageService.localeNotifier.addListener(_onLanguageChanged);
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Initialize selected language after context is available
    _selectedLanguage = LanguageService.currentLocale?.languageCode == 'en' 
        ? AppLocalizations.of(context)!.english
        : AppLocalizations.of(context)!.arabic;
  }
  
  @override
  void dispose() {
    LanguageService.localeNotifier.removeListener(_onLanguageChanged);
    super.dispose();
  }
  
  void _onLanguageChanged() {
    if (mounted) {
      setState(() {
        final currentLocale = LanguageService.currentLocale;
        _selectedLanguage = currentLocale?.languageCode == 'en' 
            ? AppLocalizations.of(context)!.english
            : AppLocalizations.of(context)!.arabic;
      });
    }
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await _prefsDataSource.getPreferences();
      if (!mounted) return;

      setState(() {
        _lowCouponsAlerts = prefs.lowCouponsAlerts;
        _lowCouponsThreshold = prefs.lowCouponsThreshold;
        _walletBalanceAlerts = prefs.walletBalanceAlerts;
        _walletBalanceThreshold = prefs.walletBalanceThreshold;
        _isLoadingPrefs = false;
      });
    } catch (e) {
      // ignore: avoid_print
      print('${AppLocalizations.of(context)!.errorLoadingPreferences}$e');
      if (!mounted) return;
      setState(() => _isLoadingPrefs = false);
    }
  }

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
      // ignore: avoid_print
      print('${AppLocalizations.of(context)!.errorUpdatingPreferences}$e');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.failedSavePreferences)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            color: AppColors.backgrounHome,
          ),
          buildBackgroundAppbar(screenWidth),
          BuildForegroundappbarhome(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            title: AppLocalizations.of(context)!.settings,
            is_returned: true,
          ),

          Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            bottom: screenHeight * .05,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * .03,
                bottom: screenHeight * .1,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * .04,
                    right: screenWidth * .04,
                    bottom: screenHeight * .04,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.notificationPreferences,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: screenWidth * .04,
                        ),
                      ),
                      SizedBox(height: screenHeight * .01),

                      if (_isLoadingPrefs)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(color: AppColors.primary),
                          ),
                        )
                      else
                        Column(
                          children: [
                            SettingCard(
                              title: AppLocalizations.of(context)!.lowCouponAlerts,
                              description:
                              AppLocalizations.of(context)!.couponLowDesc,
                              quantityLabel: AppLocalizations.of(context)!.coupons,
                              isIncrease: true,
                              initialSwitchValue: _lowCouponsAlerts,
                              initialThresholdValue: _lowCouponsThreshold,
                              onSwitchChanged: (value) {
                                setState(() => _lowCouponsAlerts = value);
                                _updatePreferences();
                              },
                              onThresholdChanged: (value) {
                                setState(() => _lowCouponsThreshold = value);
                                _updatePreferences();
                              },
                            ),
                            SettingCard(
                              title: AppLocalizations.of(context)!.walletBalanceAlerts,
                              description:
                              AppLocalizations.of(context)!.walletLowDesc,
                              quantityLabel: AppLocalizations.of(context)!.qar,
                              isIncrease: true,
                              initialSwitchValue: _walletBalanceAlerts,
                              initialThresholdValue:
                              _walletBalanceThreshold.toInt(),
                              onSwitchChanged: (value) {
                                setState(() => _walletBalanceAlerts = value);
                                _updatePreferences();
                              },
                              onThresholdChanged: (value) {
                                setState(() =>
                                _walletBalanceThreshold = value.toDouble());
                                _updatePreferences();
                              },
                            ),
                            SettingCard(
                              title: AppLocalizations.of(context)!.orderUpdates,
                              description:
                              AppLocalizations.of(context)!.orderUpdatesDesc,
                              quantityLabel: '',
                              isIncrease: false,
                              initialSwitchValue: true,
                              onSwitchChanged: (value) {
                                // Static preference - always true, just save to backend
                                _updatePreferences();
                              },
                            ),
                            SettingCard(
                              title: AppLocalizations.of(context)!.refillUpdates,
                              description:
                              AppLocalizations.of(context)!.refillUpdatesDesc,
                              quantityLabel: '',
                              isIncrease: false,
                              initialSwitchValue: true,
                              onSwitchChanged: (value) {
                                // Static preference - always true, just save to backend
                                _updatePreferences();
                              },
                            ),
                            SettingCard(
                              title: AppLocalizations.of(context)!.promotionsOffers,
                              description:
                              AppLocalizations.of(context)!.promotionsOffersDesc,
                              quantityLabel: '',
                              isIncrease: false,
                              initialSwitchValue: true,
                              onSwitchChanged: (value) {
                                // Static preference - always true, just save to backend
                                _updatePreferences();
                              },
                            ),
                          ],
                        ),

                      SizedBox(height: screenHeight * .02),

                      // ✅ Clean fixed Language Preference card (no duplicated broken Row/child)
                      Container(
                        margin:
                        EdgeInsets.symmetric(vertical: screenHeight * .01),
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * .01,
                          horizontal: screenWidth * .03,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.whiteColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                customCouponPrimaryTitle(
                                  AppLocalizations.of(context)!.languagePreference,
                                  screenWidth,
                                  screenHeight,
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: screenWidth * .03,
                                top: screenHeight * .02,
                                bottom: screenHeight * .02,
                              ),
                              child: Row(
                                children: [
                                  _buildLanguageRadio(
                                    label: AppLocalizations.of(context)!.english,
                                    screenWidth: screenWidth,
                                    screenHeight: screenHeight,
                                  ),
                                  SizedBox(width: screenWidth * .08),
                                  _buildLanguageRadio(
                                    label: AppLocalizations.of(context)!.arabic,
                                    screenWidth: screenWidth,
                                    screenHeight: screenHeight,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding:
                        EdgeInsets.symmetric(vertical: screenHeight * .01),
                        child: Text(
                          AppLocalizations.of(context)!.security,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: screenWidth * .036,
                          ),
                        ),
                      ),

                      BuildInfoAndAddToCartButton(
                        screenWidth,
                        screenHeight,
                        AppLocalizations.of(context)!.changePassword,
                        false,
                            () {
                          showDialog(
                            context: context,
                            builder: (ctx) => ChangePasswordAlert(),
                          );
                        },
                        fromDelivery: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageRadio({
    required String label,
    required double screenWidth,
    required double screenHeight,
  }) {
    final bool isSelected = _selectedLanguage == label;
    
    // Map display labels to locale codes
    final String localeCode = label == AppLocalizations.of(context)!.english ? 'en' : 'ar';

    return GestureDetector(
      onTap: () {
        // Only proceed if the language is actually different
        if (_selectedLanguage != label) {
          setState(() {
            _selectedLanguage = label;
          });
          
          // Change the app locale using LanguageService
          LanguageService.setLanguage(localeCode);
          
          // Wait a moment for the UI to update, then show confirmation message
          Future.delayed(Duration(milliseconds: 300), () {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    localeCode == 'en' ?
                    AppLocalizations.of(context)!.languageChangedToEnglish :
                    AppLocalizations.of(context)!.languageChangedToArabic
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          });
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: screenWidth * 0.045,
            height: screenWidth * 0.045,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.greyDarktextIntExtFieldAndIconsHome,
                width: isSelected ? 2 : 1.5,
              ),
            ),
            child: isSelected
                ? Center(
              child: Container(
                width: screenWidth * 0.023,
                height: screenWidth * 0.023,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              ),
            )
                : null,
          ),
          SizedBox(width: screenWidth * 0.02),
          Text(
            label,
            style: AppTextStyles.LabelInTextField,
          ),
        ],
      ),
    );
  }
}
