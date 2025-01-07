enum SafePayEnvironment { production, sandbox }

extension EnvironmentValues on SafePayEnvironment {
  String get value {
    switch (this) {
      case SafePayEnvironment.production:
        return 'production';
      case SafePayEnvironment.sandbox:
        return 'sandbox';
    }
  }
}
