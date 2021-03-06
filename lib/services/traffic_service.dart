import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa_app/models/driving_response.dart';

class TrafficService {
  // Singleton

  TrafficService._privateConstructor();

  static final TrafficService _instance = TrafficService._privateConstructor();

  factory TrafficService() => _instance;

  final _dio = Dio();

  final _baseUrl = 'https://api.mapbox.com/directions/v5';
  final _apiKey =
      'pk.eyJ1Ijoia293YW55IiwiYSI6ImNraHo3ZXJzdDBoNm0yd2s2a3c1azdpM3oifQ.JJhxCs26_nnLN3Y7GJ_R4Q';

  Future<DrivingResponse> getCoordsInicioYDestino(
      LatLng inicio, LatLng destino) async {
    // print('Inicio: $inicio');
    // print('Destino: $destino');
    final coordString =
        '${inicio.longitude},${inicio.latitude};${destino.longitude},${destino.latitude}';
    final url = '${this._baseUrl}/mapbox/driving/${coordString}?';

    final resp = await this._dio.get(url, queryParameters: {
      'alternatives': 'true',
      'geometries': 'polyline6',
      'steps': 'false',
      'access_token': this._apiKey,
      'language': 'es'
    });
    final data = DrivingResponse.fromJson(resp.data);
    return data;
  }
}
