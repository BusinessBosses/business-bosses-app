import 'package:business_bosses_v2/features/home/widgets/home_appbar.dart';
import 'package:business_bosses_v2/features/posts/controllers/posts_controller.dart';
import 'package:business_bosses_v2/features/posts/presentation/widgets/userpost_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/theme/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostsController>(
      builder: (PostsController controller) {
        return Scaffold(
          backgroundColor: backgroundcolorinterface,
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Homeappbar(),
          ),
          body: ListView.builder(
            itemCount: controller.posts.length,
            // physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return PostTile(
                controller: controller,
                post: controller.posts[index],
              );
            },
          ),
        );
      },
    );
  }
}
