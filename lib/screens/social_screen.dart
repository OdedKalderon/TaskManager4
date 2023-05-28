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
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../main_drawer.dart';
import '../models/userc.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({Key key}) : super(key: key);

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  //(provider function)
  void _setConnection(UserC user) {
    Provider.of<SocialProvider>(context, listen: false).addFriendConnection(user.userId);
    setState(() {});
  }

  //input: user instance
  //output: takes the connection between the user inputted and the user signed in and deletes it (provider function)
  void _deleteConnection(UserC user) {
    Provider.of<SocialProvider>(context, listen: false).deleteFriendConnection(
        Provider.of<SocialProvider>(context, listen: false).getSpecificConnectionId(FirebaseAuth.instance.currentUser.uid, user.userId));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<FriendConnection> allRequests = Provider.of<SocialProvider>(context, listen: true).getMyFriendRequests();
    List<FriendConnection> allFriends = Provider.of<SocialProvider>(context, listen: true).getFriends();
    return Scaffold(
        appBar: AppBar(
          title: Row(children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: AssetImage('lib/images/logo.jpg'))),
            ),
            SizedBox(width: 10),
            Text('Social', style: GoogleFonts.quicksand(fontWeight: FontWeight.w600)),
          ]),
          actions: [
            IconButton(
              icon: Icon(
                Icons.search,
                size: 26,
              ),
              onPressed: () {
                bottomSheetUsers(context, allFriends, allRequests);
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
                    style: GoogleFonts.quicksand(color: Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 15),
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
                          UserC sender = Provider.of<AuthProvider>(context).getSpecificUser(allRequests[index].SendingUserId);
                          return Card(
                            child: ListTile(
                              contentPadding: EdgeInsets.all(8),
                              title: Text(
                                sender.username,
                                style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                              ),
                              leading: CircleAvatar(backgroundImage: NetworkImage(sender.userProfileUrl)),
                              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                                IconButton(
                                  //:this fucntion sets the 2 user friend connection Status to true (also removes it from the friedn requests list)
                                  onPressed: () {
                                    setState(() {
                                      Provider.of<SocialProvider>(context, listen: false).establishConnection(allRequests[index].ConnectionId);
                                      allRequests.removeWhere((element) => element.ConnectionId == allRequests[index].ConnectionId);
                                    });
                                  },
                                  icon: Icon(Icons.check),
                                  color: Colors.green,
                                ),
                                IconButton(
                                  //:this fucntion deletes the 2 user friend connection (also removes it from the friedn requests list)
                                  onPressed: () {
                                    setState(() {
                                      Provider.of<SocialProvider>(context, listen: false).deleteFriendConnection(allRequests[index].ConnectionId);
                                      allRequests.removeWhere((element) => element.ConnectionId == allRequests[index].ConnectionId);
                                    });
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
                                style: GoogleFonts.quicksand(fontSize: 20, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
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
                    style: GoogleFonts.quicksand(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
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
                              style: GoogleFonts.quicksand(fontSize: 20, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      )
                    : Scrollbar(
                        child: Container(
                          height: 420,
                          child: GridView.builder(
                            physics: ScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.9,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                            ),
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 8),
                            shrinkWrap: true,
                            itemCount: allFriends.length,
                            itemBuilder: (context, index) {
                              //gets the instance of the user that isn't the signed in one in the 2 users friend connection
                              UserC friend = Provider.of<AuthProvider>(context, listen: false)
                                  .getSpecificUser(Provider.of<SocialProvider>(context, listen: false).getSpecificFriend(allFriends[index]));
                              return Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  elevation: 4,
                                  shadowColor: Colors.grey.shade100,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                                    child: Column(children: [
                                      Container(
                                        height: 30,
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                            onPressed: () {
                                              //defined down this file
                                              deleteFriend(context, allFriends, index);
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              size: 20,
                                              color: Colors.red.shade700,
                                            )),
                                      ),
                                      CircleAvatar(
                                        radius: 35,
                                        backgroundImage: NetworkImage(friend.userProfileUrl),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 2),
                                        child: Text(
                                          friend.username,
                                          style: GoogleFonts.quicksand(color: Colors.grey.shade700, fontWeight: FontWeight.bold, fontSize: 18),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 2),
                                        child: Text(
                                          friend.email,
                                          style: GoogleFonts.quicksand(color: Colors.grey.shade700, fontWeight: FontWeight.bold, fontSize: 12),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 22,
                                      ),
                                    ]),
                                  ));
                            },
                          ),
                        ),
                      ))
          ],
        ));
  }

  //input: context of page, a list of all established friend connections, index of gridview item (up this file)
  //output: shows a dialog on screen (via context) asking the user for final aprooval
  //        to delete the friend (user) apreaing in that gridview item (with the inputted index)
  deleteFriend(BuildContext context, List<FriendConnection> allFriends, int index) async {
    showDialog(
        context: context,
        builder: ((ctx) => AlertDialog(
              title: Text('Delete Friend'),
              content: Text(
                'WARNING: This action will permanently delete this user from your friend list',
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                ),
                TextButton(
                  child: Text(
                    'Delete',
                    style: GoogleFonts.quicksand(color: Colors.red.shade800),
                  ),
                  onPressed: () async {
                    //provider method
                    await Provider.of<SocialProvider>(context, listen: false).deleteFriendConnection(allFriends[index].ConnectionId);
                    Navigator.of(ctx).pop(true);
                  },
                )
              ],
            )));
  }

  //shows a bottom sheet with a searchbar, to search for users that you friend request.
  Future<dynamic> bottomSheetUsers(BuildContext context, List<FriendConnection> allFriends, List<FriendConnection> allRequests) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          //sets a searchebale list of users. removes yourself, all established friend connections, and all friend requests.
          List<UserC> searchableUsers = Provider.of<AuthProvider>(context, listen: false).users;
          searchableUsers.removeWhere((item) => item.userId == FirebaseAuth.instance.currentUser.uid);
          for (FriendConnection connection in allFriends) {
            searchableUsers.removeWhere((item) =>
                item.userId ==
                (Provider.of<AuthProvider>(context, listen: false)
                        .getSpecificUser(Provider.of<SocialProvider>(context, listen: false).getSpecificFriend(connection)))
                    .userId);
          }
          for (FriendConnection connection in allRequests) {
            searchableUsers.removeWhere((item) =>
                item.userId ==
                (Provider.of<AuthProvider>(context, listen: false)
                        .getSpecificUser(Provider.of<SocialProvider>(context, listen: false).getSpecificFriend(connection)))
                    .userId);
          }
          ;
          List<UserC> displayedList = List.from(searchableUsers);

          //input: String value
          //output: takes the string valuse inputted from the textfield searchbar and constantly updates the searchable useres according to it.
          void updateList(String value) {
            setState(() {
              displayedList = searchableUsers.where((element) => element.username.toLowerCase().contains(value.toLowerCase())).toList();
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
                        style: GoogleFonts.quicksand(color: Colors.grey.shade600, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        onChanged: (value) {
                          state(() {
                            updateList(value); //defined up this file
                          });
                        },
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
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
                                        style: GoogleFonts.quicksand(fontSize: 22, fontWeight: FontWeight.bold),
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
                                              contentPadding: EdgeInsets.all(8),
                                              title: Text(
                                                displayedList[index].username,
                                                style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                                              ),
                                              leading: CircleAvatar(
                                                backgroundImage: NetworkImage(displayedList[index].userProfileUrl),
                                              ),
                                              //check if the user[index] has already a pending request connection,
                                              //if yes then button switches to pending with a function to delete the connection
                                              //if no then button stays as send request and it's function sets a connection (Status: false)
                                              trailing: !Provider.of<SocialProvider>(context, listen: true).allConnections.contains(
                                                      Provider.of<SocialProvider>(context, listen: true)
                                                          .getConnectionById(displayedList[index].userId))
                                                  ? ElevatedButton(
                                                      child: Text('Friend Request'),
                                                      onPressed: () {
                                                        _setConnection(displayedList[index]); //defined up this file
                                                        FocusScope.of(context).unfocus();
                                                      },
                                                    )
                                                  : OutlinedButton(
                                                      child: Text('Pending Request'),
                                                      onPressed: () {
                                                        _deleteConnection(displayedList[index]); //defined up this file
                                                        FocusScope.of(context).unfocus();
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
  }
}
