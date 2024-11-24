class Statistique{
  String user_id;
  int id;
  String last_open;
  int last_cantique_open_id;
  int open;

//<editor-fold desc="Data Methods">

  Statistique({
    required this.user_id,
    required this.id,
    required this.last_open,
    required this.last_cantique_open_id,
    required this.open,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Statistique &&
          runtimeType == other.runtimeType &&
          user_id == other.user_id &&
          id == other.id &&
          last_open == other.last_open &&
          last_cantique_open_id == other.last_cantique_open_id &&
          open == other.open);

  @override
  int get hashCode =>
      user_id.hashCode ^ id.hashCode ^ last_open.hashCode ^ last_cantique_open_id.hashCode ^ open.hashCode;

  @override
  String toString() {
    return 'Statistique{' +
        ' user_id: $user_id,' +
        ' id: $id,' +
        ' last_open: $last_open,' +
        ' last_cantique_open_id: $last_cantique_open_id,' +
        ' open: $open,' +
        '}';
  }

  Statistique copyWith({
    String? user_id,
    int? id,
    String? last_open,
    int? last_cantique_open_id,
    int? open,
  }) {
    return Statistique(
      user_id: user_id ?? this.user_id,
      id: id ?? this.id,
      last_open: last_open ?? this.last_open,
      last_cantique_open_id: last_cantique_open_id ?? this.last_cantique_open_id,
      open: open ?? this.open,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': this.user_id,
      'id': this.id,
      'last_open': this.last_open,
      'last_cantique_open_id': this.last_cantique_open_id,
      'open': this.open,
    };
  }

  factory Statistique.fromMap(Map<String, dynamic> map) {
    return Statistique(
      user_id: map['user_id']??"",
      id: map['id']??0,
      last_open: map['last_open']??"",
      last_cantique_open_id: map['last_cantique_open_id']??0,
      open: map['open']??0,
    );
  }

  factory Statistique.initial(){
    return Statistique(user_id: "", id: 0, last_open: "", last_cantique_open_id: 0, open: 0);
  }

//</editor-fold>
}