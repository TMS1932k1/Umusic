class Genre {
  final String id;
  final String name;

  Genre(
    this.id,
    this.name,
  );

  Genre.fromDataMap(this.id, Map<String, dynamic> map) : name = map['name'];
}
