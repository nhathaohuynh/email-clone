import 'package:flutter/material.dart';
import 'account_management_page.dart';
import 'email_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isComposingEmail = false;
  bool _isSearching = false;
  bool _showStarredEmails = false;

  final TextEditingController recipientController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> emails = List.generate(
    20,
    (index) => {'title': 'Tiêu đề email $index', 'isStarred': false},
  );

  List<Map<String, dynamic>> filteredEmails = [];

  void _showNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Thông báo',
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNotificationItem('10 phút trước'),
              const Divider(color: Colors.grey),
              _buildNotificationItem('23 giờ trước'),
              const Divider(color: Colors.grey),
              _buildNotificationItem('3 ngày trước'),
              const Divider(color: Colors.grey),
              _buildNotificationItem('3 ngày trước'),
              const Divider(color: Colors.grey),
              _buildNotificationItem('5 ngày trước'),
              const Divider(color: Colors.grey),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Xem thông báo trước đó',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        time,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    filteredEmails = emails;
    _searchController.addListener(_filterEmails);
  }

  void _filterEmails() {
    setState(() {
      if (_showStarredEmails) {
        filteredEmails = emails.where((email) => email['isStarred']).toList();
      } else {
        filteredEmails = emails
            .where((email) => email['title']
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterEmails);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm...',
                  border: InputBorder.none,
                ),
                autofocus: true,
              )
            : const Text('Hộp thư'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: _showNotifications,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserInfoSection(),
            ListTile(
              leading: const Icon(Icons.inbox),
              title: const Text('Hộp thư đến'),
              onTap: () {
                setState(() {
                  _showStarredEmails = false;
                  filteredEmails = emails;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Có gắn dấu sao'),
              onTap: () {
                setState(() {
                  _showStarredEmails = true;
                  filteredEmails =
                      emails.where((email) => email['isStarred']).toList();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.snooze),
              title: const Text('Đã tạm ẩn'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.send),
              title: const Text('Đã gửi'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.drafts),
              title: const Text('Thư nháp'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Thùng rác'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.label),
              title: const Text('Quản lý nhãn'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Cài đặt'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ListView.builder(
              itemCount: filteredEmails.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(filteredEmails[index]['title']),
                  subtitle: const Text('Đoạn trích nội dung email...'),
                  trailing: IconButton(
                    icon: Icon(
                      filteredEmails[index]['isStarred']
                          ? Icons.star
                          : Icons.star_border,
                      color: filteredEmails[index]['isStarred']
                          ? Colors.amber
                          : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        filteredEmails[index]['isStarred'] =
                            !filteredEmails[index]['isStarred'];
                      });
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmailDetailPage(
                          title: filteredEmails[index]['title'],
                          sender: 'Người gửi mẫu',
                          date: 'Hôm nay, 10:00 AM',
                          content:
                              'Nội dung chi tiết của ${filteredEmails[index]['title']}',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (_isComposingEmail)
            Center(
              child: Container(
                width: 500,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Thư mới',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.minimize),
                              onPressed: () {
                                setState(() {
                                  _isComposingEmail = false;
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  _isComposingEmail = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: recipientController,
                      decoration: const InputDecoration(
                        labelText: 'Người nhận',
                        suffixIcon: Icon(Icons.arrow_drop_down),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Tiêu đề',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: contentController,
                      maxLines: 10,
                      decoration: const InputDecoration(
                        hintText: 'Nội dung',
                        border: InputBorder.none,
                      ),
                    ),
                    const Divider(),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Gửi'),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.attach_file),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.insert_emoticon),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.image),
                          onPressed: () {},
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isComposingEmail = true;
          });
        },
        child: const Icon(Icons.create),
      ),
    );
  }
}

class UserInfoSection extends StatelessWidget {
  const UserInfoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.blueGrey,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      NetworkImage('https://example.com/avatar.jpg'),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Người dùng tên',
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '0123456789',
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blueGrey),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AccountManagementPage()),
                );
              },
              child: const Text(
                'Quản lý tài khoản',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
