part of 'busqueda_bloc.dart';

@immutable
abstract class BusquedaEvent {}

class onActivarMarcadorManual extends BusquedaEvent {}

class onDesactivarMarcadorManual extends BusquedaEvent {}
