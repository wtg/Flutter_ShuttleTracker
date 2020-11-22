import 'dart:developer';
//import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../blocs/fusion_bloc/fusion_bloc.dart';
import '../../../data/models/shuttle_eta.dart';

/// Class: ETAPanel Widget
/// Function: Used to create an instance of the ETA Panel
class ETAPanel extends StatefulWidget {
  final String markerName;
  final bool stopMarker;

  /// Constructor of the ETAPanel Widget
  ETAPanel({@required this.markerName, this.stopMarker});

  @override
  _ETAPanelState createState() => _ETAPanelState();
}

/// Class: _ETAPanelState
/// Function: Provides the internal state of the ETAPanel Widget, contains
///           information read synchronously during the lifetime of the widget
class _ETAPanelState extends State<ETAPanel> {
  // Contains a list of the ETAs recieved from the server
  List<ShuttleETA> etaList = [];

  /// Standard Initialization function
  @override
  void initState() {
    super.initState();
  }

  /// Builds the internal content of the Widget
  Widget build(BuildContext context) {
    var panelColor = Theme.of(context).cardColor;
    return Container(
      decoration: BoxDecoration(
          color: panelColor,
          border: Border.all(
            width: 5,
            color: panelColor,
          ),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(25),
            topRight: const Radius.circular(25),
          ),
          boxShadow: Theme.of(context).backgroundColor == Color(0xffffffff)
              ? [
                  BoxShadow(
                    color: Color(0xffD3D3D3),
                    blurRadius: 5.0,
                  )
                ]
              : null
          /*
                [
                  BoxShadow(
                    color: Colors.blueGrey,
                    blurRadius: 1.0,
                  )
                ],
           */
          ),
      height: MediaQuery.of(context).size.height * 0.35,
      child: Center(
          child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.clear, color: Theme.of(context).hoverColor),
                onPressed: () => Navigator.pop(context),
                splashRadius: 10,
              )
            ],
          ),
          FittedBox(
            child: Text(
              '${widget.markerName}',
              style: TextStyle(
                  color: widget.stopMarker
                      ? Theme.of(context).hoverColor
                      : Colors.blue,
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          BlocBuilder<FusionBloc, FusionState>(
            builder: (context, state) {
              if (state is FusionETALoaded) {
                etaList = state.etas;
                var eta = etaList[0];
                var now = new DateTime.now().toUtc();
                log('TIME NOW IS: $now');
              }
              return Expanded(
                child: !etaList.isNotEmpty ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: 3,
                    itemBuilder: createTiles,
                /*
                children:
                    !etaList.isNotEmpty
                        ? <Widget>[
                              Text(
                                  "Testing",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 25
                                  ),
                              ),
                              Text(
                                "Testing",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25
                                ),),
                              Text("Testing",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25
                                ),),
                            ]
                        : <Widget>[Text('No ETAs calculated')], */
                  ) : Text('No ETAs calculated')
              );
            },
          )
        ],
      )),
    );
  }

  Widget createTiles(BuildContext context, int index){
    var eta;
    return ListTile(
      dense: true,
      title:
          Text(
            "This is a test to see if there is any overflow with the text and "
                "if it wraps around",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20
            ),
          )
    );
  }
}
