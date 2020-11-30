part of 'widgets.dart';

class MarcadorManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(
      builder: (context, state) {
        if (state.seleccionManual) {
          return _BuildMarcadorManual();
        } else {
          return Container();
        }
      },
    );
  }
}

class _BuildMarcadorManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        // botón regresar
        Positioned(
          top: 70.0,
          left: 20.0,
          child: FadeInLeft(
            delay: Duration(milliseconds: 150),
            child: CircleAvatar(
              maxRadius: 25.0,
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () {
                  BlocProvider.of<BusquedaBloc>(context)
                      .add(onDesactivarMarcadorManual());
                },
              ),
            ),
          ),
        ),
        Center(
          child: Transform.translate(
            offset: Offset(0.0, -24.0),
            child: BounceInDown(
              from: 150,
              delay: Duration(milliseconds: 200),
              child: Icon(Icons.location_on, size: 50.0),
            ),
          ),
        ),
        // botón de confirmar destino
        Positioned(
          bottom: 70.0,
          left: 20.0,
          child: FadeIn(
            child: MaterialButton(
              minWidth: width - 120.0,
              child: Text('Confirmar destino',
                  style: TextStyle(color: Colors.white)),
              color: Colors.black,
              shape: StadiumBorder(),
              elevation: 0.0,
              splashColor: Colors.transparent,
              onPressed: () {
                this.calcularDestino(context);
              },
            ),
          ),
        )
      ],
    );
  }

  void calcularDestino(BuildContext context) async {
    calculandoAlerta(context);
    final trafficService = new TrafficService();
    final mapaBloc = context.read<MapaBloc>();
    final busquedaBloc = context.read<BusquedaBloc>();

    final inicio = context.read<MiUbicacionBloc>().state.ubicacion;
    final destino = mapaBloc.state.ubicacionCentral;

    final drivingResponse =
        await trafficService.getCoordsInicioYDestino(inicio, destino);

    final geometry = drivingResponse.routes[0].geometry;
    final duration = drivingResponse.routes[0].duration;
    final distance = drivingResponse.routes[0].distance;
    // Decodificar los puntos del geometry

    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6)
        .decodedCoords;

    final List<LatLng> rutaCoordenadas =
        points.map((point) => LatLng(point[0], point[1])).toList();
    mapaBloc.add(OnCrearRutaInicioDestino(rutaCoordenadas, duration, distance));
    Navigator.of(context).pop();
    busquedaBloc.add(onDesactivarMarcadorManual());
  }
}
