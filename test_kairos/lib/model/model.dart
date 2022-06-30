final tableData='data';

class ResultField{

  static final List<String> values=[
    id,namabarang,kodebarang,jumlahbarang,datetime
  ];
  static final String id='_id';
  static final String namabarang='namabarang';
  static final String kodebarang='kodebarang';
  static final String jumlahbarang='jumlahbarang';
  static final String datetime='datetime';

}

class ProductModel{
    int? id;
    String? namabarang;
    String? kodebarang;
    int? jumlahbarang;
    DateTime? dateTime;
   

  ProductModel({
       this.id,
        this.namabarang,
        this.kodebarang,
        this.jumlahbarang,
        this.dateTime
    });
    
   ProductModel copy({
   int? id,
   String? namabarang,
   String? kodebarang,
   int? jumlahbarang,
   DateTime? dateTime,
})=>  
ProductModel(
  id:id ?? this.id,
  namabarang:namabarang ?? this.namabarang,
  kodebarang:kodebarang ?? this.kodebarang,
  jumlahbarang:jumlahbarang ?? this.jumlahbarang,
  dateTime:dateTime ?? this.dateTime,
);


static ProductModel fromJson(Map<String,Object?>json)=>
ProductModel(
  id: json[ResultField.id] as int,
  namabarang: json[ResultField.namabarang] as String,
  kodebarang: json[ResultField.kodebarang] as String,
  jumlahbarang: json[ResultField.jumlahbarang] as int,
  dateTime: DateTime.parse(json[ResultField.datetime] as String),
);
Map<String,Object?>toJson()=>{
  ResultField.id:id,
  ResultField.namabarang:namabarang,
  ResultField.kodebarang:kodebarang,
  ResultField.jumlahbarang:jumlahbarang,
  ResultField.datetime:dateTime!.toIso8601String(), 
};

}
