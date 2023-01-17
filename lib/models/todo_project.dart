class TodoProject {
  int id;
  String name;
  int created;
  int deadline;


  TodoProject(this.id, this.name, this.created, this.deadline);

  TodoProject.fromMap(Map<String, dynamic> map)
      : id = map[columnId],
        name = map[columnName],
        created = map[columnCreated],
        deadline = map[columnDeadline];

  Map<String, Object> toMap() => {
        columnId: id,
        columnName: name,
        columnCreated: created,
        columnDeadline: deadline,
      };




  static const String tableName = "TodoProject";
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnCreated = 'created';
  static const String columnDeadline = 'deadline';



  static const String sqlCreate =
      "CREATE TABLE $tableName("
      "$columnId INTEGER PRIMARY KEY,"
      "$columnName TEXT,"
      "$columnCreated INTEGER,"
      "$columnDeadline INTEGER);";
}
