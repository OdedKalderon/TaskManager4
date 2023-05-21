import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/main.dart';
import 'package:flutter_complete_guide/models/friend_connection.dart';
import 'package:flutter_complete_guide/providers/authprovider.dart';
import 'package:flutter_complete_guide/providers/socialprovider.dart';
import 'package:provider/provider.dart';

import '../main_drawer.dart';
import '../models/userc.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({Key key}) : super(key: key);

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  void _setConnection(UserC user) {
    Provider.of<SocialProvider>(context, listen: false)
        .addFriendConnection(user.userId);
    setState(() {});
  }

  void _deleteConnection(UserC user) {
    Provider.of<SocialProvider>(context, listen: false).deleteFriendConnection(
        Provider.of<SocialProvider>(context, listen: false)
            .getSpecificConnectionId(
                FirebaseAuth.instance.currentUser.uid, user.userId));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<FriendConnection> allRequests =
        Provider.of<SocialProvider>(context, listen: true)
            .getMyFriendRequests();
    List<FriendConnection> allFriends =
        Provider.of<SocialProvider>(context, listen: true).getFriends();
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
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      List<UserC> searchableUsers =
                          Provider.of<AuthProvider>(context, listen: false)
                              .users;
                      searchableUsers.removeWhere((item) =>
                          item.userId == FirebaseAuth.instance.currentUser.uid);
                      for (FriendConnection connection in allFriends) {
                        searchableUsers.removeWhere((item) =>
                            item.userId ==
                            (Provider.of<AuthProvider>(context, listen: false)
                                    .getSpecificUser(
                                        Provider.of<SocialProvider>(context,
                                                listen: false)
                                            .getSpecificFriend(connection)))
                                .userId);
                      }
                      ;
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
                      return StatefulBuilder(
                        builder: (context, state) {
                          return Padding(
                            padding: EdgeInsets.all(16),
                            child: Container(
                              height: 650,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
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
                                    onChanged: (value) {
                                      state(() {
                                        updateList(value);
                                      });
                                    },
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey.shade300,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide.none),
                                        hintText: 'eg: odedkalderon',
                                        prefixIcon: Icon(Icons.search),
                                        prefixIconColor: Colors.grey.shade600),
                                    textInputAction: TextInputAction.done,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Expanded(
                                      child: displayedList.length == 0
                                          ? Column(
                                              children: [
                                                SizedBox(
                                                  height: 100,
                                                ),
                                                Center(
                                                  child: Text(
                                                    'No result found',
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(
                                              padding: EdgeInsets.all(10),
                                              child: ListView.builder(
                                                itemCount: displayedList.length,
                                                itemBuilder: ((context, index) {
                                                  return Column(
                                                    children: [
                                                      ListTile(
                                                          contentPadding:
                                                              EdgeInsets.all(8),
                                                          title: Text(
                                                            displayedList[index]
                                                                .username,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          leading: CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    displayedList[
                                                                            index]
                                                                        .userProfileUrl),
                                                          ),
                                                          trailing: !Provider.of<
                                                                          SocialProvider>(
                                                                      context,
                                                                      listen:
                                                                          true)
                                                                  .allConnections
                                                                  .contains(Provider.of<
                                                                              SocialProvider>(
                                                                          context,
                                                                          listen:
                                                                              true)
                                                                      .getConnectionById(
                                                                          displayedList[index]
                                                                              .userId)) //doesn't work needs future fixing!!!!!!!!!!!!!!!!!!!!
                                                              ? ElevatedButton(
                                                                  child: Text(
                                                                      'Friend Request'),
                                                                  onPressed:
                                                                      () {
                                                                    _setConnection(
                                                                        displayedList[
                                                                            index]);
                                                                    FocusScope.of(
                                                                            context)
                                                                        .unfocus();
                                                                  },
                                                                )
                                                              : OutlinedButton(
                                                                  child: Text(
                                                                      'Pending Request'),
                                                                  onPressed:
                                                                      () {
                                                                    _deleteConnection(
                                                                        displayedList[
                                                                            index]);
                                                                    FocusScope.of(
                                                                            context)
                                                                        .unfocus();
                                                                  },
                                                                )),
                                                      SizedBox(
                                                        height: 8,
                                                      )
                                                    ],
                                                  );
                                                }),
                                              ),
                                            ))
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    });
              },
            )
          ],
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        drawer: MainDrawer(),
        body: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                  padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
                  child: Text(
                    'Friend Request',
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  )),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              height: 150,
              child: Expanded(
                child: allRequests.length != 0
                    ? ListView.builder(
                        itemCount: allRequests.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              contentPadding: EdgeInsets.all(8),
                              title: Text(
                                Provider.of<AuthProvider>(context)
                                    .getSpecificUser(
                                        allRequests[index].SendingUserId)
                                    .username,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      Provider.of<AuthProvider>(context)
                                          .getSpecificUser(
                                              allRequests[index].SendingUserId)
                                          .userProfileUrl)),
                              trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Provider.of<SocialProvider>(context,
                                                listen: false)
                                            .establishConnection(
                                                allRequests[index]
                                                    .ConnectionId);
                                        allRequests.removeWhere((element) =>
                                            element.ConnectionId ==
                                            allRequests[index].ConnectionId);
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.check),
                                      color: Colors.green,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Provider.of<SocialProvider>(context,
                                                listen: false)
                                            .deleteFriendConnection(
                                                allRequests[index]
                                                    .ConnectionId);
                                        allRequests.removeWhere((element) =>
                                            element.ConnectionId ==
                                            allRequests[index].ConnectionId);
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.close),
                                      color: Colors.red,
                                    )
                                  ]),
                            ),
                          );
                        })
                    : Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 55,
                            ),
                            Container(
                              height: 75,
                              child: Text(
                                'You don\'t have any new \n friend requests :)',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey.shade700),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                  padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
                  child: Text(
                    'Friend List',
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  )),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: allFriends.length == 0
                    ? Column(
                        children: [
                          SizedBox(
                            height: 150,
                          ),
                          Center(
                            child: Text(
                              'You don\'t have any friends yet',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.grey.shade700),
                            ),
                          ),
                        ],
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.9,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 8),
                        primary: false,
                        shrinkWrap: true,
                        itemCount: allFriends.length,
                        itemBuilder: (context, index) {
                          UserC friend =
                              Provider.of<AuthProvider>(context, listen: false)
                                  .getSpecificUser(Provider.of<SocialProvider>(
                                          context,
                                          listen: false)
                                      .getSpecificFriend(allFriends[index]));
                          return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              elevation: 4,
                              shadowColor: Colors.grey.shade100,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                child: Column(children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  CircleAvatar(
                                    radius: 35,
                                    backgroundImage:
                                        NetworkImage(friend.userProfileUrl),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 2),
                                    child: Text(
                                      friend.username,
                                      style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 2),
                                    child: Text(
                                      friend.email,
                                      style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                ]),
                              ));
                        },
                      ))
          ],
        ));
  }
}
