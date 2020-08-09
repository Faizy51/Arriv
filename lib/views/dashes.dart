import 'package:flutter/material.dart';

class Dashes extends StatelessWidget {
  const Dashes({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width -
          (MediaQuery.of(context).size.width / 10),
      child: Row(
        children: List.generate(
            150 ~/ 3,
            (index) => Expanded(
                  child: Container(
                    color: index % 2 == 0 ? Colors.transparent : Colors.black87,
                    height: 1,
                  ),
                )),
      ),
    );
  }
}