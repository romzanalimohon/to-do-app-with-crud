import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_text_image_test/my_home_page.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ShowData extends StatefulWidget {
  const ShowData({Key? key}) : super(key: key);

  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {


  Future<List> getData() async{
    //var url = Uri.parse("http://192.168.0.103:5000/users");
    //http.Response response = await http.get(url);
    var response = await get(Uri.parse("http://192.168.0.103:5000/users"));
    return json.decode(response.body);
  }

  // Future deleteById(String id) async{
  //   //delete the item
  //   final url = 'http://192.168.0.103:5000/users/$id';
  //   final uri = Uri.parse(url);
  //   final response = await http.delete(uri);
  //
  //
  //   if(response.statusCode == 200){
  //     //remove item from the list
  //   }else{
  //     //show error
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('data is displayed'),),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          setState(() {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> MyHomePage()));
          });
        },
      ),
      body: new FutureBuilder<List>(
          future: getData(),
          builder: (context, snapshot){
            if(snapshot.hasError) print(snapshot.error);
            return snapshot.hasData ? new Itemlist(list: snapshot.data!,) : new Center(child: CircularProgressIndicator(),);
          }),
    );
  }
}

class Itemlist extends StatelessWidget {

  List list;
  Itemlist({required this.list});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i){
          final item = list[i] as Map;
          final id = item['id'];
          return new ListTile(
            title: Text(list[i]['username']),
            leading: SizedBox(
              height: 40,
              width: 40,
              child: Image.network('${list[i]['image']}'),
            ),
            subtitle: Text("Password: ${list[i]['password']}"),
            trailing: PopupMenuButton(
              onSelected: (value){
                if(value == 'delete'){
                  //perform delete operation
                  deleteById(id);
                }else if(value == 'edit'){
                  //perform edit operation
                }
              },
              itemBuilder: (context){
                return [
                  PopupMenuItem(
                    child: Text("Delete",),
                    value: 'delete',
                  ),
                  PopupMenuItem(
                    child: Text("update"),
                    value: 'edit',
                  )
                ];
              },
            ),
          );
        });
  }





  Future <void> deleteById(int id) async{
    //delete the item
    final url = 'http://192.168.0.103:5000/users/:$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);


    if(response.statusCode == 200){
      //remove item from the list
      final filtered = list.where((element)=> element['id'] != id).toList();

    }else{
      //show error
    }
  }
}



