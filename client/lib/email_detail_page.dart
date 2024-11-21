import 'package:flutter/material.dart';

class EmailDetailPage extends StatefulWidget {
  final String title;
  final String sender;
  final String date;
  final String content;

  const EmailDetailPage({
    Key? key,
    required this.title,
    required this.sender,
    required this.date,
    required this.content,
  }) : super(key: key);

  @override
  State<EmailDetailPage> createState() => _EmailDetailPageState();
}

class _EmailDetailPageState extends State<EmailDetailPage> {
  bool _showTextField = false;
  final TextEditingController _responseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết email'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.sender,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                widget.date,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.content,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showTextField = true;
                      });
                    },
                    child: const Text('Trả lời'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Chuyển tiếp'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_showTextField)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Nhập phản hồi:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _responseController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Nhập nội dung phản hồi tại đây...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        final response = _responseController.text;
                        if (response.isNotEmpty) {
                          print("Nội dung phản hồi: $response");
                          setState(() {
                            _showTextField = false;
                            _responseController.clear();
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Vui lòng nhập nội dung phản hồi."),
                            ),
                          );
                        }
                      },
                      child: const Text('Gửi'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
