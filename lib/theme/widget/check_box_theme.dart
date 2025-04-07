part of "../theme.dart";

var _checkBoxTheme = CheckboxThemeData(
  side: BorderSide(color: appColors.onSurface, width: 1),

  fillColor: WidgetStateProperty.resolveWith((states) {
    if (!states.contains(WidgetState.selected)) {
      return appColors.surfContainer;
    }
    return null;
  }),
  checkColor: WidgetStateProperty.resolveWith((states) {
    if (!states.contains(WidgetState.selected)) {
      return appColors.onPrimary;
    }
    return null;
  }),
  shape: RoundedRectangleBorder(
    side: BorderSide(color: appColors.primary, width: 1),
    borderRadius: BorderRadius.circular(2.0),
  ),
);
