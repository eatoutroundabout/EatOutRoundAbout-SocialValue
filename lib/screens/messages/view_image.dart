import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ViewImages extends StatefulWidget {
  final List? images;
  final int? index;

  ViewImages({this.images, this.index});

  @override
  _RestaurantPage2State createState() => _RestaurantPage2State();
}

class _RestaurantPage2State extends State<ViewImages> {
  PageController? pageController;

  @override
  void initState() {
    pageController = new PageController(initialPage: widget.index!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          LoadingData(),
          PhotoViewGallery.builder(
            itemCount: widget.images!.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(widget.images![index]),
              );
            },
            pageController: pageController,
          ),
        ],
      ),
    );
  }
}
