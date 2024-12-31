enum Environment { production, sandbox }

extension EnvironmentValues on Environment {
  String get value {
    switch (this) {
      case Environment.production:
        return 'production';
      case Environment.sandbox:
        return 'sandbox';
    }
  }
}
