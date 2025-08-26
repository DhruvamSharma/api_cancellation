import 'package:api_cancellation/api_cancellation/services/user_api_service.dart';
import 'package:api_cancellation/api_cancellation/view/api_cancellation_page.dart';
import 'package:api_cancellation/api_cancellation/view/bloc/api_cancellation_bloc.dart';
import 'package:api_cancellation/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ApiCancellatioBloc(
        userApiService: UserApiService(),
      ),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          useMaterial3: true,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const ApiCancellationPage(),
      ),
    );
  }
}
