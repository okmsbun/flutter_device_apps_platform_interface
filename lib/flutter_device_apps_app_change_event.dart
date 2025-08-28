/// Represents the type of change that occurred to an app.
enum AppChangeType {
  /// The app was newly installed on the device.
  installed,

  /// The app was removed/uninstalled from the device.
  removed,

  /// The app was updated to a new version.
  updated,

  /// The app was enabled (re-activated) on the device.
  enabled,

  /// The app was disabled (deactivated) on the device.
  disabled,
}

/// Represents an event when an app's state changes on the device.
///
/// This includes installations, removals, updates, and enable/disable operations.
class AppChangeEvent {
  /// Creates an [AppChangeEvent] with the specified properties.
  ///
  /// All parameters are optional and represent the details of the app change.
  const AppChangeEvent({
    this.packageName,
    this.type,
    this.isReplacing,
  });

  /// Creates an [AppChangeEvent] from a map of key-value pairs.
  ///
  /// The map typically comes from platform-specific implementations.
  /// Handles type conversion and parsing for the change event data.
  factory AppChangeEvent.fromMap(Map<String, Object?> m) {
    final String? pkg = m['packageName']?.toString();
    final String? t = m['type']?.toString();
    final bool? replacing =
        m['isReplacing'] != null ? bool.tryParse(m['isReplacing']!.toString()) : null;

    return AppChangeEvent(
      packageName: pkg,
      type: t != null ? _parseType(t) : null,
      isReplacing: replacing,
    );
  }

  /// The package name of the app that changed (e.g., 'com.example.app').
  final String? packageName;

  /// The type of change that occurred to the app.
  final AppChangeType? type;

  /// Whether this change is part of a replacement operation (e.g., app update).
  final bool? isReplacing;

  /// Converts this [AppChangeEvent] to a map representation.
  ///
  /// Useful for serialization to platform channels or other data formats.
  Map<String, Object?> toMap() => {
        'packageName': packageName,
        'type': type?.name,
        'isReplacing': isReplacing,
      };

  static AppChangeType? _parseType(String raw) => switch (raw) {
        'installed' => AppChangeType.installed,
        'removed' => AppChangeType.removed,
        'updated' => AppChangeType.updated,
        'enabled' => AppChangeType.enabled,
        'disabled' => AppChangeType.disabled,
        _ => null,
      };
}
