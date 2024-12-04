import 'package:flutter/material.dart';
import '../trash_bin/trash_bin_page.dart';
import '../../authentication/account_management_page.dart';
import '../draft_page.dart';
import '../email_detail_page.dart';
import '../home_page.dart';
import '../email_data.dart';

class StarredPage extends StatefulWidget {
  const StarredPage({Key? key}) : super(key: key);

  @override
  State<StarredPage> createState() => _StarredPageState();
}

class _StarredPageState extends State<StarredPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredEmails = [];
  List<Map<String, dynamic>> selectedEmails = []; // Track selected emails

  @override
  void initState() {
    super.initState();
    _filterStarredEmails(); // Show only deleted emails by default
    _searchController.addListener(_filterEmails);
  }

  void _filterStarredEmails() {
    setState(() {
      filteredEmails = emails.where((email) => !email['isDeleted'] && email['isStarred']).toList();
    });
  }

  void _filterEmails() {
    setState(() {
      filteredEmails = emails
          .where((email) =>
      email['isStarred'] &&

          email['title']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _unstarEmail(int id) {
    setState(() {
      // Mark the email as deleted
      final email = emails.firstWhere((email) => email['id'] == id);
      email['isStarred'] = false;

      // Update the filtered list
      _filterEmails();
    });
  }


  void _showEmailOptions(Map<String, dynamic> email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey,
          title: const Text(
            'Cài đặt',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Gắn/Hủy dấu sao', style: TextStyle(color: Colors.white)),
                leading: const Icon(Icons.star, color: Colors.white),
                onTap: () {
                  _unstarEmail(email['id']);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterEmails);
    _searchController.dispose();
    super.dispose();
  }

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

  void _markAsReadEmail(int id){
    setState(() {
      // Mark the email as deleted
      final email = emails.firstWhere((email) => email['id'] == id);
      email['isRead'] = true;

      // Update the filtered list
      _filterEmails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Tìm kiếm...',
            border: InputBorder.none,
          ),
        ),
        actions: [
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Có gắn dấu sao'),
              onTap: () {

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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DraftPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Thùng rác'),
              onTap: () {Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TrashBinPage()),
              );},
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
      body: filteredEmails.isEmpty
          ? const Center(
        child: Text(
          'Không có email gắn dấu sao.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: filteredEmails.length,
        itemBuilder: (context, index) {
          final email = filteredEmails[index];
          final isSelected = selectedEmails.contains(email);
          return ListTile(
            leading: CircleAvatar(
              radius: 30.0, // Adjust size of the avatar
              backgroundImage: NetworkImage(filteredEmails[index]['imgLink']), // Set image from network
              //child: Text('AB'), // Text inside the avatar (optional)
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    filteredEmails[index]['sender'],
                    style: TextStyle(
                        fontSize: 17,
                        color: filteredEmails[index]['isRead'] ? Colors.grey : Colors.black)),
                Text(
                  filteredEmails[index]['time'],
                  style: TextStyle(
                      fontSize: 15,
                      color: filteredEmails[index]['isRead'] ? Colors.grey : Colors.black),
                )
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                filteredEmails[index]['title'] == '' ?
                const Text('(Không có tiêu đề)')
                    : Text(filteredEmails[index]['title'],
                    style: TextStyle(
                        fontSize: 17,
                        color: filteredEmails[index]['isRead'] ? Colors.grey : Colors.black)),
                Text(filteredEmails[index]['content'],
                    style: const TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                filteredEmails[index]['isStarred'] ? Icons.star : Icons.star_border,
                color: filteredEmails[index]['isStarred'] ? Colors.amber : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  filteredEmails[index]['isStarred'] = !filteredEmails[index]['isStarred'];
                  _filterStarredEmails();
                });
              },
            ),
            onLongPress: () => _showEmailOptions(email),
            onTap: () {
              _markAsReadEmail(email['id']);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmailDetailPage(
                    title: filteredEmails[index]['title'],
                    sender: filteredEmails[index]['sender'],
                    date: filteredEmails[index]['time'],
                    content: filteredEmails[index]['content']
                    ,
                  ),
                ),
              );
            },
          );
        },
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
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Người dùng tên',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '0123456789',
                    style: TextStyle(color: Colors.white, fontSize: 14),
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
