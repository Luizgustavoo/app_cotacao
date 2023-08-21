import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  final TextEditingController controller;
  final Function(BuildContext, int, String) onSearchPressed;

  const SearchTextField(
      {super.key, required this.controller, required this.onSearchPressed});

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: widget.controller,
        onSubmitted: (query) {
          widget.onSearchPressed(context, 1, query);
        },
        decoration: InputDecoration(
          hintText: 'Pesquisar cotações ...',
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.grey.shade800,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              widget.onSearchPressed(context, 1, widget.controller.text);
            },
            icon: const Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}
