import 'package:coffee_app/business/model/product.dart';
import 'package:rxdart/rxdart.dart';
import 'package:coffee_app/business/bloc/cart/cart_bloc.dart';
import 'package:coffee_app/business/bloc/products/product_bloc.dart';
import 'package:coffee_app/business/bloc/store/store_bloc.dart';
import 'package:coffee_app/business/bloc/user/user_bloc.dart';
import 'package:coffee_app/business/model/cart.dart';
import 'package:coffee_app/business/model/cart_delivery.dart';
import 'package:coffee_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:transparent_image/transparent_image.dart';

class CartPage extends StatefulWidget {
  CartPage({Key key}) : super(key: key);

  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  StoreBloc _storeBloc;
  CartBloc _cartBloc;
  ProductBloc _productBloc;
  UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    //
    _storeBloc = coffeeGetIt<StoreBloc>();
    _cartBloc = coffeeGetIt<CartBloc>();
    _productBloc = coffeeGetIt<ProductBloc>();
    _userBloc = coffeeGetIt<UserBloc>();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, 'cart.title')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          _buildTotalPrice(context, theme),
          SizedBox(height: 12),
          _buildDeliveryAddress(context, theme),
          SizedBox(height: 12),
          _buildDeliveryTime(context, theme),
          SizedBox(height: 12),
          _buildCartItems(context, theme),
        ],
      ),
    );
  }

  Widget _buildTotalPrice(BuildContext context, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.monetization_on),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(FlutterI18n.translate(context, 'cart.total')),
            Text(
              'R\$ 12.00',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: theme.textTheme.title,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildDeliveryAddress(BuildContext context, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.location_on),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(FlutterI18n.translate(context, 'cart.deliveryAddress')),
            Text(
              'Alameda Barão de Limeira, 539',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: theme.textTheme.title,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildDeliveryTime(BuildContext context, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.access_time),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(FlutterI18n.translate(context, 'cart.scheduleDelivery')),
            StreamBuilder<Cart>(
              stream: _cartBloc.cart,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final cart = snapshot.data;
                  final cartDelivery = cart.deliveryDate == null
                      ? CartDelivery.now
                      : CartDelivery.schedule;
                  //
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: CartDelivery.now,
                        groupValue: cartDelivery,
                        activeColor: theme.primaryColor,
                        onChanged: (value) =>
                            _cartBloc.setScheduleDelivery(value),
                      ),
                      Text(FlutterI18n.translate(context, 'names.now')),
                      SizedBox(width: 16),
                      Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: CartDelivery.schedule,
                        groupValue: cartDelivery,
                        activeColor: theme.primaryColor,
                        onChanged: (value) =>
                            _cartBloc.setScheduleDelivery(value),
                      ),
                      Text(FlutterI18n.translate(context, 'actions.schedule')),
                    ],
                  );
                }
                return SizedBox.shrink();
              },
            )
          ],
        )
      ],
    );
  }

  Widget _buildCartItems(BuildContext context, ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.format_list_numbered),
            SizedBox(width: 12),
            Text(FlutterI18n.translate(context, 'cart.items')),
          ],
        ),
        SizedBox(height: 8),
        StreamBuilder<Cart>(
          stream: _cartBloc.cart,
          builder: (context, snapshotCart) {
            if (snapshotCart.hasData) {
              final cart = snapshotCart.data;
              return StreamBuilder<Iterable<Product>>(
                stream: _productBloc.byStore,
                builder: (context, snapshotProducts) {
                  if (snapshotProducts.hasData) {
                    final products = snapshotProducts.data;
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        final item = cart.items.elementAt(index);
                        final product = products.firstWhere(
                            (product) => product.id == item.productId);
                        return Card(
                          key: Key(product.id.toString()),
                          clipBehavior: Clip.hardEdge,
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                color: theme.primaryColor,
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      width: 64,
                                      height: 64,
                                      child: Material(
                                        shape: CircleBorder(),
                                        clipBehavior: Clip.hardEdge,
                                        child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: product.imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            product.name,
                                            style: theme.textTheme.subtitle,
                                          ),
                                          Text(
                                            product.description,
                                            style: theme.textTheme.caption,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    IconButton(
                                      icon: Icon(Icons.cancel),
                                      onPressed: () =>
                                          _cartBloc.removeProduct(product.id),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: <Widget>[],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return SizedBox.shrink();
                },
              );
            }
            return SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
