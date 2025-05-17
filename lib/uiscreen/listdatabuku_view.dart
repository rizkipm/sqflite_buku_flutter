import 'package:flutter/material.dart';
import 'package:sqflite_buku_flutter/helper/db_helper.dart';
import 'package:sqflite_buku_flutter/model/model_buku.dart';

class ListdatabukuView extends StatefulWidget {
  const ListdatabukuView({super.key});

  @override
  State<ListdatabukuView> createState() => _ListdatabukuViewState();
}

class _ListdatabukuViewState extends State<ListdatabukuView> {

  List<ModelBuku> _buku = [];

  @override
  void initState() {
    // TODO: implement initState
    DatabaseHelper.instance.dummyBuku();
    super.initState();
    _fetchDataBuku();
  }

  Future<void> _fetchDataBuku() async{
    final bukuMaps = await DatabaseHelper.instance.quaryAllBuku();
    setState(() {
      _buku = bukuMaps.map((bukuMaps) => ModelBuku.fromMap(bukuMaps)).toList();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'List Data Buku'
        ),
      ),

      body: ListView.builder(
        itemCount: _buku.length,
        itemBuilder: (context, index){
          return ListTile(
            title: Text(_buku[index].judulbuku),
            subtitle: Text(_buku[index].kategori),
          );
        },
      ),
    );
  }
}
