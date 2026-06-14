class AppuUSer {
  String email;
  String paaword;
  String firsrName;
  String lastName;
  String phoneNumber;
  String id;
  String role;
  String isBlocked;

  AppuUSer({
    required this.email,
    required this.paaword,
    required this.firsrName,
    required this.lastName,
    required this.phoneNumber,
    required this.id,
    this.role = 'User',
    this.isBlocked = 'False',
  });
}
