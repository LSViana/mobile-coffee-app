import 'package:coffee_app/business/bloc/cart/request_bloc.dart';
import 'package:coffee_app/business/model/request.dart';
import 'package:coffee_app/business/model/request_status.dart';
import 'package:coffee_app/definitions/text_formatter.dart';
import 'package:coffee_app/main.dart';
import 'package:coffee_app/widgets/coffee_drawer.dart';
import 'package:coffee_app/widgets/general_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:intl/intl.dart';

class OrdersPage extends StatefulWidget {
  OrdersPage({Key key}) : super(key: key);

  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  RequestBloc _requestBloc;

  @override
  void initState() {
    super.initState();
    //
    _requestBloc = coffeeGetIt<RequestBloc>();
    _requestBloc.getMine();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //
    return Scaffold(
      appBar: AppBar(
        title: Text(
          FlutterI18n.translate(context, 'orders.title'),
        ),
      ),
      drawer: CoffeeDrawer(pageIndex: 1),
      body: StreamBuilder<Iterable<Request>>(
          stream: _requestBloc.mine,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final requests = snapshot.data;
              return _buildRequests(requests, theme);
            }
            if (snapshot.hasError) {
              return GeneralErrorDialog();
            }
            return Container(
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: theme.primaryColor,
                ),
              ),
            );
          }),
    );
  }
}

Widget _buildRequests(Iterable<Request> requests, ThemeData theme) {
  return ListView.builder(
    itemCount: requests.length,
    itemBuilder: (context, index) {
      final request = requests.elementAt(index);
      final dateFormat = DateFormat('yyyy/MM/dd, HH:mm:ss');
      //
      return ExpansionTile(
        key: Key(request.id),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(request.store.name),
            Row(
              children: <Widget>[
                Text(writeRequestStatus(context, request.status),
                    style: theme.textTheme.caption),
                Text(', ', style: theme.textTheme.caption),
                Expanded(
                  child: Text(
                    dateFormat.format(request.createdAt),
                    style: theme.textTheme.caption,
                  ),
                ),
              ],
            ),
          ],
        ),
        children: <Widget>[
          Card(
            margin:
                const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          FlutterI18n.translate(context, 'cart.items'),
                          style: theme.textTheme.subtitle
                              .copyWith(color: theme.primaryColor),
                        ),
                        ...request.items.map((item) {
                          return Row(
                            key: Key(item.id),
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text('${item.amount} x ${item.product.name}'),
                              Spacer(),
                              Text(
                                request.items.elementAt(0).product.priceUnit,
                                style: theme.textTheme.caption.copyWith(fontSize: 10),
                              ),
                              SizedBox(width: 2),
                              Text('${item.amount * item.price}'),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                  Divider(height: 4),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          FlutterI18n.translate(context, 'cart.total'),
                          style: theme.textTheme.subtitle
                              .copyWith(color: theme.primaryColor),
                        ),
                        Spacer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              request.items.elementAt(0).product.priceUnit,
                              style: theme.textTheme.caption.copyWith(fontSize: 16),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${request.items.map((p) => p.price * p.amount).fold(0.0, (previous, current) => previous + current)}',
                              style: theme.textTheme.title,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      );
    },
  );
}
