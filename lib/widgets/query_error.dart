import 'package:flutter/material.dart';

class QueryError extends StatefulWidget {
  final String error;

  QueryError({Key? key, required this.error}) : super(key: key);

  @override
  _QueryErrorState createState() => _QueryErrorState();
}

class _QueryErrorState extends State<QueryError> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.red, width: 2),
          ),
          child: Column(
            children: [
              Text(
                "An error occurred. Try later!",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
