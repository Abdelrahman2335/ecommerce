import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  TextEditingController nameCon = TextEditingController();
  TextEditingController phoneCon = TextEditingController();
  @override
  void dispose() {
    nameCon;
    phoneCon;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 129, 129, 129).withAlpha(140),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(-2, 3),
              ),
              BoxShadow(
                color: const Color.fromARGB(255, 129, 129, 129).withAlpha(140),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(2, -3),
              )
            ],
            color: Colors.white,
          ),
          height: MediaQuery.of(context).size.height * 0.44,
          width: mediaQuery.size.width * 0.90,
          child: Padding(
            padding: const EdgeInsets.all(19.0),
            child: Column(children: [

              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Personal Information",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                ),
              ),
              const Text("Step 1 of 2", style: TextStyle(color: Colors.grey,fontSize: 12)),
              TextField(
                controller: nameCon,
                decoration: InputDecoration(

                  contentPadding:  const EdgeInsets.all(9),
                  hintText: "Full Name",
                ),
              ),Gap(24),
              TextField(
                controller: phoneCon,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  contentPadding:  const EdgeInsets.all(9),
                  icon: Icon(Icons.phone,size: 19,color: Colors.grey,),

                  labelText: "Phone Number",
                  hintText: "+1 (555) 000-0000",
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
