import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/model/clb_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateClubScreen extends StatefulWidget {
  final void Function(Club) onAddClub;
  final void Function(int, Club) onUpdateClub;
  final Club? club;
  final int? index;
  final String uid;

  const CreateClubScreen({
    super.key,
    required this.onAddClub,
    required this.onUpdateClub,
    this.club,
    this.index,
    required this.uid,
  });

  @override
  _CreateClubScreenState createState() => _CreateClubScreenState();
}

class _CreateClubScreenState extends State<CreateClubScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ownerController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _imagePath = '';
  DateTime selectedDate = DateTime.now();
  final TextEditingController _activeYearsController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  void _saveClub() async {
    final clubData = {
      'name': _nameController.text,
      'owner': _ownerController.text,
      'location': _locationController.text,
      'description': _descriptionController.text,
      'imagePath': _imagePath,
      'foundingDate': selectedDate,
      'activeYears': int.parse(_activeYearsController.text),
      'uid': widget.uid,
    };

    try {
      // Sử dụng tên của câu lạc bộ làm ID khi tạo mới câu lạc bộ
      await FirebaseFirestore.instance
          .collection('clubs')
          .doc(_nameController.text)
          .set(clubData);
      // Thêm các cầu thủ vào collection 'players' của câu lạc bộ nếu cần
    } catch (error) {
      // Xử lý lỗi nếu có
      print("Error saving club: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.club != null) {
      _nameController.text = widget.club!.name;
      _ownerController.text = widget.club!.owner;
      _locationController.text = widget.club!.location;
      _descriptionController.text = widget.club!.description;
      _imagePath = widget.club!.imageUrl;
      selectedDate = widget.club!.foundingDate;
      _activeYearsController.text = widget.club!.activeYears.toString();
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget buildDateButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => selectDate(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade100,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      final club = Club(
        name: _nameController.text,
        owner: _ownerController.text,
        location: _locationController.text,
        description: _descriptionController.text,
        imageUrl: _imagePath,
        foundingDate: selectedDate,
        activeYears: int.parse(_activeYearsController.text),
        members: [],
      );

      if (widget.index == null) {
        widget.onAddClub(club);
      } else {
        widget.onUpdateClub(widget.index!, club);
      }

      _saveClub();

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo CLB Mới'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: _imagePath.isNotEmpty
                      ? FileImage(File(_imagePath))
                      : null,
                  child: _imagePath.isEmpty
                      ? const Icon(Icons.camera_alt,
                          size: 80, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => pickImage(ImageSource.camera),
                    child: const Text('Chụp ảnh'),
                  ),
                  ElevatedButton(
                    onPressed: () => pickImage(ImageSource.gallery),
                    child: const Text('Chọn ảnh từ thư viện'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    labelText: 'Tên Câu Lạc Bộ',
                    labelStyle: TextStyle(fontSize: 18)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Xin nhập tên câu lạc bộ của bạn';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _ownerController,
                decoration: const InputDecoration(
                    labelText: 'Người sở hữu',
                    labelStyle: TextStyle(fontSize: 18)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập đầy đủ thông tin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                    labelText: 'Địa chỉ', labelStyle: TextStyle(fontSize: 18)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập đầy đủ thông tin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                    labelText: 'Mô tả', labelStyle: TextStyle(fontSize: 18)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập đầy đủ thông tin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _activeYearsController,
                decoration: const InputDecoration(
                    labelText: 'Số năm hoạt động',
                    labelStyle: TextStyle(fontSize: 18)),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Vui lòng nhập đầy đủ thông tin. VD: '9'";
                  }
                  if (int.tryParse(value) == null) {
                    return 'Vui lòng nhập số hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Text('Ngày thành lập:', style: TextStyle(fontSize: 18)),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: buildDateButton(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  onPressed: submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text(
                    widget.index == null
                        ? 'Tạo câu lạc bộ'
                        : 'Cập nhật câu lạc bộ',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
