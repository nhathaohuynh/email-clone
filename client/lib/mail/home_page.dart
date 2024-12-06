import 'dart:math';
import 'package:flutter/material.dart';
import 'package:client/mail/starred/starred_page.dart';
import 'package:client/authentication/account_management_page.dart';
import 'package:client/mail/draft_page.dart';
import 'package:client/mail/email_detail_page.dart';
import 'package:client/dialog/label_management_dialog.dart';
import 'package:client/mail/trash_bin/trash_bin_page.dart';
import 'package:client/mail/email_data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isComposingEmail = false;
  bool _isSearching = false;
  bool _showStarredEmails = false;

  late Map<String, dynamic> userData;

  final TextEditingController recipientController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> filteredEmails = [];
  List<Map<String, dynamic>> selectedEmails = []; // Track selected emails

  Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      '_id': prefs.getString('_id') ?? '',
      'accessToken': prefs.getString('accessToken') ?? '',
      'email': prefs.getString('email') ?? '',
      'avatar': prefs.getString('avatar') ?? '',
      'full_name': prefs.getString('full_name') ?? '',
      'phone': prefs.getString('phone') ?? '',
    };
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
    filteredEmails = emails.where((email) => !email['isDeleted']).toList();
    _searchController.addListener(_filterEmails);
    userData = getUserData() as Map<String, dynamic>;
  }


  void _filterEmails() {
    setState(() {
      filteredEmails = emails
          .where((email) =>
      !email['isDeleted'] && // Filter out deleted emails
          email['title']// Or the field you want to search
              .toLowerCase()
              .contains(_searchController.text.toLowerCase())) // Match search text
          .toList();
    });
  }

  void _deleteEmail(int id) {
    setState(() {
      // Mark the email as deleted
      final email = emails.firstWhere((email) => email['id'] == id);
      email['isDeleted'] = true;

      // Update the filtered list
      _filterEmails();
    });

    Fluttertoast.showToast(
      msg: "Đã xóa thư",
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.white,
      gravity: ToastGravity.BOTTOM, // Show at the bottom
      timeInSecForIosWeb: 3,
    );
  }


  void _showEmailOptions(Map<String, dynamic> email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey,

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Xóa thư', style: TextStyle(color: Colors.white)),
                leading: const Icon(Icons.delete, color: Colors.white),
                onTap: () {
                  _deleteEmail(email['id']);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title:
                email['isRead'] ?
                const Text('Đánh dấu là chưa đọc', style: TextStyle(color: Colors.white))
                    : const Text('Đánh dấu là đã đọc', style: TextStyle(color: Colors.white)),
                leading: email['isRead'] ?
                const Icon(Icons.mark_email_unread, color: Colors.white)
                    : const Icon(Icons.mark_email_read, color: Colors.white),
                onTap: () {
                  if(email['isRead']){
                    _markAsUnreadEmail(email['id']);
                  }else {
                    _markAsReadEmail(email['id']);
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: email['isStarred'] ? const Text('Hủy dấu sao', style: TextStyle(color: Colors.white)): const Text('Gắn dấu sao', style: TextStyle(color: Colors.white)),
                leading: const Icon(Icons.star, color: Colors.white),
                onTap: () {
                  setState(() {
                    email['isStarred'] = !email['isStarred'];
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
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

  void _markAsUnreadEmail(int id){
    setState(() {
      // Mark the email as deleted
      final email = emails.firstWhere((email) => email['id'] == id);
      email['isRead'] = false;

      // Update the filtered list
      _filterEmails();
    });
  }

  void saveDraft() {
    final String recipient = recipientController.text;
    final String title = subjectController.text;
    final String content = contentController.text;

    final draft = {
      'id': Random().nextInt(9999),
      'receiver': recipient,
      'title': title,
      'content': content
    };

    drafts.add(draft);

    Fluttertoast.showToast(
      msg: "Đã lưu vào thư nháp",
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.white,
      gravity: ToastGravity.BOTTOM, // Show at the bottom
      timeInSecForIosWeb: 3,
    );
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
            FutureBuilder<Map<String, dynamic>>(
              future: getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading user data'));
                } else if (snapshot.hasData) {
                  final userData = snapshot.data!;
                  return UserInfoSection(userData: userData);
                } else {
                  return const Center(child: Text('No user data'));
                }
              },
            ),
            UserInfoSection(userData: userData,),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StarredPage()));
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
              onTap: () {
                showLabelDialog(context);
              },
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
          ),
          if (_isComposingEmail)
            GestureDetector(
              onTap: () {
                saveDraft();
                setState(() {
                  _isComposingEmail = false;
                });
              },
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          Center(
            child: Visibility(
              visible: _isComposingEmail,
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
  final Map<String, dynamic> userData;
  const UserInfoSection({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.blueGrey,
      child: Column(
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage:
                  NetworkImage('https://example.com/avatar.jpg'),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData['full_name'] ?? 'Unknown user',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  const Text(
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
