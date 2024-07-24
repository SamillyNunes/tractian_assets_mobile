enum SensorType { energy, vibration }

extension SensorTypeExtension on SensorType {
  static SensorType? fromString(String? label) {
    switch (label?.toLowerCase()) {
      case 'energy':
        return SensorType.energy;
      case 'vibration':
        return SensorType.vibration;
      default:
        return null;
    }
  }
}
