import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lifelog_repo/lifelog_repo.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:wadsworth/widgets/lifelogs_list.dart';
import 'package:wadsworth/widgets/widgets.dart';
import 'package:wadsworth/app/theme.dart';
import 'package:wadsworth/blocs/blocs.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  // Open the Database connection before starting the app.
  final lifelogClient = await LifelogClient.instance;
  final lifelogBloc = LifelogBloc(lifelogClient: lifelogClient);
  runApp(
    MyApp(
      lifelogBloc: lifelogBloc,
    ),
  );
  lifelogBloc.add(LifelogReloadRequested());
}

class MyApp extends StatelessWidget {
  MyApp({
    @required this.lifelogBloc,
  });

  final LifelogBloc lifelogBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LifelogBloc>(
      create: (BuildContext context) => lifelogBloc,
      child: MaterialApp(
        title: 'Positive Banking',
        theme: AppTheme.theme,
        home: AppHome(),
      ),
    );
  }
}

class AppHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: AppBar(
          title: Column(
            children: [
              Text('🤵', style: TextStyle(fontSize: 30)),
              Text('Wadsworth'),
            ],
          ),
          bottom: PreferredSize(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Your personal memory manager™️'),
            ),
            preferredSize: null,
          ),
        ),
      ),
      body: LifelogsList(),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8),
            child: FloatingActionButton(
                child: const Icon(Icons.add),
                // Create a new entry:
                onPressed: () {
                  showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context, scrollController) =>
                        Scaffold(body: LifelogEntryForm()),
                  );
                  // lifelogBloc.add(LifelogAdded(Lifelog(isBeingEdited: true)));

                  // Scroll to new entry after render!
                  // SchedulerBinding.instance.addPostFrameCallback((_) {
                  //   _scrollController.animateTo(
                  //     _scrollController.position.maxScrollExtent,
                  //     duration: const Duration(milliseconds: 300),
                  //     curve: Curves.easeOut,
                  //   );
                  // });
                }),
          ),
        ],
      ),
    );
  }
}
