import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:notas/models/anotacao.dart';

class AnotacaoPage extends StatefulWidget {
  final Anotacao anotacao;
  AnotacaoPage({this.anotacao});

  @override
  _AnotacaoPageState createState() => _AnotacaoPageState();
}

class _AnotacaoPageState extends State<AnotacaoPage> {
  DateTime _alarmTime;

  // String datetime = DateFormat('hh:mm aa').format(DateTime.now());
  String formattedDate = DateFormat("dd MMM yyy", 'pt').format(DateTime.now());
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  final _titleFocus = FocusNode();
  bool _usuarioEditou = false;

  Anotacao anotacaoEditada;

  @override
  void initState() {
    super.initState();
    _alarmTime = DateTime.now();
    print(formattedDate);
    print(_alarmTime);
    verificaEditacao();
    setState(() {});
  }

  void verificaEditacao() {
    if (widget.anotacao == null) {
      anotacaoEditada = Anotacao();
    } else {
      anotacaoEditada = Anotacao.fromMap(widget.anotacao.toMap());
      _titleController.text = anotacaoEditada.title;
      _bodyController.text = anotacaoEditada.body;
      //  datetime = anotacaoEditada.dataTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFFedd0c2),
          onPressed: () {
            if (anotacaoEditada.title != null &&
                anotacaoEditada.title.isNotEmpty) {
              Navigator.pop(context, anotacaoEditada);
            } else {
              FocusScope.of(context).requestFocus(_titleFocus);
            }
          },
          child: Icon(Icons.save),
        ),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Color(0xFFa98f78),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            },
          ),
          backgroundColor: Color(0xFFFFFAFA),
          title: Text(
            anotacaoEditada.title != null
                ? anotacaoEditada.title
                : 'Criar anotação',
            style: TextStyle(
                color: Color(0xFFa98f78),
                fontSize: 22,
                fontWeight: FontWeight.w400),
          ),
        ),
        body: body(),
      ),
    );
  }

  body() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Color(0xffedd0c2),
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ]),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _titleController,
                focusNode: _titleFocus,
                decoration: InputDecoration(
                  labelText: "Titulo",
                  hintText: "Escreva um titulo",
                  hintStyle: TextStyle(
                      color: Color(0xFFa98f78),
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                  labelStyle: TextStyle(
                      color: Color(0xFFa98f78),
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (text) {
                  _usuarioEditou = true;
                  setState(() {
                    anotacaoEditada.title = text;
                    anotacaoEditada.dataTime = formattedDate;
                  });
                },
              ),
              SizedBox(
                height: 50,
              ),
              TextField(
                controller: _bodyController,
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: "Descrição",
                  hintText: "Escreva uma descrição",
                  labelStyle: TextStyle(
                      color: Color(0xFFa98f78),
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                  hintStyle: TextStyle(
                      color: Color(0xFFa98f78),
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
                onChanged: (text) {
                  _usuarioEditou = true;
                  anotacaoEditada.body = text;
                },
              ),
              SizedBox(height: 15),
              Column(
                children: [
                  Text("Imagem (Opcional)",
                      style: TextStyle(
                          color: Color(0xFFa98f78),
                          fontSize: 20,
                          fontWeight: FontWeight.w400)),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    child: Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: anotacaoEditada.img != null
                                ? FileImage(File(anotacaoEditada.img))
                                : AssetImage("assets/images/adi.jpg"),
                            fit: BoxFit.cover),
                      ),
                    ),
                    onTap: () {
                      ImagePicker.pickImage(source: ImageSource.camera)
                          .then((file) {
                        if (file == null) return;
                        setState(() {
                          anotacaoEditada.img = file.path;
                        });
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_usuarioEditou) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Descartar alterações?'),
              content: Text('Se sair as alterações serão perdidas!'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancelar')),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('Sim')),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
