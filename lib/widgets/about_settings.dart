import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../blocs/theme_bloc/theme_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../pages/settings_page/widgets/../../../widgets/faq_detail.dart';
import '../pages/settings_page/widgets/../../../widgets/privacy_detail.dart';

/// Class: AboutSettings
/// Function: Represents the About section of the Settings Page
class AboutSettings extends StatefulWidget {
  @override
  _AboutSettingsState createState() => _AboutSettingsState();
}

/// Class: _AboutSettingsState
/// Function: Returns the state of the AboutSettings widget
class _AboutSettingsState extends State<AboutSettings> {
//  int devSettings = 0;

  /// Standard build function for the widget
  @override
  Widget build(BuildContext context) {
    var themeBloc = context.watch<ThemeBloc>();
    var theme = themeBloc.state.getTheme;
    var aboutSettingsList = <Widget>[
      ListTile(
        leading: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'FAQ',
              style: TextStyle(color: theme.primaryColor, fontSize: 16),
            ),
            Text(
              'View frequently asked questions',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FaqPage(
                        theme: themeBloc.state,
                      )));
        },
      ),
      ListTile(
        leading: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'GitHub Repo',
              style: TextStyle(color: theme.primaryColor, fontSize: 16),
            ),
            Text(
              'Interested in contributing?',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        onTap: () async {
          var url = 'https://github.com/wtg/Flutter_ShuttleTracker';
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        },
      ),
      ListTile(
        dense: true,
        leading: Text(
          'Privacy Policy',
          style: TextStyle(color: theme.primaryColor, fontSize: 16),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PrivacyPolicyPage(
                        theme: themeBloc.state,
                      )));
        },
      ),
      ListTile(
        leading: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Version',
              style: TextStyle(color: theme.primaryColor, fontSize: 16),
            ),
            Text(
              '1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    ];
    return Column(
      children: <Widget>[
        ListTile(
          dense: true,
          leading: Text(
            'About',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
          ),
        ),
        NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return null;
          },
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: aboutSettingsList.length,
            itemBuilder: (context, index) => aboutSettingsList[index],
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.grey[600],
                height: 4,
                indent: 15.0,
              );
            },
          ),
        )
      ],
    );
  }
}
