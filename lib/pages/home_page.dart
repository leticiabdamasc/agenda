import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:customizable_space_bar/customizable_space_bar.dart';
import 'package:flutter/material.dart';
import 'package:notas/DAO/anotacaoDAO.dart';
import 'package:notas/models/anotacao.dart';
import 'package:notas/pages/alarm_page.dart';
import 'package:notas/pages/anotacao_page.dart';
import 'package:notas/utils/calendar.dart';
import 'package:notas/utils/clock.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime now = DateTime.now();
  AnotacaoDAO anotacaoDAO = AnotacaoDAO();
  List<Anotacao> anotacao = List();
  @override
  void initState() {
    print(now);
    fetchDados();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAnotacaoPage();
          },
          backgroundColor: Color(0xFFedd0c2),
          child: Icon(
            Icons.add_circle_outline_rounded,
            size: 30,
          ),
        ),
        /*   appBar: AppBar(
          title: Text(
            "Minhas anotações",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Color(0xFF6600eb),
            ),
          ),
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.white,
          toolbarHeight: 50,
        ), */

        body: body());
  }

  body() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  elevation: 2,
                  pinned: true,
                  actions: [
                    IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: Color(0xFFedd0c2),
                        ),
                        onPressed: null)
                  ],
                  title: Text(
                    "Minhas anotações",
                    style: TextStyle(
                        color: Color(0xFFa98f78),
                        fontWeight: FontWeight.w300,
                        fontSize: 25),
                  ),
                  centerTitle: true,
                  toolbarHeight: 60,
                  backgroundColor: Colors.white,
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFFFFAFA),
                    ),
                    child: CustomizableSpaceBar(
                      builder: (context, scrollingRate) {
                        return ListView(
                          children: <Widget>[
                            SizedBox(
                              height: 60,
                            ),
                            CarouselSlider(
                              height: MediaQuery.of(context).size.height / 4,
                              enlargeCenterPage: true,
                              autoPlay: true,
                              aspectRatio: 16 / 9,
                              initialPage: 0,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enableInfiniteScroll: true,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration: Duration(seconds: 1),
                              viewportFraction: 0.8,
                              items: [
                                Clock(),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFdcbeb4),
                                  ),
                                  width: 250,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: OutlinedButton(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Icon(
                                                  Icons.calendar_today_outlined,
                                                  color: Color(0xFF321804),
                                                  size: 40,
                                                ),
                                                Text(
                                                  "Ver calendario",
                                                  style: TextStyle(
                                                      color: Color(0xFF321804),
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (contex) =>
                                                        Calendar()));
                                          }),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFf0c1b1),
                                  ),
                                  width: 250,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: OutlinedButton(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Icon(
                                                  Icons.alarm_rounded,
                                                  color: Color(0xFF301d0f),
                                                  size: 40,
                                                ),
                                                Text(
                                                  "Agendar lembrete",
                                                  style: TextStyle(
                                                      color: Color(0xFF301d0f),
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (contex) =>
                                                        Alarmpage()));
                                          }),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  expandedHeight: 230,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _anotacaoCard(context, index);
                    },
                    childCount: anotacao.length,
                  ),
                )
              ],
            ),
          ),
          /*       Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Column(
              children: <Widget>[
                Text('Minhas anotações'),
              ],
            ),
          ),
            Padding(
            padding: const EdgeInsets.only(top: 230),
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: anotacao.length,
              itemBuilder: (context, index) {
                return _anotacaoCard(context, index);
              },
            ),
          ), */
        ],
      ),
    );
  }

  Widget _anotacaoCard(BuildContext context, int index) {
    /* if (anotacao.isEmpty) {
      return Container(
        //<---------------------------------------------------------------------------------
        height: 800,
        color: Colors.red,
        child: Text("a fazer"),
      );
    } else { */
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Color(0xFFFFFAFA),
        child: GestureDetector(
            child: Card(
              elevation: 5,
              color: Color(0xFFFFFAFA),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 320,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.label,
                                      size: 15,
                                      color: Color(0xFFedd0c2),
                                    ),
                                  ],
                                ),
                                Text(
                                  anotacao[index].title ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xFF321804)),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        color: Color(0xFFedd0c2),
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        //                    <--- top side
                                        color: Color(0xFFedd0c2),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        anotacao[index].dataTime ?? "",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF321804)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          constraints: BoxConstraints(maxWidth: 200),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Color(0xFFedd0c2),
                                width: 1,
                              ),
                              bottom: BorderSide(
                                //                    <--- top side
                                color: Color(0xFFedd0c2),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(
                            anotacao[index].body ?? "Sem descrição",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              showOptions(context, index);
            }),
      ),
    );
  }

  void fetchDados() {
    anotacaoDAO.getAllAnotacao().then((list) {
      if (anotacao.isEmpty) {
        setState(() {
          teste();
        });
      }
      setState(() {
        anotacao = list;
      });
      print(list);
    });
  }

  void teste() {
    Container(
      color: Colors.black,
      height: 400,
      child: Text(
        "teste",
        style: TextStyle(color: Colors.black, fontSize: 800),
      ),
    );
    print("teste");
  }

  void showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              builder: (context) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xFFFFFAFA)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          child: Text(
                            "Ver",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w300),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Center(
                                      child: Text(
                                          anotacao[index].title != null
                                              ? anotacao[index].title
                                              : "Sem titulo",
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF321804))),
                                    ),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Text(
                                                anotacao[index].body != null
                                                    ? anotacao[index].body
                                                    : "Sem descrição",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w300,
                                                    color: Color(0xFF321804))),
                                          ),
                                          Container(
                                            width: 300,
                                            height: 300,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: anotacao[index].img !=
                                                          null
                                                      ? FileImage(File(
                                                          anotacao[index].img))
                                                      : AssetImage(
                                                          "assets/images/sem_foto.jpg"),
                                                  fit: BoxFit.cover,
                                                  scale: 5.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        color: Color(0xFFedd0c2),
                                        child: Text("Fechar",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white)),
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          child: Text("Editar",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w300)),
                          onPressed: () {
                            Navigator.pop(context);
                            showAnotacaoPage(anotacao: anotacao[index]);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          child: Text("Excluir",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w300)),
                          onPressed: () {
                            Navigator.pop(context);
                            anotacaoDAO.deleteContact(anotacao[index].id);
                            setState(() {
                              anotacao.removeAt(index);
                            });
                          },
                        ),
                      )
                    ],
                  ),
                );
              });
        });
  }

  void redOnly(int id) {
    anotacaoDAO.getAnotacao(id);
  }

  void showAnotacaoPage({Anotacao anotacao}) async {
    final recebeAnotacao = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnotacaoPage(
          anotacao: anotacao,
        ),
      ),
    );
    if (recebeAnotacao != null) {
      if (anotacao != null) {
        await anotacaoDAO.updateAnotacao(recebeAnotacao);
        fetchDados();
      } else {
        await anotacaoDAO.saveAnotacao(recebeAnotacao);
      }
      fetchDados();
    }
  }
}
