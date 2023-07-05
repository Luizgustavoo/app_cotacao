import 'dart:convert';

import 'package:cotacao/models/class_empresas.dart';

class Cotacao {
  final String? idCotacao;
  final String? dataCotacao;
  final String? idUsuario;
  final String? tituloCotacao;
  final String? comentariosCotacao;
  final String? statusCotacao;
  final String? idSolicitacaoCompra;
  final String? observacoes;
  final String? nomeUsuario;
  final String? totalCotacao;
  final String? qProdutos;
  final String? qServicos;
  final String? tCotacao;
  final List<Empresa> empresas;
  bool desabilitado;

  Cotacao(
      this.idCotacao,
      this.dataCotacao,
      this.idUsuario,
      this.tituloCotacao,
      this.comentariosCotacao,
      this.statusCotacao,
      this.idSolicitacaoCompra,
      this.observacoes,
      this.nomeUsuario,
      this.totalCotacao,
      this.qProdutos,
      this.qServicos,
      this.tCotacao,
      this.desabilitado,
      this.empresas);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id_cotacao': idCotacao,
      'data_cotacao': dataCotacao,
      'id_usuario': idUsuario,
      'titulo_cotacao': tituloCotacao,
      'comentarios_cotacao': comentariosCotacao,
      'status_cotacao': statusCotacao,
      'id_solicitacao_compra': idSolicitacaoCompra,
      'observacoes': observacoes,
      'nome_usuario': nomeUsuario,
      'total_cotacao': totalCotacao,
      'q_produtos': qProdutos,
      'q_servicos': qServicos,
      't_cotacao': tCotacao,
      'desabilitado': desabilitado,
      'empresas': empresas.map((x) => x.toMap()).toList(),
    };
  }

  factory Cotacao.fromMap(Map<String, dynamic> map) {
    return Cotacao(
        map['id_cotacao'] != null ? map['id_cotacao'] as String : null,
        map['data_cotacao'] != null ? map['data_cotacao'] as String : null,
        map['id_usuario'] != null ? map['id_usuario'] as String : null,
        map['titulo_cotacao'] != null ? map['titulo_cotacao'] as String : null,
        map['comentarios_cotacao'] != null
            ? map['comentarios_cotacao'] as String
            : null,
        map['status_cotacao'] != null ? map['status_cotacao'] as String : null,
        map['id_solicitacao_compra'] != null
            ? map['id_solicitacao_compra'] as String
            : null,
        map['observacoes'] != null ? map['observacoes'] as String : null,
        map['nome_usuario'] != null ? map['nome_usuario'] as String : null,
        map['total_cotacao'] != null ? map['total_cotacao'] as String : null,
        map['q_produtos'] != null ? map['q_produtos'] as String : null,
        map['q_servicos'] != null ? map['q_servicos'] as String : null,
        map['t_cotacao'] != null ? map['t_cotacao'] as String : null,
        map['desabilitado'] ?? false,
        List<Empresa>.from(
          List<Empresa>.from(
              map['empresas']?.map((x) => Empresa.fromMap(x)) ?? const []),
        ));
  }

  String toJson() => json.encode(toMap());

  factory Cotacao.fromJson(String source) =>
      Cotacao.fromMap(json.decode(source) as Map<String, dynamic>);
}
