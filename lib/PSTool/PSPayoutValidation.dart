class PSPayoutValidation {
  static String? validate(
    String method,
    String account, {
    String name = '',
    String cpf = '',
    String type = 'Email',
  }) {
    if (account.trim().isEmpty) return 'Please Input Your Account ID';
    if (method == 'PagBank') {
      return email(account) ? null : 'The format you entered is incorrect.';
    }
    if (method != 'Pix') return null;
    if (!RegExp(r'^\d{11}$').hasMatch(cpf.trim()))
      return 'Enter 11-digit CPF number';
    if (name.trim().isEmpty || name.contains('@'))
      return 'Enter the correct name';
    final value = account.trim();
    switch (type) {
      case 'Email':
        return email(value) ? null : 'The format you entered is incorrect.';
      case 'Phone':
        return RegExp(r'^\+55\d{10,11}$').hasMatch(value)
            ? null
            : 'Please enter a valid phone number starting with 55.';
      case 'CPF':
        return RegExp(r'^\d{11}$').hasMatch(value)
            ? null
            : 'Enter 11-digit CPF number';
      case 'EVP':
        return value.length == 36 && value.contains('-')
            ? null
            : 'Enter the correct EVP';
      default:
        return null;
    }
  }

  static bool email(String value) =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value.trim());
}
