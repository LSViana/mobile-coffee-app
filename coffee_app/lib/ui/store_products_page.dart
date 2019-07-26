import 'package:coffee_app/business/bloc/cart/cart_bloc.dart';
import 'package:coffee_app/business/bloc/products/product_bloc.dart';
import 'package:coffee_app/business/model/cart.dart';
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
  CartBloc _cartBloc;

  void _addProductToCart(Product p) {
    _cartBloc.addProduct(p.id);
  }

  void _removeProductFromCart(Product p) {
    _cartBloc.removeProduct(p.id);
  }

  Future<void> _openCheckout() async {
    print('Open checkout');
  }

  @override
  void initState() {
    super.initState();
    //
    _cartBloc = coffeeGetIt<CartBloc>();
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
    final theme = Theme.of(context);
    return StreamBuilder<Cart>(
        stream: _cartBloc.cart,
        builder: (context, snapshot) {
          final cart = snapshot.data;
          //
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
            floatingActionButton: cart?.items?.isEmpty ?? true
                ? null
                : FloatingActionButton.extended(
                    onPressed: _openCheckout,
                    label: Text(
                        FlutterI18n.translate(context, 'actions.checkout')
                            .toUpperCase()),
                    icon: Icon(Icons.shopping_cart),
                    backgroundColor: theme.primaryColor,
                  ),
            body: Container(
              child: _buildProducts(theme),
            ),
          );
        });
  }

  Widget _buildProducts(ThemeData theme) {
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
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        product.name,
                                        style: theme.textTheme.subtitle,
                                      ),
                                      Text(
                                          '${product.price.toStringAsFixed(2)}'),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(
                                    product.description,
                                    style: theme.textTheme.caption,
                                  ),
                                ),
                                StreamBuilder<Cart>(
                                  stream: _cartBloc.cart,
                                  builder: (context, snapshot) {
                                    final item = _cartBloc.getItem(product.id);
                                    final isInCart = item != null;
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                            child: Icon(Icons.favorite_border),
                                            padding: const EdgeInsets.all(16).copyWith(top: 0)),
                                        Expanded(
                                          child: AnimatedCrossFade(
                                            firstCurve: Curves.easeInOut,
                                            secondCurve: Curves.easeInOut,
                                            sizeCurve: Curves.easeInOut,
                                            duration:
                                                Duration(milliseconds: 300),
                                            crossFadeState: isInCart
                                                ? CrossFadeState.showFirst
                                                : CrossFadeState.showSecond,
                                            firstChild: Container(
                                              alignment: Alignment.centerRight,
                                              padding: const EdgeInsets.all(16).copyWith(top: 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  if (isInCart) ...[
                                                    Icon(Icons.check),
                                                    Text(
                                                        '${FlutterI18n.translate(context, 'products.added')} ${item.amount}'),
                                                  ],
                                                  SizedBox(width: 8),
                                                  RawMaterialButton(
                                                    child: Text(
                                                      '+1',
                                                      style: TextStyle(
                                                          color: theme
                                                              .primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    shape: CircleBorder(),
                                                    constraints: BoxConstraints(
                                                        minWidth: 32),
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    onPressed: () =>
                                                        _addProductToCart(
                                                            product),
                                                  ),
                                                  SizedBox(width: 8),
                                                  FlatButton(
                                                    child: Text(
                                                      FlutterI18n.translate(
                                                              context,
                                                              'actions.remove')
                                                          .toUpperCase(),
                                                    ),
                                                    textColor:
                                                        theme.primaryColor,
                                                    onPressed: () =>
                                                        _removeProductFromCart(
                                                            product),
                                                  )
                                                ],
                                              ),
                                            ),
                                            secondChild: Container(
                                              alignment: Alignment.centerRight,
                                              padding:
                                                  const EdgeInsets.all(16).copyWith(top: 0),
                                              child: RaisedButton(
                                                child: Text(
                                                  FlutterI18n.translate(context,
                                                          'actions.addToCart')
                                                      .toUpperCase(),
                                                ),
                                                color: theme.primaryColor,
                                                onPressed: () =>
                                                    _addProductToCart(product),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
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
