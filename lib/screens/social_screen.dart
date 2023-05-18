import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/main.dart';
import 'package:flutter_complete_guide/providers/authprovider.dart';
import 'package:provider/provider.dart';

import '../main_drawer.dart';
import '../models/userc.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({Key key}) : super(key: key);

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Social',
              style: TextStyle(fontWeight: FontWeight.w600)),
          actions: [
            IconButton(
              icon: Icon(
                Icons.search,
                size: 26,
              ),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      List<UserC> searchableUsers =
                          Provider.of<AuthProvider>(context, listen: false)
                              .users;
                      searchableUsers.removeWhere((item) =>
                          item.userId == FirebaseAuth.instance.currentUser.uid);
                      List<UserC> displayedList = List.from(searchableUsers);
                      void updateList(String value) {
                        setState(() {
                          displayedList = searchableUsers
                              .where((element) => element.username
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      }

                      ;
                      return Scaffold(
                          body: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Search for a user',
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              onChanged: (value) => updateList(value),
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade300,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none),
                                  hintText: 'eg: odedkalderon',
                                  prefixIcon: Icon(Icons.search),
                                  prefixIconColor: Colors.grey.shade600),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                                child: displayedList.length == 0
                                    ? Center(
                                        child: Text(
                                          'No result found',
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: displayedList.length,
                                        itemBuilder: ((context, index) {
                                          return ListTile(
                                            contentPadding: EdgeInsets.all(8),
                                            title: Text(
                                              displayedList[index].username,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            leading: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  displayedList[index]
                                                      .userProfileUrl),
                                            ),
                                          );
                                        }),
                                      ))
                          ],
                        ),
                      ));
                    });
              },
            )
          ],
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        drawer: MainDrawer(),
        body: Column(
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
                child: Text(
                  'Friend Request',
                  style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                )),
          ],
        ));
  }
}
