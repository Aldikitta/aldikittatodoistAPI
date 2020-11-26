import 'dart:convert';

class Profile {
  String content;
  int id;
  int projectid;
  Profile({this.content, this.id, this.projectid});

  factory Profile.fromJson(Map<String, dynamic> map) {
    return Profile(
        content: map["content"], id: map["id"], projectid: map["project_id"]);
  }

  Map<String, dynamic> toJson() {
    // return {"content": content};
    return {"content": content, "id": id, "project_id": projectid};
  }

  @override
  String toString() {
    return 'Profile{content: $content, id: $id, project_id: $projectid}';
  }
}

List<Profile> profileFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Profile>.from(data.map((item) => Profile.fromJson(item)));
}

String profileToJson(Profile data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
