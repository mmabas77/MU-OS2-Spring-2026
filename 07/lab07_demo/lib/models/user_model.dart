/// UserModel mirrors the object used in the Lesson 32 debugging demo.
/// The [points] field is nullable to simulate the real bug: the API returned
/// a JSON payload that did NOT contain the "points" key, causing a null crash.
class UserModel {
  final String email;
  final int? points; // nullable — the API sometimes omits this field

  const UserModel({
    required this.email,
    this.points, // intentionally optional to reproduce the null bug
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] as String,
      // points is absent in the API response — this is the bug from Lesson 32
      points: json['points'] as int?,
    );
  }
}
