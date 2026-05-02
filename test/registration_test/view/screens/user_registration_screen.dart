import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../widgets/user_registration_screen_body.dart';

void main() {
  testWidgets("UserRegistrationScreenBody builds correctly",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: UserRegistrationScreen()),
    );
    await tester.pumpAndSettle();
  });
}

class UserRegistrationScreen extends StatelessWidget {
  const UserRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(PhosphorIcons.signOut()),
          ),
        ],
      ),
      body: UserRegistrationScreenBody(),
    );
  }
}
