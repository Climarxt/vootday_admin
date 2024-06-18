// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vootday_admin/config/configs.dart';
import 'package:vootday_admin/config/logger/logger.dart';

class FunctionsScreen extends StatelessWidget {
  const FunctionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              expandedHeight: 126.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Functions'),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return _buildBody(context)[index];
                },
                childCount: _buildBody(context).length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBody(BuildContext context) {
    return [
      FunctionTile(
        functionName: 'Function 1',
        description: 'This is the description for function 1.',
        onActivate: () async {
          await _callFunction(context, 'Function 1');
        },
      ),
      FunctionTile(
        functionName: 'Function 2',
        description: 'This is the description for function 2.',
        onActivate: () async {
          await _callFunction(context, 'Function 2');
        },
      ),
      FunctionTile(
        functionName: 'Function 3',
        description: 'This is the description for function 3.',
        onActivate: () async {
          await _callFunction(context, 'Function 3');
        },
      ),
      // Add more FunctionTile widgets as needed
    ];
  }

  Future<void> _callFunction(BuildContext context, String functionName) async {
    final logger = ContextualLogger('FunctionsScreen._callFunction');
    const url = 'https://us-central1-bootdv2.cloudfunctions.net/helloWorld';

    try {
      logger.logInfo('_callFunction', 'Calling cloud function', {'functionName': functionName, 'url': url});
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        logger.logInfo('_callFunction', 'Function activated successfully', {'functionName': functionName, 'response': response.body});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Function $functionName activated successfully: ${response.body}')),
        );
      } else {
        logger.logError('_callFunction', 'Failed to activate function', {'functionName': functionName, 'statusCode': response.statusCode});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to activate function $functionName: ${response.statusCode}')),
        );
      }
    } catch (e) {
      logger.logError('_callFunction', 'Error activating function', {'functionName': functionName, 'error': e.toString()});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error activating function $functionName: $e')),
      );
    }
  }
}

class FunctionTile extends StatelessWidget {
  final String functionName;
  final String description;
  final VoidCallback onActivate;

  const FunctionTile({
    super.key,
    required this.functionName,
    required this.description,
    required this.onActivate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              functionName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(description),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onActivate,
                child: const Text('Activate'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
