import 'package:flutter/material.dart';
import 'starred/starred_page.dart';
import 'trash_bin//trash_bin_page.dart';
import '../authentication/account_management_page.dart';
import 'home_page.dart';
import 'email_data.dart';

class DraftPage extends StatefulWidget {
  const DraftPage({Key? key}) : super(key: key);

  @override
  State<DraftPage> createState() => _DraftPageState();
}

class _DraftPageState extends State<DraftPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredEmails = [];
  List<Map<String, dynamic>> selectedEmails = []; // Track selected emails

  @override
  void initState() {
    super.initState();
    _loadDraftEmails();
    _searchController.addListener(_filterEmails);
  }

  void _loadDraftEmails() {
    print(drafts.length);
    setState(() {
      filteredEmails = drafts.where((draft) => draft['title'] != null && draft['title'].isNotEmpty).toList();
    });
  }

  void _filterEmails() {
    setState(() {
      filteredEmails = emails
          .where((email) =>
          email['title']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
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
                title: const Text('Khôi phục thư', style: TextStyle(color: Colors.white)),
                leading: const Icon(Icons.account_tree, color: Colors.white),
                onTap: () {
                  //_restoreDeletedEmail(email['id']);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Xóa vĩnh viễn', style: TextStyle(color: Colors.white)),
                leading: const Icon(Icons.delete_forever, color: Colors.white),
                onTap: () {
                  Navigator.pop(context);
                  //_showConfirmDeleteDialog(email['id']);

                },
              ),
            ],
          ),
        );
      },
    );
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const StarredPage()),
                );
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
          'Không có thư nháp.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: filteredEmails.length,
        itemBuilder: (context, index) {
          final email = filteredEmails[index];
          final isSelected = selectedEmails.contains(email);
          return ListTile(
            leading: const CircleAvatar(
              radius: 30.0, // Adjust size of the avatar
              backgroundImage: NetworkImage('https://avatar.iran.liara.run/public'), // Set image from network
              //child: Text('AB'), // Text inside the avatar (optional)
            ),
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Thư ',
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.red))
                ,
                // Text(
                //   filteredEmails[index]['time'],
                //   style: const TextStyle(
                //       fontSize: 15,
                //       color: Colors.grey),
                // )
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                filteredEmails[index]['title'] == '' ?
                const Text('(Không có tiêu đề)')
                    : Text(filteredEmails[index]['title'],
                    style: const TextStyle(
                        fontSize: 17,
                        color: Colors.grey)),
                Text(filteredEmails[index]['content'].length > 70
                    ? "${filteredEmails[index]['content'].substring(0, 70)}..."
                    : filteredEmails[index]['content'],
                  style: const TextStyle(color: Colors.grey),),
              ],
            ),

            onLongPress: () {_showEmailOptions(email);},
            onTap: () {

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
