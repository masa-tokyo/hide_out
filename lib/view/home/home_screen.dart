import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_put/view_models/home_screen_view_model.dart';

import 'components/my_group_part.dart';
import 'components/new_group_part.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeScreenViewModel = Provider.of<HomeScreenViewModel>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: RefreshIndicator(
            onRefresh: () => homeScreenViewModel.getMyGroup(),
            child: Column(
              children: [
                SizedBox(
                  height: 26.0,
                ),
                MyGroupPart(),
                SizedBox(
                  height: 28.0,
                ),
                NewGroupPart(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
