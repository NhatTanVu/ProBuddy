import 'package:flutter/material.dart';

class ClickableRow extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String subtitle;
  final IconData leadingIcon;

  const ClickableRow({
    super.key,
    required this.onTap,
    required this.title,
    required this.subtitle,
    required this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.white,
              width: 1.0,
            ),
            bottom: BorderSide(
              color: Colors.white,
              width: 1.0,
            ),
          ),
        ),
        child: ListTile(
          leading: Icon(
            leadingIcon,
            color: Colors.white,
            size: 35,
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
