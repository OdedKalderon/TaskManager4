import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/models/friend_connection.dart';

class SocialProvider with ChangeNotifier {
  List<FriendConnection> _connections = [];

  List<FriendConnection> get allConnections {
    return [..._connections];
  }

  String getSpecificConnectionId(String senderId, String recieverId) {
    for (int i = 0; i < _connections.length; i++) {
      if (_connections[i].SendingUserId == senderId &&
          _connections[i].RecievingUserId == recieverId) {
        return _connections[i].ConnectionId;
      }
    }
    return null;
  }

  FriendConnection getConnectionById(String userId) {
    for (int i = 0; i < _connections.length; i++) {
      if (_connections[i].SendingUserId ==
              FirebaseAuth.instance.currentUser.uid &&
          _connections[i].RecievingUserId == userId) {
        return _connections[i];
      }
    }
    return FriendConnection('fake', 'fake', 'fake', false);
  }

  String getSpecificFriend(FriendConnection connection) {
    if (connection.RecievingUserId == FirebaseAuth.instance.currentUser.uid) {
      return connection.SendingUserId;
    } else {
      return connection.RecievingUserId;
    }
  }

  void addFriendConnection(String RecieverId) async {
    await FirebaseFirestore.instance.collection('friend_connections').add({
      'SendingUserId': FirebaseAuth.instance.currentUser.uid,
      'RecievingUserId': RecieverId,
      'Status': false
    }).then((DocumentReference doc) {
      _connections.add(FriendConnection(
          doc.id, FirebaseAuth.instance.currentUser.uid, RecieverId, false));
    });
  }

  void establishConnection(String ConnectionId) async {
    await FirebaseFirestore.instance
        .collection('friend_connections')
        .doc(ConnectionId)
        .update({'Status': true});
  }

  void deleteFriendConnection(String connectionId) async {
    await FirebaseFirestore.instance
        .collection('friend_connections')
        .doc(connectionId)
        .delete();
    _connections.removeWhere((element) => element.ConnectionId == connectionId);
  }

  List<FriendConnection> getFriends() {
    List<FriendConnection> requests = [];
    for (FriendConnection connection in _connections) {
      if (connection.Status == true &&
          (connection.RecievingUserId ==
                  FirebaseAuth.instance.currentUser.uid ||
              connection.SendingUserId ==
                  FirebaseAuth.instance.currentUser.uid)) {
        requests.add(connection);
      }
    }
    return requests;
  }

  List<FriendConnection> getMyFriendRequests() {
    List<FriendConnection> requests = [];
    for (FriendConnection connection in _connections) {
      if (connection.Status == false &&
          connection.RecievingUserId == FirebaseAuth.instance.currentUser.uid) {
        requests.add(connection);
      }
    }
    return requests;
  }

  Future<void> fetchConnectionData() async {
    _connections = [];
    await FirebaseFirestore.instance
        .collection('friend_connections')
        .get()
        .then(
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
