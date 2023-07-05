// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Usuario {
  final String? idUsuario;
  final String? loginUsuario;
  final String? senhaUsuario;
  final String? token;
  Usuario(
    this.idUsuario,
    this.loginUsuario,
    this.senhaUsuario,
    this.token,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idUsuario': idUsuario,
      'loginUsuario': loginUsuario,
      'senhaUsuario': senhaUsuario,
      'token': token,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      map['idUsuario'] != null ? map['idUsuario'] as String : null,
      map['loginUsuario'] != null ? map['loginUsuario'] as String : null,
      map['senhaUsuario'] != null ? map['senhaUsuario'] as String : null,
      map['token'] != null ? map['token'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Usuario.fromJson(String source) =>
      Usuario.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Usuario(idUsuario: $idUsuario, loginUsuario: $loginUsuario, senhaUsuario: $senhaUsuario, token: $token)';
  }
}
