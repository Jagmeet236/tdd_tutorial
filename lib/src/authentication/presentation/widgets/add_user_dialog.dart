import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_tutorial/src/authentication/presentation/cubit/authentication/authentication_cubit.dart';

class AddUserDialog extends StatelessWidget {
  const AddUserDialog({
    Key? key,
    required this.nameController,
  }) : super(key: key);
  final TextEditingController nameController;
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                )),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'username',
                    hintText: 'Enter Your Name..',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      final name = nameController.text.trim();
                      const avatar =
                          "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/406.jpg";
                      context.read<AuthenticationCubit>().createUser(
                          createdAt: DateTime.now().toString(),
                          name: name,
                          avatar: avatar);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Create User'))
              ],
            )),
      ),
    );
  }
}
