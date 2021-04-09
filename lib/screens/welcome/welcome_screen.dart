import 'package:flutter/material.dart';
import 'package:EasyMP3/constants.dart';
import 'package:EasyMP3/screens/home/home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/welcome_image.png"),
            Text(
              "Welcome to EasyMP3 \n Tracks Streamer",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                )
            ),
            Text(
                "Listen to and download your \n favorite track in a few seconds.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.5,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w200,
                  color: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.color
                      ?.withOpacity(0.90),
                )
            ),
            FittedBox(
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.grey,
                ),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    )
                  );
                },
                child: Row(
                  children: [
                    Text(
                      "Skip",
                      style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.color
                            ?.withOpacity(0.8)
                      ),
                    ),
                    SizedBox(
                        width: kDefaultPadding,
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 16,
                      color: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.color
                        ?.withOpacity(0.8)
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
