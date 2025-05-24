import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_buku_flutter/helper/db_helper.dart';
import 'package:sqflite_buku_flutter/model/model_buku.dart';
import 'package:sqflite_buku_flutter/uiscreen/addbuku_view.dart';

class ListdatabukuView extends StatefulWidget {
  const ListdatabukuView({super.key});

  @override
  State<ListdatabukuView> createState() => _ListdatabukuViewState();
}

class _ListdatabukuViewState extends State<ListdatabukuView> {
  List<ModelBuku> _buku = [];
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    DatabaseHelper.instance.dummyBuku();
    super.initState();
    _fetchDataBuku();
  }

  Future<void> _fetchDataBuku() async {
    setState(() {
      _isLoading = true;
    });
    final bukuMaps = await DatabaseHelper.instance.quaryAllBuku();
    setState(() {
      _buku = bukuMaps.map((bukuMaps) => ModelBuku.fromMap(bukuMaps)).toList();
      _isLoading = false;
    });
  }

  _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  _deleteFormDialog(BuildContext context, bukuId) {
    return showDialog(
      context: context,
      builder: (param) {
        return AlertDialog(
          title: Text(
            'Are you sure to Delete ?',
            style: TextStyle(color: Colors.teal, fontSize: 20),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                var result = await DatabaseHelper.instance.deleteBuku(bukuId);
                if (result != null) {
                  Navigator.pop(context);
                  _fetchDataBuku();
                  _showSuccessSnackbar(
                    "Buku Id ${bukuId} telah berhasil di hapus!",
                  );
                }
              },
              child: Text('Delete'),
            ),

            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
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
        title: Text('List Data Buku'),
        actions: [
          IconButton(
            onPressed: () {
              _fetchDataBuku();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),

      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _buku.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_buku[index].judulbuku),
                    subtitle: Text(_buku[index].kategori),

                    //button delete
                    onLongPress: () {
                      _deleteFormDialog(context, _buku[index].id);
                    },
                  );
                },
              ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddbukuView()),
          );
          _fetchDataBuku();
          // Navigator.push(context, (MaterialPageRoute(builder: (context) => const AddbukuView())));
        },

        child: Icon(Icons.add),
      ),
    );
  }
}
