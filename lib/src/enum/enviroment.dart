/// Enum representing the possible environments for SafePay.
///
/// - production: Used for real transactions in the live environment.
/// - sandbox: Used for testing and development.
enum SafePayEnvironment {
  production, // Represents the production environment.
  sandbox // Represents the sandbox environment for testing.
}

/// Extension on [SafePayEnvironment] to get the string value of the environment.
///
/// It provides a string representation for the environment to be used in API requests.
extension EnvironmentValues on SafePayEnvironment {
  /// Gets the string value corresponding to the environment.
  ///
  /// Returns:
  /// - 'production' if the environment is production.
  /// - 'sandbox' if the environment is sandbox.
  String get value {
    switch (this) {
      case SafePayEnvironment.production:
        return 'production';
      case SafePayEnvironment.sandbox:
        return 'sandbox';
    }
  }
}
