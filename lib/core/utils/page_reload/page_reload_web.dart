import 'dart:js_interop';

extension type _Location._(JSObject _) implements JSObject {
  external void reload();
}

@JS('location')
external _Location get _location;

/// ブラウザのページを再読み込みする。
void reloadPage() => _location.reload();
