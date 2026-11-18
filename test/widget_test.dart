import 'package:flutter_test/flutter_test.dart';
import 'package:new_app/core/validators/form_validators.dart';

void main() {
  group('FormValidators', () {
    test('validates email correctly', () {
      expect(FormValidators.validateEmail(''), 'Email is required');
      expect(FormValidators.validateEmail('invalid'), 'Please enter a valid email');
      expect(FormValidators.validateEmail('test@example.com'), isNull);
    });

    test('validates password correctly', () {
      expect(FormValidators.validatePassword(''), 'Password is required');
      expect(FormValidators.validatePassword('123'), 'Password must be at least 6 characters');
      expect(FormValidators.validatePassword('123456'), isNull);
    });

    test('validates password confirmation correctly', () {
      expect(FormValidators.validateConfirmPassword('', 'secret123'), 'Please confirm your password');
      expect(FormValidators.validateConfirmPassword('mismatch', 'secret123'), 'Passwords do not match');
      expect(FormValidators.validateConfirmPassword('secret123', 'secret123'), isNull);
    });
  });
}
