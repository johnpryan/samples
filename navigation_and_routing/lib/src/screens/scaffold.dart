// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/material.dart';

import '../routing.dart';
import 'scaffold_body.dart';

class BookstoreScaffold extends StatelessWidget {
  final ParsedRoute currentRoute;

  const BookstoreScaffold({
    Key? key,
    required this.currentRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeState = RouteState.of(context);
    final selectedIndex = _getSelectedIndex(currentRoute.pathTemplate);

    return Scaffold(
      body: AdaptiveNavigationScaffold(
        selectedIndex: selectedIndex,
        body: BookstoreScaffoldBody(currentRoute: currentRoute),
        onDestinationSelected: (idx) {
          if (idx == 0) routeState.go('/books');
          if (idx == 1) routeState.go('/authors');
          if (idx == 2) routeState.go('/settings');
        },
        destinations: const [
          AdaptiveScaffoldDestination(
            title: 'Books',
            icon: Icons.book,
          ),
          AdaptiveScaffoldDestination(
            title: 'Authors',
            icon: Icons.person,
          ),
          AdaptiveScaffoldDestination(
            title: 'Settings',
            icon: Icons.settings,
          ),
        ],
      ),
    );
  }

  int _getSelectedIndex(String pathTemplate) {
    if (pathTemplate == '/books') return 0;
    if (pathTemplate == '/authors') return 1;
    if (pathTemplate == '/settings') return 2;
    return 0;
  }
}
