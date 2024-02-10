import 'package:flutter/material.dart';
import 'package:vootday_admin/config/configs.dart';

Widget buildTextLock(BuildContext context, String label, String value,
    TextEditingController controller) {
  final Size size = MediaQuery.of(context).size;

  return ConstrainedBox(
    constraints: BoxConstraints(maxWidth: size.width / 2.2),
    child: Padding(
      padding: const EdgeInsets.all(4),
      child: TextField(
        controller: TextEditingController(text: value),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54),
          fillColor: Colors.grey[300],
          filled: true,
          border: const OutlineInputBorder(),
          disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        enabled: false,
        style: const TextStyle(color: Colors.black54),
      ),
    ),
  );
}

Widget buildTextField(
    BuildContext context, String label, TextEditingController controller) {
  final Size size = MediaQuery.of(context).size;

  return ConstrainedBox(
    constraints: BoxConstraints(maxWidth: size.width / 2.2),
    child: Padding(
      padding: const EdgeInsets.all(4),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          fillColor: white,
          filled: true,
          border: const OutlineInputBorder(),
        ),
      ),
    ),
  );
}

Widget buildTextFieldCaption(
    BuildContext context, String label, TextEditingController controller) {
  final Size size = MediaQuery.of(context).size;

  return ConstrainedBox(
    constraints: BoxConstraints(maxWidth: size.width / 2.2),
    child: Padding(
      padding: const EdgeInsets.all(4),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          fillColor: white,
          filled: true,
          border: const OutlineInputBorder(),
        ),
      ),
    ),
  );
}

Widget buildDateSelector(
    BuildContext context, String label, TextEditingController controller) {
  final Size size = MediaQuery.of(context).size;

  return ConstrainedBox(
    constraints: BoxConstraints(maxWidth: size.width / 2.2),
    child: Padding(
      padding: const EdgeInsets.all(4),
      child: GestureDetector(
        onTap: () {
          selectDate(context, controller);
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.black),
              fillColor: white,
              filled: true,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ),
    ),
  );
}

void selectDate(
  BuildContext context,
  TextEditingController controller,
) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2015, 8),
    lastDate: DateTime(2101),
  );
  if (picked != null && picked != DateTime.now()) {
    controller.text = picked.toString();
  }
}
