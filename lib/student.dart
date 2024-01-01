class Student {
  final int id;
  final String first_name;
  final String last_name;
  final int age;

  const Student(
      {required this.id,
      required this.first_name,
      required this.last_name,
      required this.age});

  // Conversion d'un eleve en Map. Les cles correspondent aux noms dans colones dans la base de donnees
  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'first_name' : first_name,
      'last_name' : last_name,
      'age' : age,
    };
  }

  @override
  String toString() {
    return 'Student{id: $id, first_name: $first_name, last_name: $last_name, age: $age}';
  }
}
