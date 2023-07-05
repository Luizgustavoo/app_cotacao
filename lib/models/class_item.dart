import 'dart:convert';

class Item {
  final String idPs;
  final String nomePs;
  final String valorPs;
  final String quantidadePs;
  String menorValor;
  final String idItem;
  final String tipoItem;

  Item(this.idPs, this.nomePs, this.valorPs, this.quantidadePs, this.menorValor,
      this.idItem, this.tipoItem);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id_p_s': idPs,
      'nome_p_s': nomePs,
      'valor_p_s': valorPs,
      'quantidade_p_s': quantidadePs,
      'menor_valor': menorValor,
      'id_item': idItem,
      'tipo_item': tipoItem,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      map['id_p_s'] as String,
      map['nome_p_s'] as String,
      map['valor_p_s'] as String,
      map['quantidade_p_s'] as String,
      map['menor_valor'] as String,
      map['id_item'] as String,
      map['tipo_item'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source) as Map<String, dynamic>);
}
