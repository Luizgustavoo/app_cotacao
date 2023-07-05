import 'package:cotacao/constants/constants.dart';
import 'package:cotacao/repository/service.dart';
import 'package:cotacao/widgets/cotacao_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  Future<void> loadCotacoes(BuildContext context) {
    return Provider.of<Services>(context, listen: false)
        .loadCotacoes('aguardando_presidente')
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadCotacoes(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.cinza,
      body: _isLoading
          ? Column(
              children: [
                Center(
                  child: CircularProgressIndicator(
                    color: Constants.verde,
                  ),
                ),
              ],
            )
          : RefreshIndicator(
              onRefresh: () => loadCotacoes(context),
              child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Consumer<Services>(
                    builder: (context, services, _) {
                      final cotacao = services.items;
                      return services.itemsCount <= 0
                          ? SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: SizedBox(
                                height: MediaQuery.sizeOf(context).height / 1.5,
                                child: const Center(
                                  child: Text(
                                    'Nenhuma cotação para ser \naprovada no momento...',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: services.itemsCount,
                              itemBuilder: (ctx, i) {
                                if (cotacao[i].tCotacao == "P" &&
                                    int.parse(cotacao[i].qProdutos!) > 0) {
                                  return CotacaoTile(cotacao: cotacao[i]);
                                }
                                if (cotacao[i].tCotacao == "S" &&
                                    int.parse(cotacao[i].qServicos!) > 0) {
                                  return CotacaoTile(cotacao: cotacao[i]);
                                }
                                return const SizedBox();
                              },
                            );
                    },
                  )),
            ),
    );
  }
}
