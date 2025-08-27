import 'package:api_cancellation/api_cancellation/helpers/data_field.dart';
import 'package:api_cancellation/api_cancellation/helpers/user_entity.dart';
import 'package:api_cancellation/api_cancellation/view/bloc/api_cancellation_bloc.dart';
import 'package:api_cancellation/api_cancellation/view/widgets/request_statistics_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCancellationDemo extends StatefulWidget {
  const SearchCancellationDemo({super.key});

  @override
  State<SearchCancellationDemo> createState() => _SearchCancellationDemoState();
}

class _SearchCancellationDemoState extends State<SearchCancellationDemo> {

  Future<void> _performSearch(String query) async {
    final bloc = context.read<ApiCancellatioBloc>();
    bloc.add(const StartManualApiRequest());
  }

  void _onSearchChanged(String query) {
    _performSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Cancellation Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.search,
                      size: 64,
                      color: Colors.blue[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Search with Request Replacement',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Type quickly to see how previous requests are automatically cancelled',
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
            const SizedBox(height: 24),
            TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Type to search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
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
            const SizedBox(height: 16),
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
          ],
        ),
      ),
    );
  }
}
