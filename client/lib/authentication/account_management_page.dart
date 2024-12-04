import 'package:flutter/material.dart';

class AccountManagementPage extends StatefulWidget {
  const AccountManagementPage({Key? key}) : super(key: key);

  @override
  _AccountManagementPageState createState() => _AccountManagementPageState();
}

class _AccountManagementPageState extends State<AccountManagementPage> {
  final TextEditingController _nameController =
      TextEditingController(text: 'Nguyễn Văn A');
  final TextEditingController _phoneController =
      TextEditingController(text: '0123456789');
  final TextEditingController _addressController =
      TextEditingController(text: '123 Đường ABC, Thành phố XYZ');

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isEditing = false;

  void _saveProfileChanges(BuildContext context) {
    setState(() {
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lưu thông tin thành công!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _changePassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Đổi mật khẩu'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu cũ',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu mới',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Nhập lại mật khẩu mới',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                if (_newPasswordController.text !=
                    _confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mật khẩu xác nhận không khớp!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đổi mật khẩu thành công!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý tài khoản'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        const AssetImage('assets/avatar_placeholder.png'),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.camera_alt,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                readOnly: !_isEditing,
                decoration: InputDecoration(
                  labelText: 'Tên người dùng',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isEditing ? Colors.blue : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneController,
                readOnly: !_isEditing,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isEditing ? Colors.blue : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _addressController,
                readOnly: !_isEditing,
                decoration: InputDecoration(
                  labelText: 'Địa chỉ',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isEditing ? Colors.blue : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    child: const Text('Chỉnh sửa thông tin'),
                  ),
                  ElevatedButton(
                    onPressed:
                        _isEditing ? () => _saveProfileChanges(context) : null,
                    child: const Text('Lưu thông tin'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => _changePassword(context),
                child: const Text(
                  'Đổi mật khẩu',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
