part of flutter_video_cast_nullsafety;

final AirPlayPlatform _airPlayPlatform = AirPlayPlatform.instance;

/// Widget that displays the AirPlay button.
class AirPlayButton extends StatelessWidget {
  /// Creates a widget displaying a AirPlay button.
  AirPlayButton({
    Key? key,
    this.size = 30.0,
    this.color = Colors.black,
    this.activeColor = Colors.white,
    required this.isConnected,
    required this.onRoutesOpening,
    required this.onRoutesClosed,
  }) : super(key: key);

  /// The size of the button.
  final double size;

  /// The color of the button.
  final Color color;

  final Function(bool? a) isConnected;

  /// The color of the button when connected.
  final Color activeColor;

  /// Called while the AirPlay popup is opening.
  final VoidCallback onRoutesOpening;

  /// Called when the AirPlay popup has closed.
  Function(bool? b) onRoutesClosed;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = {
      'red': color.red,
      'green': color.green,
      'blue': color.blue,
      'alpha': color.alpha,
      'activeRed': activeColor.red,
      'activeGreen': activeColor.green,
      'activeBlue': activeColor.blue,
      'activeAlpha': activeColor.alpha,
    };
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return SizedBox(
        width: size,
        height: size,
        child: _airPlayPlatform.buildView(args, _onPlatformViewCreated),
      );
    }
    return SizedBox();
  }

  Future<void> _onPlatformViewCreated(int id) async {
    await _airPlayPlatform.init(id);
   // isConnected=    await _airPlayPlatform.isConnected(id);
    isConnected(await _airPlayPlatform.isConnected(id));

    if (onRoutesOpening != null) {
      _airPlayPlatform.onRoutesOpening(id: id).listen((_) => onRoutesOpening());
    }
    if (onRoutesClosed != null) {
      _airPlayPlatform
          .onRoutesClosed(id: id)
          .listen((event) async{
            bool? a= await _airPlayPlatform.isConnected(id);
            return onRoutesClosed(a);
      });
    }
  }
}