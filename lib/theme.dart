import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4284219392),
      surfaceTint: Color(4289866525),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4287960331),
      onPrimaryContainer: Color(4294959323),
      secondary: Color(4288038715),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4294944922),
      onSecondaryContainer: Color(4284094994),
      tertiary: Color(4282000896),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4284696078),
      onTertiaryContainer: Color(4294960318),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(4294965494),
      onSurface: Color(4280686614),
      onSurfaceVariant: Color(4284105021),
      outline: Color(4287524972),
      outlineVariant: Color(4293050297),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4282199338),
      inversePrimary: Color(4294948008),
      primaryFixed: Color(4294957780),
      onPrimaryFixed: Color(4282449920),
      primaryFixedDim: Color(4294948008),
      onPrimaryFixedVariant: Color(4287565575),
      secondaryFixed: Color(4294957780),
      onSecondaryFixed: Color(4282254594),
      secondaryFixedDim: Color(4294948008),
      onSecondaryFixedVariant: Color(4286066726),
      tertiaryFixed: Color(4294958764),
      onTertiaryFixed: Color(4280817920),
      tertiaryFixedDim: Color(4293574781),
      onTertiaryFixedVariant: Color(4284367113),
      surfaceDim: Color(4293842128),
      surfaceBright: Color(4294965494),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294963438),
      surfaceContainer: Color(4294961638),
      surfaceContainerHigh: Color(4294828766),
      surfaceContainerHighest: Color(4294434264),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4284219392),
      surfaceTint: Color(4289866525),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4287960331),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4285738019),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4289813583),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4282000896),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4284696078),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      surface: Color(4294965494),
      onSurface: Color(4280686614),
      onSurfaceVariant: Color(4283776313),
      outline: Color(4285815124),
      outlineVariant: Color(4287722607),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4282199338),
      inversePrimary: Color(4294948008),
      primaryFixed: Color(4291903793),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4289603611),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4289813583),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4287841337),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4287721268),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4285945374),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4293842128),
      surfaceBright: Color(4294965494),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294963438),
      surfaceContainer: Color(4294961638),
      surfaceContainerHigh: Color(4294828766),
      surfaceContainerHighest: Color(4294434264),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4283301888),
      surfaceTint: Color(4289866525),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4287170820),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4282846214),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4285738019),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4281343744),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4284104197),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      surface: Color(4294965494),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4281540379),
      outline: Color(4283776313),
      outlineVariant: Color(4283776313),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4282199338),
      inversePrimary: Color(4294961123),
      primaryFixed: Color(4287170820),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4284612608),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4285738019),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4283766543),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4284104197),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4282263808),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4293842128),
      surfaceBright: Color(4294965494),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294963438),
      surfaceContainer: Color(4294961638),
      surfaceContainerHigh: Color(4294828766),
      surfaceContainerHighest: Color(4294434264),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294948008),
      surfaceTint: Color(4294948008),
      onPrimary: Color(4285071360),
      primaryContainer: Color(4285464576),
      onPrimaryContainer: Color(4294946722),
      secondary: Color(4294948008),
      onSecondary: Color(4284094994),
      secondaryContainer: Color(4285277982),
      onSecondaryContainer: Color(4294951866),
      tertiary: Color(4293574781),
      onTertiary: Color(4282592256),
      tertiaryContainer: Color(4282855168),
      onTertiaryContainer: Color(4293311609),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4280094734),
      onSurface: Color(4294434264),
      onSurfaceVariant: Color(4293050297),
      outline: Color(4289300868),
      outlineVariant: Color(4284105021),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4294434264),
      inversePrimary: Color(4289866525),
      primaryFixed: Color(4294957780),
      onPrimaryFixed: Color(4282449920),
      primaryFixedDim: Color(4294948008),
      onPrimaryFixedVariant: Color(4287565575),
      secondaryFixed: Color(4294957780),
      onSecondaryFixed: Color(4282254594),
      secondaryFixedDim: Color(4294948008),
      onSecondaryFixedVariant: Color(4286066726),
      tertiaryFixed: Color(4294958764),
      onTertiaryFixed: Color(4280817920),
      tertiaryFixedDim: Color(4293574781),
      onTertiaryFixedVariant: Color(4284367113),
      surfaceDim: Color(4280094734),
      surfaceBright: Color(4282791219),
      surfaceContainerLowest: Color(4279700233),
      surfaceContainerLow: Color(4280686614),
      surfaceContainer: Color(4280949786),
      surfaceContainerHigh: Color(4281738788),
      surfaceContainerHighest: Color(4282462510),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294949551),
      surfaceTint: Color(4294948008),
      onPrimary: Color(4281794560),
      primaryContainer: Color(4294401353),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294949551),
      onSecondary: Color(4281729281),
      secondaryContainer: Color(4292048745),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4293903489),
      onTertiary: Color(4280357888),
      tertiaryContainer: Color(4289760077),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      surface: Color(4280094734),
      onSurface: Color(4294965752),
      onSurfaceVariant: Color(4293313469),
      outline: Color(4290550678),
      outlineVariant: Color(4288314487),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4294434264),
      inversePrimary: Color(4287697160),
      primaryFixed: Color(4294957780),
      onPrimaryFixed: Color(4281139200),
      primaryFixedDim: Color(4294948008),
      onPrimaryFixedVariant: Color(4285792256),
      secondaryFixed: Color(4294957780),
      onSecondaryFixed: Color(4281139200),
      secondaryFixedDim: Color(4294948008),
      onSecondaryFixedVariant: Color(4284620823),
      tertiaryFixed: Color(4294958764),
      onTertiaryFixed: Color(4279897856),
      tertiaryFixedDim: Color(4293574781),
      onTertiaryFixedVariant: Color(4283052288),
      surfaceDim: Color(4280094734),
      surfaceBright: Color(4282791219),
      surfaceContainerLowest: Color(4279700233),
      surfaceContainerLow: Color(4280686614),
      surfaceContainer: Color(4280949786),
      surfaceContainerHigh: Color(4281738788),
      surfaceContainerHighest: Color(4282462510),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294965752),
      surfaceTint: Color(4294948008),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4294949551),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294965752),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4294949551),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294966007),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4293903489),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4280094734),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294965752),
      outline: Color(4293313469),
      outlineVariant: Color(4293313469),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4294434264),
      inversePrimary: Color(4284284928),
      primaryFixed: Color(4294959323),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4294949551),
      onPrimaryFixedVariant: Color(4281794560),
      secondaryFixed: Color(4294959323),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4294949551),
      onSecondaryFixedVariant: Color(4281729281),
      tertiaryFixed: Color(4294960059),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4293903489),
      onTertiaryFixedVariant: Color(4280357888),
      surfaceDim: Color(4280094734),
      surfaceBright: Color(4282791219),
      surfaceContainerLowest: Color(4279700233),
      surfaceContainerLow: Color(4280686614),
      surfaceContainer: Color(4280949786),
      surfaceContainerHigh: Color(4281738788),
      surfaceContainerHighest: Color(4282462510),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.surface,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
