class Artist {
  final String id;
  final String name;
  final String urlImage;

  Artist(
    this.id,
    this.name,
    this.urlImage,
  );

  Artist.fromDataMap(this.id, Map<String, dynamic> map)
      : name = map['name'],
        urlImage = map['image'];
}
