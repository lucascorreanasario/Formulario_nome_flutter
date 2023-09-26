import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title: 'Formulário de Perfil',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserProfileForm(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [const Locale('pt', 'BR')],
    );
  }
}

class UserProfileForm extends StatefulWidget {
  final bool isEditing;
  final String? name;
  final String? profession;
  final String? dob;
  final String? city;
  final String? country;
  final String? preferredLanguage;
  final XFile? profileImage;

  UserProfileForm({
    this.isEditing = false,
    this.name,
    this.profession,
    this.dob,
    this.city,
    this.country,
    this.preferredLanguage,
    this.profileImage,
  });

  @override
  _UserProfileFormState createState() => _UserProfileFormState();
}

class _UserProfileFormState extends State<UserProfileForm> {
  final _formKey = GlobalKey<FormState>();
  XFile? _profileImage;
  String? _preferredLanguage;

  late TextEditingController _nameController;
  late TextEditingController _professionController;
  late TextEditingController _dateController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.name ?? "");
    _professionController = TextEditingController(text: widget.profession ?? "");
    _dateController = TextEditingController(text: widget.dob ?? "");
    _cityController = TextEditingController(text: widget.city ?? "");
    _countryController = TextEditingController(text: widget.country ?? "");
    _preferredLanguage = widget.preferredLanguage;
    if (widget.profileImage != null) {
      _profileImage = widget.profileImage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Editar Perfil' : 'Formulário de Perfil'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nome Completo'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu nome completo';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(labelText: 'Data de Nascimento'),
                  onTap: _selectDate,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua data de nascimento';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(labelText: 'Cidade'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua cidade';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _countryController,
                  decoration: InputDecoration(labelText: 'País'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu país';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _professionController,
                  decoration: InputDecoration(labelText: 'Profissão'),
                ),
                DropdownButtonFormField<String>(
                  value: _preferredLanguage,
                  items: ['Português', 'Inglês'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _preferredLanguage = newValue;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Idioma Preferido'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecione um idioma';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Upload de Imagem de Perfil'),
                ),
                if (_profileImage != null)
                  Image.file(File(_profileImage!.path), width: 100, height: 100),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UserProfileScreen(
                          name: _nameController.text,
                          profileImage: _profileImage,
                          profession: _professionController.text,
                          dob: _dateController.text,
                          city: _cityController.text,
                          country: _countryController.text,
                          preferredLanguage: _preferredLanguage!,
                        ),
                      ));
                    }
                  },
                  child: Text('Atualizar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );
    if (selectedDate != null && selectedDate != DateTime.now()) {
      _dateController.text = '${selectedDate.toLocal()}'.split(' ')[0];
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = image;
    });
  }
}

class UserProfileScreen extends StatelessWidget {
  final String name;
  final String? dob;
  final String? city;
  final String? country;
  final String? preferredLanguage;
  final XFile? profileImage;
  final String? profession;

  UserProfileScreen({
    required this.name,
    this.dob,
    this.city,
    this.country,
    this.preferredLanguage,
    this.profileImage,
    this.profession,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (profileImage != null)
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: FileImage(File(profileImage!.path)),
                  ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    if (profession != null && profession!.isNotEmpty)
                      Text(profession!, style: TextStyle(fontSize: 18)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => UserProfileForm(
                    isEditing: true,
                    name: name,
                    profession: profession,
                    dob: dob,
                    city: city,
                    country: country,
                    preferredLanguage: preferredLanguage,
                    profileImage: profileImage,
                  ),
                ));
              },
              child: Text('Editar Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}
