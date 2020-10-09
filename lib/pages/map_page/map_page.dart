import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../../blocs/fusion_bloc/fusion_bloc.dart';
import '../../blocs/map_bloc/map_bloc.dart';
import '../../blocs/theme_bloc/theme_bloc.dart';
import '../../global_widgets/loading_state.dart';
import '../../global_widgets/shuttle_svg.dart';
import 'widgets/attribution.dart';
import 'widgets/legend.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  final Connectivity connectivity = Connectivity();
  final MapController mapController = MapController();

  static const darkLink =
      'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}@2x.png';
  static const lightLink =
      'http://tile.stamen.com/toner-lite/{z}/{x}/{y}@2x.png';

  int i = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   ws.openWS();
  //   ws.subscribe("eta");
  //   ws.subscribe("vehicle_location");
  // }

  // @override
  // void dispose() {
  //   ws.closeWS();
  //   super.dispose();
  // }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final _latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    var lat = 42.729;
    var long = -73.6758;
    var mapBloc = context.bloc<MapBloc>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Image.asset(
          'assets/img/logo.png',
          height: 40,
          width: 40,
        ),
      ),
      body: StreamBuilder(
        stream: connectivity.onConnectivityChanged,
        builder: (context, snapshot) {
          if (snapshot.data != ConnectivityResult.none) {
            return Center(
              child: BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, theme) {
                  var isDarkMode = theme.getThemeState;
                  var routes = <Polyline>[];
                  var stops = <Marker>[];

                  var legend = <String, ShuttleSVG>{};

                  return BlocBuilder<MapBloc, MapState>(
                    builder: (context, state) {
                      print("API Poll $i | State is $state");
                      i++;
                      if (state is MapInitial) {
                        mapBloc.add(GetMapData(
                          animatedMapMove: _animatedMapMove,
                          context: context,
                        ));
                      } else if (state is MapLoaded) {
                        routes = state.routes;
                        stops = state.stops;
                        // updates = state.updates;
                        legend = state.legend;
                        // mapBloc.add(GetMapData(
                        //   animatedMapMove: _animatedMapMove,
                        //   context: context,
                        // ));
                      } else if (state is MapError) {
                        mapBloc.add(GetMapData(
                          animatedMapMove: _animatedMapMove,
                          context: context,
                        ));
                      } else {}
                      return BlocBuilder<FusionBloc, FusionState>(
                        builder: (context, fusionState) {
                          var updates = <Marker>[];
                          if (fusionState is FusionInitial) {
                          } else if (fusionState is FusionLoaded) {
                            updates = fusionState.updates;
                          }
                          return Stack(children: <Widget>[
                            Column(
                              children: [
                                /// Map
                                Flexible(
                                  child: FlutterMap(
                                    mapController: mapController,
                                    options: MapOptions(
                                      nePanBoundary: LatLng(42.78, -73.63),
                                      swPanBoundary: LatLng(42.68, -73.71),
                                      center: LatLng(lat, long),
                                      zoom: 14,
                                      maxZoom: 16, // max you can zoom in
                                      minZoom: 13, // min you can zoom out
                                    ),
                                    layers: [
                                      TileLayerOptions(
                                        backgroundColor:
                                            theme.getTheme.bottomAppBarColor,
                                        urlTemplate:
                                            isDarkMode ? darkLink : lightLink,
                                        subdomains: ['a', 'b', 'c'],
                                        tileProvider:
                                            CachedNetworkTileProvider(),
                                      ),
                                      PolylineLayerOptions(polylines: routes),
                                      MarkerLayerOptions(markers: stops),
                                      // MarkerLayerOptions(markers: location),
                                      MarkerLayerOptions(markers: updates),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Attribution(
                              theme: theme.getTheme,
                            ),
                            Legend(
                              legend: legend,
                            ),
                          ]);
                        },
                      );
                    },
                  );
                },
              ),
            );
          }
          return LoadingScreen();
        },
      ),
    );
  }
}
