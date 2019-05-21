import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:row_collection/row_collection.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/query_model.dart';
import '../util/menu.dart';
import 'header_swiper.dart';
import 'loading_indicator.dart';
import 'sliver_bar.dart';

class ScrollPage<T extends QueryModel> extends StatelessWidget {
  final String title;
  final List<Widget> children, actions;

  ScrollPage({
    @required this.title,
    @required this.children,
    this.actions,
  });

  Future<Null> _onRefresh(BuildContext context, T model) {
    Completer<Null> completer = Completer<Null>();
    model.refreshData().then((_) {
      if (model.loadingFailed)
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('No internet connection, cannot reload.'),
            action: SnackBarAction(
              label: 'RELOAD',
              onPressed: () => _onRefresh(context, model),
            ),
          ),
        );
      completer.complete();
    });

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<T>(
      builder: (context, child, model) => RefreshIndicator(
            onRefresh: () => _onRefresh(context, model),
            child: CustomScrollView(
              key: PageStorageKey(title),
              slivers: <Widget>[
                SliverBar(
                  title: title,
                  header: model.isLoading
                      ? LoadingIndicator()
                      : model.loadingFailed && model.photos.isEmpty
                          ? SizedBox()
                          : SwiperHeader(list: model.photos),
                  actions: actions,
                ),
                if (model.isLoading)
                  SliverFillRemaining(child: LoadingIndicator())
                else
                  if (model.loadingFailed && model.items.isEmpty)
                    SliverFillRemaining(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Icon(
                            Icons.cloud_off,
                            size: 100,
                            color: Theme.of(context).textTheme.caption.color,
                          ),
                          Column(children: <Widget>[
                            RowLayout(children: <Widget>[
                              Text(
                                'No internet connection, cannot reload.',
                                style: TextStyle(fontSize: 17),
                              ),
                              FlatButton(
                                child: Text(
                                  'RELOAD',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                  ),
                                ),
                                onPressed: () => _onRefresh(context, model),
                              )
                            ])
                          ])
                        ],
                      ),
                    )
                  else
                    ...children,
              ],
            ),
          ),
    );
  }

  factory ScrollPage.tab({
    @required BuildContext context,
    @required String title,
    @required List<Widget> children,
  }) {
    return ScrollPage(
      title: title,
      children: children,
      actions: <Widget>[
        PopupMenuButton<String>(
          itemBuilder: (context) => Menu.home.keys
              .map((string) => PopupMenuItem(
                    value: string,
                    child: Text(FlutterI18n.translate(context, string)),
                  ))
              .toList(),
          onSelected: (text) => Navigator.pushNamed(context, Menu.home[text]),
        ),
      ],
    );
  }
}