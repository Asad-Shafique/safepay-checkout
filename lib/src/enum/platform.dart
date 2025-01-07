enum PlatformType { mobile, web }

extension PlatformTypeValues on PlatformType {
  String get value {
    switch (this) {
      case PlatformType.mobile:
        return 'mobile';
      case PlatformType.web:
        return 'hosted';
    }
  }
}
