import 'package:flutter/material.dart';
import 'package:vootday_admin/config/configs.dart';

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
        onActivate: () {
          // Code to activate function 1
        },
      ),
      FunctionTile(
        functionName: 'Function 2',
        description: 'This is the description for function 2.',
        onActivate: () {
          // Code to activate function 2
        },
      ),
      FunctionTile(
        functionName: 'Function 3',
        description: 'This is the description for function 3.',
        onActivate: () {
          // Code to activate function 3
        },
      ),
      // Add more FunctionTile widgets as needed
    ];
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
