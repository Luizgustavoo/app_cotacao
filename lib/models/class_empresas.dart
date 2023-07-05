import 'dart:convert';

import 'package:cotacao/models/class_item.dart';

class Empresa {
  final String razaoSocial;
  final List<Item> itens;

  Empresa(this.razaoSocial, this.itens);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'razao_social': razaoSocial,
      'itens': itens.map((x) => x.toMap()).toList(),
    };
  }

  factory Empresa.fromMap(Map<String, dynamic> map) {
    return Empresa(map['razao_social'] as String,
        List<Item>.from(map['itens']?.map((x) => Item.fromMap(x)) ?? const []));
  }

  String toJson() => json.encode(toMap());

  factory Empresa.fromJson(String source) =>
      Empresa.fromMap(json.decode(source) as Map<String, dynamic>);
}
