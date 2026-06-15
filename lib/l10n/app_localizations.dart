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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

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

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get haveAccount;

  /// No description provided for @showPass.
  ///
  /// In en, this message translates to:
  /// **'show password'**
  String get showPass;

  /// No description provided for @hidePass.
  ///
  /// In en, this message translates to:
  /// **'hide password'**
  String get hidePass;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is reauired'**
  String get requiredField;

  /// No description provided for @langSelect.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get langSelect;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

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

  /// No description provided for @saudiDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover Saudi Arabia'**
  String get saudiDiscover;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'WAIN NAFLEH'**
  String get title;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

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

  /// No description provided for @alredylog.
  ///
  /// In en, this message translates to:
  /// **'Do you have an account ?'**
  String get alredylog;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @addPlace.
  ///
  /// In en, this message translates to:
  /// **'Add Place'**
  String get addPlace;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @like.
  ///
  /// In en, this message translates to:
  /// **'love'**
  String get like;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'comment'**
  String get comment;

  /// No description provided for @discover.
  ///
  /// In en, this message translates to:
  /// **'Discover beauty of Saudi Arabia'**
  String get discover;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'comments'**
  String get comments;

  /// No description provided for @writeComment.
  ///
  /// In en, this message translates to:
  /// **'Write a comment...'**
  String get writeComment;

  /// No description provided for @noComments.
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get noComments;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @places.
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get places;

  /// No description provided for @likes.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get likes;

  /// No description provided for @myPlaces.
  ///
  /// In en, this message translates to:
  /// **'Favourite Places'**
  String get myPlaces;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @manageProfile.
  ///
  /// In en, this message translates to:
  /// **'Manage your profile'**
  String get manageProfile;

  /// No description provided for @placesDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover best places'**
  String get placesDiscover;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'save'**
  String get save;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhone;

  /// No description provided for @enterFullCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the complete code'**
  String get enterFullCode;

  /// No description provided for @vreificationMessage.
  ///
  /// In en, this message translates to:
  /// **'To verify your account, a one-time verification code will be sent to your registered mobile number. Please enter the code below once received.'**
  String get vreificationMessage;

  /// No description provided for @somethingWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWrong;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @placeTitle.
  ///
  /// In en, this message translates to:
  /// **'Place Title'**
  String get placeTitle;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @placeImage.
  ///
  /// In en, this message translates to:
  /// **'Place Image'**
  String get placeImage;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @submitPlace.
  ///
  /// In en, this message translates to:
  /// **'Submit Place'**
  String get submitPlace;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @manageYourAccountInformationSecurely.
  ///
  /// In en, this message translates to:
  /// **'Manage your account information securely'**
  String get manageYourAccountInformationSecurely;

  /// No description provided for @editUsername.
  ///
  /// In en, this message translates to:
  /// **'Edit Username'**
  String get editUsername;

  /// No description provided for @changeYourFirstAndLastName.
  ///
  /// In en, this message translates to:
  /// **'Change your first and last name'**
  String get changeYourFirstAndLastName;

  /// No description provided for @editPassword.
  ///
  /// In en, this message translates to:
  /// **'Edit Password'**
  String get editPassword;

  /// No description provided for @updateYourAccountPassword.
  ///
  /// In en, this message translates to:
  /// **'Update your account password'**
  String get updateYourAccountPassword;

  /// No description provided for @updateYourName.
  ///
  /// In en, this message translates to:
  /// **'Update Your Name'**
  String get updateYourName;

  /// No description provided for @makeSureYourInformationIsAccurate.
  ///
  /// In en, this message translates to:
  /// **'Make sure your information is accurate'**
  String get makeSureYourInformationIsAccurate;

  /// No description provided for @usernameUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Username updated successfully'**
  String get usernameUpdatedSuccessfully;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @securitySettings.
  ///
  /// In en, this message translates to:
  /// **'Security Settings'**
  String get securitySettings;

  /// No description provided for @chooseAStrongPasswordToKeepYourAccountSecure.
  ///
  /// In en, this message translates to:
  /// **'Choose a strong password to keep your account secure'**
  String get chooseAStrongPasswordToKeepYourAccountSecure;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get passwordUpdatedSuccessfully;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// No description provided for @discoverYourBestPlaces.
  ///
  /// In en, this message translates to:
  /// **'Discover your best places'**
  String get discoverYourBestPlaces;

  /// No description provided for @placeAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Place added successfully'**
  String get placeAddedSuccessfully;

  /// No description provided for @enterPlaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter place title'**
  String get enterPlaceTitle;

  /// No description provided for @addPlaceYouHaveDiscovered.
  ///
  /// In en, this message translates to:
  /// **'Add place you have discovered'**
  String get addPlaceYouHaveDiscovered;

  /// No description provided for @writePlaceDescription.
  ///
  /// In en, this message translates to:
  /// **'Write place description...'**
  String get writePlaceDescription;

  /// No description provided for @chooseCategory.
  ///
  /// In en, this message translates to:
  /// **'Choose category'**
  String get chooseCategory;

  /// No description provided for @mountain.
  ///
  /// In en, this message translates to:
  /// **'Mountain'**
  String get mountain;

  /// No description provided for @sea.
  ///
  /// In en, this message translates to:
  /// **'Sea'**
  String get sea;

  /// No description provided for @beach.
  ///
  /// In en, this message translates to:
  /// **'Beach'**
  String get beach;

  /// No description provided for @entertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get entertainment;

  /// No description provided for @historical.
  ///
  /// In en, this message translates to:
  /// **'Historical'**
  String get historical;

  /// No description provided for @desert.
  ///
  /// In en, this message translates to:
  /// **'Desert'**
  String get desert;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @chooseImage.
  ///
  /// In en, this message translates to:
  /// **'Choose Image'**
  String get chooseImage;

  /// No description provided for @searchLocation.
  ///
  /// In en, this message translates to:
  /// **'Search location...'**
  String get searchLocation;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @addToFavourite.
  ///
  /// In en, this message translates to:
  /// **'Add to favourite'**
  String get addToFavourite;

  /// No description provided for @rateThisPlace.
  ///
  /// In en, this message translates to:
  /// **'Rate this place'**
  String get rateThisPlace;

  /// No description provided for @yourFeedbackHelpsOtherTravelers.
  ///
  /// In en, this message translates to:
  /// **'Your feedback helps other travelers'**
  String get yourFeedbackHelpsOtherTravelers;

  /// No description provided for @tapToRate.
  ///
  /// In en, this message translates to:
  /// **'Tap to rate'**
  String get tapToRate;

  /// No description provided for @thanksForYourRating.
  ///
  /// In en, this message translates to:
  /// **'Thanks for your rating'**
  String get thanksForYourRating;

  /// No description provided for @addedToFavourites.
  ///
  /// In en, this message translates to:
  /// **'Added to favourites'**
  String get addedToFavourites;

  /// No description provided for @youCanFindItLaterInSavedPlaces.
  ///
  /// In en, this message translates to:
  /// **'You can find it later in saved places'**
  String get youCanFindItLaterInSavedPlaces;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of your account?'**
  String get confirmLogout;

  /// No description provided for @adminDashboard.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get adminDashboard;

  /// No description provided for @management.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get management;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @pendingPlaces.
  ///
  /// In en, this message translates to:
  /// **'Pending Places'**
  String get pendingPlaces;

  /// No description provided for @approveOrRejectNewPlaces.
  ///
  /// In en, this message translates to:
  /// **'Approve or reject new places'**
  String get approveOrRejectNewPlaces;

  /// No description provided for @viewAndManageUsers.
  ///
  /// In en, this message translates to:
  /// **'View and manage users'**
  String get viewAndManageUsers;

  /// No description provided for @editOrDeletePlaces.
  ///
  /// In en, this message translates to:
  /// **'Edit or delete places'**
  String get editOrDeletePlaces;

  /// No description provided for @logoutFromYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Logout from your account'**
  String get logoutFromYourAccount;

  /// No description provided for @noPlacesYet.
  ///
  /// In en, this message translates to:
  /// **'No places yet'**
  String get noPlacesYet;

  /// No description provided for @thereIsAnError.
  ///
  /// In en, this message translates to:
  /// **'There is an error'**
  String get thereIsAnError;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @approvePlace.
  ///
  /// In en, this message translates to:
  /// **'Approve Place'**
  String get approvePlace;

  /// No description provided for @approvePlaceConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to approve this place? It will become visible to users in the application.'**
  String get approvePlaceConfirmation;

  /// No description provided for @placeApprovedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Place approved successfully'**
  String get placeApprovedSuccessfully;

  /// No description provided for @rejectPlace.
  ///
  /// In en, this message translates to:
  /// **'Reject Place'**
  String get rejectPlace;

  /// No description provided for @rejectPlaceConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reject this place? The place will not be published in the application.'**
  String get rejectPlaceConfirmation;

  /// No description provided for @placeRejectedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Place rejected successfully'**
  String get placeRejectedSuccessfully;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deletePlace.
  ///
  /// In en, this message translates to:
  /// **'Delete Place?'**
  String get deletePlace;

  /// No description provided for @deletePlaceConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this place? This action cannot be undone.'**
  String get deletePlaceConfirmation;

  /// No description provided for @placeDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Place deleted successfully'**
  String get placeDeletedSuccessfully;

  /// No description provided for @noUsersYet.
  ///
  /// In en, this message translates to:
  /// **'No users yet'**
  String get noUsersYet;

  /// No description provided for @promoteToAdmin.
  ///
  /// In en, this message translates to:
  /// **'Promote to admin'**
  String get promoteToAdmin;

  /// No description provided for @downgradeToUser.
  ///
  /// In en, this message translates to:
  /// **'Downgrade to user'**
  String get downgradeToUser;

  /// No description provided for @userPromotedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User promoted successfully'**
  String get userPromotedSuccessfully;

  /// No description provided for @userDowngradedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User downgraded successfully'**
  String get userDowngradedSuccessfully;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @editPlace.
  ///
  /// In en, this message translates to:
  /// **'Edit Place'**
  String get editPlace;

  /// No description provided for @editPlaceYouDiscovered.
  ///
  /// In en, this message translates to:
  /// **'Edit the place user discovered'**
  String get editPlaceYouDiscovered;

  /// No description provided for @placeEditedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Place edited successfully'**
  String get placeEditedSuccessfully;

  /// No description provided for @blockUser.
  ///
  /// In en, this message translates to:
  /// **'Block User?'**
  String get blockUser;

  /// No description provided for @blockUserConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to block this user?'**
  String get blockUserConfirmation;

  /// No description provided for @unblock.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get unblock;

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get block;

  /// No description provided for @blockedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Blocked successfully'**
  String get blockedSuccessfully;

  /// No description provided for @unblockedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Unblocked successfully'**
  String get unblockedSuccessfully;

  /// No description provided for @loggedInSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Logged in successfully'**
  String get loggedInSuccessfully;

  /// No description provided for @noAccountFoundWithThisEmail.
  ///
  /// In en, this message translates to:
  /// **'No account found with this email'**
  String get noAccountFoundWithThisEmail;

  /// No description provided for @incorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get incorrectPassword;

  /// No description provided for @emailAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered'**
  String get emailAlreadyRegistered;

  /// No description provided for @passwordTooWeak.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get passwordTooWeak;

  /// No description provided for @invalidEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmailFormat;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again'**
  String get somethingWentWrong;

  /// No description provided for @checkInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again'**
  String get checkInternetConnection;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again'**
  String get loginFailed;

  /// No description provided for @removeFromFavourite.
  ///
  /// In en, this message translates to:
  /// **'Remove from favourite'**
  String get removeFromFavourite;

  /// No description provided for @editComment.
  ///
  /// In en, this message translates to:
  /// **'Edit Comment'**
  String get editComment;

  /// No description provided for @updateYourComment.
  ///
  /// In en, this message translates to:
  /// **'Update your comment'**
  String get updateYourComment;

  /// No description provided for @commentEditedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Comment edited successfully'**
  String get commentEditedSuccessfully;

  /// No description provided for @commentDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Comment deleted successfully'**
  String get commentDeletedSuccessfully;

  /// No description provided for @removedFromFavouriteSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Removed from favourites successfully'**
  String get removedFromFavouriteSuccessfully;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
