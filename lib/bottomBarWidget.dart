import 'package:flutter/material.dart';
import 'package:matjer/Post.dart';
import 'package:matjer/firstPage.dart';

// ignore: must_be_immutable
class BottomBarWidget extends StatefulWidget {
  BottomBarWidget(this.posts, {Key? key}) : super(key: key);
  List<Post> posts;

  @override
  State<BottomBarWidget> createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: SizedBox(
          width: double.infinity,
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () {},
                    child: Column(
                      children: const [
                        Icon(Icons.account_balance_rounded, size: 40),
                        Text("open"),
                      ],
                    )),
              ),
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FirstPage(widget.posts),
                          ));
                    },
                    child: Column(
                      children: const [
                        Icon(Icons.home_rounded, size: 40),
                        Text("open"),
                      ],
                    )),
              ),
              Expanded(
                child: ElevatedButton(
                    onPressed: () {},
                    child: Column(
                      children: const [
                        Icon(
                          Icons.shop_2_rounded,
                          size: 40,
                        ),
                        Text("open"),
                      ],
                    )),
              ),
            ],
          ),
        ));
  }
}
