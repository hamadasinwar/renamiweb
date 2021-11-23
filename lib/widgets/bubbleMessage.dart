import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final bool isImage;
  MessageBubble(
      {required this.message, required this.isMe, required this.isImage});

  @override
  Widget build(BuildContext context) {
    ui.platformViewRegistry.registerViewFactory(
      message,
      (int _) => ImageElement()..src = message,
    );
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: isMe
                      ? Colors.purple[100]
                      : Color.fromARGB(255, 255, 255, 153),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft:
                        !isMe ? Radius.circular(0) : Radius.circular(12),
                    bottomRight:
                        isMe ? Radius.circular(0) : Radius.circular(12),
                  )),
              width: 140,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: isImage
                  ? Container(
                      height: 300,
                      width: 400,
                      child: HtmlElementView(
                        viewType: message,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          message,
                          style: TextStyle(
                              color: isMe ? Colors.black : Colors.purple),
                          textAlign: isMe ? TextAlign.end : TextAlign.start,
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
