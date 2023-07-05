import 'package:cotacao/repository/service.dart';
import 'package:cotacao/widgets/cotacao_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecuseOrderPage extends StatefulWidget {
  const RecuseOrderPage({super.key});

  @override
  State<RecuseOrderPage> createState() => _RecuseOrderPageState();
}

class _RecuseOrderPageState extends State<RecuseOrderPage> {
  bool _isLoading = true;
  Future<void> loadCotacoes(BuildContext context) {
    return Provider.of<Services>(context, listen: false)
        .loadCotacoes('negado')
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
      body: _isLoading
          ? Column(
              children: [
                Center(
                  child: CircularProgressIndicator(
                    color: Colors.green.shade500,
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
                                  'Nenhuma cotação recusada no momento...',
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
                            itemCount: 50,
                            itemBuilder: (ctx, i) {
                              return CotacaoTile(
                                cotacao: cotacao[i],
                              );
                            },
                          );
                  },
                ),
              ),
            ),
    );
  }
}
