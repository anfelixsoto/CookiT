class Name{
  String name;

  Name({this.name});

  factory Name.fromJson(Map<String, dynamic> json) {
    return new Name(
      name: json['original'],
    );
  }
}