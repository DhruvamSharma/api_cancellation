import 'package:flutter/material.dart';
import 'package:api_cancellation/api_cancellation/view/manual_cancellation_demo.dart';
import 'package:api_cancellation/api_cancellation/view/search_cancellation_demo.dart';
import 'package:api_cancellation/api_cancellation/view/page_cancellation_demo.dart';

class ApiCancellationPage extends StatelessWidget {
  const ApiCancellationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'API Cancellation Examples',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose an API cancellation pattern to demonstrate:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _buildOptionCard(
                    context,
                    title: 'Manual Request Cancellation',
                    description: 'Start an API request and manually cancel it with a button',
                    icon: Icons.stop_circle,
                    color: Colors.red,
                    onTap: () => _navigateToManualCancellation(context),
                  ),
                  const SizedBox(height: 16),
                  _buildOptionCard(
                    context,
                    title: 'Search with Request Replacement',
                    description: 'Type in a search field to see how previous requests are automatically cancelled',
                    icon: Icons.search,
                    color: Colors.blue,
                    onTap: () => _navigateToSearchCancellation(context),
                  ),
                  const SizedBox(height: 16),
                  _buildOptionCard(
                    context,
                    title: 'Page-Level Request Cancellation',
                    description: 'Start a request and see it cancelled when navigating away',
                    icon: Icons.pageview,
                    color: Colors.green,
                    onTap: () => _navigateToPageCancellation(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToManualCancellation(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ManualCancellationDemo(),
      ),
    );
  }

  void _navigateToSearchCancellation(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SearchCancellationDemo(),
      ),
    );
  }

  void _navigateToPageCancellation(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PageCancellationDemo(),
      ),
    );
  }
}
