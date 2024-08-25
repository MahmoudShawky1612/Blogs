import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final Function(String) onSearch;
  final Function(String) onQueryChanged;

  const SearchBar({
    required this.onSearch,
    required this.onQueryChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by title',
                border: OutlineInputBorder(),
              ),
              onChanged: onQueryChanged,
              onSubmitted: onSearch,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => onSearch(''),
          ),
        ],
      ),
    );
  }
}