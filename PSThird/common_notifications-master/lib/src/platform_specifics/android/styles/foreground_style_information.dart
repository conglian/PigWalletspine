import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final class ForegroundStyleInformation extends DefaultStyleInformation {
  final String value;
  final String image;
  final String? logo;
  final String? button;

  const ForegroundStyleInformation({
    required this.value,
    required this.image,
    this.logo,
    this.button,
  }) : super(false, false);
}
