import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_kairos/database/database.dart';
import 'package:test_kairos/model/model.dart';
import 'package:test_kairos/page/home.dart';

class CreateUpdateNote extends StatefulWidget {
  CreateUpdateNote({Key? key, this.productModel}) : super(key: key);
  ProductModel? productModel;

  @override
  State<CreateUpdateNote> createState() => _CreateUpdateNoteState();
}

class _CreateUpdateNoteState extends State<CreateUpdateNote> {
  late TextEditingController namaBarang;
  late TextEditingController kodeBarang;
  late TextEditingController jumlah;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    namaBarang = TextEditingController(text: widget.productModel?.namabarang);
    kodeBarang = TextEditingController(text: widget.productModel?.kodebarang);
    jumlah = TextEditingController(
        text: widget.productModel?.jumlahbarang.toString());
  }

  final keys = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: keys,
      child: Scaffold(
        appBar: AppBar(
            title: widget.productModel != null
                ? const Text('UPDATE')
                : const Text('CREATE')),
        body: Center(
            child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Nama barang harus diisi';
                }
              },
              decoration: InputDecoration(
                  hintText: 'Nama Barang',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.blue)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.green.shade500)),
                       errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.red))
                      
                      
                      ),
                    
              controller: namaBarang,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Kode barang harus diisi';
                }
              },
              decoration: InputDecoration(
                  hintText: 'Kode Barang',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.blue)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.green.shade500)),
                      errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.red))),
              controller: kodeBarang,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Jumlah barang harus diisi';
                }
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Jumlah Barang',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.blue)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.green.shade500)), errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.red))),
              controller: jumlah,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  // primary: isFormValid ? null : Colors.grey.shade700,
                ),
                onPressed: () {
                  if (keys.currentState!.validate()) {
                    if (widget.productModel != null) {
                      final data = ProductModel(
                          id: widget.productModel?.id,
                          namabarang: namaBarang.text,
                          kodebarang: kodeBarang.text,
                          jumlahbarang: int.parse(jumlah.text),
                          dateTime: DateTime.now());
                      DatabaseProduct.instance.update(data);
                       Navigator.push(context, MaterialPageRoute(builder: (c) {
                      return const Home();
                    }));
                    final _snackBar = SnackBar(
                      content: Text('Berhasil Diubah'),
                      backgroundColor: Colors.green,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                    } else {
                      final data = ProductModel(
                          namabarang: namaBarang.text,
                          kodebarang: kodeBarang.text,
                          jumlahbarang: int.parse(jumlah.text),
                          dateTime: DateTime.now());
                      DatabaseProduct.instance.create(data);
                       Navigator.push(context, MaterialPageRoute(builder: (c) {
                      return const Home();
                    }));
                    final _snackBar = SnackBar(
                      content: Text('Berhasil Ditambahkan'),
                      backgroundColor: Colors.green,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                    }
                   
                  }
                },
                child: widget.productModel != null
                    ? Text('Edit Barang')
                    : Text('Simpan Barang')),
          ]),
        )),
      ),
    );
  }
}
