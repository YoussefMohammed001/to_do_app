import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/tasks_cubit.dart';
import 'package:to_do_app/tasks_states.dart';

class ImportantTaksScreen extends StatefulWidget {
  const ImportantTaksScreen({Key? key}) : super(key: key);

  @override
  State<ImportantTaksScreen> createState() => _ImportantTasksScreenState();
}

class _ImportantTasksScreenState extends State<ImportantTaksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: BlocBuilder<TasksCubit,TasksStates>(
        builder: (context,state) {

          return ListView.builder(itemBuilder: (BuildContext context, int index) => buildImportantItem(index),
            itemCount: context.read<TasksCubit>().importantTasks?.length,

          );
        }
      ),

    );
  }

  Widget buildImportantItem(index){
    return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 10),

        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(0.0),
            topLeft: Radius.circular(10.0),
          ),),
        child:Row(
          children: [
            InkWell(
              onTap: (){
                context.read<TasksCubit>().updateTasks(
                    done:context.read<TasksCubit>().importantTasks?[index]['done'] == 0 ? 1 : 0,
                    id: context.read<TasksCubit>().importantTasks?[index]['id'],
                    important:context.read<TasksCubit>().importantTasks?[index]['important']);

              },
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [CircleAvatar(
                    backgroundColor: context.read<TasksCubit>().importantTasks?[index]['done'] == 0 ? Colors.white : Colors.yellow[700]
                ),
                  Icon(Icons.done,  color: context.read<TasksCubit>().importantTasks?[index]['done'] == 0 ? Colors.yellow[700] : Colors.white,)
                ],
              ),
            ),
            SizedBox(width: 5,),

            Text(context.read<TasksCubit>().importantTasks?[index]['task'],style: TextStyle(color: Colors.blue[900],fontWeight: FontWeight.bold,fontSize: 20),),
            Spacer(),
            IconButton(onPressed: () {
              context.read<TasksCubit>().updateTasks(
                  important:context.read<TasksCubit>().importantTasks?[index]['important'] == 1 ? 0 : 1,
                  id: context.read<TasksCubit>().importantTasks?[index]['id'],
                  done:context.read<TasksCubit>().importantTasks?[index]['done']);


            }, icon: Icon(Icons.label_important ,color: Colors.yellow[700],)),


          ],
        )

    );
  }
}
