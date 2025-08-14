import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../provider/providers.dart';
import '../../services/bible_service.dart';
import 'bible_reader_screen.dart';

class HolyBibleSection extends ConsumerStatefulWidget {
  const HolyBibleSection({super.key});

  @override
  ConsumerState<HolyBibleSection> createState() => _HolyBibleSectionState();
}

class _HolyBibleSectionState extends ConsumerState<HolyBibleSection> {
  String selectedTranslation = 'kjv';
  final TextEditingController _verseSearchController = TextEditingController();
  BibleService? _bibleService;
  BibleVerseResponse? _currentVerse;
  bool _isLoadingVerse = false;
  String? _verseError;

  @override
  void initState() {
    super.initState();
    _bibleService = BibleService();
    _loadRandomVerse();
  }

  @override
  void dispose() {
    _verseSearchController.dispose();
    super.dispose();
  }

  Future<void> _loadRandomVerse() async {
    setState(() {
      _isLoadingVerse = true;
      _verseError = null;
    });

    try {
      final verse = await _bibleService!.getRandomVerse(
        translation: selectedTranslation,
      );

      if (mounted) {
        setState(() {
          _currentVerse = verse;
          _isLoadingVerse = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _verseError = e.toString();
          _isLoadingVerse = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final translationsAsync = ref.watch(bibleTranslationsProvider);

    return CustomCard(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeHeader(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildTranslationSelector(translationsAsync),
                const SizedBox(height: 16),
                _buildVerseOfTheDay(),
                const SizedBox(height: 16),
                _buildVerseSearch(),
                const SizedBox(height: 16),
                _buildQuickAccess(),
                const SizedBox(height: 16),
                _buildFullBibleAccess(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: AppTheme.charcoalBlack,
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                color: AppTheme.primaryGold,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Holy Bible',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Study Scripture with multiple translations',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(AsyncValue<List<BibleTranslation>> translationsAsync) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildTranslationSelector(translationsAsync),
          const SizedBox(height: 20),
          _buildVerseOfTheDay(),
          const SizedBox(height: 20),
          _buildVerseSearch(),
          const SizedBox(height: 20),
          _buildQuickAccess(),
          const SizedBox(height: 20),
          _buildFullBibleAccess(),
        ],
      ),
    );
  }

  Widget _buildTranslationSelector(
    AsyncValue<List<BibleTranslation>> translationsAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bible Translation',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.deepGold,
          ),
        ),
        const SizedBox(height: 8),
        translationsAsync.when(
          data: (translations) => DropdownButtonFormField<String>(
            value: selectedTranslation,
            isExpanded: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.translate, color: AppTheme.darkGold),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: AppTheme.accentGold.withOpacity(0.5),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: AppTheme.accentGold.withOpacity(0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: AppTheme.primaryGold,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: AppTheme.accentGold.withOpacity(0.1),
            ),
            dropdownColor: Colors.white,
            items: translations.map((translation) {
              return DropdownMenuItem<String>(
                value: translation.identifier,
                child: Text(
                  '${translation.name} (${translation.identifier.toUpperCase()})',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedTranslation = value;
                });
                _loadRandomVerse();
              }
            },
          ),
          loading: () =>
              const LoadingWidget(message: 'Loading translations...'),
          error: (error, _) => const ErrorStateWidget(
            title: 'Failed to load translations',
            subtitle: 'Please check your internet connection and try again.',
          ),
        ),
      ],
    );
  }

  Widget _buildVerseOfTheDay() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Verse of Inspiration',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.deepGold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: _loadRandomVerse,
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: AppTheme.darkGold,
                ),
                tooltip: 'Get new verse',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            constraints: const BoxConstraints(minHeight: 80),
            child: _isLoadingVerse
                ? const LoadingWidget(message: 'Loading inspiration...')
                : _verseError != null
                ? const ErrorStateWidget(
                    title: 'Failed to load verse',
                    subtitle: 'Tap refresh to try again.',
                  )
                : _currentVerse != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StatusChip(
                        label: _currentVerse!.reference,
                        color: AppTheme.primaryGold,
                        icon: Icons.book_rounded,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _currentVerse!.text.trim(),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  )
                : EmptyStateWidget(
                    icon: Icons.auto_awesome_rounded,
                    title: 'Verse of Inspiration',
                    subtitle: 'Tap refresh to load a verse of inspiration',
                    action: GradientButton(
                      text: 'Load Verse',
                      onPressed: _loadRandomVerse,
                      icon: Icons.refresh_rounded,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerseSearch() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Search Verse',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.deepGold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _verseSearchController,
                  decoration: InputDecoration(
                    hintText: 'e.g., John 3:16 or Romans 8:28',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppTheme.darkGold,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: AppTheme.accentGold.withOpacity(0.5),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: AppTheme.accentGold.withOpacity(0.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: AppTheme.primaryGold,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: AppTheme.accentGold.withOpacity(0.1),
                  ),
                  onSubmitted: (value) => _searchVerse(),
                ),
              ),
              const SizedBox(width: 12),
              GradientButton(
                text: 'Search',
                onPressed: _searchVerse,
                icon: Icons.search_rounded,
                width: 100,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccess() {
    final popularBooks = [
      {'name': 'Psalms', 'id': 'PSA'},
      {'name': 'Proverbs', 'id': 'PRO'},
      {'name': 'Matthew', 'id': 'MAT'},
      {'name': 'John', 'id': 'JHN'},
      {'name': 'Romans', 'id': 'ROM'},
      {'name': '1 Corinthians', 'id': '1CO'},
    ];

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Popular Books',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.deepGold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: popularBooks
                .map(
                  (book) => _buildQuickAccessChip(book['name']!, book['id']!),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessChip(String bookName, String bookId) {
    return GestureDetector(
      onTap: () => _openBibleReader(bookId: bookId),
      child: StatusChip(
        label: bookName,
        color: AppTheme.darkGold,
        icon: Icons.book_rounded,
      ),
    );
  }

  Widget _buildFullBibleAccess() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.charcoalBlack,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_stories,
                  color: AppTheme.primaryGold,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Complete Bible Access',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.deepGold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Access the complete Bible with advanced reading features, chapter navigation, verse search, and multiple translations.',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.deepGold,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          GradientButton(
            text: 'Open Bible Reader',
            onPressed: () => _openBibleReader(),
            icon: Icons.menu_book_rounded,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Future<void> _searchVerse() async {
    final reference = _verseSearchController.text.trim();
    if (reference.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: AppTheme.primaryGold,
                child: const Text(
                  'Verse Search Results',
                  style: TextStyle(
                    color: AppTheme.richBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<BibleVerseResponse>(
                  future: _bibleService!.getVerse(
                    reference,
                    translation: selectedTranslation,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryGold,
                          ),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Verse not found',
                              style: TextStyle(
                                color: Colors.red.shade600,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Please check your reference format (e.g., John 3:16)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Error: ${snapshot.error}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    if (snapshot.hasData) {
                      final verseResponse = snapshot.data!;
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              verseResponse.reference,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryGold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              verseResponse.text,
                              style: const TextStyle(fontSize: 12, height: 1.4),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              verseResponse.translationName.isNotEmpty
                                  ? verseResponse.translationName
                                  : selectedTranslation.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return const Center(child: Text('No data available'));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _openBibleReader();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGold,
                          foregroundColor: AppTheme.richBlack,
                        ),
                        child: const Text('Open Bible'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openBibleReader({String? bookId}) {
    // Create a mapping for book name to ID for popular books
    final Map<String, BibleBook> bookMap = {
      'PSA': BibleBook(id: 'PSA', name: 'Psalms', url: ''),
      'PRO': BibleBook(id: 'PRO', name: 'Proverbs', url: ''),
      'MAT': BibleBook(id: 'MAT', name: 'Matthew', url: ''),
      'JHN': BibleBook(id: 'JHN', name: 'John', url: ''),
      'ROM': BibleBook(id: 'ROM', name: 'Romans', url: ''),
      '1CO': BibleBook(id: '1CO', name: '1 Corinthians', url: ''),
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BibleReaderScreen(
          initialBook: bookId,
          initialChapter: 1,
          initialTranslation: selectedTranslation,
        ),
      ),
    );
  }
}
