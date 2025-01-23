import 'package:flutter/material.dart';

class CustomDropdownFormField<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final String labelText;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  // final Color? dropdownColor;

  const CustomDropdownFormField({
    Key? key,
    required this.items,
    this.value,
    required this.labelText,
    this.onChanged,
    this.validator,
    // this.dropdownColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
