import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:zefyr/util.dart';

import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'editor.dart';

mixin RawEditorStateSelectionDelegateMixin on EditorState
    implements TextSelectionDelegate {
  @override
  TextEditingValue get textEditingValue {
    return widget.controller.plainTextEditingValue;
  }

  @override
  set textEditingValue(TextEditingValue value) {
    final cursorPosition = value.selection.extentOffset;
    final oldText = widget.controller.document.toPlainText();
    final newText = value.text;
    final diff = fastDiff(oldText, newText, cursorPosition);
    widget.controller.replaceText(
        diff.start, diff.deleted.length, diff.inserted,
        selection: value.selection);
  }

  @override
  void copySelection(SelectionChangedCause cause) async {
    final selection = textEditingValue.selection;
    final text = textEditingValue.text;
    if (selection.isCollapsed || !selection.isValid) {
      return;
    }
    await Clipboard.setData(ClipboardData(text: selection.textInside(text)));
  }

  @override
  void cutSelection(SelectionChangedCause cause) {
    final selection = textEditingValue.selection;
    if (!selection.isValid) {
      return;
    }
    final text = textEditingValue.text;
    assert(selection != null);
    if (selection.isCollapsed) {
      return;
    }
    Clipboard.setData(ClipboardData(text: selection.textInside(text)));
    userUpdateTextEditingValue(
      TextEditingValue(
        text: selection.textBefore(text) + selection.textAfter(text),
        selection: TextSelection.collapsed(
          offset: math.min(selection.start, selection.end),
          affinity: selection.affinity,
        ),
      ),
      cause,
    );
  }

  @override
  Future<void> pasteText(SelectionChangedCause cause) async {
    final selection = textEditingValue.selection;
    if (!selection.isValid) {
      return Future<void>.value(null);
    }
    final text = textEditingValue.text;
    assert(selection != null);
    // Snapshot the input before using `await`.
    // See https://github.com/flutter/flutter/issues/11427
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data == null) {
      return Future<void>.value(null);
    }
    userUpdateTextEditingValue(
      TextEditingValue(
        text:
            selection.textBefore(text) + data.text! + selection.textAfter(text),
        selection: TextSelection.collapsed(
          offset: math.min(selection.start, selection.end) + data.text!.length,
          affinity: selection.affinity,
        ),
      ),
      cause,
    );
    hideToolbar();
  }

  @override
  void selectAll(SelectionChangedCause cause) {
    setSelection(
      textEditingValue.selection.copyWith(
        baseOffset: 0,
        extentOffset: textEditingValue.text.length,
      ),
      cause,
    );
  }

  void setSelection(TextSelection nextSelection, SelectionChangedCause cause) {
    if (nextSelection == textEditingValue.selection) {
      return;
    }
    userUpdateTextEditingValue(
      textEditingValue.copyWith(selection: nextSelection),
      cause,
    );
  }

  @override
  void userUpdateTextEditingValue(
      TextEditingValue value, SelectionChangedCause cause) {
    textEditingValue = value;
  }

  @override
  void bringIntoView(TextPosition position) {
    final localRect = renderEditor.getLocalRectForCaret(position);
    final targetOffset = _getOffsetToRevealCaret(localRect, position);

    scrollController.jumpTo(targetOffset.offset);
    renderEditor.showOnScreen(rect: targetOffset.rect);
  }

  // Finds the closest scroll offset to the current scroll offset that fully
  // reveals the given caret rect. If the given rect's main axis extent is too
  // large to be fully revealed in `renderEditable`, it will be centered along
  // the main axis.
  //
  // If this is a multiline EditableText (which means the Editable can only
  // scroll vertically), the given rect's height will first be extended to match
  // `renderEditable.preferredLineHeight`, before the target scroll offset is
  // calculated.
  RevealedOffset _getOffsetToRevealCaret(Rect rect, TextPosition position) {
    if (!scrollController.position.allowImplicitScrolling) {
      return RevealedOffset(offset: scrollController.offset, rect: rect);
    }

    final editableSize = renderEditor.size;
    double additionalOffset;
    Offset unitOffset;

    // The caret is vertically centered within the line. Expand the caret's
    // height so that it spans the line because we're going to ensure that the
    // entire expanded caret is scrolled into view.
    final expandedRect = Rect.fromCenter(
      center: rect.center,
      width: rect.width,
      height: math.max(rect.height, renderEditor.preferredLineHeight(position)),
    );

    additionalOffset = expandedRect.height >= editableSize.height
        ? editableSize.height / 2 - expandedRect.center.dy
        : 0.0
            .clamp(expandedRect.bottom - editableSize.height, expandedRect.top);
    unitOffset = const Offset(0, 1);

    // No overscrolling when encountering tall fonts/scripts that extend past
    // the ascent.
    final targetOffset = (additionalOffset + scrollController.offset).clamp(
      scrollController.position.minScrollExtent,
      scrollController.position.maxScrollExtent,
    );

    final offsetDelta = scrollController.offset - targetOffset;
    return RevealedOffset(
        rect: rect.shift(unitOffset * offsetDelta), offset: targetOffset);
  }

  @override
  void hideToolbar([bool hideHandles = true]) {
    if (selectionOverlay?.toolbarIsVisible == true) {
      selectionOverlay?.hideToolbar();
    }
  }

  @override
  bool get cutEnabled => widget.toolbarOptions.cut && !widget.readOnly;

  @override
  bool get copyEnabled => widget.toolbarOptions.copy;

  @override
  bool get pasteEnabled => widget.toolbarOptions.paste && !widget.readOnly;

  @override
  bool get selectAllEnabled => widget.toolbarOptions.selectAll;
}
