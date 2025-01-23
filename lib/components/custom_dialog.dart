import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final Widget title;
  final Widget content;
  final VoidCallback? onCancel;
  final VoidCallback onConfirm;
  final String confirmButtonText;
  final String? cancelButtonText;

  const CustomDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.onCancel,
    this.confirmButtonText = 'Confirm',
    this.cancelButtonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white.withOpacity(0.95),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: title,
      content: content,
      actions: [
        if (cancelButtonText != null && onCancel != null)
          TextButton(
            onPressed: onCancel,
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
            child: Text(cancelButtonText!),
          ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            confirmButtonText,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class ConfirmationDialog extends StatelessWidget {
  final Widget title;
  final Widget content;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final String confirmButtonText;
  final String cancelButtonText;

  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
    this.confirmButtonText = 'Confirm',
    this.cancelButtonText = 'Cancel',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: title,
      content: content,
      onConfirm: onConfirm,
      onCancel: onCancel,
      confirmButtonText: confirmButtonText,
      cancelButtonText: cancelButtonText,
    );
  }
}

class AcceptDialog extends StatelessWidget {
  final Widget title;
  final Widget content;
  final VoidCallback onAccept;
  final String acceptButtonText;

  const AcceptDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onAccept,
    this.acceptButtonText = 'OK',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: title,
      content: content,
      onConfirm: onAccept,
      confirmButtonText: acceptButtonText,
      cancelButtonText: null, // Omitting the cancel button
    );
  }
}
