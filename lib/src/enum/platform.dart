/// Enum representing the supported platform types.
///
/// - mobile: Indicates a mobile platform (e.g., iOS, Android).
/// - web: Indicates a web platform.
enum PlatformType {
  mobile, // Represents the mobile platform (iOS, Android).
  web // Represents the web platform.
}

/// Extension on [PlatformType] to get the string value of the platform type.
///
/// It provides a string representation for the platform to be used in API requests.
extension PlatformTypeValues on PlatformType {
  /// Gets the string value corresponding to the platform type.
  ///
  /// Returns:
  /// - 'mobile' if the platform is mobile.
  /// - 'hosted' if the platform is web.
  String get value {
    switch (this) {
      case PlatformType.mobile:
        return 'mobile';
      case PlatformType.web:
        return 'hosted';
    }
  }
}
