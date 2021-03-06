import 'package:coffee_app/business/model/product.dart';
import 'package:coffee_app/business/bloc/cart/request_bloc.dart';
import 'package:coffee_app/business/bloc/products/product_bloc.dart';
import 'package:coffee_app/business/bloc/user/user_bloc.dart';
import 'package:coffee_app/business/model/cart.dart';
import 'package:coffee_app/main.dart';
import 'package:coffee_app/ui/request_success_page.dart';
import 'package:coffee_app/widgets/general_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:transparent_image/transparent_image.dart';

class CartPage extends StatefulWidget {
  CartPage({Key key}) : super(key: key);

  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  TextEditingController _deliveryAddressController;
  bool _sendingRequest;
  //
  RequestBloc _requestBloc;
  ProductBloc _productBloc;
  UserBloc _userBloc;

  Future<void> _sendRequest() async {
    try {
      setState(() {
        _sendingRequest = true;
      });
      await _requestBloc.send();
      _requestBloc.restore();
      await Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => RequestSuccessPage(),
      ));
    } catch (e) {
      // Handle error in sending request
      await showDialog(
        context: context,
        builder: (context) => GeneralErrorDialog(),
      );
      // Just show the button again if there's any error, in the success case this page won't be shown anymore
      setState(() {
        _sendingRequest = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //
    _requestBloc = coffeeGetIt<RequestBloc>();
    _productBloc = coffeeGetIt<ProductBloc>();
    _userBloc = coffeeGetIt<UserBloc>();
    //
    _sendingRequest = false;
    _deliveryAddressController = TextEditingController(
        text: _requestBloc.getCurrentDeliveryAddress(
            orElse: _userBloc.getCurrentDeliveryAddress()));
    _startEventHandlers();
  }

  void _startEventHandlers() {
    _requestBloc.updateDeliveryAddress(_deliveryAddressController.text);
    _deliveryAddressController.addListener(() {
      _requestBloc.updateDeliveryAddress(_deliveryAddressController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //
    return StreamBuilder<Cart>(
        stream: _requestBloc.cart,
        builder: (context, snapshot) {
          final cart = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text(FlutterI18n.translate(context, 'cart.title')),
            ),
            floatingActionButton: _sendingRequest
                ? null
                : FloatingActionButton.extended(
                    icon: Icon(Icons.send),
                    label: Text(FlutterI18n.translate(context, 'actions.send')
                        .toUpperCase()),
                    onPressed: snapshot.hasData ? _sendRequest : null,
                    backgroundColor: theme.primaryColor,
                  ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                _buildTotalPrice(context, theme, cart),
                SizedBox(height: 12),
                _buildDeliveryAddress(context, theme, cart),
                // SizedBox(height: 12),
                // _buildDeliveryTime(context, theme, cart),
                SizedBox(height: 12),
                _buildCartItems(context, theme, cart),
              ],
            ),
          );
        });
  }

  Widget _buildTotalPrice(BuildContext context, ThemeData theme, Cart cart) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.monetization_on,
          color: theme.primaryColor,
        ),
        SizedBox(width: 12),
        StreamBuilder<Iterable<Product>>(
            stream: _productBloc.byStore,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final products = snapshot.data;
                //
                final totalPrice = cart.items.map((i) {
                  final product =
                      products.firstWhere((p) => p.id == i.productId);
                  return i.amount * product.price;
                }).fold<double>(0.0, (previous, current) => previous + current);
                //
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(FlutterI18n.translate(context, 'cart.total')),
                    Text(
                      '${products.elementAt(0).priceUnit} ${totalPrice.toStringAsFixed(2)}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: theme.textTheme.title,
                    ),
                  ],
                );
              }
              return SizedBox.shrink();
            })
      ],
    );
  }

  Widget _buildDeliveryAddress(
      BuildContext context, ThemeData theme, Cart cart) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.location_on,
          color: theme.primaryColor,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(FlutterI18n.translate(context, 'cart.deliveryAddress')),
              TextFormField(
                controller: _deliveryAddressController,
              ),
            ],
          ),
        )
      ],
    );
  }

  // This widget may be recovered later
  // Widget _buildDeliveryTime(BuildContext context, ThemeData theme, Cart cart) {
  //   final cartDelivery =
  //       cart?.deliveryDate == null ? CartDelivery.now : CartDelivery.schedule;
  //   //
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: <Widget>[
  //       Icon(Icons.access_time),
  //       SizedBox(width: 12),
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           Text(FlutterI18n.translate(context, 'cart.scheduleDelivery')),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: <Widget>[
  //               Radio(
  //                 materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //                 value: CartDelivery.now,
  //                 groupValue: cartDelivery,
  //                 activeColor: theme.primaryColor,
  //                 onChanged: (value) => _cartBloc.setScheduleDelivery(value),
  //               ),
  //               Text(FlutterI18n.translate(context, 'names.now')),
  //               SizedBox(width: 16),
  //               Radio(
  //                 materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //                 value: CartDelivery.schedule,
  //                 groupValue: cartDelivery,
  //                 activeColor: theme.primaryColor,
  //                 // TODO Open date picker
  //                 onChanged: (value) => _cartBloc.setScheduleDelivery(value),
  //               ),
  //               Text(FlutterI18n.translate(context, 'actions.schedule')),
  //             ],
  //           ),
  //         ],
  //       )
  //     ],
  //   );
  // }

  Widget _buildCartItems(BuildContext context, ThemeData theme, Cart cart) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.format_list_numbered,
              color: theme.primaryColor,
            ),
            SizedBox(width: 12),
            Text(FlutterI18n.translate(context, 'cart.items')),
          ],
        ),
        SizedBox(height: 8),
        StreamBuilder<Iterable<Product>>(
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
                    final product = products
                        .firstWhere((product) => product.id == item.productId);
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
                                  onPressed: () {
                                    _requestBloc.removeProduct(product.id);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.keyboard_arrow_up),
                                        color: theme.primaryColor,
                                        onPressed: () =>
                                            _requestBloc.updateProductAmount(
                                                product.id, item.amount + 1),
                                      ),
                                      Text(item.amount.toString()),
                                      IconButton(
                                        icon: Icon(Icons.keyboard_arrow_down),
                                        color: theme.primaryColor,
                                        onPressed: item.amount < 2
                                            ? null
                                            : () =>
                                                _requestBloc.updateProductAmount(
                                                    product.id,
                                                    item.amount - 1),
                                      )
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  width: 80,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        '${product.priceUnit}',
                                        style: theme.textTheme.caption,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                          '${(item.amount * product.price).toStringAsFixed(2)}',
                                          style: theme.textTheme.title.copyWith(
                                              color: theme.primaryColor))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              }
              return SizedBox.shrink();
            }),
        SizedBox(height: 56),
      ],
    );
  }
}
