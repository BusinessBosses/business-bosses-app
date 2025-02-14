import 'package:business_bosses_v2/bbpro/models/customitem_model.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/custom_item_card.dart';
import 'package:business_bosses_v2/bbpro/widgets/inventorycard.dart';
import 'package:business_bosses_v2/bbpro/widgets/proseardwidget.dart';
import 'package:business_bosses_v2/bbpro/widgets/servicecard.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BizCenterSearch extends StatefulWidget {
  const BizCenterSearch({super.key});

  @override
  _BizCenterSearchState createState() => _BizCenterSearchState();
}

class _BizCenterSearchState extends State<BizCenterSearch>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  List<Product> _allProducts = <Product>[];
  List<Product> _filteredProducts = <Product>[];
  List<Service> _allServices = <Service>[];
  List<Service> _filteredServices = <Service>[];
  List<Customitem> _allCustomItems = <Customitem>[];
  List<Customitem> _filteredCustomItems = <Customitem>[];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeData();
    _searchController.addListener(() {
      _performSearch(_searchController.text);
    });
  }

  void _initializeData() {
    // Initialize with some dummy data
    _allProducts = List.generate(
        10,
        (int index) => Product(
              id: index,
              name: 'Product $index',
              price: 10.0 * index,
              description: 'Description for product $index',
              category: 'Category $index',
              itemType: 'Type $index',
              isActive: true,
              createdAt: DateTime.now(),
            ));
    _filteredProducts = List.from(_allProducts);

    _allServices = List.generate(
        10,
        (int index) => Service(
              id: index,
              name: 'Service $index',
              price: 20.0 * index,
              discount: 5.0 * index,
              description: 'Description for service $index',
              location: 'Location $index',
              itemType: 'Type $index',
              isActive: true,
              createdAt: DateTime.now(),
            ));
    _filteredServices = List.from(_allServices);

    _allCustomItems = List.generate(
        10,
        (int index) => Customitem(
              images: <String>[''],
              id: index,
              title: 'Custom Item $index',
              description: 'Description for custom item $index',
              createdAt: DateTime.now(),
            ));
    _filteredCustomItems = List.from(_allCustomItems);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      _filteredProducts = _allProducts
          .where((Product product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _filteredServices = _allServices
          .where((Service service) =>
              service.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _filteredCustomItems = _allCustomItems
          .where((Customitem customitem) =>
              customitem.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          // ignore: always_specify_types
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
          title: GestureDetector(
            onTap: () {
              if (Get.previousRoute == Routes.publicProfile) {
                Get.back();
              } else {}
            },
            // Get.to(UserShopScreen(
            //   user: widget.customitem!.user!,
            // ));

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Shop name',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(radius)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Visit Biz-Center',
                        style: TextStyle(
                          fontSize: 10,
                          color: textColor,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: textColor,
                        size: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ProSearchbar(
                radius: 8,
                contentPadding: 10,
                hasSearchIcon: false,
                backgroundColor: backgroundColor,
                hintText: 'Search...',
                autofocus: false,
                onChange: (String query) {
                  _performSearch(query);
                },
                onSubmit: (String query) {},
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.black,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  tabs: const <Tab>[
                    Tab(text: 'Products'),
                    Tab(text: 'Services'),
                    Tab(text: 'Custom Items'),
                  ],
                ),
                const Divider(
                  height: 1,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15,
              ),
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  ProductsTab(products: _filteredProducts),
                  ServicesTab(services: _filteredServices),
                  CustomItemsTab(customItems: _filteredCustomItems),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductsTab extends StatelessWidget {
  final List<Product> products;

  const ProductsTab({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(child: Text('No results found'));
    }
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: InventoryCard(
            myShop: false,
            product: products[index],
          ),
        );
      },
    );
  }
}

class ServicesTab extends StatelessWidget {
  final List<Service> services;

  const ServicesTab({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return const Center(child: Text('No results found'));
    }
    return ListView.builder(
      itemCount: services.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ServiceCard(
            myShop: false,
            service: services[index],
          ),
        );
      },
    );
  }
}

class CustomItemsTab extends StatelessWidget {
  final List<Customitem> customItems;

  const CustomItemsTab({super.key, required this.customItems});

  @override
  Widget build(BuildContext context) {
    if (customItems.isEmpty) {
      return const Center(child: Text('No results found'));
    }
    return ListView.builder(
      itemCount: customItems.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: CustomItemCard(
            myShop: false,
            customitem: customItems[index],
          ),
        );
      },
    );
  }
}
