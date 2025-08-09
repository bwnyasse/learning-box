class FakeHtmlUtil {
  dynamic createDivElement(String id) {
    throw UnsupportedError("createDivElement in non-web context");
  }

  dynamic createInputElement(String id) {
    throw UnsupportedError("createInputElement in non-web context");
  }

  void triggerSearch(String triggerId) {
    throw UnsupportedError("triggerSearch in non-web context");
  }
}

final htmlUtil = FakeHtmlUtil();