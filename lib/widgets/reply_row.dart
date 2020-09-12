import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:story_viewer/viewer.dart';
import 'package:story_viewer/viewer_controller.dart';
import 'package:story_viewer/widgets/source_row.dart';

class StoryReplyRow extends StatelessWidget {
  final StoryViewer viewer;
  final TextEditingController textController;
  final StoryViewerController viewerController;
  final Function(bool hasFocus) onFocusChange;
  final FocusNode textNode;

  const StoryReplyRow({
    Key key,
    this.viewer,
    this.viewerController,
    this.textController,
    this.onFocusChange,
    this.textNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (viewerController.owner) {
      return Container(
        width: 0,
        height: 0,
      );
    }
    double bottom = MediaQuery.of(context).viewInsets.bottom;
    Widget returnW = Container(
      width: ScreenUtil.screenWidth,
      padding: EdgeInsets.only(bottom: bottom),
      color: Colors.black12,
      child: SafeArea(
        top: false,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Focus(
                    onFocusChange: onFocusChange, child: textField(context)),
              ),
            ),
            CupertinoButton(
              child: Icon(
                viewer.customizer.sendIcon,
                color: Colors.white,
              ),
              onPressed: () {
                viewer.onStoryReplied?.call(
                  storyID: viewerController.currentStory.id,
                  message: textController.text,
                );
              },
            )
          ],
        ),
      ),
    );
    if (!viewer.showSource) {
      returnW = Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SourceRow(
            viewer: viewer,
            source: viewerController.currentStory.source,
          ),
          returnW,
        ],
      );
    }
    return returnW;
  }

  Widget textField(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return CupertinoTextField(
        focusNode: textNode,
        controller: textController,
        keyboardAppearance: MediaQuery.of(context).platformBrightness,
        padding: EdgeInsets.all(ScreenUtil().setWidth(32)),
        placeholderStyle: TextStyle(
          decoration: TextDecoration.none,
          color: Colors.white54,
          fontSize: ScreenUtil().setSp(44),
        ),
        placeholder: viewer.customizer.replyPlaceholder,
        decoration: BoxDecoration(),
        maxLines: 1,
        style: TextStyle(
          decoration: TextDecoration.none,
          color: Colors.white,
          fontSize: ScreenUtil().setSp(44),
        ),
        onSubmitted: (String message) {
          viewer.onStoryReplied?.call(
            storyID: viewerController.currentStory.id,
            message: message,
          );
        },
      );
    } else {
      return Material(
        color: Colors.transparent,
        child: TextField(
          focusNode: textNode,
          controller: textController,
          keyboardAppearance: MediaQuery.of(context).platformBrightness,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(ScreenUtil().setWidth(32)),
            border: InputBorder.none,
            helperStyle: TextStyle(
              decoration: TextDecoration.none,
              color: Colors.white60,
            ),
            hintStyle: TextStyle(
              decoration: TextDecoration.none,
              color: Colors.white54,
              fontSize: ScreenUtil().setSp(44),
            ),
            hintText: viewer.customizer.replyPlaceholder,
          ),
          maxLines: 1,
          style: TextStyle(
            decoration: TextDecoration.none,
            color: Colors.white,
            fontSize: ScreenUtil().setSp(44),
          ),
          onSubmitted: (String message) {
            viewer.onStoryReplied?.call(
              storyID: viewerController.currentStory.id,
              message: message,
            );
          },
        ),
      );
    }
  }
}
