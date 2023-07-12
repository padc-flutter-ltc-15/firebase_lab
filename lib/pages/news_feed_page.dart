import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_lab/pages/text_detection_page.dart';
import 'package:firebase_lab/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_lab/blocs/news_feed_bloc.dart';
import 'package:firebase_lab/pages/add_new_post_page.dart';
import 'package:firebase_lab/resources/dimens.dart';
import 'package:firebase_lab/viewitems/news_feed_item_view.dart';

import 'login_page.dart';

class NewsFeedPage extends StatelessWidget {
  const NewsFeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewsFeedBloc(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Container(
            margin: const EdgeInsets.only(
              left: MARGIN_MEDIUM,
            ),
            child: const Text(
              "Social",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: TEXT_HEADING_1X,
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                navigateToScreen(context, const TextDetectionPage());
              },
              child: Container(
                margin: const EdgeInsets.only(
                  right: MARGIN_LARGE,
                ),
                child: const Icon(
                  Icons.face_outlined ,
                  color: Colors.grey,
                  size: MARGIN_LARGE,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.only(
                  right: MARGIN_LARGE,
                ),
                child: const Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: MARGIN_LARGE,
                ),
              ),
            ),
            Consumer<NewsFeedBloc>(
              builder: (context, bloc, child) => GestureDetector(
                onTap: () {
                  bloc.onTapLogout().then(
                          (_) => navigateToScreen(context, const LoginPage()));
                },
                child: Container(
                  margin: const EdgeInsets.only(
                    right: MARGIN_LARGE,
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: MARGIN_LARGE,
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            /// Navigate to Add New Post Page
            _navigateToAddNewPostPage(context);
            //FirebaseCrashlytics.instance.crash();
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Consumer<NewsFeedBloc>(
            builder: (context, bloc, child) => ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: MARGIN_LARGE,
                horizontal: MARGIN_LARGE,
              ),
              itemBuilder: (context, index) {
                return NewsFeedItemView(
                  mNewsFeed: bloc.newsFeed?[index],
                  onTapDelete: (newsFeedId) {
                    bloc.onTapDeletePost(newsFeedId);
                  },
                  onTapEdit: (newsFeedId) {
                    Future.delayed(const Duration(milliseconds: 1000))
                        .then((value) {
                      _navigateToEditPostPage(context, newsFeedId);
                    });
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: MARGIN_XLARGE,
                );
              },
              itemCount: bloc.newsFeed?.length ?? 0,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToAddNewPostPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddNewPostPage(),
      ),
    );
  }

  void _navigateToEditPostPage(BuildContext context, int newsFeedId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddNewPostPage(
          newsFeedId: newsFeedId,
        ),
      ),
    );
  }
}
