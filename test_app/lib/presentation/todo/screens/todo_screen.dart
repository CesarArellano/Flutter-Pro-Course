import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/presentation/todo/providers/todo_provider.dart';

class TodoScreen extends ConsumerWidget {
  static const name = 'todo_screen';
  
  const TodoScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoNotifier = ref.read(todoProvider.notifier);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
      ),
      body: const _TodoView(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          todoNotifier.addTodo('Title ${ DateTime.now().millisecond }', 'Test body');
        }
      ),
    );
  }
}

class _TodoView extends ConsumerWidget {
  const _TodoView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = Theme.of(context).colorScheme.primary;

    final todoNotifier = ref.read(todoProvider.notifier);
    final todoList = ref.watch(todoProvider);

    if( todoList.isEmpty ) {
      return Center(
        child: Text("There is nothing left to do", style: Theme.of(context).textTheme.titleMedium,),
      );
    }

    return ListView.builder(
      itemCount: todoList.length,
      itemBuilder: (context, index) {
        final todo = todoList[index];

        return Dismissible(
          key: UniqueKey(),
          background: Container(
            padding: const EdgeInsets.only(right: 10),
            alignment: Alignment.centerRight,
            color: Colors.red,
            child: const Icon(Icons.delete_forever, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed:( _ ) => todoNotifier.removeTodo(todo.id),
          child: ListTile(
            onTap: () {
              todoNotifier.setDoneOrNot(todo.id, !todo.isDone);
            },
            leading: Checkbox.adaptive(
              value: todo.isDone,
              onChanged: ( value ) {
                todoNotifier.setDoneOrNot(todo.id, value ?? false);
              } 
            ),
            title: Text(todo.title),
            subtitle: Text(todo.body),
            trailing: IconButton(
              onPressed: () {
                todoNotifier.editTodo(todo.id, 'New Title ${ DateTime.now().millisecond }', 'New Test body');
              },
              icon: Icon(Icons.edit, color: primary)
            ),
          )
        );
      },
    );
  }
}