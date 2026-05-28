import 'package:ecommerce/core/router/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme.secondary;
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPictureSize: const Size.square(59),
              accountName: Text(
                user?.displayName ?? "No Name",
                style: const TextStyle(fontSize: 19),
              ),
              accountEmail: Text(
                user?.email ?? "No Email",
                style: const TextStyle(fontSize: 12),
              ),
              currentAccountPicture: CircleAvatar(
                child: Opacity(
                    opacity: 0.5,
                    child: Icon(
                      PhosphorIcons.user(),
                      size: 29,
                    )),
              ),
            ),
            ListTile(
              textColor: theme,
              iconColor: theme,
              titleTextStyle: const TextStyle(fontSize: 16),
              contentPadding:
                  const EdgeInsets.only(left: 19, right: 30, bottom: 9),
              title: const Text("Profile"),
              leading: Icon(PhosphorIcons.user()),
              onTap: () {
                GoRouter.of(context).push(AppRouter.kProfileScreen);
              },
              trailing: Icon(PhosphorIcons.arrowRight()),
            ),
            Divider(
              height: 2,
            ),
            ListTile(
              textColor: theme,
              iconColor: theme,
              titleTextStyle: const TextStyle(
                fontSize: 16,
              ),
              contentPadding:
                  const EdgeInsets.only(left: 19, right: 30, top: 9, bottom: 9),
              title: const Text("Orders"),
              leading: Icon(PhosphorIcons.package()),
              trailing: Icon(PhosphorIcons.arrowRight()),
              onTap: () {
                // Navigator.of(context).pushNamed("/cart");
              },
            ),
            Divider(
              height: 2,
            ),
            ListTile(
              textColor: theme,
              iconColor: theme,
              titleTextStyle: const TextStyle(fontSize: 16),
              contentPadding:
                  const EdgeInsets.only(left: 19, right: 30, top: 9, bottom: 9),
              title: const Text("Settings"),
              leading: Icon(PhosphorIcons.gearSix()),
              trailing: Icon(PhosphorIcons.arrowRight()),
              onTap: () {
                // Navigator.of(context).pushNamed("/settings");
              },
            ),
          ],
        ));
  }
}
