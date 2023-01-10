// login  exceptions
class UserNotFoundAuthException implements Exception{}

class WorngPasswordAuthException implements Exception{}

// rigester exceptions
class WeakPasswordAuthException implements Exception{}

class EmailAlreadyInUseAuthException implements Exception{}

class InvalidEmailAuthException implements Exception{}


// genaric exceptions
class GenaricAuthException implements Exception{}

class UserNotLoggedInAuthException implements Exception{}