// import 'package:flutter/material.dart';
// import 'package:zefyrka/zefyrka.dart';

// class ZefyrRichEditor extends StatefulWidget {
//   const ZefyrRichEditor({super.key, this.focusNode, required this.controller});
//   final FocusNode? focusNode;
//   final ZefyrController controller;

//   @override
//   State<ZefyrRichEditor> createState() => RichEditorState();
// }

// class RichEditorState extends State<ZefyrRichEditor> {
//   // late ZefyrController _controller;
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
//         ZefyrToolbar.basic(controller: widget.controller),
//         ZefyrEditor(
//           controller: widget.controller,
//           autofocus: true,
//           maxHeight: 200,
//           minHeight: 100,
//           showCursor: true,
//           focusNode: widget.focusNode,
//         ),
//       ],
//     );
//   }
// }
