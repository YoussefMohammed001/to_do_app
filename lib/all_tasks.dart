import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/tasks_cubit.dart';
import 'package:to_do_app/tasks_states.dart';



class AllTasksScreen extends StatefulWidget {
  const AllTasksScreen({Key? key}) : super(key: key);

  @override
  State<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }




  //List<Tasks> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TasksCubit,TasksStates>(
        buildWhen: (previous, current) => current is GetTasksStates,
        builder: (context,state){
          return ListView.builder(itemBuilder: (context,index) => buildTaskItem(index),
            itemCount: context.read<TasksCubit>().tasks?.length,
          );
        },

      ),
    );
  }

  Widget buildTaskItem(index){
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),

      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.only(
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
                  done:context.read<TasksCubit>().tasks?[index]['done'] == 0 ? 1 : 0,
                  id: context.read<TasksCubit>().tasks?[index]['id'],
                  important:context.read<TasksCubit>().tasks?[index]['important']);

            },
            child: Stack(
             alignment: AlignmentDirectional.center,
             children: [CircleAvatar(
                 backgroundColor: context.read<TasksCubit>().tasks?[index]['done'] == 0 ? Colors.white : Colors.yellow[700]
            ),
                Icon(Icons.done,  color: context.read<TasksCubit>().tasks?[index]['done'] == 0 ? Colors.yellow[700] : Colors.white,)
            ],
            ),
          ),
         const SizedBox(width: 5,),

          Expanded(child: Text(

            context.read<TasksCubit>().tasks?[index]['task'],style: TextStyle(color: Colors.blue[900],fontWeight: FontWeight.bold,fontSize: 20),maxLines: 4,)),

         Row(
           children: [
             IconButton(onPressed: () {
               context.read<TasksCubit>().updateTasks(
                   important:context.read<TasksCubit>().tasks?[index]['important'] == 0 ? 1 : 0,
                   id: context.read<TasksCubit>().tasks?[index]['id'],
                   done:context.read<TasksCubit>().tasks?[index]['done']);


                }, icon: Icon(context.read<TasksCubit>().tasks?[index]['important'] == 0 ? Icons.label_important_outline  :Icons.label_important ,color: Colors.yellow[700],)),
                IconButton(onPressed: () {
                  context.read<TasksCubit>().deleteContact(id: context.read<TasksCubit>().tasks?[index]['id']);
                  }, icon: Icon(Icons.delete,color: Colors.red[900],)),
           ],
         )

        ],
      )

    );
  }
}
