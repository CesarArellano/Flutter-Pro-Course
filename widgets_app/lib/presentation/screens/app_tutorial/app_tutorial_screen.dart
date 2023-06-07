import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SlideInfo {
  final String title;
  final String caption;
  final String imageUrl;

  SlideInfo(this.title, this.caption, this.imageUrl);
}

final slides = <SlideInfo>[
  SlideInfo('Search food','Nisi Lorem ea do elit non ex adipisicing sit eiusmod culpa culpa ex nostrud.', 'assets/images/1.png'),
  SlideInfo('Fast Delivery','Laboris irure quis id ad tempor cupidatat non velit ut reprehenderit ipsum nisi qui qui.', 'assets/images/2.png'),
  SlideInfo('Enjoy your meal','Non eu labore nulla exercitation commodo non sit quis.', 'assets/images/3.png'),
];

class AppTutorialScreen extends StatefulWidget {
  static const String name = 'app_tutorial_screen';
  const AppTutorialScreen({Key? key}) : super(key: key);

  @override
  State<AppTutorialScreen> createState() => _AppTutorialScreenState();
}

class _AppTutorialScreenState extends State<AppTutorialScreen> {
  final PageController pageViewController = PageController();
  bool endReached = false;

  @override
  void initState() {
    pageViewController.addListener(() {
      final page = pageViewController.page ?? 0;

      if( !endReached && page >= ( slides.length - 1.5 )  ) {
        setState(() {
          endReached = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: pageViewController,
            physics: const BouncingScrollPhysics(),
            children: [
              ...slides.map(
                (slide) => _Slide(slide: slide,)
              )
            ],
          ),
          Positioned(
            right: 10,
            child: SafeArea(
              child: TextButton(
                child: const Text('Skip Tutorial'),
                onPressed: () => context.pop(),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: FilledButton(
              onPressed: endReached
                ? () => context.pop()
                : null,
              child: const Text('Get started')
            ),
          ),
        ],
      )
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({
    required this.slide
  });

  final SlideInfo slide;
  @override
  Widget build(BuildContext context) {
    final texTheme = Theme.of(context).textTheme;
    final titleStyle = texTheme.titleLarge;
    final captionStyle = texTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(image: AssetImage(slide.imageUrl)),
            const SizedBox(height: 20),
            Text(slide.title, style: titleStyle),
            const SizedBox(height: 10),
            Text(slide.caption, style: captionStyle,),
          ],
        ),
      ),
    );
  }
}