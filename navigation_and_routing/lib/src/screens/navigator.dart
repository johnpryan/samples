import 'package:bookstore/src/screens/scaffold.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../auth/auth.dart';
import '../data/author.dart';
import '../data/book.dart';
import '../data/library_scope.dart';
import '../routing/route_state.dart';
import '../screens/sign_in.dart';
import '../util/fade_transition_page.dart';
import 'author_details.dart';
import 'book_details.dart';

class BookstoreNavigator extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final RouteState routeState;
  final BookstoreAuth auth;

  const BookstoreNavigator({
    required this.routeState,
    required this.auth,
    required this.navigatorKey,
    Key? key,
  }) : super(key: key);

  @override
  _BookstoreNavigatorState createState() => _BookstoreNavigatorState();
}

class _BookstoreNavigatorState extends State<BookstoreNavigator> {
  final scaffoldKey = const ValueKey<String>('App scaffold');
  final bookDetailsKey = const ValueKey<String>('Book details screen');
  final authorDetailsKey = const ValueKey<String>('Author details screen');

  @override
  Widget build(BuildContext context) {
    final pathTemplate = widget.routeState.route.pathTemplate;
    final library = LibraryScope.of(context);

    Book? book;
    if (pathTemplate == '/books/:bookId') {
      book = library.allBooks.firstWhereOrNull((b) =>
          b.id.toString() == widget.routeState.route.parameters['bookId']);
    }

    Author? author;
    if (pathTemplate == '/authors/:authorId') {
      author = library.allAuthors.firstWhereOrNull((b) =>
          b.id.toString() == widget.routeState.route.parameters['authorId']);
    }

    return Navigator(
      key: widget.navigatorKey,
      onPopPage: (route, dynamic result) {
        // When a page that is stacked on top of the scaffold is popped, display
        // the /books or /authors tab in BookstoreScaffold.
        if (route.settings is Page &&
            (route.settings as Page).key == bookDetailsKey) {
          widget.routeState.go('/books');
        }

        if (route.settings is Page &&
            (route.settings as Page).key == authorDetailsKey) {
          widget.routeState.go('/authors');
        }

        return route.didPop(result);
      },
      pages: [
        if (widget.routeState.route.pathTemplate == '/')
          const FadeTransitionPage<void>(
            key: ValueKey('None'),
            child: Scaffold(),
          )
        else if (widget.routeState.route.pathTemplate == '/signin')
          // Display the sign in screen.
          FadeTransitionPage<void>(
            key: const ValueKey('Sign in'),
            child: SignInScreen(
              onSignIn: (credentials) async {
                var signedIn = await widget.auth
                    .signIn(credentials.username, credentials.password);
                if (signedIn) {
                  widget.routeState.go('/books');
                }
              },
            ),
          )
        else ...[
          // Display the app
          FadeTransitionPage<void>(
            key: scaffoldKey,
            child: BookstoreScaffold(
              currentRoute: widget.routeState.route,
            ),
          ),
          // Add an additional page to the stack if the user is viewing a book
          // or an author
          if (book != null)
            MaterialPage<void>(
              key: bookDetailsKey,
              child: BookDetailsScreen(
                book: book,
              ),
            )
          else if (author != null)
            MaterialPage<void>(
              key: authorDetailsKey,
              child: AuthorDetailsScreen(
                author: author,
              ),
            ),
        ],
      ],
    );
  }
}
