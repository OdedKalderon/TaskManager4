class Task {
  String TaskId;
  String UserId;
  String Name;
  String Description;
  String DateDue;
  bool IsUrgent;

  Task(this.TaskId, this.Name, this.Description, this.DateDue, this.IsUrgent,
      this.UserId);
}
