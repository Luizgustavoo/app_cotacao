import 'package:cotacao/repository/service.dart';
import 'package:cotacao/widgets/cotacao_tile.dart';
import 'package:cotacao/widgets/search_widget.dart';

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
  final loading = ValueNotifier(true);
  late final ScrollController _scrollController;
  final TextEditingController _controller = TextEditingController();
  String searchQuery = '';
  double loadThresholdPercentage = 0.99;

  Future<void> loadCotacoes(BuildContext context, int page, String filtro) {
    loading.value = true;
    if (page != 0) {
      Provider.of<Services>(context, listen: false).pageCount = page;
    }
    return Provider.of<Services>(context, listen: false)
        .loadCotacoes('aguardando_compra', filtro)
        .then((_) {
      if (mounted) {
        setState(() {
          loading.value = false;
        });
      }
    });
  }

  void infiniteScrolling() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;
    double scrollPercentage = currentScroll / maxScroll;
    if (scrollPercentage > loadThresholdPercentage) {
      var filtro = _controller.text.isNotEmpty ? _controller.text : '0';
      loadCotacoes(context, 0, filtro);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(infiniteScrolling);
    Provider.of<Services>(context, listen: false).pageCount = 1;
    loadCotacoes(context, 1, '0');
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
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.green.shade500,
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                _controller.text = '';
                await loadCotacoes(context, 1, '0');
              },
              child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    children: [
                      SearchTextField(
                          controller: _controller,
                          onSearchPressed: (context, page, query) {
                            if (_controller.text.isNotEmpty) {
                              loadCotacoes(context, 1, _controller.text.trim());
                            } else {
                              FocusScope.of(context).unfocus();
                            }
                          }),
                      Expanded(
                        child: Consumer<Services>(
                          builder: (context, services, _) {
                            final cotacao = services.listModel;
                            return services.itemsCount <= 0
                                ? SingleChildScrollView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).height /
                                              1.5,
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
                                : Stack(
                                    children: [
                                      ListView.builder(
                                        controller: _scrollController,
                                        itemCount: cotacao.length,
                                        itemBuilder: (ctx, i) {
                                          return CotacaoTile(
                                            cotacao: cotacao[i],
                                          );
                                        },
                                      ),
                                      loadingIndicatorWidget()
                                    ],
                                  );
                          },
                        ),
                      ),
                    ],
                  )),
            ),
    );
  }

  loadingIndicatorWidget() {
    return ValueListenableBuilder(
        valueListenable: loading,
        builder: (context, bool isLoading, _) {
          return (isLoading)
              ? Positioned(
                  left: (MediaQuery.of(context).size.width / 2) - 20,
                  bottom: 80,
                  child: const CircleAvatar(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ))
              : Container();
        });
  }
}
