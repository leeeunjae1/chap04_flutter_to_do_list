import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key});

  @override
  State<Homepage> createState() => _HomepageState();
}

// 상태 클래스
class _HomepageState extends State<Homepage> {
  List<ToDo> toDoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "ToDoList",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: toDoList.isEmpty
          ? const Center(
              child: Text("TodoList 작성해주세요"),
            )
          : ListView.builder(
              itemCount: toDoList.length,
              itemBuilder: (context, index) {
                ToDo toDo = toDoList[index];

                return ListTile(
                  title: Text(
                    toDo.todo,
                    style: TextStyle(
                      fontSize: 20,
                      color: toDo.isDone ? Colors.grey : Colors.black,
                      decoration: toDo.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      CupertinoIcons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('삭제하시겠습니까?'),
                              actions: [
                                // 취소버튼
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    '취소',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      toDoList.removeAt(index);
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    '삭제',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                )
                              ],
                            );
                          });
                    },
                  ),
                  onTap: () {
                    //아이템 클릭시
                    setState(() {
                      toDo.isDone = !toDo.isDone;
                    });
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // + 버튼 클릭시 버킷 생성 페이지로 이동
          ToDo? todo = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatePage()),
          );
          if (todo != null) {
            setState(() {
              toDoList.add(todo);
            });
          }
        },
      ),
    );
  }
}

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  // TestField의 값을 가져올 때 사용
  TextEditingController textController = TextEditingController();

  // 경고 메시지
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDoList 작성'),
        // 뒤로가기 버튼
        leading: IconButton(
          icon: const Icon(CupertinoIcons.chevron_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            // 텍스트 입력창
            TextField(
              controller: textController,
              // 화면이 나오면 바로 입력창에 커서가 올 수 있게 함.
              autofocus: true,
              decoration: InputDecoration(
                hintText: "할 일을 입력하세요",
                errorText: error,
              ),
            ),
            // sizedBox : Row, Column 등에서 widget 사이에 빈 공간을 넣기 위해 사용
            const SizedBox(
              height: 20,
            ),

            // sizedBox : child widget의 size를 강제하기 위해 사용
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                child: const Text(
                  "추가하기",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  // 추가하기 버튼 클릭하면 작동
                  String todo = textController.text;
                  if (todo.isNotEmpty) {
                    setState(() {
                      error = null;
                      Navigator.pop(context, ToDo(todo, false));
                    });
                  } else {
                    setState(() {
                      error = "내용을 입력해주세요";
                    });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ToDo 클래스
class ToDo {
  // 할일
  final String todo;
  // 완료여부
  bool isDone;

  ToDo(this.todo, this.isDone); // 생성자
}
