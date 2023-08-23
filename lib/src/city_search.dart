import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'city_search_result.dart';

class CitySearch extends SearchDelegate<CitySearchResult?> {
  CitySearch({
    String? searchFieldLabel,
    TextStyle? searchFieldStyle,
    this.emptyWidget = const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search,
            size: 48,
            color: Colors.grey,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            'Search by city name',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    ),
    this.loadingWidget = const Center(
      child: CircularProgressIndicator(),
    ),
    this.errorWidget = const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.grey,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            'Could not load results',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    ),
  }) : super(
          searchFieldLabel: searchFieldLabel ?? 'Search',
          searchFieldStyle: searchFieldStyle ??
              const TextStyle(
                fontSize: 18,
              ),
        );

  Widget emptyWidget;
  Widget loadingWidget;
  Widget errorWidget;
  Widget Function(
          BuildContext context, CitySearchResult result, Function onConfirm)
      resultWidgetBuilder = (context, result, onConfirm) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 12,
        left: 12,
        right: 12,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => onConfirm(),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 22,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${result.name}'),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      '${result.address?.state != null ? '${result.address?.state}, ' : ''}${result.address?.country}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // child: ListTile(
        // leading: Icon(
        //   Icons.arrow_back_ios,
        //   size: 22,
        //   color: Theme.of(context).colorScheme.primary,
        // ),
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        //   title: Text('${result.name}'),
        //   subtitle:
        //       Text('${result.address?.state}, ${result.address?.country}'),
        //   onTap: () {
        //     onConfirm();
        //   },
        // ),
      ),
    );
  };

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

  Future<List<CitySearchResult>> searchCities(
    String query, {
    List<String>? languages,
    List<String>? countryCodes,
  }) async {
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
          return loadingWidget;
        } else if (snapshot.hasError) {
          return errorWidget;
        } else {
          return ListView.builder(
            itemCount:
                snapshot.data?.length != null ? snapshot.data!.length + 1 : 0,
            itemBuilder: (context, index) {
              if (index == snapshot.data!.length) {
                return Container(
                  height: 100,
                );
              }
              final result = snapshot.data![index];
              return resultWidgetBuilder(context, result, () {
                close(context, result);
              });
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return emptyWidget;
  }
}
