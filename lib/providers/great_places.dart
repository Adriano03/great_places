import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/models/place.dart';
import 'package:great_places/utils/db_util.dart';
import 'package:great_places/utils/location_util.dart';

class GreatPlaces with ChangeNotifier {
  //Pegar dados da lista;
  List<Place> _items = [];

  //Carregar dados que já estejam cadastrados no BD;
  Future<void> loadPlaces() async {
    final dataList = await DbUtil.getData('places');
    _items = dataList
        .map(
          (item) => Place(
            id: item['id'],
            title: item['title'],
            image: File(item['image']),
            location: PlaceLocation(
              latitude: item['latitude'],
              longitude: item['longitude'],
              address: item['address'],
            ),
          ),
        )
        .toList();
    notifyListeners();
  }

  //Por segurança é feito um clone da lista [...], assim impede que algo altere a lista verdadeira;
  List<Place> get items {
    return [..._items];
  }

  //Pegar tamanho da lista;
  int get itemsCount {
    return _items.length;
  }

  //Pegar item pelo id;
  Place itemByIndex(int index) {
    return _items[index];
  }

  //Adicionar dados do formulário no BD;
  Future<void> addPlace(String title, File image, LatLng position) async {
    // Desativado devido a key desabilitada;
    // String address = await LocationUtil.getAddressFrom(position);

    final newPlace = Place(
      id: Random().nextDouble().toString(),
      title: title,
      image: image,
      location: PlaceLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        //Usado valor constante para não dar erro pela falta da key;
        address: 'Rua tal número tal bairro tal',
      ),
    );

    _items.add(newPlace);
    DbUtil.insert('places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'latitude': position.latitude,
      'longitude': position.longitude,
      //Usado valor constante para não dar erro pela falta da key;
      'address': 'Rua tal número tal bairro tal'
    });
    //Notifica os interessados, atualiza os componentes que depende do ChangeNotifier;
    notifyListeners();
  }
}
