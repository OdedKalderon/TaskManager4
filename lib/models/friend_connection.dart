class FriendConnection {
  String ConnectionId;
  String SendingUserId;
  String RecievingUserId;
  bool Status; //false means didn't answer yet, true means wants to be friends, when decline just delete doc.

  FriendConnection(this.ConnectionId, this.SendingUserId, this.RecievingUserId, this.Status);
}
