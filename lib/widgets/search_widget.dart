// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final VoidCallback onClose; // Callback to close the search widget

  const SearchWidget({Key? key, required this.onClose}) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  String _searchQuery = "";
  final Map<String, String> _navigationMap = {
    'Settings': '/settings',
    // Add all other navigation options here
    'Distance': '/distance',
    // ... include all units for distance
    'Area': '/area',
    // ... include all units for area
    'Volume': '/volume',
    // ... include all units for volume
    // etc...
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Type Symbol/Magnitude/Unit',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red, size: 23),
                onPressed: widget.onClose, // Call the onClose callback
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: _navigationMap.keys
                  .where((key) =>
                      key.toLowerCase().contains(_searchQuery.toLowerCase()))
                  .map((key) => ListTile(
                        title: Text(key),
                        onTap: () {
                          Navigator.of(context).pushNamed(_navigationMap[key]!);
                        },
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
