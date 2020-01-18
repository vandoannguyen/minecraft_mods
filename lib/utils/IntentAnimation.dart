import 'package:flutter/cupertino.dart';

enum IntentAnimationOption {
  LEFT_TO_RIGHT,
  EXIT_LEFT_TO_RIGHT,
  RIGHT_TO_LEFT,
  EXIT_RIGHT_TO_LEFT,
  TOP_TO_BOTTOM,
  EXIT_TOP_TO_BOTTOM,
  BOTTOM_TO_TOP,
  EXIT_BOTTOM_TO_TOP,
  FADE,
  ZOOM,
  ROTATE,
  SCALE,
  ZOOM_ROLATE
}

class IntentAnimation {
  static Future intentNomal(
      {@required BuildContext context,
      @required Widget screen,
      Widget exitScreen,
      @required IntentAnimationOption option,
      @required Duration duration}) {
    return Navigator.of(context).push(SlideRoute(
        page: screen,
        option: option,
        exitScreen: exitScreen,
        duration: duration));
  }

  static Future intentPushReplacement(
      {@required BuildContext context,
      @required Widget screen,
      Widget exitScreen,
      @required IntentAnimationOption option,
      @required Duration duration}) {
    return Navigator.of(context).pushReplacement(SlideRoute(
        page: screen,
        option: option,
        exitScreen: exitScreen,
        duration: duration));
  }

  static bool intentBack({@required BuildContext context, result}) {
    return Navigator.pop(context, result);
  }

  static bool intentBack1({@required BuildContext context, result}) {
    return Navigator.of(context).pop();
  }
}

class SlideRoute extends PageRouteBuilder {
  final Widget page;
  Duration duration;
  SlideRoute(
      {@required this.page,
      @required option,
      @required this.duration,
      exitScreen})
      : super(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                page,
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              switch (option) {
                case IntentAnimationOption.LEFT_TO_RIGHT:
                  {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(-1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  }
                case IntentAnimationOption.RIGHT_TO_LEFT:
                  {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  }
                case IntentAnimationOption.EXIT_LEFT_TO_RIGHT:
                  {
                    if (exitScreen == null) throw "Exit Screen is null";
                    return Stack(
                      children: <Widget>[
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0),
                            end: Offset(1, 0),
                          ).animate(animation),
                          child: exitScreen,
                        ),
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(-1, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        )
                      ],
                    );
                  }
                case IntentAnimationOption.EXIT_RIGHT_TO_LEFT:
                  {
                    if (exitScreen == null) throw "Exit Screen is null";
                    return Stack(
                      children: <Widget>[
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0),
                            end: Offset(-1, 0),
                          ).animate(animation),
                          child: exitScreen,
                        ),
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        )
                      ],
                    );
                  }
                case IntentAnimationOption.TOP_TO_BOTTOM:
                  {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -1),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  }
                case IntentAnimationOption.BOTTOM_TO_TOP:
                  {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  }
                case IntentAnimationOption.EXIT_TOP_TO_BOTTOM:
                  {
                    if (exitScreen == null) throw "Exit Screen is null";
                    return Stack(
                      children: <Widget>[
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0),
                            end: Offset(0, 1),
                          ).animate(animation),
                          child: exitScreen,
                        ),
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, -1),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        )
                      ],
                    );
                  }
                case IntentAnimationOption.EXIT_BOTTOM_TO_TOP:
                  {
                    if (exitScreen == null) throw "Exit Screen is null";
                    return Stack(
                      children: <Widget>[
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0),
                            end: Offset(0, -1),
                          ).animate(animation),
                          child: exitScreen,
                        ),
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 1),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        )
                      ],
                    );
                  }
                case IntentAnimationOption.FADE:
                  {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                      alwaysIncludeSemantics: true,
                    );
                  }
                case IntentAnimationOption.ZOOM:
                  {
                    return Align(
                      alignment: Alignment.center,
                      child: SizeTransition(
                        sizeFactor: animation,
                        child: child,
                      ),
                    );
                  }
                case IntentAnimationOption.SCALE:
                  {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                      alignment: Alignment.center,
                    );
//                    return ScaleTransition(
//                      scale: Tween<double>(
//                        begin: 0.0,
//                        end: 1.0,
//                      ).animate(
//                        CurvedAnimation(
//                          parent: animation,
//                          curve: Curves.fastOutSlowIn,
//                        ),
//                      ),
//                      child: child,
//                    );
                  }
                case IntentAnimationOption.ROTATE:
                  {
                    return RotationTransition(
                      turns: Tween<double>(
                        begin: 0.0,
                        end: 1.0,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.linear,
                        ),
                      ),
                      child: child,
                    );
                  }
                case IntentAnimationOption.ZOOM_ROLATE:
                  {
                    return ScaleTransition(
                      scale: Tween<double>(
                        begin: 0.0,
                        end: 1.0,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.fastOutSlowIn,
                        ),
                      ),
                      child: RotationTransition(
                        turns: Tween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.linear,
                          ),
                        ),
                        child: child,
                      ),
                    );
                  }
                default:
                  {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(-1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  }
              }
            });
}
