import 'dart:async';
import 'dart:io';

import 'package:eatoutroundabout/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  Future pickImage({bool? crop, bool? compress, CropAspectRatioPreset? aspectRatio}) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 65);
    if (pickedFile != null) {
      CroppedFile croppedFile = crop ?? true ? await cropImage(pickedFile, aspectRatio) : File(pickedFile.path);
      File? compressedFile = compress ?? true ? await compressFile(croppedFile) : croppedFile as File;
      return compressedFile;
    }
  }

  cropImage(XFile pickedFile, aspectRatio) async {
    return await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatioPresets: [aspectRatio ?? CropAspectRatioPreset.square],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: primaryColor,
          toolbarWidgetColor: Colors.white,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        )
      ],
    );
  }

  Future<File> compressFile(CroppedFile file) async {
    File compressedFile = await FlutterNativeImage.compressImage(
      file.path,
      quality: 90,
    );
    return compressedFile;
  }

  uploadImage(File file) async {
    String domain = 'https://alig10.sg-host.com/';
    num uploadProgress = 0;

    final request = MultipartRequest(
      'POST',
      Uri.parse(domain + 'upload-image.php'),
      onProgress: (int bytes, int total) {
        uploadProgress = (bytes / total) * 100;
        print('progress: $uploadProgress');
      },
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'picture',
        file.path,
        contentType: MediaType('image', 'png'),
      ),
    );

    /*final streamedResponse = */
    await request.send();
    print(domain + 'images' + file.path.substring(file.path.lastIndexOf('/'), file.path.length));
    return domain + 'images' + file.path.substring(file.path.lastIndexOf('/'), file.path.length);
  }
}

class MultipartRequest extends http.MultipartRequest {
  /// Creates a new [MultipartRequest].
  MultipartRequest(
    String method,
    Uri url, {
    this.onProgress,
  }) : super(method, url);

  final void Function(int bytes, int totalBytes)? onProgress;

  /// Freezes all mutable fields and returns a single-subscription [ByteStream]
  /// that will emit the request body.
  http.ByteStream finalize() {
    final byteStream = super.finalize();
    if (onProgress == null) return byteStream;

    final total = this.contentLength;
    int bytes = 0;

    final t = StreamTransformer.fromHandlers(
      handleData: (List<int> data, EventSink<List<int>> sink) {
        bytes += data.length;
        onProgress!(bytes, total);
        sink.add(data);
      },
    );
    final stream = byteStream.transform(t);
    return http.ByteStream(stream);
  }
}
