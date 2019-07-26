import 'package:coffee_app/business/bloc/products/product_bloc.dart';
import 'package:coffee_app/business/model/product.dart';
import 'package:coffee_app/business/model/store.dart';
import 'package:coffee_app/main.dart';
import 'package:coffee_app/widgets/general_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:transparent_image/transparent_image.dart';

class StoreProductsPage extends StatefulWidget {
  final Store store;

  StoreProductsPage({Key key, this.store}) : super(key: key);

  _StoreProductsPageState createState() => _StoreProductsPageState();
}

class _StoreProductsPageState extends State<StoreProductsPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ProductBloc _productBloc;

  Future<void> _addProductToCart(Product p) async {
    print('Add product ${p.name} to cart');
  }

  @override
  void initState() {
    super.initState();
    //
    _productBloc = coffeeGetIt<ProductBloc>();
    _productBloc.listByStore(widget.store.id);
    _tabController = TabController(
      vsync: this,
      length: widget.store.categories.length,
      initialIndex: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.store.name),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            ...widget.store.categories
                .map((c) => Tab(text: c.name.toUpperCase())),
          ],
        ),
      ),
      body: Container(
        child: _buildProducts(),
      ),
    );
  }

  Widget _buildProducts() {
    final theme = Theme.of(context);
    //
    return StreamBuilder<Iterable<Product>>(
      stream: _productBloc.byStore,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: GeneralErrorDialog(),
          );
        }
        if (snapshot.hasData) {
          final byStore = snapshot.data;
          return TabBarView(
            controller: _tabController,
            children: <Widget>[
              ...widget.store.categories.map((c) {
                final categoryProducts =
                    byStore.where((p) => p.categoryId == c.id);
                // TODO Handle the case of categories with no products
                return ListView.builder(
                  itemCount: categoryProducts.length,
                  itemBuilder: (context, index) {
                    final product = categoryProducts.elementAt(index);
                    return Card(
                      clipBehavior: Clip.hardEdge,
                      margin: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 4 / 2,
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: product.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      product.name,
                                      style: theme.textTheme.subtitle,
                                    ),
                                    Text('${product.price.toStringAsFixed(2)}'),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  product.description,
                                  style: theme.textTheme.caption,
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Icon(Icons.favorite_border),
                                    RaisedButton(
                                      child: Text(
                                        FlutterI18n.translate(context, 'actions.addToCart').toUpperCase(),
                                      ),
                                      color: theme.primaryColor,
                                      onPressed: () => _addProductToCart(product),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
              //   child: ListView.builder(
              //     itemCount: byStore.length,
              //     itemBuilder: (context, index) {
              //       final product = byStore.elementAt(index);
              //       return ListTile(
              //         title: Text(product.name),
              //       );
              //     },
              //   ),
            ],
          );
        }
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: theme.primaryColor,
          ),
        );
      },
    );
  }
}
