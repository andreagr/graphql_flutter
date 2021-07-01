import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_test/classes/mission.dart';
import 'package:graphql_test/widgets/mission_entry.dart';
import 'package:graphql_test/widgets/query_error.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String queryTerm = "";
  int offsetValue = 0;
  int queryLimit = 10;
  String error = "";
  ButtonStyle buttonStyle = TextButton.styleFrom(
    primary: Colors.blue,
    backgroundColor: Colors.white,
    textStyle: TextStyle(
      fontSize: 16,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'https://s.yimg.com/ny/api/res/1.2/1F.EB0EaZ8hU2RMWzX24ig--/YXBwaWQ9aGlnaGxhbmRlcjt3PTk2MDtoPTY0MC4zMg--/https://s.yimg.com/uu/api/res/1.2/uNzzhYazYqY.8huN166k9Q--~B/aD02Njc7dz0xMDAwO2FwcGlkPXl0YWNoeW9u/https://media.zenfs.com/en/coin_rivet_596/85e72e3e8e27ef2ff4a0d3ba777cfdad',
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        height: 100,
                        child: Text(
                          "SpaceX Search",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(80.0),
                              ),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            filled: true,
                            hintStyle: new TextStyle(color: Colors.grey[800]),
                            hintText: "Type to search space missions",
                            fillColor: Colors.white,
                            errorStyle: TextStyle(color: Colors.white)),
                        onChanged: (String value) {
                          if (value.length <= 3) {
                            setState(() {
                              error = "Write at least 3 characters";
                            });
                          } else {
                            setState(() {
                              error = "";
                            });
                          }
                          setState(() {
                            queryTerm = value;
                          });
                        },
                      ),
                      SizedBox(height: 5),
                      Text(
                        error,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 20),
                      canStartQuery()
                          ? Expanded(
                              child: Query(
                                options: QueryOptions(
                                  document: gql(
                                    _gqlQuery(
                                      queryTerm,
                                      offset: offsetValue,
                                      queryLimit: queryLimit,
                                    ),
                                  ),
                                ),
                                builder: (
                                  QueryResult result, {
                                  FetchMore? fetchMore,
                                  VoidCallback? refetch,
                                }) {
                                  if (result.hasException) {
                                    return QueryError(
                                      error: result.exception.toString(),
                                    );
                                  }

                                  if (result.isLoading) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    );
                                  }
                                  List missions = result.data!['launches'];
                                  if (missions.length == 0) {
                                    offsetValue = 0;
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.network(
                                          "https://www.freeiconspng.com/thumbs/rocket-png/red-rocket-png-5.png",
                                          width: 50,
                                        ),
                                        Text(
                                          "No results!",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              shadows: [
                                                BoxShadow(
                                                  color: Colors.black,
                                                )
                                              ]),
                                        ),
                                        Image.network(
                                          "https://www.freeiconspng.com/thumbs/rocket-png/red-rocket-png-5.png",
                                          width: 50,
                                        ),
                                      ],
                                    );
                                  }
                                  return ListView.builder(
                                    itemCount: missions.length,
                                    itemBuilder: (context, index) {
                                      if (index != missions.length - 1) {
                                        return MissionEntry(
                                          mission: Mission.fromQuery(
                                            missions[index],
                                          ),
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            MissionEntry(
                                              mission: Mission.fromQuery(
                                                missions[index],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                offsetValue != 0
                                                    ? TextButton(
                                                        child: Text("< Back"),
                                                        onPressed: () {
                                                          _loadLess();
                                                        },
                                                        style: buttonStyle,
                                                      )
                                                    : Container(),
                                                TextButton(
                                                  child: Text("Next >"),
                                                  onPressed: () {
                                                    _loadMore();
                                                  },
                                                  style: buttonStyle,
                                                ),
                                              ],
                                            )
                                          ],
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _gqlQuery(String queryTerm, {int queryLimit = 10, int offset = 0}) {
    return """
    query launches {
      launches(find: {mission_name: "$queryTerm"}, limit: $queryLimit, offset: $offset) {
        id
        mission_name
        details
    }
  }
  """;
  }

  bool canStartQuery() {
    return queryTerm.length > 3;
  }

  _loadLess() {
    if (offsetValue > 10)
      setState(() {
        offsetValue -= 10;
      });
  }

  _loadMore() {
    setState(() {
      offsetValue += 10;
    });
  }
}
