import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '憧れ診断',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor:  const Color.fromARGB(255, 241, 239, 239)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Benesse あなたの憧れは？'),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context)  => const MyHomePage(title: 'Benesse あなたの憧れは？'),
        '/subpage': (BuildContext context) => SubPage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final List<({String icon, bool id, String message})> _chatList = [
    (message: 'もちろんです！診断のために\nこれから質問をさせてください！', id: false, icon: 'assets/image/bot_icon.png'),
  ];
  final TextEditingController _editContoroller = TextEditingController();
  final ScrollController _scrollContoroller = ScrollController();

  final _anserList = [
    (message: 'まかせてください！\nそれでは最初の質問です！\n好きなことはなんですか？',id: false, icon: 'assets/image/bot_icon.png'),
    (message: 'なるほど！例えば\nどのようなところが好きですか？',id: false, icon: 'assets/image/bot_icon.png'),
    (message: '素敵ですね！得意なことは\nどんなことですか？',id: false, icon: 'assets/image/bot_icon.png'),
    (message: 'ご回答ありがとうございます！\nお答えをもとに診断してみますね！',id: false, icon: 'assets/image/bot_icon.png')
  ];

  void _scrollToBottom(){
    _scrollContoroller.animateTo(
      _scrollContoroller.position.maxScrollExtent + MediaQuery.of(context).viewInsets.bottom, 
      curve: Curves.easeOut,
      duration: const Duration(microseconds: 200), 
      );
  }

  //_chatListに追加
  void _addChatList(){
    if (_counter != _anserList.length){
      setState(() {
        _chatList.add((message: _editContoroller.text,id: true, icon: 'assets/image/user_icon.png'));
        _editContoroller.clear();
        _chatList.add((message: _anserList[_counter].message, id: _anserList[_counter].id, icon: _anserList[_counter].icon));
        _counter++;
      });
      Timer(
        const Duration(milliseconds: 200),
        _scrollToBottom,
      );
    }
    else{
      Navigator.of(context).pushNamed("/subpage");
    }
  }

  Widget buildListtile(int index, bool id){
    if (id == false){
      return ListTile(
        title: Text(_chatList[index].message),
        leading: Image.asset('assets/images/bot_icon.png'),
        );
    }

    else{
      return ListTile(
        title: Text(_chatList[index].message),
        trailing: Image.asset('assets/images/user_icon.png'),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(11, 208, 250, 1),

      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
        title: Text(widget.title),
      ),

      body: Column(
        // alignment: Alignment.bottomCenter,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollContoroller,
              itemCount: _chatList.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    margin: _chatList[index].id
                    ? const EdgeInsets.only(top: 5.0, left: 90.0, bottom: 5.0, right: 8.0)
                    : const EdgeInsets.only(top: 5.0, left: 8.0, bottom: 5.0, right: 90.0),
                    color: _chatList[index].id
                    ? const Color.fromRGBO(244, 245, 250, 1)
                    : const Color.fromRGBO(140, 245, 144, 1),
                    child: 
                    buildListtile(index, _chatList[index].id),
                  ),
                );
              },
            ),
          ),

          //メッセージ送信部分
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      
                      child: Column(
                        children: <Widget>[
                          Form(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Flexible(
                                  child: TextFormField(
                                    controller: _editContoroller,
                                    autofocus: true,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    minLines: 1,
                                    decoration: const InputDecoration(
                                      hintText: 'メッセージを入力してください',
                                    ),
                                    onTap: () {
                                      Timer(
                                        const Duration(microseconds: 200),
                                        _scrollToBottom
                                      );
                                    },
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                  // フォームが送信されたときの処理を記述
                                  _addChatList();
                                  Timer(
                                    const Duration(microseconds: 200),
                                    _scrollToBottom,
                                  );
                                  },
                                  child: const Icon(Icons.send),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

    );
  }
}

//--------結果表示----------------
class SubPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(11, 208, 250, 1),

      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
        title: const Text('Benesse あなたの憧れは？'),
      ),

      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
              
                width: 334,
                height: 600,
              
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                  children: <Widget>[
                    const Text('あなたが憧れている仕事は',
                      style: TextStyle(
                        fontSize: 24,
                        ),
                      ),
              
                    GestureDetector(
                      onTap: (){
              
                      },
                      child: Image.asset('assets/images/evepra.png'),
                    ),
              
                    const Text('イベントプランナーってどんな仕事？',
                      style: TextStyle(
                        fontSize: 15,
                        ),
                    ),
              
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(217, 217, 217, 1),
                        borderRadius: BorderRadius.circular(10),
                      ), 
              
                      width: 312,
                      height: 150,
                      child: const Text('サッカーが大好きで\n関わる人たちを盛り上げる\nそんなあなたは\nイベントプランナー！',
                        style: TextStyle(
                        fontSize: 20,
                        ),
                      ),
                    ),
              
                  ],
                ),
              
              ),
            ),
          ),

          //メッセージ送信部分
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                
                child: Column(
                  children: <Widget>[
                    Form(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              minLines: 1,
                              decoration: const InputDecoration(
                                hintText: 'メッセージを入力してください',
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                            // ボタンが送信されたときの処理を記述
                            },
                            child: const Icon(Icons.send),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}