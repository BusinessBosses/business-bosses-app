import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/models/order_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/orderwidget.dart';
// import 'package:business_bosses_v2/bbpro/models/task_model.dart';
// import 'package:business_bosses_v2/bbpro/widgets/statswidget.dart';
// import 'package:business_bosses_v2/bbpro/widgets/taskdisplayitem.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderPopUp extends StatefulWidget {
  final Order order;
  const OrderPopUp({
    super.key,
    required this.order,
  });

  @override
  State<OrderPopUp> createState() => _OrderPopUpState();
}

class _OrderPopUpState extends State<OrderPopUp> {
  final OrderController orderController = Get.find();
  @override
  Widget build(BuildContext context) {
    // final int totalTasks = widget.project.tasks?.length ?? 0;
    // final int completedTasks = widget.project.tasks
    //         ?.where((Task task) => task.status.toString() == 'completed')
    //         .length ??
    //     0;
    // final double completionRate =
    //     (totalTasks > 0) ? (completedTasks / totalTasks) * 100 : 0;

    return Dialog(
      backgroundColor: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      insetPadding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: 15,
            ),
            OrderWidget(
                isExpanded: true,
                order: widget.order,
                bgcolor: widget.order.status.backgroundColor),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Wrap(
                children: <Widget>[
                  const Text(
                    'Notes: ',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    widget.order.notes ?? 'No note added!',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Row(
              children: <Widget>[],
            ),
            const Padding(
              padding: EdgeInsets.all(0.0),
              child: Column(
                children: <Widget>[
                  // Row(
                  //   children: <Widget>[
                  //     Padding(
                  //       padding: EdgeInsets.symmetric(horizontal: 8.0),
                  //       child: Text('Tasks'),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 300,
                  //   child: ListView.builder(
                  //     itemCount: widget.project.tasks?.length ?? 0,
                  //     itemBuilder: (BuildContext context, int index) {
                  //       return TaskDisplayItem(
                  //         task: widget.project.tasks![index],
                  //         onChanged: (bool? value) {
                  //           setState(() {
                  //             widget.project.tasks![index].status = value!
                  //                 ? TaskStatus.completed
                  //                 : TaskStatus.pending;

                  //             projectController.updateTask(
                  //                 widget.project.tasks![index].id,
                  //                 <String, dynamic>{
                  //                   'status': widget
                  //                       .project.tasks![index].status
                  //                       .toString()
                  //                 });
                  //             // The completion rate and task stats will automatically update
                  //           });
                  //         },
                  //       );
                  //     },
                  //   ),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
