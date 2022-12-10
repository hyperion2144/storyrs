import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class CustomThemeData {
  macosThemeData(
    Brightness? brightness,
    Color? primaryColor,
    Color? canvasColor,
    MacosTypography? typography,
    PushButtonThemeData? pushButtonTheme,
    Color? dividerColor,
    HelpButtonThemeData? helpButtonTheme,
    MacosTooltipThemeData? tooltipTheme,
    VisualDensity? visualDensity,
    MacosScrollbarThemeData? scrollbarTheme,
    MacosIconButtonThemeData? macosIconButtonTheme,
    MacosIconThemeData? iconTheme,
    MacosPopupButtonThemeData? popupButtonTheme,
    MacosPulldownButtonThemeData? pulldownButtonTheme,
    MacosDatePickerThemeData? datePickerTheme,
    MacosTimePickerThemeData? timePickerTheme,
    MacosSearchFieldThemeData? searchFieldTheme,
  ) {
    // ignore: no_leading_underscores_for_local_identifiers
    final Brightness _brightness = brightness ?? Brightness.light;
    final bool isDark = _brightness == Brightness.dark;
    primaryColor ??= MacosColors.controlAccentColor;
    canvasColor ??= isDark
        ? CupertinoColors.systemBackground.darkElevatedColor
        : CupertinoColors.systemBackground;
    typography ??= MacosTypography(
      color: _brightness == Brightness.light
          ? CupertinoColors.black
          : CupertinoColors.white,
    );
    pushButtonTheme ??= PushButtonThemeData(
      color: primaryColor,
      secondaryColor: isDark
          ? const Color.fromRGBO(56, 56, 56, 1.0)
          : const Color.fromRGBO(218, 218, 223, 1.0),
      disabledColor: isDark
          ? const Color.fromRGBO(255, 255, 255, 0.1)
          : const Color.fromRGBO(244, 245, 245, 1.0),
    );
    dividerColor ??= isDark ? const Color(0x1FFFFFFF) : const Color(0x1F000000);
    helpButtonTheme ??= HelpButtonThemeData(
      color: isDark
          ? const Color.fromRGBO(255, 255, 255, 0.1)
          : const Color.fromRGBO(244, 245, 245, 1.0),
      disabledColor: isDark
          ? const Color.fromRGBO(255, 255, 255, 0.1)
          : const Color.fromRGBO(244, 245, 245, 1.0),
    );
    tooltipTheme ??= MacosTooltipThemeData.standard(
      brightness: _brightness,
      textStyle: typography.callout,
    );
    scrollbarTheme ??= const MacosScrollbarThemeData();
    macosIconButtonTheme ??= MacosIconButtonThemeData(
      backgroundColor: MacosColors.transparent,
      disabledColor: isDark ? const Color(0xff353535) : const Color(0xffE5E5E5),
      // TODO: correct disabled color
      hoverColor: isDark ? const Color(0xff333336) : const Color(0xffF3F2F2),
      shape: BoxShape.circle,
      boxConstraints: const BoxConstraints(
        minHeight: 20,
        minWidth: 20,
        maxWidth: 30,
        maxHeight: 30,
      ),
    );

    visualDensity ??= VisualDensity.adaptivePlatformDensity;

    iconTheme ??= MacosIconThemeData(
      color: isDark
          ? CupertinoColors.activeBlue.darkColor
          : CupertinoColors.activeBlue.color,
      size: 20,
    );

    popupButtonTheme ??= MacosPopupButtonThemeData(
      highlightColor: isDark
          ? CupertinoColors.activeBlue.darkColor
          : CupertinoColors.activeBlue.color,
      backgroundColor: isDark
          ? const Color.fromRGBO(255, 255, 255, 0.247)
          : const Color.fromRGBO(255, 255, 255, 1),
      popupColor: isDark
          ? const Color.fromRGBO(30, 30, 30, 1)
          : const Color.fromRGBO(242, 242, 247, 1),
    );

    pulldownButtonTheme ??= MacosPulldownButtonThemeData(
      highlightColor: isDark
          ? CupertinoColors.activeBlue.darkColor
          : CupertinoColors.activeBlue.color,
      backgroundColor: isDark
          ? const Color.fromRGBO(255, 255, 255, 0.247)
          : const Color.fromRGBO(255, 255, 255, 1),
      pulldownColor: isDark
          ? const Color.fromRGBO(30, 30, 30, 1)
          : const Color.fromRGBO(242, 242, 247, 1),
      iconColor: isDark
          ? const Color.fromRGBO(255, 255, 255, 0.7)
          : const Color.fromRGBO(0, 0, 0, 0.7),
    );

    datePickerTheme = MacosDatePickerThemeData(
      shadowColor: const Color.fromRGBO(0, 0, 0, 0.1),
      backgroundColor: isDark
          ? const Color.fromRGBO(255, 255, 255, 0.1)
          : const Color.fromRGBO(255, 255, 255, 1.0),
      caretColor: isDark ? MacosColors.white : MacosColors.black,
      caretControlsBackgroundColor: isDark
          ? const Color.fromRGBO(255, 255, 255, 0.1)
          : const Color.fromRGBO(255, 255, 255, 1.0),
      caretControlsSeparatorColor: isDark
          ? const Color.fromRGBO(71, 71, 71, 1)
          : const Color.fromRGBO(0, 0, 0, 0.1),
      monthViewControlsColor: isDark
          ? const Color.fromRGBO(255, 255, 255, 0.55)
          : const Color.fromRGBO(0, 0, 0, 0.5),
      selectedElementColor: const Color(0xFF0063E1),
      selectedElementTextColor: MacosColors.white,
      monthViewDateColor: isDark ? MacosColors.white : MacosColors.black,
      monthViewHeaderColor: isDark ? MacosColors.white : MacosColors.black,
      monthViewWeekdayHeaderColor: isDark
          ? const Color.fromRGBO(255, 255, 255, 0.55)
          : const Color.fromRGBO(0, 0, 0, 0.5),
      monthViewCurrentDateColor: isDark
          ? const Color.fromRGBO(0, 88, 208, 1)
          : const Color.fromRGBO(0, 99, 255, 1),
      monthViewSelectedDateColor:
          isDark ? const MacosColor(0xff464646) : const MacosColor(0xffDCDCDC),
      monthViewHeaderDividerColor: isDark
          ? const Color.fromRGBO(255, 255, 255, 0.1)
          : const Color.fromRGBO(0, 0, 0, 0.1),
    );

    timePickerTheme ??= MacosTimePickerThemeData(
      shadowColor: const Color.fromRGBO(0, 0, 0, 0.1),
      backgroundColor: isDark
          ? const Color.fromRGBO(255, 255, 255, 0.1)
          : const Color.fromRGBO(255, 255, 255, 1.0),
      selectedElementColor: const Color(0xFF0063E1),
      selectedElementTextColor: MacosColors.white,
      caretColor: isDark ? MacosColors.white : MacosColors.black,
      caretControlsBackgroundColor: isDark
          ? const Color.fromRGBO(255, 255, 255, 0.1)
          : const Color.fromRGBO(255, 255, 255, 1.0),
      caretControlsSeparatorColor: isDark
          ? const Color.fromRGBO(71, 71, 71, 1)
          : const Color.fromRGBO(0, 0, 0, 0.1),
      clockViewBackgroundColor: MacosColors.white,
      clockViewBorderColor: const MacosColor(0xFFD1E5ED),
      dayPeriodTextColor: const MacosColor(0xFFAAAAAA),
      hourHandColor: MacosColors.black,
      minuteHandColor: MacosColors.black,
      secondHandColor: const MacosColor(0xFFFF3B2F),
      hourTextColor: MacosColors.black,
    );

    searchFieldTheme ??= MacosSearchFieldThemeData(
      highlightColor: isDark
          ? CupertinoColors.activeBlue.darkColor
          : CupertinoColors.activeBlue.color,
      resultsBackgroundColor: isDark
          ? const Color.fromRGBO(30, 30, 30, 1)
          : const Color.fromRGBO(242, 242, 247, 1),
    );

    final defaultData = MacosThemeData.raw(
      brightness: _brightness,
      primaryColor: primaryColor,
      canvasColor: canvasColor,
      typography: typography,
      pushButtonTheme: pushButtonTheme,
      dividerColor: dividerColor,
      helpButtonTheme: helpButtonTheme,
      tooltipTheme: tooltipTheme,
      visualDensity: visualDensity,
      scrollbarTheme: scrollbarTheme,
      iconButtonTheme: macosIconButtonTheme,
      iconTheme: iconTheme,
      popupButtonTheme: popupButtonTheme,
      pulldownButtonTheme: pulldownButtonTheme,
      datePickerTheme: datePickerTheme,
      timePickerTheme: timePickerTheme,
      searchFieldTheme: searchFieldTheme,
    );

    final customizedData = defaultData.copyWith(
      brightness: _brightness,
      primaryColor: primaryColor,
      canvasColor: canvasColor,
      typography: typography,
      pushButtonTheme: pushButtonTheme,
      dividerColor: dividerColor,
      helpButtonTheme: helpButtonTheme,
      tooltipTheme: tooltipTheme,
      visualDensity: visualDensity,
      scrollbarTheme: scrollbarTheme,
      iconButtonTheme: macosIconButtonTheme,
      iconTheme: iconTheme,
      popupButtonTheme: popupButtonTheme,
      pulldownButtonTheme: pulldownButtonTheme,
      datePickerTheme: datePickerTheme,
      searchFieldTheme: searchFieldTheme,
    );

    return defaultData.merge(customizedData);
  }
}
