import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageHolderView extends StatelessWidget {
  final Widget child;
  final String url;
  final Function(String) onImagePressed;
  const ImageHolderView(
      {Key? key,
      required this.child,
      this.url = '',
      required this.onImagePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: 80,
      height: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: url.isEmpty
          ? child
          : InkWell(
              onTap: () {
                onImagePressed(url);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  imageUrl: url,
                  placeholder: (context, url) => const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: LinearProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                  ),
                ),
              ),
            ),
    );
  }
}
