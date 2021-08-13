import 'dart:developer';

import 'package:flutter/material.dart';

enum _Slot {
  chart,
  baseline,
  divider14,
  divider24,
  divider34,
  divider44,
}

typedef BarCharGetColor = Color Function(double value);
typedef BarCharGetIcon = Icon Function(double value);

/// Bar chart component. Horizontally scrollable.
/// Items can show the value and an icon on top, and a label on the footer.
class BarChart extends StatelessWidget {
  /// [Get the number of users so as to align the bar chart]
  final int users;

  /// Source data. [Changed for two dimensional data]
  final List<List<double>> data;

  /// Labels to display under the bars. [We need only one dimensional data]
  final List<String> labels;

  /// Label style. If not provided TextTheme.subtitle1 will be used
  final TextStyle? labelStyle;

  /// If enabled isplays the value on top of the bar.
  final bool displayValue;

  /// Textstyle of displayed value
  /// If not provided textTheme.caption style will be used
  final TextStyle? valueStyle;

  /// Gets the color of the bar based on the bar value.
  final List<Color> userColors;

  /// Gets the icon to be displayed on top based on the bar value.
  final BarCharGetIcon? getIcon;

  /// Radius for the top of the bar.
  /// Default 10
  final double itemRadius;

  /// Bar's width.
  /// Default 32.
  final double barWidth;

  /// Distance between bars.
  /// Default 12.
  final double barSeparation;

  /// Duration of the bar's grow animation.
  final Duration animationDuration;

  /// Animation curve to use.
  /// Default Curves.easeInOutSine
  final Curve animationCurve;

  /// If enabled, the last items in the collection will appear on the screen.
  /// User can scroll to the left.
  /// Default false
  final bool reverse;

  /// Height of the footer. Can be 0 when no labels shown.
  /// Default 16
  final double footerHeight;

  /// Height of the top's icon.
  /// Default 16
  final double iconHeight;

  /// Height of the top's value text.
  /// Default 16
  final double headerValueHeight;

  /// Grid's lines color.
  /// Default from theme.
  final Color? lineGridColor;

  /// Int labels.
  /// Default false.
  final bool roundValuesOnText;

  BarChart(
      {required this.users,
      this.labels = const [],
      this.labelStyle,
      required this.data,
      this.reverse = false,
      this.displayValue = true,
      this.valueStyle,
      required this.userColors,
      this.getIcon,
      this.barWidth = 32,
      this.barSeparation = 12,
      required this.animationDuration,
      this.itemRadius = 10,
      this.footerHeight = 32,
      this.iconHeight = 0,
      this.headerValueHeight = 16,
      this.lineGridColor,
      this.roundValuesOnText = false,
      this.animationCurve = Curves.easeInOutSine});

