import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'city_search_result.dart';

class CitySearch extends SearchDelegate<CitySearchResult?> {
  CitySearch({
    String? searchFieldLabel,
    TextStyle? searchFieldStyle,
    Widget? errorWidget,
  }) : super(
          searchFieldLabel: searchFieldLabel ?? 'Search city',
          searchFieldStyle: searchFieldStyle ??
              const TextStyle(
                fontSize: 18,
              ),
        );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  static Future<CitySearchResult?> open(BuildContext context) async {
    return await showSearch<CitySearchResult?>(
      context: context,
      delegate: CitySearch(),
    );
  }

  Future<List<CitySearchResult>> searchCities(String query) async {
    //&countrycodes=us,ca
    //&accept-language=pt
    final response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=10&addressdetails=1'));

    if (response.statusCode == 200) {
      final String body = utf8.decode(response.bodyBytes);
      Iterable i = json.decode(body);
      List<CitySearchResult> list = List<CitySearchResult>.from(
        i.map((o) => CitySearchResult.fromMap(o)),
      );
      return list;
    } else {
      throw Exception();
    }
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) return Container();

    return FutureBuilder<List<CitySearchResult>>(
      future: searchCities(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              final result = snapshot.data![index];
              return ListTile(
                title: Text('${result.name}, ${result.address?.state}'),
                subtitle: Text(result.address?.country ?? ''),
                onTap: () {
                  close(context, result);
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
