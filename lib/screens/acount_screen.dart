import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../main_drawer.dart';
import '../providers/authprovider.dart';
import '../models/user.dart';

class AcountScreen extends StatefulWidget {
  const AcountScreen({Key key}) : super(key: key);

  @override
  State<AcountScreen> createState() => _AcountScreenState();
}

class _AcountScreenState extends State<AcountScreen> {
  @override
  Widget build(BuildContext context) {
    //User userinfo = fetchUserData(Provider.of<AuthProvider>(context, listen: false).Userid);
    return Scaffold(
      appBar: AppBar(
        title: Text('Acount', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: MainDrawer(),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                "https://pbs.twimg.com/media/FGCpQkBXMAIqA6d.jpg:large",
                              ))),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Text(
                    'OdedKalderon',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 4),
                  Text('odedkalderon@gmail.com',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(15)),
                        alignment: Alignment.center,
                        width: 169,
                        height: 360,
                        child: Text('List of Friends'),
                        //THIS WILL BE CHANGES WITH A SCROLLABLE
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(15)),
                        alignment: Alignment.center,
                        width: 169,
                        height: 360,
                        child: Text('2 week history tasks '),
                        //THIS WILL BE CHANGES WITH A SCROLLABLE
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Container(
                    width: 155,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            Icon(Icons.person_add_alt),
                            SizedBox(
                              width: 16,
                            ),
                            Text('Add A Friend')
                          ],
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
