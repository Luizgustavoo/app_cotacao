import 'package:cotacao/repository/service.dart';
import 'package:cotacao/widgets/cotacao_tile.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({
    super.key,
  });

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool _isLoading = true;
  Future<void> loadCotacoes(BuildContext context) {
    return Provider.of<Services>(context, listen: false)
        .loadCotacoes('aguardando_compra')
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
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.green.shade500,
              ),
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
                                    'Nenhuma cotação aprovada no momento...',
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
                  )),
            ),
    );
  }
}
