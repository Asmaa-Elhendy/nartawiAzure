import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'NARTAWI'**
  String get appName;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @myImpact.
  ///
  /// In en, this message translates to:
  /// **'My Impact'**
  String get myImpact;

  /// No description provided for @myEWallet.
  ///
  /// In en, this message translates to:
  /// **'My e-Wallet'**
  String get myEWallet;

  /// No description provided for @deliveryAddresses.
  ///
  /// In en, this message translates to:
  /// **'Delivery Addresses'**
  String get deliveryAddresses;

  /// No description provided for @scanQR.
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get scanQR;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @coupons.
  ///
  /// In en, this message translates to:
  /// **'Coupons'**
  String get coupons;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @letsGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Get Started'**
  String get letsGetStarted;

  /// No description provided for @onboarding1.
  ///
  /// In en, this message translates to:
  /// **'Pick Your Favorite Water Brand, Coupon Bundle, And Delivery Address'**
  String get onboarding1;

  /// No description provided for @onboarding2.
  ///
  /// In en, this message translates to:
  /// **'Confirm Your Order And Checkout—All in Few Taps'**
  String get onboarding2;

  /// No description provided for @onboarding3.
  ///
  /// In en, this message translates to:
  /// **'Stay refreshed. Your water arrives straight to your door every week. Say goodbye to paper coupons'**
  String get onboarding3;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get enterPassword;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get userName;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @alternativePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Alternative Phone Number'**
  String get alternativePhoneNumber;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter Username'**
  String get enterUsername;

  /// No description provided for @enterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Enter First Name'**
  String get enterFirstName;

  /// No description provided for @enterLastName.
  ///
  /// In en, this message translates to:
  /// **'Enter Last Name'**
  String get enterLastName;

  /// No description provided for @exEmail.
  ///
  /// In en, this message translates to:
  /// **'Ex: abc@example.com'**
  String get exEmail;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter Phone Number'**
  String get enterPhone;

  /// No description provided for @enterAlternativePhone.
  ///
  /// In en, this message translates to:
  /// **'Enter Alternative phone number'**
  String get enterAlternativePhone;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email Address is required'**
  String get emailRequired;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get enterValidEmail;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password is required'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Password doesn\'t match'**
  String get passwordMismatch;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'is required'**
  String get fieldRequired;

  /// No description provided for @pickFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Pick From Gallery'**
  String get pickFromGallery;

  /// No description provided for @pickFromCamera.
  ///
  /// In en, this message translates to:
  /// **'Pick From Camera'**
  String get pickFromCamera;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @languagePreference.
  ///
  /// In en, this message translates to:
  /// **'Language Preference'**
  String get languagePreference;

  /// No description provided for @receiveOffers.
  ///
  /// In en, this message translates to:
  /// **'Yes, I want to receive offers and discounts'**
  String get receiveOffers;

  /// No description provided for @subscribeNewsletter.
  ///
  /// In en, this message translates to:
  /// **'Subscribe To Newsletter'**
  String get subscribeNewsletter;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @areYouSureLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get areYouSureLogout;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get remove;

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'You\'ve added 1 item'**
  String get addedToCart;

  /// No description provided for @selectedItemNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'You selected 1 item, but you haven\'t confirmed your choice yet'**
  String get selectedItemNotConfirmed;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add To Cart'**
  String get addToCart;

  /// No description provided for @continueShopping.
  ///
  /// In en, this message translates to:
  /// **'Continue Shopping'**
  String get continueShopping;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @supplierError.
  ///
  /// In en, this message translates to:
  /// **'All order products must be from the same supplier'**
  String get supplierError;

  /// No description provided for @maxCouponsReached.
  ///
  /// In en, this message translates to:
  /// **'You already have 2 coupons. Continue to buy another one?'**
  String get maxCouponsReached;

  /// No description provided for @viewStore.
  ///
  /// In en, this message translates to:
  /// **'View Store'**
  String get viewStore;

  /// No description provided for @removeAllItems.
  ///
  /// In en, this message translates to:
  /// **'Remove all items from your cart?'**
  String get removeAllItems;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @cancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancelOrder;

  /// No description provided for @cancelOrderConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this order?'**
  String get cancelOrderConfirm;

  /// No description provided for @paymentRefunded.
  ///
  /// In en, this message translates to:
  /// **'Your payment will be refunded to your wallet.'**
  String get paymentRefunded;

  /// No description provided for @noKeepOrder.
  ///
  /// In en, this message translates to:
  /// **'No, Keep Order'**
  String get noKeepOrder;

  /// No description provided for @yesCancel.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get yesCancel;

  /// No description provided for @startDelivery.
  ///
  /// In en, this message translates to:
  /// **'Start Delivery'**
  String get startDelivery;

  /// No description provided for @startDeliveryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to start delivery for order #'**
  String get startDeliveryConfirm;

  /// No description provided for @orderCanceled.
  ///
  /// In en, this message translates to:
  /// **'Order canceled successfully'**
  String get orderCanceled;

  /// No description provided for @deliveryStarted.
  ///
  /// In en, this message translates to:
  /// **'Delivery started successfully'**
  String get deliveryStarted;

  /// No description provided for @failedCancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel order'**
  String get failedCancelOrder;

  /// No description provided for @failedStartDelivery.
  ///
  /// In en, this message translates to:
  /// **'Failed to start delivery'**
  String get failedStartDelivery;

  /// No description provided for @leaveReview.
  ///
  /// In en, this message translates to:
  /// **'Leave Review'**
  String get leaveReview;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noOrdersFound.
  ///
  /// In en, this message translates to:
  /// **'No orders found'**
  String get noOrdersFound;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @pendingPayment.
  ///
  /// In en, this message translates to:
  /// **'Pending Payment'**
  String get pendingPayment;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @canceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get canceled;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget Password'**
  String get forgetPassword;

  /// No description provided for @enterMobileOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Mobile Number or Email'**
  String get enterMobileOrEmail;

  /// No description provided for @enterMobileOrEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Mobile Number or Email'**
  String get enterMobileOrEmailHint;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back To Login'**
  String get backToLogin;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordMin8Chars.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMin8Chars;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully. Please login.'**
  String get passwordResetSuccess;

  /// No description provided for @passwordResetFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to reset password. Please try again.'**
  String get passwordResetFailed;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter New Password'**
  String get enterNewPassword;

  /// No description provided for @enterNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get enterNewPasswordHint;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmNewPassword;

  /// No description provided for @enterConfirmedPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Confirmed Password'**
  String get enterConfirmedPassword;

  /// No description provided for @pleaseEnter4DigitOTP.
  ///
  /// In en, this message translates to:
  /// **'Please enter 4-digit OTP'**
  String get pleaseEnter4DigitOTP;

  /// No description provided for @otpVerifiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'OTP verified successfully'**
  String get otpVerifiedSuccess;

  /// No description provided for @invalidOTP.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP. Please try again.'**
  String get invalidOTP;

  /// No description provided for @verification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verification;

  /// No description provided for @enterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Verification Code'**
  String get enterVerificationCode;

  /// No description provided for @ifDidntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'If you didn\'t receive a code,'**
  String get ifDidntReceiveCode;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @stores.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get stores;

  /// No description provided for @purchasedOn.
  ///
  /// In en, this message translates to:
  /// **'Purchased On'**
  String get purchasedOn;

  /// No description provided for @totalOrderValue.
  ///
  /// In en, this message translates to:
  /// **'Total Order Value'**
  String get totalOrderValue;

  /// No description provided for @autoRenewalDescription.
  ///
  /// In en, this message translates to:
  /// **'Automatically purchase new coupons when this bundle runs out'**
  String get autoRenewalDescription;

  /// No description provided for @noDeliveryAddressYet.
  ///
  /// In en, this message translates to:
  /// **'No Delivery Address Yet'**
  String get noDeliveryAddressYet;

  /// No description provided for @weeklyDeliveryFrequency.
  ///
  /// In en, this message translates to:
  /// **'Weekly Delivery Frequency'**
  String get weeklyDeliveryFrequency;

  /// No description provided for @bottlesPerDelivery.
  ///
  /// In en, this message translates to:
  /// **'Bottles Per Delivery'**
  String get bottlesPerDelivery;

  /// No description provided for @preferredRefillTimesPerWeek.
  ///
  /// In en, this message translates to:
  /// **'Preferred Refill Times /Week'**
  String get preferredRefillTimesPerWeek;

  /// No description provided for @usedAsGuideNotMandatory.
  ///
  /// In en, this message translates to:
  /// **'Used As A Guide, Not Mandatory'**
  String get usedAsGuideNotMandatory;

  /// No description provided for @viewLastConsumption.
  ///
  /// In en, this message translates to:
  /// **'View Last Consumption'**
  String get viewLastConsumption;

  /// No description provided for @preferredTimeSlot.
  ///
  /// In en, this message translates to:
  /// **'Preferred Time Slot'**
  String get preferredTimeSlot;

  /// No description provided for @qatar8DigitPhone.
  ///
  /// In en, this message translates to:
  /// **'8-digit Qatar phone number'**
  String get qatar8DigitPhone;

  /// No description provided for @orContinueAs.
  ///
  /// In en, this message translates to:
  /// **'Or Continue As'**
  String get orContinueAs;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @loggingIn.
  ///
  /// In en, this message translates to:
  /// **'Logging in...'**
  String get loggingIn;

  /// No description provided for @creatingAccount.
  ///
  /// In en, this message translates to:
  /// **'Creating account...'**
  String get creatingAccount;

  /// No description provided for @fieldIsRequired.
  ///
  /// In en, this message translates to:
  /// **'is required'**
  String get fieldIsRequired;

  /// No description provided for @emailAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Email Address is required'**
  String get emailAddressRequired;

  /// No description provided for @yourCart.
  ///
  /// In en, this message translates to:
  /// **'Your Cart'**
  String get yourCart;

  /// No description provided for @deliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get deliveryAddress;

  /// No description provided for @clearCart.
  ///
  /// In en, this message translates to:
  /// **'Clear Cart'**
  String get clearCart;

  /// No description provided for @removeAllItemsFromCart.
  ///
  /// In en, this message translates to:
  /// **'Remove all items from your cart?'**
  String get removeAllItemsFromCart;

  /// No description provided for @pleaseSelectAddress.
  ///
  /// In en, this message translates to:
  /// **'Please select an address'**
  String get pleaseSelectAddress;

  /// No description provided for @differentSupplierFound.
  ///
  /// In en, this message translates to:
  /// **'Different supplier found'**
  String get differentSupplierFound;

  /// No description provided for @allProductsSameSupplier.
  ///
  /// In en, this message translates to:
  /// **'All order products must be from the same supplier'**
  String get allProductsSameSupplier;

  /// No description provided for @orderCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Order created successfully!'**
  String get orderCreatedSuccessfully;

  /// No description provided for @failedToCreateOrder.
  ///
  /// In en, this message translates to:
  /// **'Failed to create order'**
  String get failedToCreateOrder;

  /// No description provided for @cartClearedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Cart cleared successfully'**
  String get cartClearedSuccessfully;

  /// No description provided for @failedToClearCart.
  ///
  /// In en, this message translates to:
  /// **'Failed to clear cart'**
  String get failedToClearCart;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @ewalletOrCashOnDelivery.
  ///
  /// In en, this message translates to:
  /// **'eWallet or Cash on Delivery'**
  String get ewalletOrCashOnDelivery;

  /// No description provided for @pleaseSelectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Please select a payment method'**
  String get pleaseSelectPaymentMethod;

  /// No description provided for @useEwalletBalanceFirst.
  ///
  /// In en, this message translates to:
  /// **'Use eWallet Balance First'**
  String get useEwalletBalanceFirst;

  /// No description provided for @availableBalance.
  ///
  /// In en, this message translates to:
  /// **'Available Balance: QAR 840.00'**
  String get availableBalance;

  /// No description provided for @ewalletWillCoverFullAmount.
  ///
  /// In en, this message translates to:
  /// **'Your eWallet will cover the full amount (QAR 500.00)'**
  String get ewalletWillCoverFullAmount;

  /// No description provided for @useCard.
  ///
  /// In en, this message translates to:
  /// **'Use Card'**
  String get useCard;

  /// No description provided for @pleaseHaveAmountReady.
  ///
  /// In en, this message translates to:
  /// **'Please have QAR 500.00 ready when your order arrives.'**
  String get pleaseHaveAmountReady;

  /// No description provided for @noDefaultAddress.
  ///
  /// In en, this message translates to:
  /// **'No Default Address'**
  String get noDefaultAddress;

  /// No description provided for @yourCoupons.
  ///
  /// In en, this message translates to:
  /// **'Your Coupons'**
  String get yourCoupons;

  /// No description provided for @bundlePurchaseHistory.
  ///
  /// In en, this message translates to:
  /// **'Bundle purchase history and details'**
  String get bundlePurchaseHistory;

  /// No description provided for @noBundlesFound.
  ///
  /// In en, this message translates to:
  /// **'No bundles found'**
  String get noBundlesFound;

  /// No description provided for @couponBundle.
  ///
  /// In en, this message translates to:
  /// **'Coupon Bundle'**
  String get couponBundle;

  /// No description provided for @autoRenewal.
  ///
  /// In en, this message translates to:
  /// **'Auto-Renewal'**
  String get autoRenewal;

  /// No description provided for @changeAddress.
  ///
  /// In en, this message translates to:
  /// **'Change Address'**
  String get changeAddress;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @scheduleStatus.
  ///
  /// In en, this message translates to:
  /// **'Schedule Status'**
  String get scheduleStatus;

  /// No description provided for @updateSchedule.
  ///
  /// In en, this message translates to:
  /// **'Update Schedule'**
  String get updateSchedule;

  /// No description provided for @saveSchedule.
  ///
  /// In en, this message translates to:
  /// **'Save Schedule'**
  String get saveSchedule;

  /// No description provided for @cancelSchedule.
  ///
  /// In en, this message translates to:
  /// **'Cancel Schedule'**
  String get cancelSchedule;

  /// No description provided for @maxPreferredDaysMessage.
  ///
  /// In en, this message translates to:
  /// **'You can select up to {max} preferred days only.'**
  String maxPreferredDaysMessage(Object max);

  /// No description provided for @preferredTimesForRefilling.
  ///
  /// In en, this message translates to:
  /// **'Preferred Times For Refilling'**
  String get preferredTimesForRefilling;

  /// No description provided for @beforeNoon.
  ///
  /// In en, this message translates to:
  /// **'Before Noon'**
  String get beforeNoon;

  /// No description provided for @couponDetails.
  ///
  /// In en, this message translates to:
  /// **'Coupon Details'**
  String get couponDetails;

  /// No description provided for @noConsumptionHistory.
  ///
  /// In en, this message translates to:
  /// **'No consumption history yet'**
  String get noConsumptionHistory;

  /// No description provided for @noMarkedUsedCoupons.
  ///
  /// In en, this message translates to:
  /// **'This bundle has no marked-used coupons.'**
  String get noMarkedUsedCoupons;

  /// No description provided for @markedOn.
  ///
  /// In en, this message translates to:
  /// **'Marked On'**
  String get markedOn;

  /// No description provided for @markedBy.
  ///
  /// In en, this message translates to:
  /// **'Marked By'**
  String get markedBy;

  /// No description provided for @disputeReason.
  ///
  /// In en, this message translates to:
  /// **'Dispute Reason'**
  String get disputeReason;

  /// No description provided for @neverReceivedWater.
  ///
  /// In en, this message translates to:
  /// **'Never Received Water'**
  String get neverReceivedWater;

  /// No description provided for @showDeliveryPhotos.
  ///
  /// In en, this message translates to:
  /// **'Show Delivery Photos'**
  String get showDeliveryPhotos;

  /// No description provided for @disputeResolved.
  ///
  /// In en, this message translates to:
  /// **'Dispute Resolved'**
  String get disputeResolved;

  /// No description provided for @couponMarkedUsed.
  ///
  /// In en, this message translates to:
  /// **'Coupon Marked Used'**
  String get couponMarkedUsed;

  /// No description provided for @pleaseRateSeller.
  ///
  /// In en, this message translates to:
  /// **'Please rate the seller'**
  String get pleaseRateSeller;

  /// No description provided for @thankYouReview.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your review!'**
  String get thankYouReview;

  /// No description provided for @writeReviewOptional.
  ///
  /// In en, this message translates to:
  /// **'Write your review here (optional)'**
  String get writeReviewOptional;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get uploadPhoto;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @maxPhotosAllowed.
  ///
  /// In en, this message translates to:
  /// **'Maximum 5 photos allowed'**
  String get maxPhotosAllowed;

  /// No description provided for @describeIssue.
  ///
  /// In en, this message translates to:
  /// **'Please describe the issue'**
  String get describeIssue;

  /// No description provided for @writeDisputeReasons.
  ///
  /// In en, this message translates to:
  /// **'Write your dispute here, explaining all your reasons'**
  String get writeDisputeReasons;

  /// No description provided for @disputeSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Dispute submitted successfully'**
  String get disputeSubmitted;

  /// No description provided for @failedSubmitDispute.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit dispute'**
  String get failedSubmitDispute;

  /// No description provided for @failedPickImages.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick images'**
  String get failedPickImages;

  /// No description provided for @failedCapturePhoto.
  ///
  /// In en, this message translates to:
  /// **'Failed to capture photo'**
  String get failedCapturePhoto;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @disputed.
  ///
  /// In en, this message translates to:
  /// **'Disputed'**
  String get disputed;

  /// No description provided for @assignedOrders.
  ///
  /// In en, this message translates to:
  /// **'Assigned Orders'**
  String get assignedOrders;

  /// No description provided for @noAddressProvided.
  ///
  /// In en, this message translates to:
  /// **'No address provided'**
  String get noAddressProvided;

  /// No description provided for @locationPermissionsDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are denied'**
  String get locationPermissionsDenied;

  /// No description provided for @locationPermissionsPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are permanently denied'**
  String get locationPermissionsPermanentlyDenied;

  /// No description provided for @failedToGetLocation.
  ///
  /// In en, this message translates to:
  /// **'Failed to get location'**
  String get failedToGetLocation;

  /// No description provided for @pleaseEnableLocationServices.
  ///
  /// In en, this message translates to:
  /// **'Please enable location services'**
  String get pleaseEnableLocationServices;

  /// No description provided for @deliveryConfirmedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Delivery confirmed successfully'**
  String get deliveryConfirmedSuccessfully;

  /// No description provided for @failedToSubmitPOD.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit POD'**
  String get failedToSubmitPOD;

  /// No description provided for @deliveryConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delivery Confirmation'**
  String get deliveryConfirmation;

  /// No description provided for @confirmDelivery.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delivery'**
  String get confirmDelivery;

  /// No description provided for @writeCommentHere.
  ///
  /// In en, this message translates to:
  /// **'Write comment here'**
  String get writeCommentHere;

  /// No description provided for @writeCommentHereIfApplicable.
  ///
  /// In en, this message translates to:
  /// **'Write a comment here if applicable'**
  String get writeCommentHereIfApplicable;

  /// No description provided for @confirmDeliveryAlert.
  ///
  /// In en, this message translates to:
  /// **'Confirm delivery'**
  String get confirmDeliveryAlert;

  /// No description provided for @gpsRequiredToConfirmOrder.
  ///
  /// In en, this message translates to:
  /// **'GPS required to confirm order.'**
  String get gpsRequiredToConfirmOrder;

  /// No description provided for @openCamera.
  ///
  /// In en, this message translates to:
  /// **'Open Camera'**
  String get openCamera;

  /// No description provided for @driver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get driver;

  /// No description provided for @noFavouriteProducts.
  ///
  /// In en, this message translates to:
  /// **'No favourite products'**
  String get noFavouriteProducts;

  /// No description provided for @noFavouriteStores.
  ///
  /// In en, this message translates to:
  /// **'No favourite stores'**
  String get noFavouriteStores;

  /// No description provided for @unknownSupplier.
  ///
  /// In en, this message translates to:
  /// **'Unknown Supplier'**
  String get unknownSupplier;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @companyHandPumpDescription.
  ///
  /// In en, this message translates to:
  /// **'Company hand pump dispenser - pure natural...'**
  String get companyHandPumpDescription;

  /// No description provided for @oneTimePurchase.
  ///
  /// In en, this message translates to:
  /// **'One Time Purchase'**
  String get oneTimePurchase;

  /// No description provided for @weeklySentBundles.
  ///
  /// In en, this message translates to:
  /// **'Weekly Sent Bundles'**
  String get weeklySentBundles;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error:'**
  String get errorPrefix;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @popularCategories.
  ///
  /// In en, this message translates to:
  /// **'Popular Categories'**
  String get popularCategories;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @removeFromCart.
  ///
  /// In en, this message translates to:
  /// **'Remove from cart'**
  String get removeFromCart;

  /// No description provided for @removeFromCartConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this item from cart?\nThis action cannot be undone.'**
  String get removeFromCartConfirmation;

  /// No description provided for @productWithId.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get productWithId;

  /// No description provided for @arabicProductWithId.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get arabicProductWithId;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @neww.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get neww;

  /// No description provided for @promos.
  ///
  /// In en, this message translates to:
  /// **'Promos'**
  String get promos;

  /// No description provided for @oneTime.
  ///
  /// In en, this message translates to:
  /// **'One time'**
  String get oneTime;

  /// No description provided for @disputes.
  ///
  /// In en, this message translates to:
  /// **'Disputes'**
  String get disputes;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @markAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark As Read'**
  String get markAsRead;

  /// No description provided for @clearSelection.
  ///
  /// In en, this message translates to:
  /// **'Clear Selection'**
  String get clearSelection;

  /// No description provided for @yesterdayAtTime.
  ///
  /// In en, this message translates to:
  /// **'Yesterday at 10:44 AM'**
  String get yesterdayAtTime;

  /// No description provided for @orderDetail.
  ///
  /// In en, this message translates to:
  /// **'Order Detail'**
  String get orderDetail;

  /// No description provided for @orderWithId.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get orderWithId;

  /// No description provided for @deliveryStartedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Delivery started successfully'**
  String get deliveryStartedSuccessfully;

  /// No description provided for @failedStartDeliveryWithReason.
  ///
  /// In en, this message translates to:
  /// **'Failed to start delivery: '**
  String get failedStartDeliveryWithReason;

  /// No description provided for @orderCancelledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Order cancelled successfully'**
  String get orderCancelledSuccessfully;

  /// No description provided for @orderInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get orderInProgress;

  /// No description provided for @orderOneTime.
  ///
  /// In en, this message translates to:
  /// **'One Time'**
  String get orderOneTime;

  /// No description provided for @orderCouponBased.
  ///
  /// In en, this message translates to:
  /// **'Coupon Based'**
  String get orderCouponBased;

  /// No description provided for @orderUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get orderUnpaid;

  /// No description provided for @toDateCannotBeBeforeFrom.
  ///
  /// In en, this message translates to:
  /// **'To date cannot be before From date'**
  String get toDateCannotBeBeforeFrom;

  /// No description provided for @enterUserName.
  ///
  /// In en, this message translates to:
  /// **'Enter UserName'**
  String get enterUserName;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Phone Number'**
  String get enterPhoneNumber;

  /// No description provided for @enterAlternativePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Alternative phone number'**
  String get enterAlternativePhoneNumber;

  /// No description provided for @errorLoadingPreferences.
  ///
  /// In en, this message translates to:
  /// **'Error loading preferences: '**
  String get errorLoadingPreferences;

  /// No description provided for @errorUpdatingPreferences.
  ///
  /// In en, this message translates to:
  /// **'Error updating preferences: '**
  String get errorUpdatingPreferences;

  /// No description provided for @unknownDate.
  ///
  /// In en, this message translates to:
  /// **'UNkOWN DATE'**
  String get unknownDate;

  /// No description provided for @cancelOrderConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this order?'**
  String get cancelOrderConfirmation;

  /// No description provided for @paymentRefundMessage.
  ///
  /// In en, this message translates to:
  /// **'Your payment will be refunded to your wallet.'**
  String get paymentRefundMessage;

  /// No description provided for @startDeliveryConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to start delivery for Order #'**
  String get startDeliveryConfirmation;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @failedToStartDelivery.
  ///
  /// In en, this message translates to:
  /// **'Failed to start delivery: '**
  String get failedToStartDelivery;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @viewDisputeStatus.
  ///
  /// In en, this message translates to:
  /// **'View Dispute Status'**
  String get viewDisputeStatus;

  /// No description provided for @viewProofOfDelivery.
  ///
  /// In en, this message translates to:
  /// **'View Proof of Delivery'**
  String get viewProofOfDelivery;

  /// No description provided for @deliverySummary.
  ///
  /// In en, this message translates to:
  /// **'Delivery Summary'**
  String get deliverySummary;

  /// No description provided for @estimatedDelivery.
  ///
  /// In en, this message translates to:
  /// **'Estimated Delivery'**
  String get estimatedDelivery;

  /// No description provided for @within24Hours.
  ///
  /// In en, this message translates to:
  /// **'Within 24-48 hours'**
  String get within24Hours;

  /// No description provided for @itemsSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Items Subtotal'**
  String get itemsSubtotal;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @deliveryFee.
  ///
  /// In en, this message translates to:
  /// **'Delivery Fee'**
  String get deliveryFee;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @noItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noItemsFound;

  /// No description provided for @itemDescription.
  ///
  /// In en, this message translates to:
  /// **'Item Description'**
  String get itemDescription;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @notVerified.
  ///
  /// In en, this message translates to:
  /// **'Not Verified'**
  String get notVerified;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get showLess;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @failedToLoadSuppliers.
  ///
  /// In en, this message translates to:
  /// **'Failed to load suppliers'**
  String get failedToLoadSuppliers;

  /// No description provided for @waterSuppliers.
  ///
  /// In en, this message translates to:
  /// **'Water Suppliers'**
  String get waterSuppliers;

  /// No description provided for @vendorAddedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Vendor added to favorites'**
  String get vendorAddedToFavorites;

  /// No description provided for @vendorRemovedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Vendor removed from favorites'**
  String get vendorRemovedFromFavorites;

  /// No description provided for @failedToUpdateFavorites.
  ///
  /// In en, this message translates to:
  /// **'Failed to update favorites'**
  String get failedToUpdateFavorites;

  /// No description provided for @proceedToCheckout.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Checkout'**
  String get proceedToCheckout;

  /// No description provided for @deliveryExperience.
  ///
  /// In en, this message translates to:
  /// **'Delivery Experience'**
  String get deliveryExperience;

  /// No description provided for @sellerExperience.
  ///
  /// In en, this message translates to:
  /// **'Seller Experience'**
  String get sellerExperience;

  /// No description provided for @orderExperience.
  ///
  /// In en, this message translates to:
  /// **'Order Experience'**
  String get orderExperience;

  /// No description provided for @overall.
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get overall;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get languageChanged;

  /// No description provided for @languageChangedToEnglish.
  ///
  /// In en, this message translates to:
  /// **'Language changed to English'**
  String get languageChangedToEnglish;

  /// No description provided for @languageChangedToArabic.
  ///
  /// In en, this message translates to:
  /// **'Language changed to Arabic'**
  String get languageChangedToArabic;

  /// No description provided for @notificationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences'**
  String get notificationPreferences;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @failedToCancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel order: '**
  String get failedToCancelOrder;

  /// No description provided for @transferFunds.
  ///
  /// In en, this message translates to:
  /// **'Transfer Funds'**
  String get transferFunds;

  /// No description provided for @sendMoneyToAnotherUser.
  ///
  /// In en, this message translates to:
  /// **'Send Money To Another User\'s Wallet'**
  String get sendMoneyToAnotherUser;

  /// No description provided for @amountQar.
  ///
  /// In en, this message translates to:
  /// **'Amount (QAR)'**
  String get amountQar;

  /// No description provided for @recipient.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get recipient;

  /// No description provided for @userNameOrMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'User Name or Mobile Number'**
  String get userNameOrMobileNumber;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @walletTransfer.
  ///
  /// In en, this message translates to:
  /// **'Wallet Transfer'**
  String get walletTransfer;

  /// No description provided for @availableBalanceQar1000.
  ///
  /// In en, this message translates to:
  /// **'Available Balance: QAR 1,000'**
  String get availableBalanceQar1000;

  /// No description provided for @paymentQR.
  ///
  /// In en, this message translates to:
  /// **'Payment QR'**
  String get paymentQR;

  /// No description provided for @scanQRPayment.
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get scanQRPayment;

  /// No description provided for @topup.
  ///
  /// In en, this message translates to:
  /// **'Top-up'**
  String get topup;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @scanned.
  ///
  /// In en, this message translates to:
  /// **'Scanned'**
  String get scanned;

  /// No description provided for @lowCouponAlerts.
  ///
  /// In en, this message translates to:
  /// **'Low Coupon Alerts'**
  String get lowCouponAlerts;

  /// No description provided for @walletBalanceAlerts.
  ///
  /// In en, this message translates to:
  /// **'Wallet Balance Alerts'**
  String get walletBalanceAlerts;

  /// No description provided for @couponLowDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notified when your coupon balance is running low'**
  String get couponLowDesc;

  /// No description provided for @walletLowDesc.
  ///
  /// In en, this message translates to:
  /// **'Get alerts when your wallet balance is low'**
  String get walletLowDesc;

  /// No description provided for @couponCurrency.
  ///
  /// In en, this message translates to:
  /// **'Coupons'**
  String get couponCurrency;

  /// No description provided for @qar.
  ///
  /// In en, this message translates to:
  /// **'QAR'**
  String get qar;

  /// No description provided for @addNewAddress.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get addNewAddress;

  /// No description provided for @useCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use Current Location'**
  String get useCurrentLocation;

  /// No description provided for @openGoogleMap.
  ///
  /// In en, this message translates to:
  /// **'Open Google Map'**
  String get openGoogleMap;

  /// No description provided for @deleteAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete address'**
  String get deleteAddressTitle;

  /// No description provided for @deleteAddressConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this address?'**
  String get deleteAddressConfirm;

  /// No description provided for @noAddressesFound.
  ///
  /// In en, this message translates to:
  /// **'No addresses found'**
  String get noAddressesFound;

  /// No description provided for @orderUpdates.
  ///
  /// In en, this message translates to:
  /// **'Order Updates'**
  String get orderUpdates;

  /// No description provided for @refillUpdates.
  ///
  /// In en, this message translates to:
  /// **'Refill Updates'**
  String get refillUpdates;

  /// No description provided for @promotionsOffers.
  ///
  /// In en, this message translates to:
  /// **'Promotions & Offers'**
  String get promotionsOffers;

  /// No description provided for @orderUpdatesDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications about your order status'**
  String get orderUpdatesDesc;

  /// No description provided for @refillUpdatesDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notified when your bottles have been refilled'**
  String get refillUpdatesDesc;

  /// No description provided for @promotionsOffersDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications about promotions and special offers'**
  String get promotionsOffersDesc;

  /// No description provided for @searchWaterProducts.
  ///
  /// In en, this message translates to:
  /// **'Search for water products...'**
  String get searchWaterProducts;

  /// No description provided for @writeCommentApplicable.
  ///
  /// In en, this message translates to:
  /// **'Write a comment here if applicable'**
  String get writeCommentApplicable;

  /// No description provided for @viewAllCoupons.
  ///
  /// In en, this message translates to:
  /// **'View All Coupons'**
  String get viewAllCoupons;

  /// No description provided for @featuredSuppliers.
  ///
  /// In en, this message translates to:
  /// **'Featured Suppliers'**
  String get featuredSuppliers;

  /// No description provided for @noFeaturedSuppliersFound.
  ///
  /// In en, this message translates to:
  /// **'No featured suppliers found'**
  String get noFeaturedSuppliersFound;

  /// No description provided for @noSuppliersFound.
  ///
  /// In en, this message translates to:
  /// **'No suppliers found'**
  String get noSuppliersFound;

  /// No description provided for @noCategoriesFound.
  ///
  /// In en, this message translates to:
  /// **'No categories found'**
  String get noCategoriesFound;

  /// No description provided for @productsStillLoading.
  ///
  /// In en, this message translates to:
  /// **'Products are still loading, please try again.'**
  String get productsStillLoading;

  /// No description provided for @failedToLoadProducts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load products'**
  String get failedToLoadProducts;

  /// No description provided for @noProductsMatchSearch.
  ///
  /// In en, this message translates to:
  /// **'No products match your search'**
  String get noProductsMatchSearch;

  /// No description provided for @noProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsFound;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @failedSavePreferences.
  ///
  /// In en, this message translates to:
  /// **'Failed to save preferences'**
  String get failedSavePreferences;

  /// No description provided for @invalidOrderId.
  ///
  /// In en, this message translates to:
  /// **'Invalid order id'**
  String get invalidOrderId;

  /// No description provided for @permissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permissionRequired;

  /// No description provided for @cameraPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is permanently denied.\n\nPlease go to App Settings → Permissions → Enable Camera.'**
  String get cameraPermissionDenied;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedError;

  /// No description provided for @authenticationRequired.
  ///
  /// In en, this message translates to:
  /// **'Authentication required'**
  String get authenticationRequired;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorMessage;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @toDateBeforeFrom.
  ///
  /// In en, this message translates to:
  /// **'To date cannot be before From date'**
  String get toDateBeforeFrom;

  /// No description provided for @earlyMorning.
  ///
  /// In en, this message translates to:
  /// **'Early Morning'**
  String get earlyMorning;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @afternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get afternoon;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// No description provided for @night.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get night;

  /// No description provided for @unlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get unlocked;

  /// No description provided for @yourAchievements.
  ///
  /// In en, this message translates to:
  /// **'Your Achievements'**
  String get yourAchievements;

  /// No description provided for @milestonesReached.
  ///
  /// In en, this message translates to:
  /// **'Milestones you\'ve reached'**
  String get milestonesReached;

  /// No description provided for @appExplorer.
  ///
  /// In en, this message translates to:
  /// **'App Explorer'**
  String get appExplorer;

  /// No description provided for @appExplorerDesc.
  ///
  /// In en, this message translates to:
  /// **'Explored the MOYAH water delivery app features'**
  String get appExplorerDesc;

  /// No description provided for @waterSupporter.
  ///
  /// In en, this message translates to:
  /// **'Water Supporter'**
  String get waterSupporter;

  /// No description provided for @waterSupporterDesc.
  ///
  /// In en, this message translates to:
  /// **'Joined the community supporting clean water access'**
  String get waterSupporterDesc;

  /// No description provided for @firstSteps.
  ///
  /// In en, this message translates to:
  /// **'First Steps'**
  String get firstSteps;

  /// No description provided for @firstStepsDesc.
  ///
  /// In en, this message translates to:
  /// **'Started your journey to help donate clean water'**
  String get firstStepsDesc;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get noData;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @removeItem.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get removeItem;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @unknownProduct.
  ///
  /// In en, this message translates to:
  /// **'Unknown Product'**
  String get unknownProduct;

  /// No description provided for @continuee.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continuee;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @editPersonalFile.
  ///
  /// In en, this message translates to:
  /// **'Edit Personal File'**
  String get editPersonalFile;

  /// No description provided for @bottles.
  ///
  /// In en, this message translates to:
  /// **'Bottles'**
  String get bottles;

  /// No description provided for @youCanSelectUpTo.
  ///
  /// In en, this message translates to:
  /// **'You can select up to'**
  String get youCanSelectUpTo;

  /// No description provided for @preferredDaysOnly.
  ///
  /// In en, this message translates to:
  /// **'preferred days only.'**
  String get preferredDaysOnly;

  /// No description provided for @productDetails.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetails;

  /// No description provided for @thisFieldIsRequired.
  ///
  /// In en, this message translates to:
  /// **'This Field Is Required'**
  String get thisFieldIsRequired;

  /// No description provided for @read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter Name'**
  String get enterName;

  /// No description provided for @emailExample.
  ///
  /// In en, this message translates to:
  /// **'Ex: abc@example.com'**
  String get emailExample;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @noTransactionsFound.
  ///
  /// In en, this message translates to:
  /// **'No Transactions Found'**
  String get noTransactionsFound;

  /// No description provided for @resolution.
  ///
  /// In en, this message translates to:
  /// **'Resolution'**
  String get resolution;

  /// No description provided for @returned.
  ///
  /// In en, this message translates to:
  /// **'Returned'**
  String get returned;

  /// No description provided for @dispute.
  ///
  /// In en, this message translates to:
  /// **'Dispute'**
  String get dispute;

  /// No description provided for @vendor.
  ///
  /// In en, this message translates to:
  /// **'Vendor'**
  String get vendor;

  /// No description provided for @reOrder.
  ///
  /// In en, this message translates to:
  /// **'Re-Order'**
  String get reOrder;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @customerReviews.
  ///
  /// In en, this message translates to:
  /// **'Customer Reviews'**
  String get customerReviews;

  /// No description provided for @ratingSummary.
  ///
  /// In en, this message translates to:
  /// **'Rating Summary'**
  String get ratingSummary;

  /// No description provided for @overAll.
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get overAll;

  /// No description provided for @noaddressesfound.
  ///
  /// In en, this message translates to:
  /// **'No Addresses Found'**
  String get noaddressesfound;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please Wait...'**
  String get pleaseWait;

  /// No description provided for @bottlesDonated.
  ///
  /// In en, this message translates to:
  /// **'Bottles Donated'**
  String get bottlesDonated;

  /// No description provided for @makingDifferenceOneBottle.
  ///
  /// In en, this message translates to:
  /// **'Making A Difference One Bottle At A Time'**
  String get makingDifferenceOneBottle;

  /// No description provided for @progressToNextMilestone.
  ///
  /// In en, this message translates to:
  /// **'Progress To Next Milestone'**
  String get progressToNextMilestone;

  /// No description provided for @nextRefill.
  ///
  /// In en, this message translates to:
  /// **'Next Refill'**
  String get nextRefill;

  /// No description provided for @nextRefillAppointment.
  ///
  /// In en, this message translates to:
  /// **'Next Refill Appointment'**
  String get nextRefillAppointment;

  /// No description provided for @editNextRefill.
  ///
  /// In en, this message translates to:
  /// **'Edit Next Refill'**
  String get editNextRefill;

  /// No description provided for @requestNewDate.
  ///
  /// In en, this message translates to:
  /// **'Request New Date'**
  String get requestNewDate;

  /// No description provided for @notSelected.
  ///
  /// In en, this message translates to:
  /// **'Not Selected'**
  String get notSelected;

  /// No description provided for @nocCouponBalanceFound.
  ///
  /// In en, this message translates to:
  /// **'No Coupon Balance Found'**
  String get nocCouponBalanceFound;

  /// No description provided for @lastDelivered.
  ///
  /// In en, this message translates to:
  /// **'Last Delivered'**
  String get lastDelivered;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @used.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get used;

  /// No description provided for @couponBalance.
  ///
  /// In en, this message translates to:
  /// **'Coupon Balance'**
  String get couponBalance;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
