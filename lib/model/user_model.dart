class UserModel {
  final String artistDisplay;
  final String title;
  final int fiscalYear;
  final int pageNumber;

  UserModel(
      {required this.artistDisplay,
      required this.title,
      required this.fiscalYear,
      required this.pageNumber});

  factory UserModel.fromJson(Map<String, dynamic> json, int pageNumber) =>
      UserModel(
          artistDisplay: json['artist_display'] ?? 'null',
          title: json['title'] ?? 'null',
          fiscalYear: json['fiscal_year'] ?? -1,
          pageNumber: pageNumber);
}
