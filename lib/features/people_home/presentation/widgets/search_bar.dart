import 'package:JumpIn/features/people_home/domain/search_provider.dart';
import 'package:JumpIn/features/people_profile/presentation/screens/people_profile.dart';
import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key key,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<SearchProvider>(builder: (context, searchProvider, child) {
      return FloatingSearchBar(
        hint: 'Search for people, plans...',
        hintStyle: TextStyle(fontSize: size.height * 0.02),
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 800),
        transitionCurve: Curves.easeInOut,
        physics: const BouncingScrollPhysics(),
        axisAlignment: size.width * 0.8,
        openAxisAlignment: 0.0,
        width: 600,
        height: size.height * 0.06,
        toolbarOptions:
            ToolbarOptions(copy: true, cut: true, paste: true, selectAll: true),
        debounceDelay: const Duration(milliseconds: 500),
        onQueryChanged: (query) {
          searchProvider.searchUserName(query);
        },
        onSubmitted: (query) {},
        onFocusChanged: (isFocused) {},
        automaticallyImplyDrawerHamburger: false,
        automaticallyImplyBackButton: false,
        backgroundColor: Colors.grey[50],
        backdropColor: Colors.grey[50].withOpacity(0.6),
        builder: (context, transition) {
          if (searchProvider.getLoadingStatus == true) {
            return Container(
              height: widget.height * 0.1,
              color: Colors.grey[50],
              child: SpinKitThreeBounce(
                color: Colors.lightBlue[900],
                size: widget.height * 0.03,
              ),
            );
          }
          if (searchProvider.tempUserNamesWithIds.isEmpty &&
              searchProvider.userNamesWithIds.isEmpty) {
            return Container();
          }
          if (searchProvider.tempUserNamesWithIds.isNotEmpty) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: widget.height * 0.4),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: searchProvider.tempUserNamesWithIds.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      // homeScreenProv.capturePng(widget.user.id, _globalKey);
                      bool val = await searchProvider.checkIfConnection(
                          searchProvider.tempUserNamesWithIds[index]["id"]
                              as String);
                      print(val);
                      if (val == true) {
                        Navigator.pushNamed(
                          context,
                          rPeopleProfile,
                          arguments: [
                            searchProvider.tempUserNamesWithIds.isNotEmpty
                                ? searchProvider.tempUserNamesWithIds[index]
                                    ["id"] as String
                                : searchProvider.userNamesWithIds[index]["id"]
                                    as String,
                            "connection"
                          ],
                        );
                      } else {
                        Navigator.pushNamed(
                          context,
                          rPeopleProfile,
                          arguments: [
                            searchProvider.tempUserNamesWithIds.isNotEmpty
                                ? searchProvider.tempUserNamesWithIds[index]
                                    ["id"] as String
                                : searchProvider.userNamesWithIds[index]["id"]
                                    as String,
                            "search"
                          ],
                        );
                      }
                    },
                    child: ClipRRect(
                      child: Material(
                        color: Colors.grey[50],
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: widget.height * 0.02,
                              horizontal: widget.width * 0.05),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    searchProvider.tempUserNamesWithIds[index]
                                        ["photoUrl"] as String),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: widget.width * 0.04),
                                child: Text(
                                  searchProvider.tempUserNamesWithIds[index]
                                      ["userName"] as String,
                                  textScaleFactor: 1,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: widget.height * 0.4),
              child: ListView.builder(
                itemCount: searchProvider.userNamesWithIds.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      bool val = await searchProvider.checkIfConnection(
                          searchProvider.userNamesWithIds[index]["id"]
                              as String);
                      print(val);
                      if (val == true) {
                        Navigator.pushNamed(context, rPeopleProfile,
                            arguments: [
                              searchProvider.userNamesWithIds[index]["id"]
                                  as String,
                              "connection"
                            ]);
                      } else {
                        Navigator.pushNamed(context, rPeopleProfile,
                            arguments: [
                              searchProvider.userNamesWithIds[index]["id"]
                                  as String,
                              "search"
                            ]);
                      }
                    },
                    child: ClipRRect(
                      child: Material(
                        color: Colors.grey[50],
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: widget.height * 0.02,
                              horizontal: widget.width * 0.05),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    searchProvider.userNamesWithIds[index]
                                        ["photoUrl"] as String),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: widget.width * 0.04),
                                child: Text(
                                  searchProvider.userNamesWithIds[index]
                                      ["userName"] as String,
                                  textScaleFactor: 1,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      );
    });
  }
}
