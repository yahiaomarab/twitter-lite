class PostModel {
  String? name;
  String? uId;
  String? image;
  dynamic date;
  String? postText;
  String? postImage;
  bool? isAccountVerified;

  PostModel(
      {required this.name,
      required this.uId,
      required this.image,
      required this.isAccountVerified,
      required this.postText,
      required this.postImage,
      required this.date});

  factory PostModel.fromJson(Map<String, dynamic>? json) {
    return PostModel(
      name: json!['name'],
      postText: json['postText'],
      postImage: json['postImage'],
      uId: json['uId'],
      image: json['image'],
      date: json['date'],
      isAccountVerified: json['isAccountVerified'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'postText': postText,
      'postImage': postImage,
      'uId': uId,
      'image': image,
      'date': date,
      'isAccountVerified': isAccountVerified
    };
  }
}
