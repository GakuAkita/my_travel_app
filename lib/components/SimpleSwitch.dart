import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

class SimpleSwitch extends StatefulWidget {
  final double? width;
  final double? height;
  final void Function(bool status) onChanged;
  final bool isEnabled;
  final bool initialValue;
  final ValueNotifier<bool>? controller; // 👈 外部から渡せるように

  const SimpleSwitch({
    this.width,
    this.height,
    this.isEnabled = true,
    this.initialValue = false,
    this.controller,
    required this.onChanged,
    super.key,
  });

  @override
  State<SimpleSwitch> createState() => _SimpleSwitchState();
}

class _SimpleSwitchState extends State<SimpleSwitch> {
  late final ValueNotifier<bool> _internalController;
  bool _isExternalController = false;

  @override
  void initState() {
    super.initState();
    _isExternalController = widget.controller != null;

    print("is external controller?? $_isExternalController");

    if (_isExternalController) {
      //外部コントローラがある場合は、そっちを優先
      _internalController = widget.controller!;
    } else {
      print("Generate controller!! initialValue:${widget.initialValue}");
      //外部コントローラがない場合は、パラーメターを優先
      _internalController = ValueNotifier<bool>(widget.initialValue);
    }
  }

  @override
  void dispose() {
    if (!_isExternalController) {
      _internalController.dispose();
    }
    super.dispose();
  }

  Widget _buildCoreSwitch(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: AdvancedSwitch(
        controller: _internalController,
        /**
         * これ無視される？？されていないけど、、
         * GPT曰く、initialValue渡さなくてもcontrollerに入っていればそれでいいらしいけど、
         * 僕がエミュレーターで試した感じだと、無視されていない。てか、いれないと思った通りに動かない
         */
        initialValue: _internalController.value,
        width: widget.width ?? 100,
        height: widget.height ?? 40,
        activeColor: Theme.of(context).colorScheme.primary,
        inactiveColor: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  void _handleTap() {
    widget.onChanged(!_internalController.value);
  }

  @override
  Widget build(BuildContext context) {
    final coreSwitch = _buildCoreSwitch(context);
    if (!widget.isEnabled) {
      return coreSwitch;
    }

    return GestureDetector(
      onTap: _handleTap,
      child: coreSwitch,
    );
  }
}
