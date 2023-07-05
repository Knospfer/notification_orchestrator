import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_drag/notification_bloc.dart';

void main() {
  runApp(
    MaterialApp(
      home: BlocProvider<NotificationBloc>(
        create: (_) => NotificationBloc(),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void sendShortMessage(BuildContext context) {
    context.read<NotificationBloc>().add(
          ShowNotificationEvent('Notificaion', Colors.blue),
        );
  }

  void sendLongMessage(BuildContext context) {
    context.read<NotificationBloc>().add(
          ShowNotificationEvent(loremIpsum, Colors.red),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<NotificationBloc, BlocState>(
            builder: (context, state) {
              final shown = state is NotificationShownState;

              //-MediaQuery.of(context).size.height / 2,
              return AnimatedPositioned(
                top: shown ? 0 : -200,
                width: MediaQuery.of(context).size.width,
                duration: const Duration(milliseconds: 250),
                child: GestureDetector(
                  onPanUpdate: (details) {
                    final scrollTop = details.delta.dy < -8;
                    if (scrollTop && shown) {
                      context.read<NotificationBloc>().add(
                            HideNotificationEvent(
                              state.message,
                              state.color,
                            ),
                          );
                    }
                  },
                  child: SafeArea(
                    child: Alert(
                      message: state.message,
                      color: state.color,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Row(children: [
        FloatingActionButton(
          onPressed: () => sendShortMessage(context),
          child: const Icon(Icons.home),
        ),
        const SizedBox(width: 10),
        FloatingActionButton(
          onPressed: () => sendLongMessage(context),
          child: const Icon(Icons.tab),
        ),
      ]),
    );
  }
}

class MyAppSate extends State {
  final key = GlobalKey();
  Size renderBoxSize = const Size(0, 0);
  Color color = Colors.blue;
  String message = "Notification";

  bool shown = false;
  bool block = false;

  void notify() {
    setState(() {
      shown = !shown;
    });
  }

  void load() {
    setState(() {
      block = !block;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        renderBoxSize = getRedBoxSize(key.currentContext!);
      });
    });
    super.initState();
  }

  Size getRedBoxSize(BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    return box.size;
  }

  void updateNotification() {
    setState(() {
      color = Colors.red;
      message = loremIpsum;
      renderBoxSize = getRedBoxSize(key.currentContext!);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild");
    return Scaffold(
        body: Stack(
          children: [
            SizedBox.expand(
              child: Center(
                child: ElevatedButton(
                  child: const Text("aaaaaaaaauuuuu"),
                  onPressed: () {
                    print("aaaaaaaaauuuuu");
                  },
                ),
              ),
            ),
            // IgnorePointer(
            //   ignoring: !block,
            //   child: SizedBox.expand(
            //     child: AnimatedOpacity(
            //       opacity: block ? 1 : 0,
            //       duration: const Duration(milliseconds: 150),
            //       child: Container(
            //         color: const Color(0x99000000),
            //         alignment: Alignment.center,
            //         child: const CupertinoActivityIndicator(
            //           radius: 20,
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            AnimatedPositioned(
              top: shown
                  ? 0
                  : -MediaQuery.of(context)
                      .size
                      .height, //renderBoxSize.height - MediaQuery.of(context).padding.top,
              width: MediaQuery.of(context).size.width,
              duration: const Duration(milliseconds: 150),
              child: GestureDetector(
                //non va bene perchè funziona anche quando tappo
                // onVerticalDragEnd: (details) {
                //   notify();
                // },
                onPanUpdate: (details) {
                  print(details.delta.dy);
                  final scrollTop = details.delta.dy < -8;
                  if (scrollTop && shown) {
                    print("scrollooo");
                    setState(() {
                      shown = false;
                    });
                  }
                },
                child: SafeArea(
                  child: Alert(
                    key: key,
                    color: color,
                    message: message,
                  ),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: notify,
              child: const Icon(Icons.home),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              onPressed: load,
              child: const Icon(Icons.tab),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              onPressed: updateNotification,
              child: const Icon(Icons.ice_skating),
            ),
          ],
        ));
  }
}

class Alert extends StatelessWidget {
  final String message;
  final Color color;

  const Alert({super.key, required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      constraints: const BoxConstraints(minHeight: 100),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      alignment: Alignment.center,
      child: Text(message),
    );
  }
}

const loremIpsum = '''
Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.

The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.''';
