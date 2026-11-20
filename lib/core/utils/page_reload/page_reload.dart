// webではページを再読み込みし、それ以外では何もしない。
export 'page_reload_stub.dart' if (dart.library.js_interop) 'page_reload_web.dart';
