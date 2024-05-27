// import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart';

// class RichEditor extends StatefulWidget {
//   const RichEditor({super.key, this.focusNode, required this.controller});
//   final FocusNode? focusNode;
//   final QuillController controller;

//   @override
//   State<RichEditor> createState() => RichEditorState();
// }

// class RichEditorState extends State<RichEditor> {
//   // late QuillController _controller;
//   @override
//   void initState() {
//     // _controller = widget.controller;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         QuillToolbar.simple(
//           configurations: QuillSimpleToolbarConfigurations(
//             controller: widget.controller,
//             showRedo: false,
//             showUndo: false,
//             showIndent: false,
//             showDividers: false,
//             showFontSize: false,
//             showSubscript: false,
//             showFontFamily: false,
//             showUnderLineButton: false,
//             showInlineCode: false,
//             // showInlineCode: false,
//             showSuperscript: false,
//             showClearFormat: false,
//             // showHeaderStyle: false,
//             showListCheck: false,
//             showColorButton: false,
//             showClipboardCut: false,
//             showSearchButton: false,
//             // showStrikeThrough: false,
//             showLeftAlignment: false,
//             showClipboardCopy: false,
//             showRightAlignment: false,
//             showClipboardPaste: false,
//             showCenterAlignment: false,
//             showAlignmentButtons: false,
//             showBackgroundColorButton: false,
//           ),
//         ),
//         QuillEditor.basic(
//           configurations: QuillEditorConfigurations(
//             controller: widget.controller,
//             // readOnly: false,
//             autoFocus: true,
//             placeholder:
//                 'Write your text block here. Press Meta+Enter to save.',
//             maxHeight: 200,
//             minHeight: 100,
//             showCursor: true,
//             enableSelectionToolbar: true,
//             enableScribble: true,
//             enableInteractiveSelection: true,
//           ),
//           focusNode: widget.focusNode,
//         )
//       ],
//     );
//   }
// }
