import 'package:api_cancellation/api_cancellation/helpers/data_field.dart';
import 'package:api_cancellation/api_cancellation/helpers/user_entity.dart';
import 'package:api_cancellation/api_cancellation/services/user_api_service.dart';
import 'package:api_cancellation/api_cancellation/view/bloc/api_cancellation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PageCancellationDemo extends StatelessWidget {
  const PageCancellationDemo({super.key});

    Future<void> _startPageRequest(BuildContext context) async {
    context.read<ApiCancellatioBloc>().add(const StartManualApiRequest());
  }

  void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ApiCancellatioBloc(userApiService: UserApiService())
        ..add(const StartManualApiRequest()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Page Cancellation Demo'),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  pop(context);
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Icon(
                              Icons.pageview,
                              size: 64,
                              color: Colors.green[400],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Page-Level Request Cancellation',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Start a request and navigate away to see it cancelled',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    BlocSelector<ApiCancellatioBloc, ApiCancellatioState,
                        DataField<List<UserEntity>>>(
                      selector: (state) => state.usersState,
                      builder: (context, state) {
                        final isRequestInProgress = state is DataFieldLoading;
          
                        return Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Go Back',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox.square(
                              dimension: 16,
                            ),
                            Expanded(
                              child: Builder(
                                builder: (context) {
                                  return ElevatedButton(
                                    onPressed:
                                        isRequestInProgress ? null : () => _startPageRequest(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Restart Request',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    BlocSelector<ApiCancellatioBloc, ApiCancellatioState,
                        DataField<List<UserEntity>>>(
                      selector: (state) => state.usersState,
                      builder: (context, state) {
                        final isRequestInProgress = state is DataFieldLoading;
          
                        if (isRequestInProgress) {
                          return const LinearProgressIndicator(
                            backgroundColor: Colors.grey,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                          );
                        }
          
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 2,
                      color: Colors.orange[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.orange[600],
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try navigating back now to see the request cancellation in action!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.orange[700],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
