@JS()
library heic2any;

import "dart:html";
import "dart:typed_data";

import "package:js/js.dart";
import "package:js/js_util.dart";
import "package:http/http.dart";

bool isHEIC(Uint8List bytes) {
  return String.fromCharCodes(bytes, 0, 16).contains("ftypheic");
}

Future<Uint8List> convertFromHEIC(Uint8List imageBytes) async {
  var heicBlob = Blob([imageBytes]);
  var pngBlob = await _doTheThing(heicBlob);
  Uint8List resultBytes = await bytesFromBlob(pngBlob);
  return resultBytes;
}

@JS("useHeic2any")
external dynamic _useHeic2any(Blob blob);

Future<Blob> _doTheThing(Blob blob) async {
  var promise = _useHeic2any(blob);
  var qs = await promiseToFuture(promise);
  return qs;
}

Future<Uint8List> bytesFromBlob(Blob pngBlob) async {
  var objectUrl = Url.createObjectUrlFromBlob(pngBlob);
  var resultBytes = await readBytes(Uri.parse(objectUrl));
  Url.revokeObjectUrl(objectUrl);
  return resultBytes;
}

