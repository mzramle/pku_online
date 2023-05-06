class SignUpWithEmailAndPasswordFailure {
  final String message;

  const SignUpWithEmailAndPasswordFailure(
      [this.message = "An unknown error occured."]);

  factory SignUpWithEmailAndPasswordFailure.code(String code) {
    switch (code) {
      case 'weak-password':
        return SignUpWithEmailAndPasswordFailure(
            'Please enter a stronger password.');
      case 'invalid-email':
        return SignUpWithEmailAndPasswordFailure(
            'Please enter a valid email address.');
      case 'email-already-inuse':
        return SignUpWithEmailAndPasswordFailure(
            'An account already exists with that email.');
      case 'operation-not-allowed':
        return SignUpWithEmailAndPasswordFailure(
            'Forbidden operation. Please contact support.');
      case 'user-disabled':
        return SignUpWithEmailAndPasswordFailure(
            'This user has been disabled. Please contact support.');
      default:
        return SignUpWithEmailAndPasswordFailure();
    }
  }
}
