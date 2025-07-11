import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:new_version_of_recycle_app/Constants/globals.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<dynamic> requests = [];
  List<dynamic> users = [];
  bool isLoadingRequests = true;
  bool isLoadingUsers = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();


  @override
  void initState() {
    super.initState();
    fetchRequests();
    fetchUsers();
  }

  Future<void> fetchRequests() async {
    final url = Uri.parse('${Globals.baseUrl}/api/RecyclingRequest'); // غيّر حسب مسار API الفعلي
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          requests = jsonDecode(response.body);
          isLoadingRequests = false;
        });
      } else {
        print('Failed to load requests');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchUsers() async {
    final url = Uri.parse('${Globals.baseUrl}/api/UserControler'); // غيّر حسب مسار API الفعلي
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          users = jsonDecode(response.body);
          isLoadingUsers = false;
        });
      } else {
        print('Failed to load users');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  Future<void> addWasteType({
    required String wasteName,
    required String description,
    required int price,
  }) async {
    final url = Uri.parse('${Globals.baseUrl}/api/WasteType');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'wasteName': wasteName,
          'description': description,
          'price': price,
        }),
      );

      if (response.statusCode == 200) {
        print('✅ Waste type added successfully.');
      } else {
        print('❌ Failed to add waste type. Status: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('❌ Error occurred: $e');
    }
  }


  Widget buildAddWasteTypeForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        const Text('إضافة نوع نفاية جديد',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'اسم النفاية'),
                validator: (value) =>
                value!.isEmpty ? 'أدخل اسم النفاية' : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'الوصف'),
                validator: (value) =>
                value!.isEmpty ? 'أدخل وصف النفاية' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'السعر'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? 'أدخل السعر' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final name = _nameController.text;
                    final desc = _descController.text;
                    final price = int.tryParse(_priceController.text) ?? 0;

                    await addWasteType(
                        wasteName: name, description: desc, price: price);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تمت الإضافة بنجاح')),
                    );

                    _nameController.clear();
                    _descController.clear();
                    _priceController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                ),
                child: const Text('إضافة النوع'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRequestsTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('طلبات إعادة التدوير', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('نوع النفاية')),
              DataColumn(label: Text('الكمية')),
              DataColumn(label: Text('الموقع')),
              DataColumn(label: Text('السعر الكلي')),
              DataColumn(label: Text('التاريخ')),
            ],
            rows: requests.map((request) {
              final date = DateTime.parse(request['requestDate']);
              final formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(date);
              return DataRow(cells: [
                DataCell(Text(request['id'].toString())),
                DataCell(Text(request['wasteName'])),
                DataCell(Text(request['quantity'].toString())),
                DataCell(Text(request['location'])),
                DataCell(Text(request['totalPrice'].toString())),
                DataCell(Text(formattedDate)),
              ]);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildUsersTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        const Text('بيانات المستخدمين', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('الاسم')),
              DataColumn(label: Text('الإيميل')),
              DataColumn(label: Text('الهاتف')),
              DataColumn(label: Text('الدور')),
            ],
            rows: users.map((user) {
              return DataRow(cells: [
                DataCell(Text(user['id'].toString())),
                DataCell(Text(user['name'] ?? '')),
                DataCell(Text(user['email'] ?? '')),
                DataCell(Text(user['phone'] ?? '')),
                DataCell(Text(user['userRole'] ?? '')),
              ]);
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة تحكم المشرف')),
      body: isLoadingRequests || isLoadingUsers
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildRequestsTable(),
            _buildUsersTable(),
            buildAddWasteTypeForm()
          ],
        ),
      ),
    );
  }
}
