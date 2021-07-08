import 'package:flutter/material.dart';

class SearchPeople extends StatelessWidget {
  const SearchPeople({
    Key key,
    @required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
        height: size.height * 0.046,
        width: width,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Icon(Icons.search),
              ),
              SizedBox(
                width: width * 0.7,
                child: TextField(
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                        hintText: 'Search for People')),
              ),
            ],
          ),
        ));
  }
}
