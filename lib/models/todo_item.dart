class Todo {
  String todoId;
  String taskId;
  String text;
  bool isDone;

  Todo(this.todoId, this.taskId, this.text, this.isDone);

  void setTaskId(String newId) {
    this.taskId = newId;
  }
}
