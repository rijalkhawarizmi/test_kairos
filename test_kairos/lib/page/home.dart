import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:test_kairos/database/database.dart';
import 'package:test_kairos/model/model.dart';
import 'package:test_kairos/page/create_update.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ProductModel> list = [];
  List<ProductModel> listSearch = [];

  fetchNote() async {
    list = await DatabaseProduct.instance.readAllNotes();

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchNote();
    initializeDateFormatting('id', null);
  }

  final search = TextEditingController();
  String message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add, size: 50),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (c) {
              return CreateUpdateNote();
            }));
          }),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
            child: TextFormField(
              onChanged: (value) async {
                listSearch = await DatabaseProduct.instance
                    .searchProduct(namabarang: '$value', kodebarang: '$value');

                if (listSearch.isEmpty) {
                  message = 'nothing';
                } else {
                  message = '';
                }

                setState(() {});
              },
              decoration: InputDecoration(
                  hintText: 'Cari Barang atau Kode Barang',
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.blue)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.blue))),
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? const Center(
                    child: Text(
                        'Kamu belum mempunyai daftar barang\nSilahkan Buat daftar barang',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30)))
                : message == 'nothing'
                    ? const Center(
                        child: Text(
                        'Barang yang anda cari tidak tersedia',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30),
                      ))
                    : ListView.builder(
                        itemCount: listSearch.isNotEmpty
                            ? listSearch.length
                            : list.length,
                        itemBuilder: (BuildContext context, int index) {
                          final listNote = listSearch.isNotEmpty
                              ? listSearch[index]
                              : list[index];

                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.blue.shade200),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: 
                                [
                                    Text('${listNote.dateTime?.day} ${DateFormat('MMMM', 'id').format(listNote.dateTime!)} ${listNote.dateTime?.year}'),
                                  Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                        Text(
                                            'Nama Barang',
                                            style:  TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text('Kode Barang'),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text('Jumlah Barang'),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          
                                        ]),
                                         Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                        Text(
                                            '${listNote.namabarang}',
                                            style:  TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text('${listNote.kodebarang}'),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text('${listNote.jumlahbarang}'),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        
                                        ]),
                                   
                                    Column(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(builder: (c) {
                                                return CreateUpdateNote(
                                                    productModel: listNote);
                                              }));
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.black,
                                            )),
                                        IconButton(
                                            onPressed: () {
                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.WARNING,
                                                animType: AnimType.BOTTOMSLIDE,
                                                btnOkText: 'Ya',
                                                btnCancelText: 'Tidak',
                                                btnCancelColor: Colors.greenAccent,
                                                btnOkColor: Colors.red,
                                                title:
                                                    'Apakah Anda Yakin Ingin Menghapus Catatan ini',
                                                btnCancelOnPress: () {},
                                                btnOkOnPress: () async {
                                                  // cancel the notification with id value of zero
                            
                                                  DatabaseProduct.instance
                                                      .delete(listNote.id!);
                                                  fetchNote();
                                                },
                                              ).show();
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ))
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
