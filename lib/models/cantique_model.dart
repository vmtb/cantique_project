import 'package:cantique/utils/app_const.dart';

import 'couplet_model.dart';

class CantiqueModel{
  int id;
  int numero;
  String title;
  String song_url;
  String melodie;
  int active;
  List<Couplet>? couplets=[];

//<editor-fold desc="Data Methods">

  CantiqueModel({
    required this.id,
    required this.numero,
    required this.title,
    required this.song_url,
    required this.melodie,
    required this.active,
    this.couplets,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CantiqueModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          numero == other.numero &&
          title == other.title &&
          song_url == other.song_url &&
          melodie == other.melodie &&
          active == other.active);

  @override
  int get hashCode =>
      id.hashCode ^ numero.hashCode ^ title.hashCode ^ song_url.hashCode ^ melodie.hashCode ^ active.hashCode;

  @override
  String toString() {
    return 'CantiqueModel{' +
        ' id: $id,' +
        ' numero: $numero,' +
        ' title: $title,' +
        ' song_url: $song_url,' +
        ' melodie: $melodie,' +
        ' active: $active,' +
        '}';
  }

  CantiqueModel copyWith({
    int? id,
    int? numero,
    String? title,
    String? song_url,
    String? melodie,
    int? active,
  }) {
    return CantiqueModel(
      id: id ?? this.id,
      numero: numero ?? this.numero,
      title: title ?? this.title,
      song_url: song_url ?? this.song_url,
      melodie: melodie ?? this.melodie,
      active: active ?? this.active,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'numero': this.numero,
      'title': this.title,
      'song_url': this.song_url,
      'melodie': this.melodie,
      'active': this.active,
    };
  }

  factory CantiqueModel.fromMap(Map<String, dynamic> map) {
    return CantiqueModel(
      id: map['id'] as int,
      numero: map['numero'] as int,
      title: map['title'] as String,
      song_url: Urls.IHOST+  (map['song_url']??"") ,
      melodie: map['melodie'] as String,
      active: map['active'] as int,
      couplets: map['couplets']==null?[]:map['couplets'].map<Couplet>((e)=>Couplet.fromMap(e)).toList()
    );
  }

//</editor-fold>
}