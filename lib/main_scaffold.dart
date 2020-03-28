import 'package:flutter/widgets.dart';
import 'package:keuangan/bloc_main.dart';

/// This is an InheritedWidget that wraps around [BlocTodolist]. Think about this
/// as Scoped Model for that specific class.
///
/// This merely solves the "passing reference down the tree" problem for us.
/// You can solve this in other ways, like through dependency injection.
///
/// Also note that this does not call [BlocTodolist.dispose]. If your app
/// ever doesn't need to access the cart, you should make sure it's
/// disposed of properly.
class MainProvider extends InheritedWidget {
  final BlocApp blocApp;


  MainProvider({
    Key key,
    BlocApp blocApp,
    Widget child,
  })  : blocApp = blocApp ?? BlocApp(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static BlocApp of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(MainProvider) as MainProvider)
          .blocApp;
}
