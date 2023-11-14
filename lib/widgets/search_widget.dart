// ignore_for_file: library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final VoidCallback onClose; // Callback to close the search widget

  const SearchWidget({Key? key, required this.onClose}) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  static const double smallFontSize = 14.0;
  static const double mediumFontSize = 17.0;
  static const double largeFontSize = 20.0;
  Locale _selectedLocale = const Locale('en', 'US');
  double fontSize = mediumFontSize;
  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;
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
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0))),
                    alignLabelWithHint: true,
                    hintText: 'Type Magnitude/Unit/Symbol'.tr(),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close,
                    color: isDarkMode ? Colors.red : Colors.black, size: 23),
                onPressed: widget.onClose, // Call the onClose callback
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                top: 0,
                left: MediaQuery.of(context).size.width * 0.02,
                right: MediaQuery.of(context).size.width * 0.14),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                  Radius.circular(10)), // Set border radius
              child: Container(
                color: Colors
                    .white, // Set the background color of the container to black
                child: SingleChildScrollView(
                  child: Column(
                    children: _navigationMap.keys
                        .where((key) => key
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()))
                        .map((key) => ListTile(
                              title: Text(key.tr(),
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Colors
                                        .black, // Set the text color to white
                                  ),
                                  textAlign: TextAlign.center),
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(_navigationMap[key]!);
                              },
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
