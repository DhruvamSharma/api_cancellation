import 'package:api_cancellation/api_cancellation/helpers/data_field.dart';
import 'package:api_cancellation/api_cancellation/helpers/user_entity.dart';
import 'package:api_cancellation/api_cancellation/view/bloc/api_cancellation_bloc.dart';
import 'package:api_cancellation/api_cancellation/view/widgets/request_statistics_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManualCancellationDemo extends StatefulWidget {
  const ManualCancellationDemo({super.key});

  @override
  State<ManualCancellationDemo> createState() => _ManualCancellationDemoState();
}

class _ManualCancellationDemoState extends State<ManualCancellationDemo> {
  Future<void> _startRequest() async {
    context.read<ApiCancellatioBloc>().add(const StartManualApiRequest());
  }

  void _cancelRequest() {
    context.read<ApiCancellatioBloc>().add(const CancelManualApiRquest());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual Cancellation Demo'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
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
                      Icons.stop_circle,
                      size: 64,
                      color: Colors.red[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Manual Request Cancellation',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start a request and manually cancel it before completion',
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
            BlocSelector<ApiCancellatioBloc, ApiCancellatioState, ApiCancellatioState>(
              selector: (state) => state,
              builder: (context, state) {
                return RequestStatisticsTable(
                  totalRequests: state.requestCount,
                  cancelledRequests: state.requestsCancelled,
                  successfulRequests: state.requestsCompleted,
                );
              },
            ),
            const SizedBox(height: 32),
            BlocSelector<ApiCancellatioBloc, ApiCancellatioState,
                DataField<List<UserEntity>>>(
              selector: (state) => state.usersState,
              builder: (context, state) {
                final isLoading = state is DataFieldLoading;
                return Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _startRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Start Request',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoading ? _cancelRequest : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel Request',
                          style: TextStyle(fontSize: 16),
                        ),
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
          ],
        ),
      ),
    );
  }
}
