import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InfiniteScrollScreen extends StatefulWidget {
  static const String name = 'infinite_scroll_screen';
  const InfiniteScrollScreen({Key? key}) : super(key: key);

  @override
  State<InfiniteScrollScreen> createState() => _InfiniteScrollScreenState();
}

class _InfiniteScrollScreenState extends State<InfiniteScrollScreen> {

  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;

  List<int> imageIds = [ 1, 2, 3, 4, 5 ];

  void addFiveImages() {
    final lastId = imageIds.last;
    
    imageIds.addAll(
      [1,2,3,4,5].map((e) => lastId + e)
    );
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if( _scrollController.position.pixels + 500 >= _scrollController.position.maxScrollExtent ) {
        loadNextPage();
      }
    });
    super.initState();
  }

  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadNextPage() async {
    if( isLoading ) return;
    isLoading = true;
    setState(() { });
    await Future.delayed(const Duration(seconds: 2));
    addFiveImages();
    isLoading = false;
    setState(() { });
    moveScrollToBottom();
  }

  void moveScrollToBottom() {
    if( _scrollController.position.pixels + 150 <= _scrollController.position.maxScrollExtent ) return;
    
    _scrollController.animateTo(
      _scrollController.position.pixels + 120,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn
    );
  }

  Future<void> onRefresh() async {
    isLoading = true;
    setState(() {});

    await Future.delayed(const Duration(seconds: 3));
    if( !mounted ) return;

    final lastId = imageIds.last;
    isLoading = false;
    imageIds.clear();
    imageIds.add(lastId + 1);
    addFiveImages();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: RefreshIndicator.adaptive(
          onRefresh: onRefresh,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: imageIds.length,
            itemBuilder: (context, index) {
              return FadeInImage(
                placeholder: const AssetImage('assets/images/jar-loading.gif'),
                image: NetworkImage('https://picsum.photos/id/${ imageIds[index] }/500/300'),
                imageErrorBuilder: ( _, __, ___) => Container(
                  color: Colors.white,
                  height: 300,
                  child: const Center(
                    child: Text('Image not available', textAlign: TextAlign.center)
                  )
                ),
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isLoading ? null : () => context.pop(),
        child: isLoading ? const CircularProgressIndicator(color: Colors.black,) : const Icon( Icons.arrow_back_ios_new ),
      ),
    );
  }
}