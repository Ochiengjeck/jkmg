import 'package:http/http.dart' as http;
import 'dart:convert';

class BibleService {
  static const String baseUrl = 'https://bible-api.com';

  Future<BibleVerseResponse> getVerse(
    String reference, {
    String? translation,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/$reference');
      final queryParameters = <String, String>{};

      if (translation != null &&
          translation.isNotEmpty &&
          translation != 'kjv') {
        queryParameters['translation'] = translation;
      }

      final response = await http.get(
        queryParameters.isEmpty
            ? uri
            : uri.replace(queryParameters: queryParameters),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return BibleVerseResponse.fromJson(data);
      } else {
        throw Exception(
          'API returned ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load verse "$reference": $e');
    }
  }

  Future<List<BibleTranslation>> getTranslations() async {
    final response = await http.get(
      Uri.parse('$baseUrl/data'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final translations = data['translations'] as List;
      return translations.map((t) => BibleTranslation.fromJson(t)).toList();
    } else {
      throw Exception('Failed to load translations: ${response.statusCode}');
    }
  }

  Future<List<BibleBook>> getBooks({String translation = 'kjv'}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/data/$translation'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final books = data['books'] as List;
      return books.map((b) => BibleBook.fromJson(b)).toList();
    } else {
      throw Exception('Failed to load books: ${response.statusCode}');
    }
  }

  Future<BibleChapterResponse> getChapter(
    String translation,
    String bookId,
    int chapter,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/data/$translation/$bookId/$chapter'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return BibleChapterResponse.fromJson(data);
    } else {
      throw Exception('Failed to load chapter: ${response.statusCode}');
    }
  }

  Future<BibleVerseResponse> getRandomVerse({
    String? bookIds,
    String translation = 'web', // Default to 'web' as it's more commonly available
  }) async {
    try {
      // Build endpoint using the correct format: /data/[translation]/random[/BOOK_IDS]
      String endpoint = '$baseUrl/data/$translation/random';
      
      if (bookIds != null && bookIds.isNotEmpty) {
        endpoint += '/$bookIds';
      }

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return BibleVerseResponse.fromJson(data);
      } else {
        throw Exception(
          'Random verse API returned ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      // Fallback to a known verse if random fails
      try {
        return await getVerse('John 3:16', translation: translation);
      } catch (fallbackError) {
        throw Exception('Failed to load random verse: $e. Fallback also failed: $fallbackError');
      }
    }
  }

  /// Get a random verse from the Old Testament
  Future<BibleVerseResponse> getRandomOldTestamentVerse({
    String translation = 'web',
  }) async {
    return getRandomVerse(bookIds: 'OT', translation: translation);
  }

  /// Get a random verse from the New Testament
  Future<BibleVerseResponse> getRandomNewTestamentVerse({
    String translation = 'web',
  }) async {
    return getRandomVerse(bookIds: 'NT', translation: translation);
  }

  /// Get a random verse from specific books
  /// bookIds should be comma-separated list like "GEN,EXO,LEV" or single book like "JHN"
  Future<BibleVerseResponse> getRandomVerseFromBooks(
    List<String> bookIds, {
    String translation = 'web',
  }) async {
    final booksString = bookIds.join(',');
    return getRandomVerse(bookIds: booksString, translation: translation);
  }

  /// Get a random verse from the four Gospels
  Future<BibleVerseResponse> getRandomGospelVerse({
    String translation = 'web',
  }) async {
    return getRandomVerseFromBooks(['MAT', 'MRK', 'LUK', 'JHN'], translation: translation);
  }
}

class BibleVerseResponse {
  final String reference;
  final List<BibleVerse> verses;
  final String text;
  final String translationId;
  final String translationName;
  final String translationNote;

  BibleVerseResponse({
    required this.reference,
    required this.verses,
    required this.text,
    required this.translationId,
    required this.translationName,
    required this.translationNote,
  });

  factory BibleVerseResponse.fromJson(Map<String, dynamic> json) {
    return BibleVerseResponse(
      reference: json['reference'] ?? '',
      verses:
          (json['verses'] as List?)
              ?.map((v) => BibleVerse.fromJson(v))
              .toList() ??
          [],
      text: json['text'] ?? '',
      translationId: json['translation_id'] ?? '',
      translationName: json['translation_name'] ?? '',
      translationNote: json['translation_note'] ?? '',
    );
  }
}

class BibleVerse {
  final String bookId;
  final String bookName;
  final int chapter;
  final int verse;
  final String text;

  BibleVerse({
    required this.bookId,
    required this.bookName,
    required this.chapter,
    required this.verse,
    required this.text,
  });

  factory BibleVerse.fromJson(Map<String, dynamic> json) {
    return BibleVerse(
      bookId: json['book_id'] ?? '',
      bookName: json['book_name'] ?? json['book'] ?? '',
      chapter: json['chapter'] ?? 0,
      verse: json['verse'] ?? 0,
      text: json['text'] ?? '',
    );
  }
}

class BibleTranslation {
  final String identifier;
  final String name;
  final String language;
  final String languageCode;
  final String license;
  final String url;

  BibleTranslation({
    required this.identifier,
    required this.name,
    required this.language,
    required this.languageCode,
    required this.license,
    required this.url,
  });

  factory BibleTranslation.fromJson(Map<String, dynamic> json) {
    return BibleTranslation(
      identifier: json['identifier'] ?? '',
      name: json['name'] ?? '',
      language: json['language'] ?? '',
      languageCode: json['language_code'] ?? '',
      license: json['license'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class BibleBook {
  final String id;
  final String name;
  final String url;

  BibleBook({required this.id, required this.name, required this.url});

  factory BibleBook.fromJson(Map<String, dynamic> json) {
    return BibleBook(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class BibleChapterResponse {
  final BibleTranslation translation;
  final List<BibleVerse> verses;

  BibleChapterResponse({required this.translation, required this.verses});

  factory BibleChapterResponse.fromJson(Map<String, dynamic> json) {
    return BibleChapterResponse(
      translation: BibleTranslation.fromJson(json['translation'] ?? {}),
      verses:
          (json['verses'] as List?)
              ?.map((v) => BibleVerse.fromJson(v))
              .toList() ??
          [],
    );
  }
}
