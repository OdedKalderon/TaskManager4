import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/models/friend_connection.dart';

class SocialProvider with ChangeNotifier {
  List<FriendConnection> _connections = [];

  List<FriendConnection> get allConnections {
    return [..._connections];
  }

  //input: connection's data
  //output: the id of the connection that has that specific data.
  String getSpecificConnectionId(String senderId, String recieverId) {
    for (int i = 0; i < _connections.length; i++) {
      if (_connections[i].SendingUserId == senderId && _connections[i].RecievingUserId == recieverId) {
        return _connections[i].ConnectionId;
      }
    }
    return null;
  }

  //input: connection id
  //outhput: returns the whole instance (including the data) of the connection with that specific id
  //         *the fake is for a check in another file if it exists
  FriendConnection getConnectionById(String userId) {
    for (int i = 0; i < _connections.length; i++) {
      if (_connections[i].SendingUserId == FirebaseAuth.instance.currentUser.uid && _connections[i].RecievingUserId == userId) {
        return _connections[i];
      }
    }
    return FriendConnection('fake', 'fake', 'fake', false);
  }

  //input: connection
  //outhput: returns the id of the other user in that connection that is not the user signed in.
  String getSpecificFriend(FriendConnection connection) {
    if (connection.RecievingUserId == FirebaseAuth.instance.currentUser.uid) {
      return connection.SendingUserId;
    } else {
      return connection.RecievingUserId;
    }
  }

  //input: a users id
  //output: creates and adds a connection from the user signed in tothe user with the inputed id
  //in both database and local memory
  void addFriendConnection(String RecieverId) async {
    await FirebaseFirestore.instance
        .collection('friend_connections')
        .add({'SendingUserId': FirebaseAuth.instance.currentUser.uid, 'RecievingUserId': RecieverId, 'Status': false}).then((DocumentReference doc) {
      _connections.add(FriendConnection(doc.id, FirebaseAuth.instance.currentUser.uid, RecieverId, false));
    });
    notifyListeners();
  }

  //input: connection's id
  //output: sets the connection staus to true (the 2 users are now friends) in both database and local memory
  void establishConnection(String ConnectionId) async {
    await FirebaseFirestore.instance.collection('friend_connections').doc(ConnectionId).update({'Status': true});
    (_connections.firstWhere((element) => element.ConnectionId == ConnectionId)).Status = true;
    notifyListeners();
  }

  //input: connection's id
  //output: deletes the connection from both database and local memory
  void deleteFriendConnection(String connectionId) async {
    await FirebaseFirestore.instance.collection('friend_connections').doc(connectionId).delete();
    _connections.removeWhere((element) => element.ConnectionId == connectionId);
    notifyListeners();
  }

  //input: none
  //output: returns a list of users connection that have been aprooved while one
  //        of the 2 users in the connection is the user signed in
  List<FriendConnection> getFriends() {
    List<FriendConnection> requests = [];
    for (FriendConnection connection in _connections) {
      if (connection.Status == true &&
          (connection.RecievingUserId == FirebaseAuth.instance.currentUser.uid ||
              connection.SendingUserId == FirebaseAuth.instance.currentUser.uid)) {
        requests.add(connection);
      }
    }
    return requests;
  }

  //input: none
  //output: returns a list of users connection that have not been aprooved yet
  //        by the recieving user (which is the user that is sigend in)
  List<FriendConnection> getMyFriendRequests() {
    List<FriendConnection> requests = [];
    for (FriendConnection connection in _connections) {
      if (connection.Status == false && connection.RecievingUserId == FirebaseAuth.instance.currentUser.uid) {
        requests.add(connection);
      }
    }
    return requests;
  }

  //input: none
  //output: adds to a local memory list all users connections from database
  Future<void> fetchConnectionData() async {
    _connections = [];
    await FirebaseFirestore.instance.collection('friend_connections').get().then(
      (QuerySnapshot value) {
        value.docs.forEach(
          (result) {
            _connections.add(FriendConnection(
              result.id,
              result["SendingUserId"],
              result["RecievingUserId"],
              result["Status"],
            ));
          },
        );
      },
    );
    notifyListeners();
  }
}
