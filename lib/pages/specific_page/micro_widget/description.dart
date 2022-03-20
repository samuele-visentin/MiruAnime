import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  final String description;
  const Description({Key? key, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.symmetric(vertical: 4.5)),
                SizedBox(
                  child: Text(
                    description,
                    style: Theme.of(context).textTheme.subtitle2,
                  )
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 4.5))
              ]
          ),
        ),
      ),
    );
  }
}
