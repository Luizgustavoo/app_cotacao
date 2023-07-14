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
  final loading = ValueNotifier(true);
  late final ScrollController _scrollController;
  Future<void> loadCotacoes(BuildContext context, int page) {
    loading.value = true;
    if (page != 0) {
      Provider.of<Services>(context, listen: false).pageCount = page;
    }
    return Provider.of<Services>(context, listen: false)
        .loadCotacoes('negado')
        .then((_) {
      if (mounted) {
        setState(() {
          loading.value = false;
        });
      }
    });
  }

  infiniteScrolling() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !loading.value) {
      loadCotacoes(context, 0);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(infiniteScrolling);
    Provider.of<Services>(context, listen: false).pageCount = 1;
    loadCotacoes(context, 1);
  }

  @override
  void dispose() {
    super.dispose();
    loading.value = false;
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading.value
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(
                    color: Colors.green.shade500,
                  ),
                ),
              ],
            )
          : RefreshIndicator(
              onRefresh: () => loadCotacoes(context, 1),
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
                            itemCount: cotacao.length,
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
