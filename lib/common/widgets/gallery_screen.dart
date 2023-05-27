import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryPhotosScreen extends StatefulWidget {
  final GalleryType galleryType;
  final int maxLength;
  final List<MyAssetEntity> selectedMyAssetEntities;

  const GalleryPhotosScreen({
    Key? key,
    this.galleryType = GalleryType.all,
    this.maxLength = 10,
    required this.selectedMyAssetEntities,
  }) : super(key: key);

  @override
  _GalleryPhotosScreenState createState() => _GalleryPhotosScreenState();
}

class _GalleryPhotosScreenState extends State<GalleryPhotosScreen> {
  List<AssetEntity> _asImages = [];
  List<AssetEntity> _asVideos = [];
  List<MyAssetEntity> _selectedAssetEntities = [];
  final ValueKey<String> _keyVideo = const ValueKey('video');
  final ValueKey<String> _keyImage = const ValueKey('Image');
  late PermissionState _permissionState;

  List<File> files = [];
  int _selectedTabIndex = 0;
  bool _isInit = false;
  bool _isLoadingImages = true;
  bool _isLoadingVideos = true;
  final ScrollController _ctrlImages = ScrollController();
  final ScrollController _ctrlVideos = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _checkPermission();
      _selectedAssetEntities = widget.selectedMyAssetEntities;
      if (widget.galleryType == GalleryType.images) {
        _selectedTabIndex = 0;
        _getGalleryData(RequestType.image);
      } else if (widget.galleryType == GalleryType.videos) {
        _selectedTabIndex = 1;
        _getGalleryData(RequestType.video);
      } else {
        _getGalleryData(RequestType.image);
      }
      _ctrlImages.addListener(_scrollListenerImg);
      _ctrlVideos.addListener(_scrollListenerVid);

