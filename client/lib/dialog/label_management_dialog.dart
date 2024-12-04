import 'package:flutter/material.dart';
void showLabelDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const LabelManagementDialog(),
  );
}

class LabelManagementDialog extends StatefulWidget {
  const LabelManagementDialog({super.key});

  @override
  _LabelManagementDialogState createState() => _LabelManagementDialogState();
}

class _LabelManagementDialogState extends State<LabelManagementDialog> {
  final List<String> labels = ['Work', 'Personal', 'Travel', 'Shopping'];
  final TextEditingController _textController = TextEditingController();

  void _addLabel() {
    setState(() {
      labels.add(_textController.text);
    });
    _textController.clear();
    Navigator.of(context).pop();
  }

  void _editLabel(int index) {
    _textController.text = labels[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Label'),
        content: TextField(
          controller: _textController,
          decoration: const InputDecoration(hintText: 'Label Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                labels[index] = _textController.text;
              });
              _textController.clear();
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteLabel(int index) {
    setState(() {
      labels.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Manage Labels'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < labels.length; i++)
              ListTile(
                title: Text(labels[i]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editLabel(i),
                    ),
                    IconButton(
                      icon: const Icon(Icons.toggle_on, color: Colors.blue),
                      onPressed: () => _editLabel(i),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteLabel(i),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: () {
            _textController.clear();
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Add New Label'),
                content: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(hintText: 'Label Name'),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: _addLabel,
                    child: const Text('Add'),
                  ),
                ],
              ),
            );
          },
          child: const Text('Add Label'),
        ),
      ],
    );
  }
}