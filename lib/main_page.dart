import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/all_tasks.dart';
import 'package:to_do_app/important_tasks.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/tasks_cubit.dart';



class MainScreen extends StatefulWidget {
  const MainScreen ({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index =0;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isBottomSheetExpand = false;

  List<Widget> screens = [AllTasksScreen(),ImportantTaksScreen()];



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<TasksCubit>().createDataBase();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0), // here the desired height
          child: AppBar(
            backgroundColor: Colors.yellow[700],
          )
      ),
      key: scaffoldKey,
      floatingActionButton: Visibility(
      visible: index == 0,
      child: FloatingActionButton(
        backgroundColor:isBottomSheetExpand ? Colors.white : Colors.yellow[800] ,

        onPressed: () {
          if (isBottomSheetExpand) {
            if (formKey.currentState!.validate()) {
              String task = taskController.text;
             context.read<TasksCubit>().insertTasks(task: task);

              taskController.clear();
              Navigator.pop(context);
              isBottomSheetExpand = false;
            }
          } else {
            if(index == 0){
              showScaffoldBottomSheet();
              isBottomSheetExpand = true;
            } if(index == 1){
              isBottomSheetExpand = false;
            }

          }
          setState(() {});
        },
        child: Icon(isBottomSheetExpand ? Icons.done : Icons.add,color: isBottomSheetExpand ? Colors.yellow[800] : Colors.white),

      ),
    ),


      bottomNavigationBar: buildBottomNavigationBar(),
      backgroundColor: Colors.yellow[700],
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(15),
              alignment: AlignmentDirectional.center,
              child: Text("ToDo Tasks",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),)),
          Expanded(
            child: Container(
              padding:EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50.0),

                      topLeft: Radius.circular(50.0),
                     ),),

                alignment: AlignmentDirectional.center,
                child: screens[index],

            ),


          )
        ],
      ),


    );

  }

  Widget buildBottomNavigationBar(){
    return BottomNavigationBar(
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.yellow[800],
      unselectedItemColor: Colors.grey[200],
      selectedItemColor: Colors.orange[800],
      selectedFontSize: 14,
      unselectedFontSize: 14,

      onTap: (value) {
        print(value);
        index = value;
        setState(() {});
      },
      currentIndex: index,
      items: [
        BottomNavigationBarItem(
          label: "Tasks",
          icon: Icon(Icons.task,),
        ),

        BottomNavigationBarItem(
          label: "Important Tasks",
          icon: Icon(Icons.label_important,),
        ),

      ],
    );
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
final TextEditingController taskController = TextEditingController();



  void showScaffoldBottomSheet() {
    scaffoldKey.currentState!.showBottomSheet((context) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 10,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: taskController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Task is required";
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Task",
                ),
              ),

            ],
          ),
        ),
      );
    })
        .closed
        .then((value) {
      print('Bottom sheet closed');
      isBottomSheetExpand = false;
      setState(() {});
    });
  }
}
