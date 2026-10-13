import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/presentation/providers/theme_provider.dart';
import 'package:todoapp/presentation/themes/theme.dart';

final containerrenk = const Color.fromARGB(253, 234, 232, 232);

// ignore: must_be_immutable
class Chipapp extends StatefulWidget {
  final Function(String) onchipselected;
  List<String> chiplist;
  final String? selectedValue;

  Chipapp({
    super.key,
    required this.chiplist,
    required this.onchipselected,
    this.selectedValue,
    required bool showCheckmark,
  });

  @override
  State<Chipapp> createState() => _ChipappState();
}

class _ChipappState extends State<Chipapp> {
  List<String> get chiplist => widget.chiplist;
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeprovider = context.watch<ThemeProvider>();
    final bool isdarkmode = themeprovider.isDarkMode;
    return Wrap(
      spacing: MediaQuery.of(context).size.width * 0.04,
      children: List.generate(chiplist.length, (index) {
        final isSelected = chiplist[index] == widget.selectedValue;
        return ChoiceChip(
          label: Text(
            chiplist[index],
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : isdarkmode
                  ? AppTheme.darkGray
                  : AppTheme.darkCard,
            ),
          ),

          selected: isSelected,
          onSelected: (bool selected) {
            if (selected) {
              widget.onchipselected(chiplist[index]);
            }
          },

          shape: StadiumBorder(),
          selectedColor: isdarkmode ? AppTheme.darkGray : AppTheme.buttonColor,
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        );
      }),
    );
  }
}
