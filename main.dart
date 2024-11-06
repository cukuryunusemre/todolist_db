import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'calculator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personel Veritabanı',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PersonelHomePage(),
    );
  }
}

class PersonelHomePage extends StatefulWidget {
  @override
  _PersonelHomePageState createState() => _PersonelHomePageState();
}

class _PersonelHomePageState extends State<PersonelHomePage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> personelList = [];

  final TextEditingController adController = TextEditingController();
  final TextEditingController soyadController = TextEditingController();
  final TextEditingController departmanController = TextEditingController();
  final TextEditingController maasController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPersonel();
  }

  Future<void> _fetchPersonel() async {
    final result = await dbHelper.getAllPersonel();
    setState(() {
      personelList = result;
    });
  }

  Future<void> _showAddPersonelDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Yeni Personel Ekle'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: adController,
                  decoration: InputDecoration(labelText: 'Ad'),
                ),
                TextField(
                  controller: soyadController,
                  decoration: InputDecoration(labelText: 'Soyad'),
                ),
                TextField(
                  controller: departmanController,
                  decoration: InputDecoration(labelText: 'Departman'),
                ),
                TextField(
                  controller: maasController,
                  decoration: InputDecoration(labelText: 'Maaş'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String ad = adController.text;
                String soyad = soyadController.text;
                String departman = departmanController.text;
                int? maas = int.tryParse(maasController.text);

                if (ad.isNotEmpty && soyad.isNotEmpty && departman.isNotEmpty && maas != null) {
                  await dbHelper.insertPersonel({
                    'ad': ad,
                    'soyad': soyad,
                    'departman': departman,
                    'maas': maas,
                  });
                  _fetchPersonel();
                  adController.clear();
                  soyadController.clear();
                  departmanController.clear();
                  maasController.clear();
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lütfen tüm alanları doldurun ve maaşı geçerli bir sayı girin!')),
                  );
                }
              },
              child: Text('Ekle'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('İptal'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePersonel(int id) async {
    await dbHelper.deletePersonel(id);
    _fetchPersonel();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Personel silindi.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],
      appBar: AppBar(
        backgroundColor: Colors.cyan[400],
        title: Text('Personel Veritabanı İşlemleri'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalculatorPage()),
                );
              },
              child: Text('Hesap Makinesi'),
            ),

            SizedBox(height: 25,), //Boşluk bırakma

            ElevatedButton(
              onPressed: _showAddPersonelDialog,
              child: Text('Personel Ekle'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: personelList.length,
                itemBuilder: (context, index) {
                  final personel = personelList[index];
                  return Card(
                    child: ListTile(
                      title: Text('${personel['ad']} ${personel['soyad']}'),
                      subtitle: Text(
                          'Departman: ${personel['departman']}, Maaş: ${personel['maas']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deletePersonel(personel['id']),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
