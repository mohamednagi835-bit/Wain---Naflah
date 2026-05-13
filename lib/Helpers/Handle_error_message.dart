String getFirebaseErrorMessage(String code) {
  switch (code) {
    case 'user-not-found':
      return "No account found with this email";

    case 'wrong-password':
      return "Incorrect password";

    case 'email-already-in-use':
      return "This email is already registered";

    case 'weak-password':
      return "Password is too weak";

    case 'invalid-email':
      return "Invalid email format";

    case 'network-request-failed':
      return "No internet connection";

    default:
      return "Something went wrong. Please try again";
  }
}