  @override
  Widget build(BuildContext context) {
    bool wasEmpty = false;
    if (data.length == 0) {
      _initEmptyData(context);
      wasEmpty = true;
    }

    bool showLabels = !(labels.length == 0);

    double maxValue = wasEmpty ? 1 : _getMaxData();
    return CustomMultiChildLayout(
      delegate: _FollowTheGridLines(
        header: this.headerValueHeight + this.iconHeight,
        footer: this.footerHeight,
      ),
      children: <Widget>[
        LayoutId(
          id: _Slot.baseline,
          child: Divider(
            color: lineGridColor,
            thickness: 1,
          ),
        ),
        LayoutId(
          id: _Slot.divider14,
          child: Divider(
            color: lineGridColor,
            thickness: 0.8,
          ),
        ),
        LayoutId(
          id: _Slot.divider24,
          child: Divider(
            color: lineGridColor,
            thickness: 0.8,
          ),
        ),
        LayoutId(
          id: _Slot.divider34,
          child: Divider(
            color: lineGridColor,
            thickness: 0.8,
          ),
        ),
        LayoutId(
          id: _Slot.divider44,
          child: Divider(
            color: lineGridColor,
            thickness: 0.8,
          ),
        ),
        LayoutId(
          id: _Slot.chart,
          child: ListView.separated(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            itemCount: data.length,
            reverse: reverse,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              double dataSum = 0.0;
              for (double d in data[index]) dataSum = dataSum + d;

              return _getBarItem(reverse ? (index - data.length + 1) * -1 : index, wasEmpty, displayValue, showLabels,
                  maxValue, dataSum, users);
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                width: barSeparation,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _getBarItem(
      int index, bool hideValue, bool displayValue, bool showLabels, double maxValue, double dataSum, int nousers) {
    return _BarItem(
        userNo: nousers,
        width: barWidth,
        value: data[index],
        valueStyle: valueStyle,
        label: labels.length > index ? labels[index] : null,
        labelStyle: labelStyle,
        showLabels: showLabels,
        heightFactor: (dataSum / (maxValue == 0 ? 1 : maxValue)),
        duration: animationDuration,
        getColor: userColors,
        getIcon: getIcon,
        radius: itemRadius,
        hideValue: hideValue,
        footerHeight: footerHeight,
        roundValuesOnText: roundValuesOnText,
        iconHeight: iconHeight,
        headerValueHeight: headerValueHeight,
        dislplayValue: displayValue,
        dataSum: dataSum);
  }

  void _initEmptyData(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double itemsize = barWidth + barSeparation;
    int totalItems = (width / itemsize).round();

    for (int i = 0; i < totalItems; i++) {
      data.add([0]);
    }
  }

  double _getMaxData() {
    double max = 0.0;
    for (var d in data) {
      double curr = 0.0;
      for (double p in d) curr = curr + p;
      if (curr > max) max = curr;
    }
    return max;
  }
}

class _BarItem extends ImplicitlyAnimatedWidget {
  final List<Color> getColor;
  final BarCharGetIcon? getIcon;
  final double heightFactor;
  final double width;
  final List<double> value;
  final TextStyle? valueStyle;
  final String? label;
  final TextStyle? labelStyle;
  final bool? showLabels;
  final bool hideValue;
  final bool dislplayValue;
  final double radius;
  final double footerHeight;
  final double iconHeight;
  final double headerValueHeight;
  final bool roundValuesOnText;
  final double dataSum;
  final int userNo;

  const _BarItem({
    Key? key,
    required this.userNo,
    required this.heightFactor,
    required this.width,
    required this.value,
    required this.dataSum,
    this.valueStyle,
    this.label,
    this.labelStyle,
    this.showLabels,
    this.dislplayValue = true,
    this.hideValue = false,
    required this.getColor,
    this.getIcon,
    Curve curve = Curves.linear,
    required Duration duration,
    this.radius = 10,
    this.footerHeight = 32,
    this.iconHeight = 16,
    this.roundValuesOnText = false,
    this.headerValueHeight = 16,
  }) : super(
          key: key,
          duration: duration,
          curve: curve,
        );

  @override
  _BarItemState createState() => _BarItemState();
}

class _BarItemState extends AnimatedWidgetBaseState<_BarItem> {
  Tween<double>? _transform;

  @override
  void forEachTween(visitor) {
    _transform =
        visitor(_transform, widget.heightFactor, (dynamic value) => Tween<double>(begin: value)) as Tween<double>;
  }

  @override
  Widget build(BuildContext context) {
    List<double> _gradientStops = [];
    double prev_prec = 0.0;
    for (int i = 0; i < widget.value.length; i++) {
      _gradientStops.add((prev_prec + ((widget.value[i] / widget.dataSum) * 100.0)) / 100);
      prev_prec += ((widget.value[i] / widget.dataSum) * 100.0);
    }
    // log("data" + widget.value.toString());
    // log("Gradient stops : " + _gradientStops.toString());
    // log("user colors : " + widget.getColor.length.toString());

    double? hf = _transform?.evaluate(animation);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        SizedBox(
          height: widget.iconHeight,
          width: widget.width,
          child: widget.getIcon == null || widget.hideValue ? null : widget.getIcon!(widget.dataSum),
        ),
        SizedBox(
          height: widget.headerValueHeight,
          width: widget.width,
          child: Text(
            widget.hideValue || !widget.dislplayValue
                ? ''
                : (widget.roundValuesOnText ? widget.dataSum.round().toString() : widget.dataSum.toString()) + "\$",
            textAlign: TextAlign.center,
            softWrap: false,
            style: widget.valueStyle ?? Theme.of(context).textTheme.caption,
          ),
        ),
        Flexible(
          flex: 10,
          child: FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: hf,
            child: Container(
              width: widget.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: widget.getColor,
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: _gradientStops), // color: widget.getColor(widget.value),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(widget.radius),
                  topRight: Radius.circular(widget.radius),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: widget.width,
          height: widget.footerHeight,
          child: Text(
            widget.label == null ? '' : widget.label!,
            softWrap: false,
            textAlign: TextAlign.center,
            style: widget.labelStyle ?? Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ],
    );
  }
}

class _FollowTheGridLines extends MultiChildLayoutDelegate {
  final double header;
  final double footer;

  _FollowTheGridLines({required this.header, required this.footer}) : super();

  @override
  void performLayout(Size size) {
    Size leaderSize = Size.zero;

    if (hasChild(_Slot.chart)) {
      leaderSize = layoutChild(_Slot.chart, BoxConstraints.loose(size));
      positionChild(_Slot.chart, Offset.zero);
    }

    Size dividerSize = Size(leaderSize.width, 1.0);
    double gridBottom = leaderSize.height - footer;
    double gridTop = header;

    if (hasChild(_Slot.baseline)) {
      layoutChild(_Slot.baseline, BoxConstraints.tight(dividerSize));
      positionChild(_Slot.baseline, Offset(0, gridBottom));
    }

    if (hasChild(_Slot.divider14)) {
      layoutChild(_Slot.divider14, BoxConstraints.tight(dividerSize));
      positionChild(_Slot.divider14, Offset(0, gridBottom - ((gridBottom - gridTop) / 4)));
    }

    if (hasChild(_Slot.divider24)) {
      layoutChild(_Slot.divider24, BoxConstraints.tight(dividerSize));
      positionChild(_Slot.divider24, Offset(0, gridBottom - ((gridBottom - gridTop) / 2)));
    }

    if (hasChild(_Slot.divider34)) {
      layoutChild(_Slot.divider34, BoxConstraints.tight(dividerSize));
      positionChild(_Slot.divider34, Offset(0, gridBottom - ((gridBottom - gridTop) * 3 / 4)));
    }

    if (hasChild(_Slot.divider44)) {
      layoutChild(_Slot.divider44, BoxConstraints.tight(dividerSize));
      positionChild(_Slot.divider44, Offset(0, gridBottom - (gridBottom - gridTop)));
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) => false;
}
