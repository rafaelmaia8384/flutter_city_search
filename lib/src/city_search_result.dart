// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CitySearchResult {
  final int? placeId;
  final String? licence;
  final String? osmType;
  final int? osmId;
  final List<String>? boundingbox;
  final String? lat;
  final String? lon;
  final String? name;
  final String? displayName;
  final String? className;
  final String? type;
  final double? importance;
  final String? icon;
  final AddressDetails? address;

  CitySearchResult({
    this.placeId,
    this.licence,
    this.osmType,
    this.osmId,
    this.boundingbox,
    this.lat,
    this.lon,
    this.name,
    this.displayName,
    this.className,
    this.type,
    this.importance,
    this.icon,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'place_id': placeId,
      'licence': licence,
      'osm_type': osmType,
      'osm_id': osmId,
      'boundingbox': boundingbox,
      'lat': lat,
      'lon': lon,
      'name': name,
      'display_name': displayName,
      'class_name': className,
      'type': type,
      'importance': importance,
      'icon': icon,
      'address': address?.toMap(),
    };
  }

  factory CitySearchResult.fromMap(Map<String, dynamic> map) {
    return CitySearchResult(
      placeId: map['place_id'] != null ? map['place_id'] as int : null,
      licence: map['licence'] != null ? map['licence'] as String : null,
      osmType: map['osm_type'] != null ? map['osm_type'] as String : null,
      osmId: map['osm_id'] != null ? map['osm_id'] as int : null,
      boundingbox: map['boundingbox'] != null
          ? List<String>.from((map['boundingbox']))
          : null,
      lat: map['lat'] != null ? map['lat'] as String : null,
      lon: map['lon'] != null ? map['lon'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      displayName:
          map['display_name'] != null ? map['display_name'] as String : null,
      className: map['class_name'] != null ? map['class_name'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      importance:
          map['importance'] != null ? map['importance'] as double : null,
      icon: map['icon'] != null ? map['icon'] as String : null,
      address: map['address'] != null
          ? AddressDetails.fromMap(map['address'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CitySearchResult.fromJson(String source) =>
      CitySearchResult.fromMap(json.decode(source) as Map<String, dynamic>);
}

class AddressDetails {
  final String? houseNumber;
  final String? road;
  final String? suburb;
  final String? city;
  final String? county;
  final String? state;
  final String? postcode;
  final String? country;
  final String? countryCode;

  AddressDetails({
    this.houseNumber,
    this.road,
    this.suburb,
    this.city,
    this.county,
    this.state,
    this.postcode,
    this.country,
    this.countryCode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'house_number': houseNumber,
      'road': road,
      'suburb': suburb,
      'city': city,
      'county': county,
      'state': state,
      'postcode': postcode,
      'country': country,
      'country_code': countryCode,
    };
  }

  factory AddressDetails.fromMap(Map<String, dynamic> map) {
    return AddressDetails(
      houseNumber:
          map['house_number'] != null ? map['house_number'] as String : null,
      road: map['road'] != null ? map['road'] as String : null,
      suburb: map['suburb'] != null ? map['suburb'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      county: map['county'] != null ? map['county'] as String : null,
      state: map['state'] != null ? map['state'] as String : null,
      postcode: map['postcode'] != null ? map['postcode'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
      countryCode:
          map['country_code'] != null ? map['country_code'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressDetails.fromJson(String source) =>
      AddressDetails.fromMap(json.decode(source) as Map<String, dynamic>);
}
