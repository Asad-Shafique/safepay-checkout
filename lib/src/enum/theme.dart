/// Enum representing the different theme types available.
///
/// - defaultTheme: The default theme.
/// - light: The light theme.
/// - dark: The dark theme.
enum ThemeType {
  defaultTheme, // The default theme.
  light, // The light theme.
  dark // The dark theme.
}

/// Extension on [ThemeType] to get the color associated with the theme.
///
/// It provides the hex color value associated with each theme.
extension ThemeValues on ThemeType {
  /// Gets the color value corresponding to the theme type.
  ///
  /// Returns:
  /// - '#ffffff' for the default theme.
  /// - 'white' for the light theme.
  /// - '#0e0e0e' for the dark theme.
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
