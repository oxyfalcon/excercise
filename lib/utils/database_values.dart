enum TableColumn{
  fiscalYear("fiscal_year"),
  artistDisplay("artist_display"),
  title("title"),
  pageNumber("page_number");
  const TableColumn(this.name);
  final String name;
}

const String tableName = "UserTable";