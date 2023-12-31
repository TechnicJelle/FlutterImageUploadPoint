import "dart:typed_data";

import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

import "heic2any.dart";

const double imageSize = 300;

class ImageUploadPoint extends StatelessWidget {
  const ImageUploadPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const _UploadedImage(),
    );
  }
}

class _UploadedImage extends StatefulWidget {
  const _UploadedImage();

  @override
  State<_UploadedImage> createState() => _UploadedImageState();
}

class _UploadedImageState extends State<_UploadedImage> {
  Uint8List? image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (image == null)
          const _UploadButton()
        else
          Image.memory(
            image!,
            fit: BoxFit.cover,
            width: imageSize,
            height: imageSize,
          ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onLongPress: () {
                // Remove image
                setState(() {
                  image = null;
                });
              },
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? pickedImage = await picker.pickImage(
                  source: ImageSource.gallery,
                  requestFullMetadata: false,
                );
                if (pickedImage == null) return; // User cancelled the popup

                Uint8List imageBytes = await pickedImage.readAsBytes();

                if (Heic2Any.isHEIC(imageBytes)) {
                  print("Converting HEIC... ${String.fromCharCodes(imageBytes, 0, 16)}");
                  imageBytes = await Heic2Any.convert(imageBytes);
                  print("Converted HEIC! ${String.fromCharCodes(imageBytes, 0, 16)}");
                }

                setState(() {
                  image = imageBytes;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _UploadButton extends StatelessWidget {
  const _UploadButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      width: imageSize,
      height: imageSize,
      child: const Center(
        child: Icon(
          Icons.upload,
          color: Colors.white,
          size: 128,
        ),
      ),
    );
  }
}
