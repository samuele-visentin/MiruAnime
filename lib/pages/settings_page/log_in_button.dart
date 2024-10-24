import 'package:flutter/material.dart';

class LogInButton extends StatelessWidget {
  final String text;
  final void Function() onTap;
  final String imageAsset;

  const LogInButton({super.key,
    required this.text,
    required this.onTap,
    required this.imageAsset
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          width: 300,
          height: 55,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(12)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset('assets/images/$imageAsset', width: 40, height: 40,),
              ),
              SizedBox(
                width: 150,
                child: Center(
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
