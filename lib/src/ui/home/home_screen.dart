import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../api/api_service.dart';
import '../../model/profile.dart';
import '../../ui/formadd/form_add_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BuildContext context;
  ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
  }

  Future<void> _getData() async {
    setState(() {
      apiService = ApiService();
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _getData,
        child: FutureBuilder(
          future: apiService.getProfiles(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Profile>> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                    "Something wrong with message: ${snapshot.error.toString()}"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<Profile> profiles = snapshot.data;
              return _buildListView(profiles);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildListView(List<Profile> profiles) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          Profile profile = profiles[index];
          return Container(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.only(top: 15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Color(0XFFEFF3F6),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    offset: Offset(5, 5),
                    blurRadius: 6.0,
                    spreadRadius: 1.0,
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(255, 255, 255, 0.9),
                    offset: Offset(-5, -5),
                    blurRadius: 6.0,
                    spreadRadius: 1.0,
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Title: ' + profile.content,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'Id: ' + profile.id.toString(),
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600]),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'Pro_id ' + profile.projectid.toString(),
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () async {
                            var result = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return FormAddScreen(profile: profile);
                            }));
                            if (result != null) {
                              setState(() {});
                            }
                          },
                          child: Text(
                            "Edit",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Color(0XFFEFF3F6),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  title: Text("Attention"),
                                  content: Text(
                                      "Is ${profile.content} list completed?"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        "No",
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(
                                          color: Colors.green,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        apiService
                                            .deleteProfile(profile.id)
                                            .then(
                                          (isSuccess) {
                                            if (isSuccess) {
                                              setState(() {});
                                              Scaffold.of(this.context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "Delete data success"),
                                                ),
                                              );
                                            } else {
                                              Scaffold.of(this.context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "Pull down to refresh"),
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            "Done",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: profiles.length,
      ),
    );
  }
}
