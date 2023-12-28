class Post {
  final String imageUrl;
  final double foodAmount;
  final int feedPoint;
  final int pk;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final double userFoodAmount;
  final int userPk;
  final String createdAt;

  Post({
    required this.imageUrl,
    required this.foodAmount,
    required this.feedPoint,
    required this.pk,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.userFoodAmount,
    required this.userPk,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      imageUrl: json['image'],
      foodAmount: json['food_amount'],
      feedPoint: json['feed_point'],
      pk: json['pk'],
      username: json['user']['username'],
      email: json['user']['email'],
      firstName: json['user']['first_name'],
      lastName: json['user']['last_name'],
      userFoodAmount: json['user']['food_amount'],
      userPk: json['user']['pk'],
      createdAt: json['created_at'],
    );
  }
}
