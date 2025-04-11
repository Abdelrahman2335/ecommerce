import 'package:ecommerce/presentation/provider/item_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';


class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme.secondary;
    return Consumer<ItemViewModel>(
        builder: (BuildContext context, provider, Widget? child) {
      return Drawer(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPictureSize: Size.square(59),
                accountName: Text(
                  provider.name ?? "No Name",
                  style: TextStyle(fontSize: 19),
                ),
                accountEmail: Text(
                  provider.user?.email.toString() ?? "No Email",
                  style: TextStyle(fontSize: 12),
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
                iconColor:theme,
                titleTextStyle: const TextStyle(
                    fontSize: 16),
                contentPadding:
                    const EdgeInsets.only(left: 19, right: 30, bottom: 9),
                title: const Text("Profile"),
                leading: Icon(PhosphorIcons.user()),
                onTap: () {
                  Navigator.of(context).pushNamed("/profile");
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
                    fontSize: 16, ),
                contentPadding: const EdgeInsets.only(
                    left: 19, right: 30, top: 9, bottom: 9),
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
                titleTextStyle: const TextStyle(
                    fontSize: 16),
                contentPadding: const EdgeInsets.only(
                    left: 19, right: 30, top: 9, bottom: 9),
                title: const Text("Settings"),
                leading: Icon(PhosphorIcons.gearSix()),
                trailing: Icon(PhosphorIcons.arrowRight()),
                onTap: () {
                  // Navigator.of(context).pushNamed("/settings");
                },
              ),
            ],
          ));
    });
  }
}
