// is not use as we conver to single vendor but i'll keep it here if needed
class Resturant {
String address;
double lat;
double lng;
String name;
bool offers_available;
String overview;
double rate;
String working_hours;
  Resturant({
    required this.address,
    required this.lat,
    required this.lng,
    required this.name,
    required this.offers_available,
    required this.overview,
    required this.rate,
    required this.working_hours,
  });



  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      'lat': lat,
      'lng': lng,
      'name': name,
      'offers_available': offers_available,
      'overview': overview,
      'rate': rate,
      'working_hours': working_hours,
    };
  }

  factory Resturant.fromMap(Map<String, dynamic> map) {
    return Resturant(
      address: map['address'] as String,
      lat: map['lat'] as double,
      lng: map['lng'] as double,
      name: map['name'] as String,
      offers_available: map['offers_available'] as bool,
      overview: map['overview'] as String,
      rate: map['rate'] as double,
      working_hours: map['working_hours'] as String,
    );
  }


}
