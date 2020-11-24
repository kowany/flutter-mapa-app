import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:mapa_app/bloc/mapa/mapa_bloc.dart';
import 'package:mapa_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';

import 'package:mapa_app/widgets/widgets.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  @override
  void initState() {
    context.read<MiUbicacionBloc>().iniciarSeguimiento();
    super.initState();
  }

  @override
  void dispose() {
    context.read<MiUbicacionBloc>().iniciarSeguimiento();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // context.watch<MiUbicacionBloc>().iniciarSeguimiento();
    return Scaffold(
      body: BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
        builder: (_, state) => crearMapa(state),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BtnUbicacion(),
        ],
      ),
    );
  }

  Widget crearMapa(MiUbicacionState state) {
    if (!state.existeUbicacion) return Center(child: Text('Localizando ...'));

    final mapaBloc = BlocProvider.of<MapaBloc>(context);

    final CameraPosition cameraPosition = new CameraPosition(
      target: state.ubicacion,
      zoom: 16,
    );
    return GoogleMap(
      initialCameraPosition: cameraPosition,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      // onMapCreated: (GoogleMapController controller) =>
      //     mapaBloc.initMapa(controller),
      // esto es exactamente igual
      onMapCreated: mapaBloc.initMapa,
    );
  }
}
