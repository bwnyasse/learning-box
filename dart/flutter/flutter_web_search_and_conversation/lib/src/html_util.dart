import 'dart:html' as html;

html.InputElement createInputElement(String id) {
  return html.InputElement()
    ..id = id
    ..style.display = 'none'; // Hide the input element
}

html.DivElement createDivElement(String id) {
  return html.DivElement();
}

void triggerSearch(String triggerId) {
  html.querySelector('#$triggerId')?.click();
}
