import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../main_drawer.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Social', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: MainDrawer(),
      body: Center(
        child: const Text('Social'),
      ),
    );
  }
}
