enum MessageRole {
  user,
  assistant,
  system;

  @override
  String toString() {
    return name;
  }

  static MessageRole fromString(String value) {
    return MessageRole.values.firstWhere(
      (role) => role.toString() == value,
      orElse: () => MessageRole.user,
    );
  }
}
