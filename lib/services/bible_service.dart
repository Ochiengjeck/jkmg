import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

class BibleService {
  static const String baseUrl = 'https://bible-api.com';

  Future<BibleVerseResponse> getVerse(
    String reference, {
    String? translation,
  }) async {
    try {
      developer.log('🔍 BibleService: Getting verse "$reference" with translation: $translation');
      
      final uri = Uri.parse('$baseUrl/$reference');
      final queryParameters = <String, String>{};

      if (translation != null &&
          translation.isNotEmpty &&
          translation != 'kjv') {
        queryParameters['translation'] = translation;
      }

      final finalUri = queryParameters.isEmpty
          ? uri
          : uri.replace(queryParameters: queryParameters);
      
      developer.log('🌐 BibleService: Making request to: $finalUri');

      final response = await http.get(
        finalUri,
        headers: {'Content-Type': 'application/json'},
      );

      developer.log('📡 BibleService: Response status: ${response.statusCode}');
      developer.log('📄 BibleService: Response body (first 200 chars): ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final result = BibleVerseResponse.fromJson(data);
        developer.log('✅ BibleService: Successfully parsed verse response for: ${result.reference}');
        return result;
      } else {
        developer.log('❌ BibleService: API error ${response.statusCode}: ${response.body}');
        throw Exception(
          'API returned ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      developer.log('💥 BibleService: Exception in getVerse: $e');
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
      developer.log('🎲 BibleService: Getting random verse with bookIds: "$bookIds", translation: "$translation"');
      
      // Build endpoint using the correct format: /data/[translation]/random[/BOOK_IDS]
      String endpoint = '$baseUrl/data/$translation/random';
      
      if (bookIds != null && bookIds.isNotEmpty) {
        endpoint += '/$bookIds';
        developer.log('📚 BibleService: Using specific books: $bookIds');
      } else {
        developer.log('🌍 BibleService: Getting random verse from entire Bible');
      }

      developer.log('🌐 BibleService: Random verse endpoint: $endpoint');

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
      );

      developer.log('📡 BibleService: Random verse response status: ${response.statusCode}');
      developer.log('📄 BibleService: Random verse response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          developer.log('✅ BibleService: Successfully decoded JSON response');
          developer.log('🔍 BibleService: JSON keys: ${data.keys.toList()}');
          
          // Handle the new random verse API format
          BibleVerseResponse result;
          if (data.containsKey('random_verse')) {
            // New random verse API format
            developer.log('🎲 BibleService: Using random_verse API format');
            result = BibleVerseResponse.fromRandomVerseJson(data);
          } else {
            // Standard verse API format
            developer.log('📖 BibleService: Using standard verse API format');
            result = BibleVerseResponse.fromJson(data);
          }
          
          developer.log('🎉 BibleService: Successfully created BibleVerseResponse: ${result.reference}');
          developer.log('📖 BibleService: Verse text preview: ${result.text.substring(0, result.text.length > 100 ? 100 : result.text.length)}...');
          return result;
        } catch (parseError) {
          developer.log('💥 BibleService: JSON parsing error: $parseError');
          throw Exception('Failed to parse random verse response: $parseError');
        }
      } else {
        developer.log('❌ BibleService: Random verse API error ${response.statusCode}');
        developer.log('💬 BibleService: Error response body: ${response.body}');
        throw Exception(
          'Random verse API returned ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      developer.log('💥 BibleService: Exception in getRandomVerse: $e');
      developer.log('🔄 BibleService: Attempting fallback to John 3:16...');
      
      // Fallback to a known verse if random fails
      try {
        final fallbackResult = await getVerse('John 3:16', translation: translation);
        developer.log('✅ BibleService: Fallback successful');
        return fallbackResult;
      } catch (fallbackError) {
        developer.log('💥 BibleService: Fallback also failed: $fallbackError');
        throw Exception('Failed to load random verse: $e. Fallback also failed: $fallbackError');
      }
    }
  }

  /// Get a random verse from the Old Testament
  Future<BibleVerseResponse> getRandomOldTestamentVerse({
    String translation = 'web',
  }) async {
    developer.log('📜 BibleService: Getting random Old Testament verse');
    return getRandomVerse(bookIds: 'OT', translation: translation);
  }

  /// Get a random verse from the New Testament
  Future<BibleVerseResponse> getRandomNewTestamentVerse({
    String translation = 'web',
  }) async {
    developer.log('✝️ BibleService: Getting random New Testament verse');
    return getRandomVerse(bookIds: 'NT', translation: translation);
  }

  /// Get a random verse from specific books
  /// bookIds should be comma-separated list like "GEN,EXO,LEV" or single book like "JHN"
  Future<BibleVerseResponse> getRandomVerseFromBooks(
    List<String> bookIds, {
    String translation = 'web',
  }) async {
    developer.log('📚 BibleService: Getting random verse from books: ${bookIds.join(', ')}');
    final booksString = bookIds.join(',');
    return getRandomVerse(bookIds: booksString, translation: translation);
  }

  /// Get a random verse from the four Gospels
  Future<BibleVerseResponse> getRandomGospelVerse({
    String translation = 'web',
  }) async {
    developer.log('🕊️ BibleService: Getting random Gospel verse (Matthew, Mark, Luke, John)');
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
    developer.log('🔧 BibleVerseResponse: Parsing standard JSON response');
    developer.log('📝 BibleVerseResponse: JSON keys: ${json.keys.toList()}');
    developer.log('📖 BibleVerseResponse: Reference: ${json['reference']}');
    developer.log('📄 BibleVerseResponse: Text length: ${(json['text'] ?? '').toString().length}');
    developer.log('🔢 BibleVerseResponse: Verses count: ${(json['verses'] as List?)?.length ?? 0}');
    
    final response = BibleVerseResponse(
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
    
    developer.log('✅ BibleVerseResponse: Successfully created response object');
    return response;
  }

  factory BibleVerseResponse.fromRandomVerseJson(Map<String, dynamic> json) {
    developer.log('🎲 BibleVerseResponse: Parsing random verse JSON response');
    developer.log('📝 BibleVerseResponse: JSON keys: ${json.keys.toList()}');
    
    final randomVerse = json['random_verse'] as Map<String, dynamic>;
    final translation = json['translation'] as Map<String, dynamic>? ?? {};
    
    developer.log('📖 BibleVerseResponse: Random verse keys: ${randomVerse.keys.toList()}');
    
    // Create a reference string from the random verse data
    final bookName = randomVerse['book'] ?? 'Unknown';
    final chapter = randomVerse['chapter'] ?? 0;
    final verse = randomVerse['verse'] ?? 0;
    final reference = '$bookName $chapter:$verse';
    
    final verseText = randomVerse['text'] ?? '';
    
    developer.log('📖 BibleVerseResponse: Constructed reference: $reference');
    developer.log('📄 BibleVerseResponse: Text length: ${verseText.length}');
    
    // Create a BibleVerse object from the random verse data
    final bibleVerse = BibleVerse(
      bookId: randomVerse['book_id'] ?? '',
      bookName: bookName,
      chapter: chapter is int ? chapter : int.tryParse(chapter.toString()) ?? 0,
      verse: verse is int ? verse : int.tryParse(verse.toString()) ?? 0,
      text: verseText,
    );
    
    final response = BibleVerseResponse(
      reference: reference,
      verses: [bibleVerse],
      text: verseText,
      translationId: translation['identifier'] ?? '',
      translationName: translation['name'] ?? '',
      translationNote: translation['language'] ?? '',
    );
    
    developer.log('✅ BibleVerseResponse: Successfully created random verse response object');
    return response;
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
    developer.log('📜 BibleVerse: Parsing verse JSON');
    developer.log('📚 BibleVerse: Book - ${json['book_name'] ?? json['book'] ?? 'Unknown'} (${json['book_id'] ?? 'No ID'})');
    developer.log('📖 BibleVerse: Chapter ${json['chapter']}, Verse ${json['verse']}');
    
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
