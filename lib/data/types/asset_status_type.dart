enum AssetStatusType { operating, alert }

extension AssetStatusTypeExtension on AssetStatusType {
  static AssetStatusType? fromString(String? label) {
    switch (label?.toLowerCase()) {
      case 'alert':
        return AssetStatusType.alert;
      case 'operating':
        return AssetStatusType.operating;
      default:
        return null;
    }
  }
}