      _isInit = true;
    }
  }

  Future<void> _checkPermission() async {
    _permissionState = await PhotoManager.requestPermissionExtend();
  }

  _scrollListenerImg() {
    if (_ctrlImages.position.atEdge) {
      if (_ctrlImages.position.pixels == 0) {
      } else {
        _fetchNextImages();
      }
    }
  }

  _scrollListenerVid() {
    if (_ctrlVideos.position.atEdge) {
      if (_ctrlVideos.position.pixels == 0) {
      } else {
        _fetchNextVideos();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
      ),
      floatingActionButton: FloatingActionButton(
        child: (const Icon(Icons.done_all)),
        onPressed: () {
          Navigator.of(context).pop(_selectedAssetEntities);
        },
      ),
      body: Stack(
        children: [
          _selectedTabIndex == 0
              ? _myAssetEntitiesImages.isEmpty
                  ? GallerySafety(title: 'image', isLoading: _isLoadingImages)
                  : GridView.builder(
                      key: _keyImage,
                      controller: _ctrlImages,
                      padding: EdgeInsets.only(
                          top: widget.galleryType == GalleryType.all
                              ? 64.0
                              : 0.0),
                      itemCount: _myAssetEntitiesImages.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? 5
                            : 3,
                        // crossAxisSpacing: 8,
                        // mainAxisSpacing: 8,
                        childAspectRatio: (1 / 1),
                      ),
                      itemBuilder: (BuildContext context, int i) {
                        return Container(
                          margin: const EdgeInsets.all(1.0),
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    _onSelect(_myAssetEntitiesImages[i]),
                                child: AssetViewer(
                                  image: _myAssetEntitiesImages[i].thumbnail,
                                  height: 150.0,
                                  width: 150.0,
                                  fit: BoxFit.cover,
                                  isSelected:
                                      _isSelected(_myAssetEntitiesImages[i]),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
              : _myAssetEntitiesVideos.isEmpty
                  ? GallerySafety(title: 'video', isLoading: _isLoadingVideos)
                  : GridView.builder(
                      key: _keyVideo,
                      controller: _ctrlVideos,
                      padding: EdgeInsets.only(
                          top: widget.galleryType == GalleryType.all
                              ? 64.0
                              : 0.0),
                      itemCount: _myAssetEntitiesVideos.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? 5
                            : 3,
                        // crossAxisSpacing: 8,
                        // mainAxisSpacing: 8,
                        childAspectRatio: (1 / 1),
                      ),
                      itemBuilder: (BuildContext context, int i) {
                        return Container(
                          margin: const EdgeInsets.all(1.0),
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    _onSelect(_myAssetEntitiesVideos[i]),
                                child: AssetViewer(
                                  image: _myAssetEntitiesVideos[i].thumbnail,
                                  height: 150.0,
                                  width: 150.0,
                                  fit: BoxFit.cover,
                                  isImage: _myAssetEntitiesVideos[i].isImage,
                                  isSelected:
                                      _isSelected(_myAssetEntitiesVideos[i]),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
          if ((_isLoadingNextImages && _myAssetEntitiesImages.isNotEmpty) ||
              (_isLoadingNextVideos && _myAssetEntitiesVideos.isNotEmpty))
            Positioned(
              bottom: 10.0,
              left: 0.0,
              right: 0.0,
              child: Center(
                child: Container(
                  height: 24.0,
                  width: 24.0,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ),
              ),
            ),
          if (Platform.isIOS && _permissionState == PermissionState.limited)
            Positioned(
              bottom: 10.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(8),
                child: TextButton(
                  onPressed: () {
                    PhotoManager.openSetting();
                    _getGalleryData(RequestType.image);
                  },
                  child: const Text('Show more photos'),
                ),
              ),
            ),
          if (widget.galleryType == GalleryType.all)
            Positioned(
              top: 12.0,
              left: 0.0,
              right: 0.0,
              child: Center(
                child: SizedBox(
                    width: min(MediaQuery.of(context).size.width * 0.8, 600),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (_asImages.isEmpty) {
                                _getGalleryData(RequestType.image);
                              }
                              setState(() {
                                _selectedTabIndex = 0;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  color: _selectedTabIndex == 0
                                      ? Theme.of(context).primaryColor
                                      : Colors.white,
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(8.0),
                                    topLeft: Radius.circular(8.0),
                                  )),
                              alignment: Alignment.center,
                              child: Text(
                                'Photos',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: _selectedTabIndex == 0
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (_asVideos.isEmpty) {
                                _getGalleryData(RequestType.video);
                              }
                              setState(() {
                                _selectedTabIndex = 1;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: _selectedTabIndex == 1
                                    ? Theme.of(context).primaryColor
                                    : Colors.white,
                                border: Border.all(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Videos',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: _selectedTabIndex == 1
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            )
        ],
      ),
    );
  }

  void _onSelect(MyAssetEntity myAssetEntity) {
    int l = _selectedAssetEntities.length;

    int index = _selectedAssetEntities.indexWhere((MyAssetEntity ae) =>
        ae.assetEntity.id == myAssetEntity.assetEntity.id);
    if (index == -1) {
      setState(() {
        if (l >= widget.maxLength) return;
        _selectedAssetEntities.add(myAssetEntity);
      });
    } else {
      setState(() {
        _selectedAssetEntities.removeAt(index);
      });
    }
  }

  bool _isSelected(MyAssetEntity myAssetEntity) {
    int? index = _selectedAssetEntities.indexWhere((MyAssetEntity ae) =>
        ae.assetEntity.id == myAssetEntity.assetEntity.id);
    if (index > -1) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _getGalleryData(RequestType requestType) async {
    try {
      setState(() {
        if (requestType == RequestType.image) {
          _isLoadingImages = true;
        } else if (requestType == RequestType.image) {
          _isLoadingVideos = true;
        }
      });
      final List<AssetPathEntity> assets =
          await PhotoManager.getAssetPathList(onlyAll: true, type: requestType);
      final AssetPathEntity recentAlbums = assets.first;

      List<AssetEntity> data =
          await recentAlbums.getAssetListPaged(page: 0, size: 80);
      data.sort((AssetEntity a, AssetEntity b) =>
          b.createDateTime.compareTo(a.createDateTime));
      if (requestType == RequestType.image) {
        setState(() {
          _asImages = data;
          _fetchNextImages();
        });
      } else {
        setState(() {
          _asVideos = data;
          _fetchNextVideos();
        });
      }
    } catch (e, stack) {
      debugPrint('stack: $stack : $e');
    }
  }

  final List<MyAssetEntity> _myAssetEntitiesImages = [];
  bool _isLoadingNextImages = false;
  int _loadedImages = 0;

  void _fetchNextImages() async {
    _loadedImages += 30;
    if (_asImages.length < _myAssetEntitiesImages.length ||
        _isLoadingNextImages) {
      setState(() {
        _isLoadingImages = false;
      });
      return;
    }
    final List<MyAssetEntity> newImages = [];
    setState(() {
      _isLoadingNextImages = true;
    });
    for (int i = _myAssetEntitiesImages.length;
        i < min(_asImages.length, _loadedImages);
        i++) {
      Uint8List? thumbnail = await _asImages[i]
          .thumbnailDataWithSize(const ThumbnailSize.square(100), quality: 80);
      AssetEntity assetEntity = _asImages[i];

      newImages.add(MyAssetEntity(
          assetEntity: assetEntity, thumbnail: thumbnail!, isImage: true));
    }
    debugPrint('_myAssetEntitiesImages: ${_myAssetEntitiesImages.length}');
    if (mounted) {
      setState(() {
        _isLoadingNextImages = false;
        _myAssetEntitiesImages.addAll(newImages);
        _isLoadingImages = false;
      });
    }
  }

  final List<MyAssetEntity> _myAssetEntitiesVideos = [];
  bool _isLoadingNextVideos = false;
  int _loadedVideos = 0;

  void _fetchNextVideos() async {
    debugPrint(
        '_asVideos.length: ${_asVideos.length}: myAssets: ${_myAssetEntitiesVideos.length}');

    _loadedVideos += 20;
    if (_asVideos.length < _myAssetEntitiesVideos.length ||
        _isLoadingNextVideos) {
      setState(() {
        _isLoadingVideos = false;
      });
      return;
    }
    final List<MyAssetEntity> newVideos = [];
    setState(() {
      _isLoadingNextVideos = true;
    });
    for (int i = _myAssetEntitiesVideos.length;
        i < min(_asVideos.length, _loadedVideos);
        i++) {
      debugPrint('FOR LOOP');
      Uint8List? thumbnail = await _asVideos[i]
          .thumbnailDataWithSize(const ThumbnailSize.square(100), quality: 50);
      AssetEntity assetEntity = _asVideos[i];

      newVideos.add(MyAssetEntity(
        assetEntity: assetEntity,
        thumbnail: thumbnail!,
        isImage: false,
      ));
    }
    setState(() {
      _isLoadingNextVideos = false;
      _myAssetEntitiesVideos.addAll(newVideos);
      _isLoadingVideos = false;
    });
  }
}

class AssetViewer extends StatelessWidget {
  // final AssetEntity assetEntity;
  final Uint8List? image;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool isImage;
  final bool isSelected;
  final File? file;
  const AssetViewer(
      {Key? key,
      // Key key,
      // @required this.assetEntity,
      this.image,
      this.width,
      this.height,
      this.fit,
      this.isImage = true,
      this.isSelected = false,
      this.file})
      : super(key: key);

  // : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (image == null && file == null) {
      return _buildContainer();
    }
    return Stack(
      children: [
        if (!isImage)
          const Center(
              child: Icon(Icons.image, color: Colors.grey, size: 48.0)),
        Container(
          decoration: BoxDecoration(
              border: isSelected
                  ? Border.all(
                      color: Theme.of(context).primaryColor, width: 2.0)
                  : Border.all(
                      color: Colors.transparent,
                    )),
          child: file == null
              ? Image.memory(
                  image!,
                  width: width,
                  height: height,
                  fit: fit,
                )
              : Image.file(
                  file!,
                  width: width,
                  height: height,
                  fit: fit,
                ),
        ),
        if (isSelected)
          Positioned(
            right: 4.0,
            top: 4.0,
            child: Icon(
              Icons.check,
              color: Theme.of(context).primaryColor,
            ),
          ),
        if (!isImage)
          const Center(
            child: Icon(
              Icons.play_arrow,
              color: Colors.black54,
              size: 40.0,
            ),
          )
      ],
    );
  }

  Widget _buildContainer({Widget? child}) {
    return SizedBox(
      width: width,
      height: height,
      child: child,
    );
  }
}

class MyAssetEntity {
  AssetEntity assetEntity;
  Uint8List thumbnail;
  bool isImage;

  MyAssetEntity({
    required this.assetEntity,
    required this.thumbnail,
    required this.isImage,
  });
}

class GallerySafety extends StatelessWidget {
  final bool isLoading;
  final String? title;

  const GallerySafety({
    Key? key,
    this.isLoading = false,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isLoading
              ? const SizedBox(
                  height: 24.0,
                  width: 24.0,
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    getIcon(title: title!),
                    const SizedBox(height: 16.0),
                    Text(
                      'There is not $title to select',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 4.0),
                  ],
                )
        ],
      ),
    );
  }

  Icon getIcon({String title = 'image'}) {
    Icon icon = title.toLowerCase() == 'video'
        ? const Icon(
            Icons.play_arrow,
            size: 80.0,
            color: Colors.grey,
          )
        : const Icon(
            Icons.photo_library,
            size: 80.0,
            color: Colors.grey,
          );
    return icon;
  }
}

enum GalleryType { videos, images, all }

Future<File?> toFile(MyAssetEntity myAssetEntity) async {
  AssetEntity? ae = myAssetEntity.assetEntity;

  Future<File?>? file = ae.file;
  return file;
}
