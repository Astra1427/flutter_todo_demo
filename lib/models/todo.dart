class Todo {
  int id;
  String name;
  int projectId;
  int created;
  int deadline;
  int finished;

  Todo(this.id, this.name, this.projectId, this.created, this.deadline,
      this.finished);

  Todo.fromMap(Map<String, dynamic> map)
      : id = map[columnId],
        name = map[columnName],
        projectId = map[columnProjectId],
        created = map[columnCreated],
        deadline = map[columnDeadline],
        finished = map[columnFinished];

  Map<String, Object> toMap() => {
        columnId: id,
        columnName: name,
        columnProjectId: projectId,
        columnCreated: created,
        columnDeadline: deadline,
        columnFinished: finished,
      };

  Todo.copy(Todo todo)
      : id = todo.id,
        name = todo.name,
        projectId = todo.projectId,
        created = todo.created,
        deadline = todo.deadline,
        finished = todo.finished ;

  static const todoFinished = 1;
  static const todoUnfinished = 0;

  static const String tableName = "Todo";
  static const String columnId = "id";
  static const String columnName = "name";
  static const String columnProjectId = "project_id";
  static const String columnCreated = "created";
  static const String columnDeadline = "deadline";
  static const String columnFinished = "finished";

  static const String sqlCreate = "CREATE TABLE $tableName ("
      "$columnId INTEGER PRIMARY KEY,"
      "$columnName TEXT,"
      "$columnProjectId INTEGER,"
      "$columnCreated INTEGER,"
      "$columnDeadline INTEGER,"
      "$columnFinished INTEGER);";
}
