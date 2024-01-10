import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AssetImageMask extends StatefulWidget {
  const AssetImageMask({
    required this.assetKey,
    required this.child,
    this.blendMode = BlendMode.modulate,
    super.key,
  });

  final String assetKey;

  final BlendMode blendMode;

  final Widget child;

  @override
  State<AssetImageMask> createState() => _AssetImageMaskState();
}

class _AssetImageMaskState extends State<AssetImageMask> {
  ui.Image? _image;

  ImageShader? _shader;

  Rect? _cachedBounds;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(AssetImageMask oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.assetKey != widget.assetKey) {
      _image?.dispose();
      _image = null;
      _shader?.dispose();
      _cachedBounds = null;

      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    final data = await rootBundle.load(widget.assetKey);
    final list = Uint8List.view(data.buffer);
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(list, completer.complete);
    _image = await completer.future;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _image?.dispose();
    _shader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = _image;

    if (image == null) {
      return widget.child;
    }

    return ShaderMask(
      shaderCallback: (bounds) {
        if (_shader == null || bounds != _cachedBounds) {
          _shader?.dispose();

          final matrix4 = Matrix4.identity().scaled(
            bounds.width / image.width,
            bounds.height / image.height,
          );

          _cachedBounds = bounds;
          _shader = ImageShader(
            image,
            TileMode.clamp,
            TileMode.clamp,
            Float64List.fromList(matrix4.storage),
          );
        }

        return _shader!;
      },
      blendMode: widget.blendMode,
      child: widget.child,
    );
  }
}
