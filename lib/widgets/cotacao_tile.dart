import 'package:cotacao/constants/constants.dart';
import 'package:cotacao/models/class_cotacao.dart';
import 'package:cotacao/repository/service.dart';
import 'package:cotacao/utils/utils_services.dart';
import 'package:cotacao/widgets/order_hero.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CotacaoTile extends StatefulWidget {
  final Cotacao cotacao;

  const CotacaoTile({
    super.key,
    required this.cotacao,
  });

  @override
  State<CotacaoTile> createState() => _CotacaoTileState();
}

class _CotacaoTileState extends State<CotacaoTile> {
  bool isDismissibleEnabled = false;
  final motivoController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void validateAndRecuse() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      Provider.of<Services>(context, listen: false)
          .negarCotacao(
              widget.cotacao.idCotacao.toString(),
              widget.cotacao.empresas.first.itens.first.tipoItem.toString(),
              motivoController.text)
          .then((value) {
        motivoController.clear();
        Provider.of<Services>(context, listen: false)
            .loadCotacoes('aguardando_presidente');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Cotação nº ${widget.cotacao.idCotacao} negada com sucesso!",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            padding: const EdgeInsets.all(12),
          ),
        );
      });
      Get.back();
    }
  }

  @override
  void dispose() {
    motivoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UtilsServices utilsServices = UtilsServices();
    // final posicaoIfen = widget.cotacao.tituloCotacao.toString().indexOf('-');
    // final titulo = widget.cotacao.tituloCotacao!.substring(0, posicaoIfen);
    final titulo = widget.cotacao.tituloCotacao!;
    final height = MediaQuery.sizeOf(context).height;
    return InkWell(
      onTap: widget.cotacao.statusCotacao == 'negado'
          ? null
          : () {
              Get.to(() => OrderHero(cotacao: widget.cotacao));
            },
      splashColor: Colors.transparent,
      child: Hero(
          tag: widget.cotacao.idCotacao.toString() +
              widget.cotacao.empresas.first.itens.first.tipoItem,
          child: Card(
            color: widget.cotacao.statusCotacao == 'aguardando_presidente'
                ? Constants.verdeclaro
                : widget.cotacao.statusCotacao == 'aguardando_compra'
                    ? Colors.orange.shade100
                    : Colors.red.shade100,
            elevation: 3,
            child: Dismissible(
              key: UniqueKey(), // Uma chave única para o item
              direction: widget.cotacao.statusCotacao == 'negado' ||
                      widget.cotacao.statusCotacao == 'aguardando_compra'
                  ? DismissDirection.none
                  : DismissDirection
                      .startToEnd, // A direção do arrasto (horizontal neste caso)
              onDismissed: (direction) {
                if (direction == DismissDirection.startToEnd) {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          title: const Text(
                            'RECUSAR COTAÇÕES',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: SizedBox(
                              height: height * 0.20,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'É OBRIGATÓRIO ADICIONAR UM MOTIVO PARA RECUSAR A COTAÇÃO!',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.red,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      autofocus: true,
                                      keyboardType: TextInputType.text,
                                      controller: motivoController,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        label: Text('Descreva o motivo...'),
                                        isDense: true,
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Descreva um motivo para cancelar\n a cotação!';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              )),
                          actions: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  Provider.of<Services>(context, listen: false)
                                      .loadCotacoes('aguardando_presidente');
                                  Get.back();
                                });
                              },
                              child: const Text(
                                'CANCELAR',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: () {
                                direction == DismissDirection.none;
                                validateAndRecuse();
                              },
                              child: const Text(
                                'CONFIRMAR',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      });
                }
              },
              background: Container(
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(10)),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(
                    left: 16.0), // Cor do fundo para negar
                child: const Icon(Icons.thumb_down, color: Colors.white),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  trailing: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                  "OBSERVAÇÕES:",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: SizedBox(
                                  height: height / 20,
                                  width: double.infinity,
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Center(
                                      child: widget.cotacao.observacoes == null
                                          ? const Text(
                                              'NÃO HÁ OBSERVAÇÕES PARA ESSA COTAÇÃO',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Montserrat',
                                              ),
                                              textAlign: TextAlign.justify,
                                            )
                                          : Text(
                                              "Observações: ${widget.cotacao.observacoes}"
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Montserrat',
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('Fechar'))
                                ],
                              );
                            });
                      },
                      icon: Icon(
                        Icons.info_rounded,
                        size: 30,
                        color: Colors.blue.shade500,
                      )),
                  leading: CircleAvatar(
                    backgroundColor: widget.cotacao.statusCotacao ==
                            'aguardando_presidente'
                        ? Constants.verde
                        : widget.cotacao.statusCotacao == 'aguardando_compra'
                            ? Colors.orange.shade400
                            : Colors.red.shade400,
                    child: Text(
                      widget.cotacao.empresas.first.itens.first.tipoItem,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "[${widget.cotacao.idCotacao.toString()}] - $titulo",
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Responsável: ${widget.cotacao.nomeUsuario}",
                        style: TextStyle(
                          color: Constants.verdeescuro,
                          fontFamily: 'Poppins',
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Data Cotação: ${utilsServices.formatDateTime(DateTime.parse(widget.cotacao.dataCotacao.toString()))}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
