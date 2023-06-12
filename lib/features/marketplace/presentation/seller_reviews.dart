import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/buttons/my_outlined_button.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';

import '../../../common/models/api_response_model.dart';
import '../../../common/widgets/safety_model.dart';
import '../../../services/api_service.dart';
import '../../profile/widgets/public_profile_tile.dart';
import '../../profile/widgets/user_profile_tile.dart';
import '../models/reviews_model.dart';
import '../widgets/review_item.dart';

class SellerReviewScreen extends StatefulWidget {
  final UserModel user;
  const SellerReviewScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<SellerReviewScreen> createState() => _SellerReviewScreenState();
}

class _SellerReviewScreenState extends State<SellerReviewScreen> {
  UserModel? cUser;
  int rater = 0;
  String reviewText = '';
  List<ReviewModel>? reviews;
  bool isSending = false;
  int oneStar = 0;
  int twoStar = 0;
  int threeStar = 0;
  int fourStar = 0;
  int fiveStar = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
    processData();
  }

  Future<void> loadUser() async {
    final Map<String, dynamic> currentUser =
        await ProfileController.loadData(widget.user.uid);
    if (mounted) {
      setState(() {
        cUser = UserModel.fromMap(currentUser['user']);
      });
    }
  }

  Future<void> processData() async {
    final ApiResponseModel response =
        await ApiService.get(path: 'reviews/user/${widget.user.uid}');
    final List<dynamic> psts = response.data['rows'];
    if (mounted) {
      setState(() {
        reviews = psts
            .map((dynamic reviewData) => ReviewModel.fromMap(reviewData))
            .toList();
      });
    }
    if (reviews!.isEmpty) {
      if (mounted) {
        setState(() {
          reviews = null;
        });
      }
    } else {
      int fiveCount =
          reviews!.where((ReviewModel review) => review.rating == 5).length;
      int fourCount =
          reviews!.where((ReviewModel review) => review.rating == 4).length;
      int threeCount =
          reviews!.where((ReviewModel review) => review.rating == 3).length;
      int twoCount =
          reviews!.where((ReviewModel review) => review.rating == 2).length;
      int oneCount =
          reviews!.where((ReviewModel review) => review.rating == 1).length;
      if (mounted) {
        setState(() {
          fiveStar = fiveCount;
          fourStar = fourCount;
          threeStar = threeCount;
          twoStar = twoCount;
          oneStar = oneCount;
        });
      }
    }
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cUser == null) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Seller Reviews'),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Seller Reviews'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            margin: const EdgeInsets.only(
              top: 16.0,
            ),
            child: Column(
              children: <Widget>[
                PublicProfileTile(
                  myProfile: cUser!,
                ),
                const SizedBox(
                  height: 10,
                ),
                MCustomButton(
                  buttonType: ButtonType.elevated,
                  onPressed: () async {
                    await rateSeller();
                  },
                  width: 250,
                  child: const Text(
                    'Rate Seller',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromRGBO(244, 244, 244, 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rating',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(widget.user.averageRating.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  )),
                              const SizedBox(
                                width: 3,
                              ),
                              const Text('out of 5',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                          Text('Based on ${reviews?.length} reviews'),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: widget.user.averageRating! >= 1
                                    ? const Color.fromRGBO(255, 202, 40, 1)
                                    : const Color.fromRGBO(229, 229, 229, 1),
                                size: 30,
                              ),
                              Icon(
                                Icons.star,
                                color: widget.user.averageRating! >= 2
                                    ? const Color.fromRGBO(255, 202, 40, 1)
                                    : const Color.fromRGBO(229, 229, 229, 1),
                                size: 30,
                              ),
                              Icon(
                                Icons.star,
                                color: widget.user.averageRating! >= 3
                                    ? const Color.fromRGBO(255, 202, 40, 1)
                                    : const Color.fromRGBO(229, 229, 229, 1),
                                size: 30,
                              ),
                              Icon(
                                Icons.star,
                                color: widget.user.averageRating! >= 4
                                    ? const Color.fromRGBO(255, 202, 40, 1)
                                    : const Color.fromRGBO(229, 229, 229, 1),
                                size: 30,
                              ),
                              Icon(
                                Icons.star,
                                color: widget.user.averageRating! == 5
                                    ? const Color.fromRGBO(255, 202, 40, 1)
                                    : const Color.fromRGBO(229, 229, 229, 1),
                                size: 30,
                              )
                            ],
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const Text(
                                '5 Stars',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: reviews == null
                                        ? 0
                                        : fiveStar / reviews!.length,
                                    minHeight: 10,
                                    backgroundColor: Colors.grey,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            Color.fromRGBO(255, 202, 40, 1)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                '4 Stars',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: reviews == null
                                        ? 0
                                        : fourStar / reviews!.length,
                                    minHeight: 10,
                                    backgroundColor: Colors.grey,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            Color.fromRGBO(255, 202, 40, 1)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                '3 Stars',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: reviews == null
                                        ? 0
                                        : threeStar / reviews!.length,
                                    minHeight: 10,
                                    backgroundColor: Colors.grey,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            Color.fromRGBO(255, 202, 40, 1)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                '2 Stars',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: reviews == null
                                        ? 0
                                        : twoStar / reviews!.length,
                                    minHeight: 10,
                                    backgroundColor: Colors.grey,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            Color.fromRGBO(255, 202, 40, 1)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '1 Star',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: reviews == null
                                        ? 0
                                        : oneStar / reviews!.length,
                                    minHeight: 10,
                                    backgroundColor: Colors.grey,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            Color.fromRGBO(255, 202, 40, 1)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                reviews == null
                    ? const Column(
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                          Center(
                            child: SafetyModel(
                              isLoading: false,
                              icon: Icon(
                                Icons.warning,
                                size: 100,
                              ),
                              title: 'No Review For This Seller',
                              subTitle: 'Be the first to review',
                            ),
                          ),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 100, top: 20),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: reviews?.length,
                          itemBuilder: (BuildContext context, int index) {
                            final ReviewModel review = reviews![index];

                            return ReviewTile(
                              post: review,
                              process: processData,
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<void> rateSeller() async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return FractionallySizedBox(
                  heightFactor: 0.5,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Rate Seller',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(
                                    () {
                                      rater = 0;
                                      reviewText = '';
                                    },
                                  );
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.star,
                                  color: rater >= 1
                                      ? const Color.fromRGBO(255, 202, 40, 1)
                                      : const Color.fromRGBO(229, 229, 229, 1),
                                  size: 40,
                                ),
                                onPressed: () {
                                  setState(() {
                                    rater = 1;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.star,
                                  color: rater >= 2
                                      ? const Color.fromRGBO(255, 202, 40, 1)
                                      : const Color.fromRGBO(229, 229, 229, 1),
                                  size: 40,
                                ),
                                onPressed: () {
                                  setState(() {
                                    rater = 2;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.star,
                                  color: rater >= 3
                                      ? const Color.fromRGBO(255, 202, 40, 1)
                                      : const Color.fromRGBO(229, 229, 229, 1),
                                  size: 40,
                                ),
                                onPressed: () {
                                  setState(() {
                                    rater = 3;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.star,
                                  color: rater >= 4
                                      ? const Color.fromRGBO(255, 202, 40, 1)
                                      : const Color.fromRGBO(229, 229, 229, 1),
                                  size: 40,
                                ),
                                onPressed: () {
                                  setState(() {
                                    rater = 4;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.star,
                                  color: rater >= 5
                                      ? const Color.fromRGBO(255, 202, 40, 1)
                                      : const Color.fromRGBO(229, 229, 229, 1),
                                  size: 40,
                                ),
                                onPressed: () {
                                  setState(() {
                                    rater = 5;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: TextField(
                            maxLines: 4,
                            onChanged: (String value) {
                              reviewText = value;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Write your Review here...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: MCustomButton(
                            isProcessing: isSending,
                            buttonType: ButtonType.elevated,
                            onPressed: () async {
                              setState(() {
                                isSending = true;
                              });
                              await ApiService.post(
                                path: 'reviews',
                                body: {
                                  'sellerId': widget.user.uid,
                                  'rating': rater,
                                  'reviewText': reviewText,
                                },
                              );
                              await processData();
                              setState(
                                () {
                                  rater = 0;
                                  reviewText = '';
                                  isSending = false;
                                },
                              );
                              Navigator.of(context).pop();
                            },
                            child: const Text('Rate'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
