import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' show Response, Client;
import 'package:space_y/blocs/login_bloc.dart';
import 'package:space_y/models/user_model.dart';
import 'package:permission_handler/permission_handler.dart';

String _address = 'Taper ici pour rechercher';

Future<String> getAddress() async {
  if (!await Permission.location.request().isGranted) {
    await <Permission>[
      Permission.location,
    ].request();
  }
  final List<double> kLatLon = await getLatLonFromGPS();
  print(kLatLon[0]);
  final Response address = await getAddressFromLatLon(kLatLon[0], kLatLon[1]);


  final Map<String, dynamic> kResJson = json.decode(address.body) as Map<String, dynamic>;
  if (kResJson['features'].length == 0)
    return kLatLon[0].toString() + ' , ' + kLatLon[1].toString();
  return kResJson['features'][0]['properties']['label'] as String;
}

Future<Response> getAddressFromLatLon(double lon, double lat) async {
  final Client kClient = Client();

  const String kBaseUrl = 'https://api-adresse.data.gouv.fr/reverse';
  final String parameters = '?lon=$lon&lat=$lat';
  // final String parameters = '?lon=-122.406417&lat=37.785834';
  final Response kAddressFromApi = await kClient.get(
      kBaseUrl + parameters);

  return kAddressFromApi;
}

Future<List<double>> getLatLonFromGPS() async {
  final Position kPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  final List<double> kLonLat = <double>[];

  kLonLat.add(kPosition.toJson()['longitude'] as double);
  kLonLat.add(kPosition.toJson()['latitude'] as double);
  return kLonLat;
}

SingleChildScrollView profileInfo(BuildContext context, UserModel user, LoginBloc loginBloc) {
  return SingleChildScrollView(
    key: const Key('ProfileScrollable'),
    child: Column(
      children: <Widget> [
        const Text('Email',
            textScaleFactor: 1.4, style: TextStyle()),
        displayEmail(context, user),
        const Text('Adresse',
            textScaleFactor: 1.4, style: TextStyle()),
        displayAddress(context),
        RaisedButton(
          key: const Key('LogoutButton'),
          onPressed: loginBloc.logout,
          child: const Text(
            'Logout',
            style: TextStyle(color: Colors.white),
          ),
          color: Theme.of(context).accentColor,
        ),
      ],
    ),
  );
}

Container displayAddress(BuildContext context) {
  return Container(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 20.0),
        width: MediaQuery.of(context).size.width,
        child: Card(
          color: Theme.of(context).accentColor,
          borderOnForeground: false,
          child: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 13.0, horizontal: 16),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        _address = await getAddress();
                        displayAddressOnModal(context);
                      },
                      child: const Text(
                        'Cliquez ici pour connaître votre\n adresse',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}

void displayAddressOnModal(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.4,
        color: Theme.of(context).accentColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Votre addresse est : ' + _address,
              textAlign: TextAlign.center,),
              ElevatedButton(
                child: const Text('Ok merci!'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        ),
      );
    },
  );
}

Container displayEmail(BuildContext context, UserModel user) {
  return Container(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 20.0),
        width: MediaQuery.of(context).size.width,
        child: Card(
          color: Colors.white,
          borderOnForeground: false,
          child: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 13.0, horizontal: 16),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      user.email,
                      style: const TextStyle(
                          color: Colors.black
                      ),
                      textScaleFactor: 1.15,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
