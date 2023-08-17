import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  final Function(String) onTextChanged;
  const SearchTextField({super.key, required this.onTextChanged});

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          widget.onTextChanged(value);
        },
        decoration: InputDecoration(
          hintText: 'Pesquisar cotações ...',
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.grey.shade800,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade800,
          ),
        ),
      ),
    );
  }
}
