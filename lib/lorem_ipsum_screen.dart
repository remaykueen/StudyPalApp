import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

class LoremIpsumScreen extends StatefulWidget {
  const LoremIpsumScreen({super.key});

  @override
  State<LoremIpsumScreen> createState() => _LoremIpsumScreenState();
}

class _LoremIpsumScreenState extends State<LoremIpsumScreen> {
  String loremText = '';
  bool isLoading = false;
  String errorMessage = '';

  int selectedCount = 1;
  String selectedType = 'paragraphs';

  Future<void> getLoremIpsum() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
      loremText = '';
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://randomapi.dev/api/lorem'
          '?type=$selectedType'
          '&startWithLorem=true'
          '&count=$selectedCount',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['data'] as List;

        setState(() {
          loremText = results
              .map((item) => item['text'])
              .join('\n\n');
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load Lorem Ipsum.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Something went wrong. Please try again.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lorem Ipsum Generator'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Number of paragraphs:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButton<int>(
              value: selectedCount,
              items: const [
                DropdownMenuItem(
                  value: 1,
                  child: Text('1'),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text('2'),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: Text('3'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCount = value;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'Type:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButton<String>(
              value: selectedType,
              items: const [
                DropdownMenuItem(
                  value: 'paragraphs',
                  child: Text('Paragraphs'),
                ),
                DropdownMenuItem(
                  value: 'sentences',
                  child: Text('Sentences'),
                ),
                DropdownMenuItem(
                  value: 'words',
                  child: Text('Words'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedType = value;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: isLoading ? null : getLoremIpsum,
              child: Text(
                isLoading ? 'Loading...' : 'Generate',
              ),
            ),

            const SizedBox(height: 20),

            const Divider(),

            const SizedBox(height: 10),

            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  errorMessage.isNotEmpty
                      ? errorMessage
                      : loremText.isEmpty
                          ? 'Select your options and tap Generate.'
                          : loremText,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}