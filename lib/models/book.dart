class Book {
  final int bookId;
  final String title;
  final String isbn;
  final int pageCount;
  final String publishedDate;
  final String thumbnailUrl;
  final String shortDescription;
  final String author;
  final String category;
  final int price;

  //Book Constructor
  Book(
      {required this.bookId,
      required this.title,
      required this.isbn,
      required this.pageCount,
      required this.publishedDate,
      required this.thumbnailUrl,
      required this.shortDescription,
      required this.author,
      required this.category,
      required this.price});

  //using factory for book constructor
  factory Book.fromJson(dynamic json) {
    return Book(
        bookId: json['bookid'] as int,
        title: json['title'] as String,
        isbn: json['isbn'] as String,
        pageCount: json['pageCount'] as int,
        publishedDate: json['publishedDate'] as String,
        thumbnailUrl: json['thumbnailUrl'] as String,
        shortDescription: json['shortDescription'] as String,
        author: json['author'] as String,
        category: json['category'] as String,
        price: json['price'] as int);
  }

  @override
  String toString() {
    return '{ $bookId, $title,$isbn,$pageCount,$publishedDate $thumbnailUrl,$shortDescription,$author ,$category, $price }';
  }
}
