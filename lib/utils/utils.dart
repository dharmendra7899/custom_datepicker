import 'dart:io';


import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:custom_datepicker/constant/messages.dart';
import 'package:custom_datepicker/theme/colors.dart';
import 'package:custom_datepicker/utils/context_extension.dart';
import 'package:custom_datepicker/utils/custom_bottom_sheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Utils {
  static String formatCurrency(num value) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );
    return formatter.format(
      value.toDouble().abs(),
    ); // Convert to double and handle negatives
  }

  static void changeNodeFocus(
    BuildContext context, {
    FocusNode? current,
    FocusNode? next,
  }) {
    current!.unfocus();
    FocusScope.of(context).requestFocus(next);
  }

  static void toastMessage(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(milliseconds: 3000),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: context.textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
        duration: duration,
        backgroundColor: Colors.green,
      ),
    );
  }

  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        forwardAnimationCurve: Curves.decelerate,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        padding: const EdgeInsets.all(12),
        message: message,
        duration: const Duration(seconds: 3),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.BOTTOM,
        backgroundColor: Colors.red,
        reverseAnimationCurve: Curves.easeInOut,
        positionOffset: 20,
        messageSize: 14,
        icon: const Icon(Icons.error, size: 28, color: Colors.white),
      )..show(context),
    );
  }

  // average for ratings
  static double averageRatings(List<int> ratings) {
    double avg = 0;
    for (int i = 0; i < ratings.length; i++) {
      avg += ratings[i];
    }
    avg /= ratings.length;

    return avg;
  }

  bool shouldLogout = true;

  void setShouldLogout(bool val) {
    shouldLogout = val;
  }

  static String formatTime(DateTime time) {
    return "${time.hour > 12
        ? time.hour - 12
        : time.hour == 0
        ? 12
        : time.hour}:${time.minute.toString().padLeft(2, '0')} ${time.hour >= 12 ? 'PM' : 'AM'}";
  }

  static String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map(
          (word) =>
              word.isNotEmpty
                  ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
                  : '',
        )
        .join(' ');
  }

  DateTime selectedDateTime = DateTime.now();

  void pickDate({
    DateTime? firstDay,
    DateTime? lastDate,
    DateTime? dateForEditProfile,
    DateTime? selectedDateAndTime,
    required DateTime focusDate,
    required Function onDateSelected,
  }) {
    selectedDateTime = selectedDateAndTime ?? DateTime.now();
    CalendarDatePicker(
      initialDate: dateForEditProfile ?? firstDay ?? DateTime.now(),
      firstDate: firstDay ?? DateTime.now(),
      lastDate: lastDate ?? DateTime.now().add(const Duration(days: 18 * 365)),
      onDateChanged: (DateTime value) {
        selectedDateTime = value;
      },
    );
  }

  Future<File?> pickImage({
    required BuildContext context,
    required ImageSource img,
    bool allowMultiple = false,
    List<String> allowedExtensions = const ['pdf', 'jpg', 'png'],
  }) async {
    setShouldLogout(false);
    if (img == ImageSource.gallery) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: allowMultiple,
        allowedExtensions: allowedExtensions,
      );
      if (result != null) {
        File file = File(result.files.single.path!);
        int fileSizeInBytes = file.lengthSync();
        double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
        if (fileSizeInMB > 5 && context.mounted) {
          flushBarErrorMessage("File size must be less than 5MB", context);
        } else {
          Future.delayed(
            const Duration(seconds: 5),
          ).then((value) => setShouldLogout(true));
          return File(result.files.single.path!);
        }
      } else {
        Future.delayed(
          const Duration(seconds: 5),
        ).then((value) => setShouldLogout(true));
        return null;
      }
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: img,
      imageQuality: 50,
      requestFullMetadata: true,
    );
    if (pickedFile != null) {
      Future.delayed(
        const Duration(seconds: 3),
      ).then((value) => setShouldLogout(true));
      return File(pickedFile.path);
    } else {
      if (context.mounted) {
        flushBarErrorMessage("Nothing is selected", context);
      }
    }
    Future.delayed(
      const Duration(seconds: 3),
    ).then((value) => setShouldLogout(true));
    return null;
  }

  static void chooseImages({
    required BuildContext context,
    required Function onCameraCLick,
    required Function onGalleryCLick,
  }) {
    return CustomBottomSheet.bottomSheet(
      context,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              onGalleryCLick();
              Navigator.pop(context);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.photo, size: 30, color: appColors.primaryDark),
                const SizedBox(height: 6),
                Text('Gallery', style: context.textTheme.bodyLarge),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              onCameraCLick();
              Navigator.pop(context);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt, size: 30, color: appColors.primaryDark),
                const SizedBox(height: 6),
                Text('Camera', style: context.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return Messages.PASSWORD_REQ;
    }
    final passwordPattern = RegExp(
      r'^(?=.*[A-Z])(?=.*[\W_])(?=.*\d)[A-Za-z\d\W_]{8,}$',
    );
    if (!passwordPattern.hasMatch(value)) {
      return Messages.SPECIAL_CHARACTER;
    }
    return null;
  }

  static String? validateEmail(String? value) {
    final emailRegExp = RegExp(
      r'^([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})$',
      caseSensitive: false,
    );

    if (value == null || value.isEmpty) {
      return Messages.EMAIL_REQ;
    } else if (!emailRegExp.hasMatch(value)) {
      return Messages.EMAIL_VALID;
    }
    return null;
  }

  static String? ifscValidator(String? value) {
    final ifscRegExp = RegExp(r'^[A-Za-z]{4}[0-9A-Za-z]{7}$');
    if (value == null || value.isEmpty) {
      return Messages.IFSC_REQ;
    } else if (!ifscRegExp.hasMatch(value)) {
      return Messages.IFSC_VALID;
    }
    return null;
  }

  static String? bankAccountValidator(String? value) {
    final RegExp bankAccountRegExp = RegExp(r'^\d{9,18}$');

    if (value == null || value.isEmpty) {
      return 'Bank account number is required';
    } else if (!bankAccountRegExp.hasMatch(value)) {
      return 'Enter a valid bank account number (9-18 digits)';
    }
    return null;
  }

  static String? validateMobileNumber(String? value) {
    final mobileRegExp = RegExp(r'^[6-9]\d{9}$');
    if (value == null || value.isEmpty) {
      return Messages.PHONE_REQ;
    } else if (!mobileRegExp.hasMatch(value)) {
      return Messages.PHONE_VALID;
    }
    return null;
  }

  /*  SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.height * 0.3,
                  collapsedHeight: MediaQuery.of(context).size.height * 0.08,
                  centerTitle: false,
                  titleSpacing: 10,
                  pinned: true,
                  floating: true,
                  backgroundColor: Colors.transparent,
                  title: Text(
                    texts.editProfile,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: appColors.appWhite,
                      fontSize:
                          MediaQuery.of(context).size.width *
                          0.05, // Responsive font size
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  leading: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.1,
                      width: MediaQuery.of(context).size.width * 0.1,
                      margin: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.03,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: appColors.appWhite,
                        boxShadow: [
                          BoxShadow(
                            color: appColors.onSurface.withOpacity(0.2),
                            blurRadius: 1,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          ConstantImage.backButton,
                          color: appColors.primary,
                          height: MediaQuery.of(context).size.width * 0.06,
                        ),
                      ),
                    ),
                  ),
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      final isCollapsed =
                          constraints.maxHeight <
                          MediaQuery.of(context).size.height * 0.29;

                      return SizedBox(
                        height:
                            !isCollapsed
                                ? MediaQuery.of(context).size.height * 0.25
                                : MediaQuery.of(context).size.height * 0.26,

                     child:  Container(
                       constraints: BoxConstraints(
                         maxHeight:
                         MediaQuery.of(context).size.height * 0.28,
                         minHeight: 60,
                       ),
                       decoration: BoxDecoration(
                         image: DecorationImage(
                           image: AssetImage(ConstantImage.topImage),
                           fit: BoxFit.cover,
                         ),
                         borderRadius: BorderRadius.only(
                           bottomLeft: Radius.circular(25),
                           bottomRight: Radius.circular(25),
                         ),
                         color: appColors.primary,
                       ),
                       child: FlexibleSpaceBar(
                         centerTitle: true,
                         background: _buildExpandedContent(context),
                       ),
                     ),
                     /*   child: Stack(
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.28,
                                minHeight: 60,
                              ),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(ConstantImage.topImage),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                ),
                                color: appColors.primary,
                              ),
                              child: FlexibleSpaceBar(
                                centerTitle: true,
                                background: _buildExpandedContent(context),
                              ),
                            ),
                         *//*   !isCollapsed
                                ? Positioned(
                                  left:
                                      MediaQuery.of(context).size.width * 0.05,
                                  right:
                                      MediaQuery.of(context).size.width * 0.05,
                                  bottom:
                                      MediaQuery.of(context).size.height * 0.02,
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.07,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: appColors.primaryDark,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                height:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.09,
                                                width:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.09,
                                                margin: EdgeInsets.all(
                                                  MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.03,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: appColors.appWhite,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: appColors.onSurface
                                                          .withOpacity(0.2),
                                                      blurRadius: 1,
                                                      spreadRadius: 0,
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    profileViewModel.savedJob,
                                                    style:
                                                        context
                                                            .textTheme
                                                            .bodyMedium,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.01,
                                              ),
                                              Text(
                                                texts.savedJob,
                                                style: context
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: appColors.appWhite,
                                                      fontSize:
                                                          MediaQuery.of(
                                                            context,
                                                          ).size.width *
                                                          0.035,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.05,
                                          width: 0.7,
                                          color: appColors.borderColor,
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                height:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.09,
                                                width:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.09,
                                                margin: EdgeInsets.all(
                                                  MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.03,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: appColors.appWhite,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: appColors.onSurface
                                                          .withOpacity(0.2),
                                                      blurRadius: 1,
                                                      spreadRadius: 0,
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    profileViewModel.applyJob,
                                                    style:
                                                        context
                                                            .textTheme
                                                            .bodyMedium,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.01,
                                              ),
                                              Text(
                                                texts.appliedJob,
                                                style: context
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: appColors.appWhite,
                                                      fontSize:
                                                          MediaQuery.of(
                                                            context,
                                                          ).size.width *
                                                          0.035,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                : SizedBox(height: 0),*//*
                          ],
                        ),*/
                      );
                    },
                  ),
                ),*/
}
