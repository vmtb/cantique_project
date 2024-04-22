class Setting{
  final int id;
  final String key;
  final String value;
  final String type;
  final String description;

//<editor-fold desc="Data Methods">
  const Setting({
    required this.id,
    required this.key,
    required this.value,
    required this.type,
    required this.description,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          key == other.key &&
          value == other.value &&
          type == other.type &&
          description == other.description);

  @override
  int get hashCode => id.hashCode ^ key.hashCode ^ value.hashCode ^ type.hashCode ^ description.hashCode;

  @override
  String toString() {
    return 'Setting{' +
        ' id: $id,' +
        ' key: $key,' +
        ' value: $value,' +
        ' type: $type,' +
        ' description: $description,' +
        '}';
  }

  Setting copyWith({
    int? id,
    String? key,
    String? value,
    String? type,
    String? description,
  }) {
    return Setting(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
      type: type ?? this.type,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'key': this.key,
      'value': this.value,
      'type': this.type,
      'description': this.description,
    };
  }

  factory Setting.fromMap(Map<String, dynamic> map) {
    return Setting(
      id: map['id'] ?? 0,
      key: map['key'] ?? "",
      value: map['value'] ?? "",
      type: map['type'] ?? "",
      description: map['description'] ?? "",
    );
  }

  static initial() {
    return Setting(id: 0, key: "", value: "0", type: "", description: "");
  }

//</editor-fold>
}