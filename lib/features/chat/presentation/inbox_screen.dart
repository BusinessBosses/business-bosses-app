import 'package:business_bosses_v2/bbpro/widgets/drawercontent.dart';
import 'package:business_bosses_v2/bbpro/widgets/menubutton.dart';
import 'package:business_bosses_v2/features/chat/chat_room_screen.dart';
import 'package:business_bosses_v2/features/chat/controllers/chat_controller.dart';
import 'package:business_bosses_v2/features/chat/chat_screen.dart'; // For ChatItem
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/features/notifications/controller/notification_controller.dart';
import 'package:business_bosses_v2/features/notifications/widgets/nonotificationfoundwidget.dart';
import 'package:business_bosses_v2/features/notifications/widgets/notification_item.dart';
import 'package:business_bosses_v2/features/notifications/widgets/quotewidget.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../common/widgets/safety_model.dart';
import '../../../utils/time_format.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:business_bosses_v2/bbpro/presentation/expanded_order_load.dart';
import 'package:business_bosses_v2/navigation/routes.dart';

class InboxScreen extends StatefulWidget {
  static const String routeName = '/inbox-screen';

  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AdvancedDrawerController _advancedDrawerController =
      AdvancedDrawerController();
  final ProfileController _profileController = Get.find();
  final NotificationController _notificationController =
      Get.isRegistered<NotificationController>()
          ? Get.find<NotificationController>()
          : Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Refresh notifications when the inbox opens so the Notifications tab shows
    // data immediately instead of requiring a manual reload.
    _notificationController.loadNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _advancedDrawerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Colors.white,
              Colors.white.withValues(alpha: 0.2),
            ],
          ),
        ),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: DrawerContent(
        oncloseclick: () => _advancedDrawerController.hideDrawer(),
        currentuser: _profileController.myProfile,
        hasUnreadNotification:
            _profileController.myProfile.unReadCount != null &&
                _profileController.myProfile.unReadCount! > 0,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: const Text(
            'Inbox',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: () => _advancedDrawerController.showDrawer(),
                child: const CustomMenuButton(),
              ),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: primaryColorLT,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primaryColorLT,
            labelStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            tabs: const <Widget>[
              Tab(text: 'Chat'),
              Tab(text: 'Notifications'),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            TabBarView(
              controller: _tabController,
              children: <Widget>[
                _buildChatTab(),
                _buildNotificationsTab(),
              ],
            ),
            BottomBar(activeIndex: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildChatTab() {
    return GetBuilder<ChatController>(
      builder: (ChatController controller) {
        return controller.chats.isEmpty
            ? SafetyModel(
                isLoading: false,
                icon: SvgPicture.asset(
                  'assets/svgs/message.svg',
                  colorFilter:
                      const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                  height: 80,
                ),
                title: 'No chat found',
                subTitle:
                    'Search for friends or connections and chat with them',
              )
            : Column(
                children: <Widget>[
                  _buildSearchBar(),
                  const SizedBox(height: 5),
                  Divider(
                      height: 0.5, color: Colors.grey.withValues(alpha: 0.3)),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(bottom: 120),
                      itemCount: controller.chats.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Divider(
                            height: 0.5,
                            color: Colors.grey.withValues(alpha: 0.05)),
                      ),
                      itemBuilder: (BuildContext context, int i) {
                        return ChatItem(
                          myChatUser: controller.chats[i],
                          chatController: controller,
                        );
                      },
                    ),
                  ),
                ],
              );
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: backgroundColor,
        ),
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              'assets/svgs/homesearch.svg',
              colorFilter: const ColorFilter.mode(textColor, BlendMode.srcIn),
              height: 18,
            ),
            const SizedBox(width: 10),
            const Text(
              'Search chat...',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsTab() {
    return GetBuilder<NotificationController>(
      builder: (NotificationController controller) {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.value) {
          return SafetyModel(
            isLoading: false,
            title: 'OOPS! Something went Wrong',
            subTitle: 'Could not get notifications',
            clickableText: 'Reload',
            onTap: controller.loadNotifications,
          );
        }
        return controller.notifications.isEmpty
            ? noNotificationsFoundWidget('notifications')
            : CustomScrollView(
                slivers: <Widget>[
                  SliverStickyHeader(
                    sticky: false,
                    header: Container(
                      color: backgroundcolorinterface,
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: QuoteWidget(controller.quote),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    sliver: SliverToBoxAdapter(
                      child: const Text(
                        'Activity',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 120),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int i) {
                          String formattedDate = TimeFormat.toDayFormat(
                              controller.notifications[i].timestamp);
                          bool showDateHeader = i == 0 ||
                              formattedDate !=
                                  TimeFormat.toDayFormat(controller
                                      .notifications[i - 1].timestamp);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (showDateHeader)
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 10, bottom: 5),
                                  child: Text(formattedDate, style: bodyText1),
                                ),
                              NotificationItem(
                                controller.notifications[i],
                                onTap: () {
                                  if (controller
                                          .notifications[i].notificationType ==
                                      'order') {
                                    Get.to(() => ExpandedOrdersView(
                                        order: controller
                                            .notifications[i].dataId!));
                                  } else if (controller.notifications[i].title
                                      .contains('New Message')) {
                                    Get.to(
                                        () => const ChatRoomScreen(
                                            frommarketplace: false),
                                        arguments:
                                            controller.notifications[i].user!);
                                  } else if (controller.notifications[i].title
                                      .contains('New Referral')) {
                                    Get.toNamed(Routes.referalsscreen,
                                        arguments:
                                            _profileController.myProfile.uid);
                                  } else {
                                    Get.toNamed(Routes.publicProfile,
                                        arguments:
                                            controller.notifications[i].user!);
                                  }
                                },
                              ),
                              const Divider(
                                  height: 0.5, indent: 12.0, endIndent: 12.0),
                            ],
                          );
                        },
                        childCount: controller.notifications.length,
                      ),
                    ),
                  ),
                ],
              );
      },
    );
  }
}
