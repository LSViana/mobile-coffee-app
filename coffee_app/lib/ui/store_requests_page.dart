import 'package:coffee_app/business/bloc/cart/request_bloc.dart';
import 'package:coffee_app/business/model/request.dart';
import 'package:coffee_app/business/model/request_status.dart';
import 'package:coffee_app/definitions/text_formatter.dart';
import 'package:coffee_app/main.dart';
import 'package:coffee_app/widgets/general_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:transparent_image/transparent_image.dart';

class StoreRequestsPage extends StatefulWidget {
  final String storeId;

  StoreRequestsPage(this.storeId, {Key key}) : super(key: key);

  _StoreRequestsPageState createState() => _StoreRequestsPageState();
}

class _StoreRequestsPageState extends State<StoreRequestsPage> {
  bool updatingStatus;
  //
  RequestBloc _requestBloc;

  Future<void> _showUpdateStatusDialog(Request request) async {
    final statusChanged = await showDialog(
          context: context,
          builder: (context) => new RequestDetailsDialog(request: request),
        ) ??
        false;
    if (statusChanged) {
      setState(() {
        updatingStatus = true;
      });
      //
      try {
        await _requestBloc.updateStatus(request);
      } catch(e) {
        // TODO Handle this error specifically
        await showDialog(
          context: context,
          builder: (context) => GeneralErrorDialog()
        );
      }
      //
      setState(() {
        updatingStatus = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //
    updatingStatus = false;
    //
    _requestBloc = coffeeGetIt<RequestBloc>();
    _requestBloc.getByStore(widget.storeId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, 'stores.requests')),
      ),
      body: StreamBuilder<Iterable<Request>>(
          stream: _requestBloc.byStore,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return GeneralErrorDialog();
            }
            if (snapshot.hasData) {
              final requests = snapshot.data;
              return _buildRequests(requests, theme);
            }
            return Container(
              child: Center(
                child: CircularProgressIndicator(
                    backgroundColor: theme.primaryColor),
              ),
            );
          }),
    );
  }

  Widget _buildRequests(Iterable<Request> requests, ThemeData theme) {
    if (requests.length == 0) {
      return Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.close),
            SizedBox(width: 8),
            Text(
              FlutterI18n.translate(context, 'names.empty'),
            )
          ],
        ),
      );
    }
    //
    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests.elementAt(index);
        return ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(4),
            width: 54,
            height: 54,
            child: Material(
              elevation: 2,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image:
                    'https://thoughtcatalog.files.wordpress.com/2015/03/shutterstock_221306548.jpg?w=786&h=523',
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 300),
              ),
            ),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(request.user.name),
              Text(
                '${writeRequestStatus(context, request.status)}, ${request.items.length} ${FlutterI18n.translate(context, request.items.length == 1 ? "cart.item" : "cart.items")}',
                style: theme.textTheme.caption,
              )
            ],
          ),
          children: <Widget>[
            _buildRequestDetails(context, theme, request),
          ],
        );
      },
    );
  }

  Widget _buildRequestDetails(
      BuildContext context, ThemeData theme, Request request) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    FlutterI18n.translate(context, 'cart.items'),
                    style: theme.textTheme.subtitle
                        .copyWith(color: theme.primaryColor),
                  ),
                  ...request.items.map((item) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 48,
                            height: 48,
                            child: Material(
                              elevation: 2,
                              shape: CircleBorder(),
                              clipBehavior: Clip.hardEdge,
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: item.product.imageUrl,
                                fit: BoxFit.cover,
                                fadeInDuration: Duration(milliseconds: 300),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                              child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('${item.amount} x ${item.product.name}'),
                              Spacer(),
                              Row(
                                children: <Widget>[
                                  Text(
                                    request.items
                                        .elementAt(0)
                                        .product
                                        .priceUnit,
                                    style: theme.textTheme.caption
                                        .copyWith(fontSize: 12),
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                      '${(item.amount * item.price).toStringAsFixed(2)}',
                                      style: theme.textTheme.body1
                                          .copyWith(fontSize: 14)),
                                ],
                              )
                            ],
                          ))
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            Divider(height: 2),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    FlutterI18n.translate(context, 'cart.deliveryAddress'),
                    style: theme.textTheme.subtitle
                        .copyWith(color: theme.primaryColor),
                  ),
                  SizedBox(height: 4),
                  Text(
                    request.deliveryAddress,
                    style: theme.textTheme.title,
                  ),
                ],
              ),
            ),
            Divider(height: 2),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    FlutterI18n.translate(context, 'cart.total'),
                    style: theme.textTheme.subtitle
                        .copyWith(color: theme.primaryColor),
                  ),
                  SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        request.items.elementAt(0).product.priceUnit,
                        style: theme.textTheme.caption.copyWith(fontSize: 16),
                      ),
                      Text(
                        '${request.items.map((p) => p.price * p.amount).fold<double>(0.0, (previous, current) => previous + current).toStringAsFixed(2)}',
                        style: theme.textTheme.title,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: <Widget>[
                  FlatButton(
                    onPressed: () => _showUpdateStatusDialog(request),
                    textColor: theme.primaryColor,
                    child: Text(
                        FlutterI18n.translate(context, 'requests.updateStatus')
                            .toUpperCase()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RequestDetailsDialog extends StatefulWidget {
  final Request request;

  const RequestDetailsDialog({
    Key key,
    @required this.request,
  }) : super(key: key);

  @override
  _RequestDetailsDialogState createState() => _RequestDetailsDialogState();
}

class _RequestDetailsDialogState extends State<RequestDetailsDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(FlutterI18n.translate(context, 'requests.details')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ...RequestStatus.values.map(
            (value) => Row(
              children: <Widget>[
                Radio(
                  groupValue: value.index,
                  value: widget.request.status,
                  onChanged: (index) {
                    setState(() {
                      widget.request.status = value.index;
                    });
                  },
                ),
                Text(writeRequestStatus(context, value.index))
              ],
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
              FlutterI18n.translate(context, 'actions.update').toUpperCase()),
          onPressed: () => Navigator.of(context).pop(true),
        )
      ],
    );
  }
}
