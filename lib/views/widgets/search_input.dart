import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(5),
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.grey,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 2,
        ),
        label: const Text(
          'Buscar Ativo ou Local',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
