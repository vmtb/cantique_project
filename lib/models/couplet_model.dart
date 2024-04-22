class Couplet{
  int ordre;
  int refrain;
  String contenu;
  int cantique_id;
  int id;

//<editor-fold desc="Data Methods">

  Couplet({
    required this.ordre,
    required this.refrain,
    required this.contenu,
    required this.cantique_id,
    required this.id,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Couplet &&
          runtimeType == other.runtimeType &&
          ordre == other.ordre &&
          refrain == other.refrain &&
          contenu == other.contenu &&
          cantique_id == other.cantique_id &&
          id == other.id);

  @override
  int get hashCode => ordre.hashCode ^ refrain.hashCode ^ contenu.hashCode ^ cantique_id.hashCode ^ id.hashCode;

  @override
  String toString() {
    return 'Couplet{' +
        ' ordre: $ordre,' +
        ' refrain: $refrain,' +
        ' contenu: $contenu,' +
        ' cantique_id: $cantique_id,' +
        ' id: $id,' +
        '}';
  }

  Couplet copyWith({
    int? ordre,
    int? refrain,
    String? contenu,
    int? cantique_id,
    int? id,
  }) {
    return Couplet(
      ordre: ordre ?? this.ordre,
      refrain: refrain ?? this.refrain,
      contenu: contenu ?? this.contenu,
      cantique_id: cantique_id ?? this.cantique_id,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ordre': this.ordre,
      'refrain': this.refrain,
      'contenu': this.contenu,
      'cantique_id': this.cantique_id,
      'id': this.id,
    };
  }

  factory Couplet.fromMap(Map<String, dynamic> map) {
    return Couplet(
      ordre: map['ordre'] as int,
      refrain: map['refrain'] as int,
      contenu: map['contenu'] as String,
      cantique_id: map['cantique_id'] as int,
      id: map['id'] as int,
    );
  }

//</editor-fold>
}