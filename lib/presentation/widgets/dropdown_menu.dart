import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/presentation/providers/dropdown_provider.dart';

const List<String> categorylist = <String>['Work', 'School', 'Self'];

class DropdownMenuExample extends StatefulWidget {
  const DropdownMenuExample({super.key});

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

typedef MenuEntry = DropdownMenuEntry<String>;

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  @override
  Widget build(BuildContext context) {
    final dropdownprovider = context.watch<DropdownProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12), // kenarlardan boşluk

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(dropdownprovider.selectedvalue ?? 'Category'),
          PopupMenuButton<String>(
            color: Theme.of(context).colorScheme.surfaceContainer,
            icon: const Icon(Icons.arrow_drop_down),
            onSelected: (String value) {
              context.read<DropdownProvider>().setCategory(value);
            },
            itemBuilder: (BuildContext context) {
              return categorylist.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
    );
  }
}
