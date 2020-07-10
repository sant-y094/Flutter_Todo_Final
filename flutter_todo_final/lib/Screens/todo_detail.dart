import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo_list/Models/todo.dart';
import 'package:todo_list/Utils/database_helper.dart';
import 'package:intl/intl.dart';

class TodoDetail extends StatefulWidget {

	final String appBarTitle;
	final Todo todo;

	TodoDetail(this.todo, this.appBarTitle);

	@override
  State<StatefulWidget> createState() {

    return TodoDetailState(this.todo, this.appBarTitle);
  }
}

class TodoDetailState extends State<TodoDetail> {


	DatabaseHelper helper = DatabaseHelper();

	String appBarTitle;
	Todo todo;

	TextEditingController titleController = TextEditingController();
	TextEditingController descriptionController = TextEditingController();

	TodoDetailState(this.todo, this.appBarTitle);

	@override
  Widget build(BuildContext context) {

		TextStyle textStyle = Theme.of(context).textTheme.title;

		titleController.text = todo.title;
		descriptionController.text = todo.description;

    return WillPopScope(

	    onWillPop: () {
	    	// When user press Back navigation button in device navigationBar
		    moveToLastScreen();
	    },

	    child: Scaffold(
	    appBar: AppBar(
		    title: Text(appBarTitle),
		    leading: IconButton(icon: Icon(
				    Icons.arrow_back),
				    onPressed: () {
		    	    // When user press back button in AppBar
		    	    moveToLastScreen();
				    }
		    ),
	    ),

	    body: Padding(
		    padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
		    child: ListView(
			    children: <Widget>[

				    // First Element
				    Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: TextField(
						    controller: titleController,
						    style: textStyle,
						    onChanged: (value) {
						    	debugPrint('Something changed in Title Text Field');
						    	updateTitle();
						    },
						    decoration: InputDecoration(
							    labelText: 'Title',
							    labelStyle: textStyle,
							    border: OutlineInputBorder(
								    borderRadius: BorderRadius.circular(5.0)
							    )
						    ),
					    ),
				    ),

				    // Second Element
				    Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: TextField(
						    controller: descriptionController,
						    style: textStyle,
						    onChanged: (value) {
							    debugPrint('Something changed in Description Text Field');
							    updateDescription();
						    },
						    decoration: InputDecoration(
								    labelText: 'Description',
								    labelStyle: textStyle,
								    border: OutlineInputBorder(
										    borderRadius: BorderRadius.circular(5.0)
								    )
						    ),
					    ),
				    ),

				    // Third Element
				    Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: Row(
						    children: <Widget>[
						    	Expanded(
								    child: RaisedButton(
									    color: Theme.of(context).primaryColorDark,
									    textColor: Theme.of(context).primaryColorLight,
									    child: Text(
										    'Save',
										    textScaleFactor: 1.5,
									    ),
									    onPressed: () {
									    	setState(() {
									    	  debugPrint("Save button clicked");
									    	  _save();
									    	});
									    },
								    ),
							    ),

							    Container(width: 5.0,),

							    Expanded(
								    child: RaisedButton(
									    color: Theme.of(context).primaryColorDark,
									    textColor: Theme.of(context).primaryColorLight,
									    child: Text(
										    'Delete',
										    textScaleFactor: 1.5,
									    ),
									    onPressed: () {
										    setState(() {
											    debugPrint("Delete button clicked");
											    _delete();
										    });
									    },
								    ),
							    ),

						    ],
					    ),
				    ),


			    ],
		    ),
	    ),

    ));
  }

  void moveToLastScreen() {
		Navigator.pop(context, true);
  }

  void updateTitle(){
    todo.title = titleController.text;
  }

	// Update the description of todo object
	void updateDescription() {
		todo.description = descriptionController.text;
	}

	// Save data to database
	void _save() async {

		moveToLastScreen();

		todo.date = DateFormat.yMMMd().format(DateTime.now());
		int result;
		if (todo.id != null) {  // Case 1: Update operation
			result = await helper.updateTodo(todo);
		} else { // Case 2: Insert Operation
			result = await helper.insertTodo(todo);
		}

		if (result != 0) {  // Success
			_showAlertDialog('Status', 'Todo Saved Successfully');
		} else {  // Failure
			_showAlertDialog('Status', 'Problem Saving Todo');
		}

	}


	void _delete() async {

		moveToLastScreen();

		// Case 1: If user is trying to delete the NEW todo i.e. he has come to
		// the detail page by pressing the FAB of todoList page.
		if (todo.id == null) {
			_showAlertDialog('Status', 'No Todo was deleted');
			return;
		}

		// Case 2: User is trying to delete the old todo that already has a valid ID.
		int result = await helper.deleteTodo(todo.id);
		if (result != 0) {
			_showAlertDialog('Status', 'Todo Deleted Successfully');
		} else {
			_showAlertDialog('Status', 'Error Occured while Deleting Todo');
		}
	}

	void _showAlertDialog(String title, String message) {

		AlertDialog alertDialog = AlertDialog(
			title: Text(title),
			content: Text(message),
		);
		showDialog(
				context: context,
				builder: (_) => alertDialog
		);
	}

}










