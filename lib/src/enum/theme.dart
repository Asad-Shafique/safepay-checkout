enum ThemeType { defaultTheme, light, dark }

extension ThemeValues on ThemeType {
  String get color {
    switch (this) {
      case ThemeType.defaultTheme:
        return '#ffffff';
      case ThemeType.light:
        return 'white';
      case ThemeType.dark:
        return '#0e0e0e';
    }
  }
}
