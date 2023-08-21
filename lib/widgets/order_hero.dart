import 'package:cotacao/constants/constants.dart';
import 'package:cotacao/models/class_cotacao.dart';
import 'package:cotacao/models/class_item.dart';
import 'package:cotacao/pages/base_screen.dart';
import 'package:cotacao/repository/service.dart';
import 'package:cotacao/utils/utils_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class OrderHero extends StatefulWidget {
  final Cotacao cotacao;
  const OrderHero({
    super.key,
    required this.cotacao,
  });

  @override
  State<OrderHero> createState() => _OrderHeroState();
}

class _OrderHeroState extends State<OrderHero> {
  final UtilsServices utilsServices = UtilsServices();

  List<Item> itens = [];
  List<dynamic> selectedProduto = [];
  final obsController = TextEditingController();
  @override
  void initState() {
    for (var e in widget.cotacao.empresas) {
      for (var i in e.itens) {
        if (i.menorValor == 'sim') {
          setState(() {
            selectedProduto.add(i.idItem);
          });
        }
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor:
              widget.cotacao.statusCotacao == 'aguardando_presidente'
                  ? Constants.verde
                  : widget.cotacao.statusCotacao == 'aguardando_compra'
                      ? Colors.orange
                      : Colors.red,
          actions: [
            widget.cotacao.statusCotacao == 'aguardando_presidente'
                ? IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              title: const Text(
                                'APROVAR COTAÇÕES',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Deseja adicionar alguma observação?',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextField(
                                        keyboardType: TextInputType.text,
                                        controller: obsController,
                                        decoration: const InputDecoration(
                                          label: Text(
                                              'Adicione sua observação...'),
                                          isDense: true,
                                          border: OutlineInputBorder(),
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
                                    Get.back();
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
                                    if (selectedProduto.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Selecione pelo menos 1 produto...',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 3),
                                          padding: EdgeInsets.all(12),
                                        ),
                                      );
                                      return;
                                    }
                                    Get.offAll(() => const BaseScreen());

                                    Provider.of<Services>(context,
                                            listen: false)
                                        .aprovaCotacao(
                                            widget.cotacao.idCotacao.toString(),
                                            selectedProduto,
                                            obsController.text,
                                            widget.cotacao.tCotacao.toString())
                                        .then((value) {
                                      obsController.clear();
                                      Provider.of<Services>(context,
                                              listen: false)
                                          .loadCotacoes(
                                              'aguardando_presidente', '0');
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            value.toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          backgroundColor: Colors.green,
                                          duration: const Duration(seconds: 3),
                                          padding: const EdgeInsets.all(12),
                                        ),
                                      );
                                    });
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
                    },
                    icon: const Icon(
                      Icons.check_circle_outline_rounded,
                    ),
                    color: Colors.white,
                    iconSize: 30,
                  )
                : Container(),
          ],
          title: Text(
            "${widget.cotacao.tituloCotacao}",
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: SizedBox(
          child: Hero(
            tag: widget.cotacao.idCotacao.toString() +
                widget.cotacao.empresas.first.itens.first.tipoItem,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: widget.cotacao.empresas.length,
              itemBuilder: (ctx, i) {
                return Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 2,
                      child: ExpansionTile(
                        collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        leading: CircleAvatar(
                          backgroundColor: widget.cotacao.statusCotacao ==
                                  'aguardando_presidente'
                              ? Constants.verde
                              : widget.cotacao.statusCotacao ==
                                      'aguardando_compra'
                                  ? Colors.orange
                                  : Colors.red,
                          child: Text(
                            widget.cotacao.empresas[i].razaoSocial
                                .substring(0, 1),
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        collapsedBackgroundColor:
                            widget.cotacao.statusCotacao ==
                                    'aguardando_presidente'
                                ? Constants.verdeclaro
                                : widget.cotacao.statusCotacao ==
                                        'aguardando_compra'
                                    ? Colors.orange.shade100
                                    : Colors.red.shade100,
                        title: Text(
                          widget.cotacao.empresas[i].razaoSocial,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: Constants.verdeescuro,
                                ),
                                children: [
                                  const TextSpan(text: 'Valor total: '),
                                  TextSpan(
                                    text: utilsServices.priceToCurrency(
                                        double.parse(widget.cotacao.totalCotacao
                                            .toString())),
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        children: [
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              showCheckboxColumn:
                                  widget.cotacao.statusCotacao ==
                                          'aguardando_presidente'
                                      ? true
                                      : false,
                              onSelectAll: (isSelectedAll) {
                                // setState(() => selectedProduto =
                                //     isSelectedAll! ? itens : []);
                              },
                              dividerThickness: 1,
                              columns: const [
                                DataColumn(label: Text('ITEM')),
                                DataColumn(label: Text('QUANTIDADE')),
                                DataColumn(label: Text('VALOR')),
                              ],
                              rows: widget.cotacao.empresas[i].itens.map((e) {
                                return DataRow(
                                  selected: widget.cotacao.statusCotacao ==
                                          'aguardando_presidente'
                                      ? e.menorValor == 'sim'
                                          ? true
                                          : false
                                      : false,
                                  onSelectChanged: (isSelected) {
                                    setState(() {
                                      if (isSelected!) {
                                        selectedProduto.add(e.idItem);
                                      } else {
                                        selectedProduto.remove(e.idItem);
                                      }
                                      e.menorValor = isSelected ? 'sim' : 'nao';
                                    });
                                  },
                                  cells: [
                                    DataCell(Text(e.nomePs)),
                                    DataCell(Text(e.quantidadePs)),
                                    DataCell(Text(utilsServices.priceToCurrency(
                                        double.parse(e.valorPs)))),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    )
                  ],
                );
              },
            ),
          ),
        ));
  }
}
