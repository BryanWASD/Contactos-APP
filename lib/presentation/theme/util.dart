import 'package:flutter/material.dart';

TextTheme createTextTheme(BuildContext context, String fontFamily) {
  TextTheme baseTextTheme = Theme.of(context).textTheme;
  return baseTextTheme.copyWith(
    bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontFamily: fontFamily),
    bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontFamily: fontFamily),
    bodySmall: baseTextTheme.bodySmall?.copyWith(fontFamily: fontFamily),
    labelLarge: baseTextTheme.labelLarge?.copyWith(fontFamily: fontFamily),
    labelMedium: baseTextTheme.labelMedium?.copyWith(fontFamily: fontFamily),
    labelSmall: baseTextTheme.labelSmall?.copyWith(fontFamily: fontFamily),
    titleLarge: baseTextTheme.titleLarge?.copyWith(fontFamily: fontFamily),
    titleMedium: baseTextTheme.titleMedium?.copyWith(fontFamily: fontFamily),
    titleSmall: baseTextTheme.titleSmall?.copyWith(fontFamily: fontFamily),
    headlineLarge:
        baseTextTheme.headlineLarge?.copyWith(fontFamily: fontFamily),
    headlineMedium:
        baseTextTheme.headlineMedium?.copyWith(fontFamily: fontFamily),
    headlineSmall:
        baseTextTheme.headlineSmall?.copyWith(fontFamily: fontFamily),
  );
}
