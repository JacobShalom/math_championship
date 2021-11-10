import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_cube/flutter_cube.dart';
import 'SplashScreen.dart';

void main() {
  runApp(MyApp()); //
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'הדגמה לאפליקצית פלאטר',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen() //MyHomePage(title: 'אליפות כפל עד 100'),
        );
  }
}

const int maxQuestions = 36;
const int offset = 1;

class Question {
  int i = 0;
  int j = 0;
  int mul = 0;
  String mulLabel = "";
  bool? corrertAnswer;
  Question(int _i, int _j) {
    i = _i;
    j = _j;
    mul = (_i + offset) * (_j + offset);
    mulLabel = (_i + offset).toString() + ' X ' + (_j + offset).toString();
  }
}

const int maxTicTacToSquares = 9;

List<int> answers = [];
Map<int, Question> questions = new Map<int, Question>();

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static late int callingIndex;

  final PageController _pageController = new PageController(initialPage: 0);
  int _selectedIndex = 0;

  final List<List<int>> wins = [
    [0, 4, 8],
    [2, 4, 6],
    [0, 2, 1],
    [3, 4, 5],
    [6, 8, 7],
    [0, 6, 3],
    [1, 4, 7],
    [2, 8, 5]
  ];
  int winsCount = 0;
  int looseCount = 0;
  int equalsCount = 0;
  bool playerIsX = false;
  bool playerBegins = true;

  List<bool?> arr = <bool?>[
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null
  ];

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  void _closeDrawer() {
    Navigator.of(context).pop();
  }

  void clear() {
    arr = <bool?>[null, null, null, null, null, null, null, null, null];
  }

  void clearCounts() {
    setState(() {
      winsCount = 0;
      looseCount = 0;
      equalsCount = 0;
    });
  }

  int? oneMoveToWin(bool player) {
    for (int i = 0; i <= 7; i++) {
      if (arr[wins[i][0]] == null &&
          arr[wins[i][1]] == player &&
          arr[wins[i][2]] == player) return (wins[i][0]);
      if (arr[wins[i][0]] == player &&
          arr[wins[i][1]] == null &&
          arr[wins[i][2]] == player) return (wins[i][1]);
      if (arr[wins[i][0]] == player &&
          arr[wins[i][1]] == player &&
          arr[wins[i][2]] == null) return (wins[i][2]);
    }
    return null;
  }

  int? moveOnEmptyBoard() {
    if (arr.any((element) => element != null)) return null;
    var random = new Random();
    return (random.nextInt(5) * 2); //take corners or center
  }

  int? thirdMove() {
    if (arr[4] == true &&
        arr[1] == null &&
        arr[3] == null &&
        arr[5] == null &&
        arr[7] == null &&
        ((arr[0] == false ? 1 : 0) +
                (arr[2] == false ? 1 : 0) +
                (arr[6] == false ? 1 : 0) +
                (arr[8] == false ? 1 : 0) ==
            1)) {
      if (arr[0] == false) return 8;
      if (arr[2] == false) return 6;
      if (arr[6] == false) return 2;
      if (arr[8] == false) return 0;
    }
    return (null);
  }

  int? freeRowSpot() {
    for (int i = 0; i <= 7; i++) {
      if (arr[wins[i][0]] == null &&
          arr[wins[i][1]] == null &&
          arr[wins[i][2]] == null) return (wins[i][1]);
      if (arr[wins[i][0]] == null &&
          arr[wins[i][1]] == null &&
          arr[wins[i][2]] == true) return (wins[i][0]); //0
      if (arr[wins[i][0]] == true &&
          arr[wins[i][1]] == null &&
          arr[wins[i][2]] == null) return (wins[i][1]); //1
      if (arr[wins[i][0]] == null &&
          arr[wins[i][1]] == true &&
          arr[wins[i][2]] == null) return (wins[i][0]); //0
    }
    return null;
  }

  int? openSpot() {
    return arr.indexOf(null) == -1 ? null : arr.indexOf(null);
  }

  void doNexstStep() {
    int? move = moveOnEmptyBoard();
    if (move == null)
      move = oneMoveToWin(playerIsX); //circle is true cross is false
    if (move == null) move = oneMoveToWin(!playerIsX);
    if (move == null) move = thirdMove();
    if (move == null) move = freeRowSpot();
    if (move == null) move = openSpot();
    if (move != null) {
      arr[move] = playerIsX;
    }
  }

  bool? checkWin() {
    for (int i = 0; i <= 7; i++) {
      if (arr[wins[i][0]] == arr[wins[i][1]] &&
          arr[wins[i][1]] == arr[wins[i][2]]) return arr[wins[i][0]];
    }
    return (null);
  }

  bool gameEnded() {
    return (checkWin() != null || arr.indexOf(null) == -1);
  }

  void updateScores() {}

  late OverlayEntry entry;

  late Object earth;

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  initState() {


    earth = Object(fileName: "assets/earth/earth_ball.obj");
    
    super.initState();
    int i = 0;
    int j = 0;

    for (int k = 0; k < maxQuestions; k++) {
      if (i == j) {
        i++;
        j = 1;
      } else {
        j++;
      }
      questions[k] = new Question(i, j);
      if (!answers.contains(questions[k]?.mul ?? 0))
        answers.add(questions[k]?.mul ?? 0);
    }
    answers.sort();

    entry = OverlayEntry(
      builder: (context) {
        return Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black.withOpacity(0.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    playerIsX = true;
                    playerBegins = true;
                    entry.remove();
                  },
                  child: Text("אני X ומתחיל",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                      ),
                      textDirection: TextDirection.rtl),
                ),
                ElevatedButton(
                  onPressed: () {
                    playerIsX = false;
                    playerBegins = true;
                    entry.remove();
                  },
                  child: Text("אני O ומתחיל",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                      ),
                      textDirection: TextDirection.rtl),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      playerIsX = true;
                      playerBegins = false;
                      doNexstStep();
                      entry.remove();
                    });
                  },
                  child: Text("אני X אתה מתחיל",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                      ),
                      textDirection: TextDirection.rtl),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      playerIsX = false;
                      playerBegins = false;
                      doNexstStep();
                      entry.remove();
                    });
                  },
                  child: Text("אני O אתה מתחיל",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                      ),
                      textDirection: TextDirection.rtl),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _reset() {
    setState(() {
      switch (_selectedIndex) {
        case 0:
          questions.forEach((k, v) => v.corrertAnswer = null);
          break;
        case 1:
          clear();
          Overlay.of(context)!.insert(entry);
          break;
        case 2:
          _incrementCounter();
          break;
      }

      // Navigator.push(
      //  context,
      //   MaterialPageRoute(builder: (context) => CreateEvent()),
      //  );
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      //_pageController. = index;
      _pageController.animateToPage(_selectedIndex,
          duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        titleTextStyle: TextStyle(fontSize: 16.0),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.deepPurpleAccent)),
        backgroundColor: Colors.indigo,
        //backgroundColor: Colors.transparent,
        //elevation: 0.0,
        actions: [
          IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                if (_selectedIndex > 0)
                  _pageController.animateToPage(--_selectedIndex,
                      duration: Duration(milliseconds: 250),
                      curve: Curves.bounceInOut);
              }),
          IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                if (_selectedIndex < 3)
                  _pageController.animateToPage(++_selectedIndex,
                      duration: Duration(milliseconds: 250),
                      curve: Curves.bounceInOut);
              }),
        ],
      ),
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: PageView(
        children: [
          new Container(
            child: GridView.count(
              crossAxisCount: 4,
              childAspectRatio: 1.4,
              children: List.generate(maxQuestions, (index) {
                return Center(
                  child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              questions[index]?.corrertAnswer == null
                                  ? Colors.deepPurpleAccent
                                  : Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              questions[index]?.corrertAnswer == true
                                  ? Colors.green
                                  : (questions[index]?.corrertAnswer == false
                                      ? Colors.redAccent
                                      : Colors.amber)),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
                              EdgeInsets.symmetric(horizontal: 20)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.deepPurpleAccent)))),
                      child: Text(
                        '${questions[index]?.mulLabel ?? ""}',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      onPressed: () {
                        {
                          callingIndex = index;

                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (BuildContext context) {
                                return ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0),
                                      bottomLeft: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0),
                                    ),
                                    child: Container(
                                        color: Colors.blueGrey.shade200,
                                        child: new Column(
                                          children: [
                                            Row(children: [
                                              // Left(
                                              //child:
                                              Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20),
                                                  child: InkWell(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Icon(Icons
                                                          .arrow_back) // the arrow back icon
                                                      )),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 50),
                                                child: Text(
                                                    "${questions[index]?.mulLabel ?? ""}",
                                                    style: TextStyle(
                                                      fontSize: 30,
                                                      color: Colors.blueGrey,
                                                    )),
                                              ) // Your desired title
                                            ]),
                                            // Expanded(
                                            //     child:
                                            new GridView.count(
                                              shrinkWrap: true,
                                              crossAxisCount: 4,
                                              childAspectRatio: 1.9,
                                              children: List<Widget>.generate(
                                                  answers.length, (index) {
                                                return Center(
                                                  child: ElevatedButton(
                                                      style: ButtonStyle(
                                                          foregroundColor:
                                                              MaterialStateProperty.all<Color>(Colors
                                                                  .deepPurpleAccent),
                                                          backgroundColor:
                                                              MaterialStateProperty.all<Color>(
                                                                  Colors.amber),
                                                          shape: MaterialStateProperty.all<
                                                                  RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          18.0),
                                                                  side: BorderSide(color: Colors.deepPurpleAccent)))),
                                                      child: Text(
                                                        '${answers[index]}',
                                                        style: TextStyle(
                                                            fontSize: 24),
                                                      ),
                                                      onPressed: () => {
                                                            questions[callingIndex]
                                                                    ?.corrertAnswer =
                                                                (questions[callingIndex]
                                                                        ?.mul ==
                                                                    answers[
                                                                        index]),
                                                            Navigator.pop(
                                                                context),
                                                            setState(() {}),
                                                            if (!(questions
                                                                .map((k, v) =>
                                                                    MapEntry(
                                                                        k,
                                                                        v.corrertAnswer ??
                                                                            false))
                                                                .containsValue(
                                                                    false)))
                                                              _openDrawer()
                                                          }),
                                                );
                                              }),
                                            )
                                            //)
                                          ],
                                        )
                                        //  )
                                        ));
                              });
                        }
                      }),
                );
              }),
            ),
          ),
          new Container(
            color: Colors.blueGrey.shade200,
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 1.4,
              children: List.generate(maxTicTacToSquares, (index) {
                return Container(
                  child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              arr[index] == true
                                  ? Colors.amberAccent
                                  : Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              arr[index] == true
                                  ? Colors.blue
                                  : (arr[index] == false
                                      ? Colors.white24
                                      : Colors.blueGrey)),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry?>(
                                  EdgeInsets.symmetric(horizontal: 20)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.deepPurpleAccent)))),
                      child: Text(
                        '${arr[index] == true ? 'O' : (arr[index] == false ? 'X' : '')}',
                        style: TextStyle(
                          fontSize: 60,
                        ),
                      ),
                      onPressed: () {
                        {
                          setState(() {
                            if (arr[index] != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('אי אפשר לבחור את המקום הזה')));
                            } else {
                              if (!gameEnded()) {
                                arr[index] = !playerIsX;
                                bool? state = checkWin();
                                bool gameHasEnded = gameEnded();
                                if (state == !playerIsX || gameHasEnded) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(state == !playerIsX
                                        ? "נצחון"
                                        : "אין לאן להמשיך.."),
                                  ));
                                  if (state == !playerIsX)
                                    winsCount++;
                                  else
                                    equalsCount++;
                                  updateScores();
                                } else {
                                  doNexstStep();
                                  bool? state = checkWin();
                                  bool gameHasEnded = gameEnded();
                                  if (state == playerIsX || gameHasEnded) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(state == playerIsX
                                          ? "אוף הפסדתי"
                                          : "אין לאן להמשיך.."),
                                    ));
                                    if (state == playerIsX)
                                      looseCount++;
                                    else
                                      equalsCount++;
                                    updateScores();
                                  }
                                }
                              } else
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("המשחק נגמר")));
                            }
                          });
                        }
                      }),
                );
              }),
            ),
          ),
          new Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.greenAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
            child: Column(
              children: [
                Expanded(child: Cube(
                  onSceneCreated: (Scene scene) {
                    scene.world.add(earth);
                    scene.camera.zoom = 1;
                  },
                )),
                Expanded(
                    child: Text(
                  'לחצת :$_counter פעמים',
                  style: Theme.of(context).textTheme.headline4,
                ))
              ],
            ),
          ),
          new Container(color: Colors.brown)
        ],
        onPageChanged: (index) {
          setState(() {
            switch (index) {
              case 0:
                widget.title = 'אליפות כפל עד 100';
                break;
              case 1:
                widget.title = "טיק טק טו";
                break;
              case 2:
                widget.title = "תלת מימד";
                break;
              case 3:
                widget.title = "לא יודע מה לשים פה";
                break;
            }
            _selectedIndex = index;
          });
        },
        controller: _pageController,
        scrollDirection: Axis.horizontal,
      ),
      backgroundColor: Colors.blueGrey.shade200,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Theme.of(context).colorScheme.secondary,
        child: new BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
          //fixedColor: Theme.of(context).accentColor,
          selectedItemColor: Colors.white,
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(
              icon: Icon(Icons.home),
              //activeIcon: new Icon(Icons.access_alarm_outlined),
              backgroundColor: Colors.white,
              label: "כפל עד 100",
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.edit),
              //activeIcon: new Icon(Icons.access_alarm_outlined),
              backgroundColor: Colors.white,
              label: "Edit",
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.business),
              //activeIcon: new Icon(Icons.access_alarm_outlined),
              backgroundColor: Colors.white,
              label: "Edit",
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.school),
              //activeIcon: new Icon(Icons.access_alarm_outlined),
              backgroundColor: Colors.white,
              label: "Edit",
            ),
          ],
          // currentIndex: _selectedTab,
        ),
      ),
      // BottomAppBar(
      //   shape: const CircularNotchedRectangle(),
      //   child: Container(height: 50.0),
      // ),

      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () => _reset(), // _incrementCounter,
          tooltip: (_selectedIndex == 2 ? 'הוסף' : 'חדש'),
          child: Icon(
            (_selectedIndex == 2 ? Icons.add : Icons.restart_alt_rounded),
            size: 32.0,
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      drawer: Drawer(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  child: Text('$winsCount נצחונות'),
                  padding: EdgeInsets.symmetric(vertical: 50)),
              Container(
                  child: Text('$looseCount הפסדים'),
                  padding: EdgeInsets.symmetric(vertical: 50)),
              Container(
                  child: Text('$equalsCount שיוויונות'),
                  padding: EdgeInsets.symmetric(vertical: 50)),
              Container(
                  child: ElevatedButton(
                    onPressed: clearCounts,
                    child: Text('אפס מונים'),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 50)),
              Container(
                  child: ElevatedButton(
                    onPressed: _closeDrawer,
                    child: const Text('סגור'),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 50)),
            ],
          ),
        ),
      ),
      // Disable opening the drawer with a swipe gesture.
      drawerEnableOpenDragGesture: false,
    );
  }

  Widget createEvent() {
    return AppBar(
      centerTitle: true,
      title: Text(
        widget.title,
        style: TextStyle(
            color: Colors.greenAccent,
            fontWeight: FontWeight.bold,
            fontSize: 25),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }
}
