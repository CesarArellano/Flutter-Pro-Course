
import 'package:flutter_riverpod/flutter_riverpod.dart';

final todoProvider = StateNotifierProvider<TodoProviderNotifier, List<TodoState>>((ref) {
  return TodoProviderNotifier();
});

class TodoProviderNotifier extends StateNotifier<List<TodoState>> {
  
  TodoProviderNotifier(): super( const []);

  void addTodo(String title, String body) {
    final uniqueId = DateTime.now().toString();

    final TodoState newTodo = TodoState(
      id: uniqueId,
      title: title,
      body: body
    );

    state = [ ...state, newTodo ];
  }
  
  void setDoneOrNot(String id, bool value) {
    List<TodoState> newTodoList = [ ...state ];
    
    final foundIndex = newTodoList.indexWhere((todo) => todo.id == id);
    
    newTodoList[foundIndex] = newTodoList[foundIndex].copyWith(
      isDone: value
    );

    state = newTodoList;
  }

  bool editTodo( String id, String title, String body ) {
    List<TodoState> newTodoList = [ ...state ];
    final foundIndex = newTodoList.indexWhere((todo) => todo.id == id);

    if( foundIndex == -1 ) return false;

    newTodoList[foundIndex] = newTodoList[foundIndex].copyWith(
      body: body,
      title: title
    );

    state = newTodoList;

    return true;
  }

  void removeTodo( String id ) {
    List<TodoState> newTodoList = [ ...state ];
    newTodoList.removeWhere((todo) => todo.id == id);
    state = newTodoList;
  }
}

class TodoState {
  final String id;
  final String title;
  final String body;
  final bool isDone;

  const TodoState({
    required this.id,
    required this.title,
    required this.body,
    this.isDone = false,
  });

  TodoState copyWith({
    String? id,
    String? title,
    String? body,
    bool? isDone,
  }) => TodoState(
    id: id ?? this.id,
    title: title ?? this.title,
    body: body ?? this.body,
    isDone: isDone ?? this.isDone
  );

  @override
  String toString() {
    return '''
      TodoState:
      id: $id
      title: $title
      body: $body
      isDone: $isDone
    ''';
  }
}