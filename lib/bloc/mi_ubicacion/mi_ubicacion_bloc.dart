import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:geolocator/geolocator.dart' as Geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

part 'mi_ubicacion_event.dart';
part 'mi_ubicacion_state.dart';

class MiUbicacionBloc extends Bloc<MiUbicacionEvent, MiUbicacionState> {
  MiUbicacionBloc() : super(MiUbicacionState());
  StreamSubscription<Geolocator.Position> _positionStream;
  // Geolocator
  // final _geolocator;

  void iniciarSeguimiento() {
    this._positionStream = Geolocator.GeolocatorPlatform.instance
        .getPositionStream(
      desiredAccuracy: Geolocator.LocationAccuracy.high,
      distanceFilter: 10,
    )
        .listen((Geolocator.Position position) {
      final nuevaUbicacion = LatLng(position.latitude, position.longitude);
      add(OnUbicacionCambio(nuevaUbicacion));
    });
  }

  void cancelarSeguimiento() {
    _positionStream?.cancel();
  }

  @override
  Stream<MiUbicacionState> mapEventToState(
    MiUbicacionEvent event,
  ) async* {
    if (event is OnUbicacionCambio) {
      print(event);
      yield state.copyWith(existeUbicacion: true, ubicacion: event.ubicacion);
    }
  }
}
