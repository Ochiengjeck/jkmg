import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/bible_service.dart';
import '../../utils/app_theme.dart';

class BibleReaderScreen extends StatefulWidget {
  final String? initialBook;
  final int? initialChapter;
  final String? initialTranslation;

  const BibleReaderScreen({
    super.key,
    this.initialBook,
    this.initialChapter,
    this.initialTranslation,
  });

  @override
  State<BibleReaderScreen> createState() => _BibleReaderScreenState();
}

class _BibleReaderScreenState extends State<BibleReaderScreen>
    with TickerProviderStateMixin {
  final BibleService _bibleService = BibleService();
  String selectedTranslation = 'kjv';
  List<BibleTranslation> translations = [];
  List<BibleBook> books = [];
  BibleBook? selectedBook;
  int selectedChapter = 1;
  BibleChapterResponse? currentChapter;
  bool showVerseNumbers = true;
  double fontSize = 18.0;
  bool isNightReading = false;

  bool _isLoadingTranslations = false;
  bool _isLoadingBooks = false;
  bool _isLoadingChapter = false;
  String? _error;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    selectedTranslation = widget.initialTranslation ?? 'kjv';
    selectedChapter = widget.initialChapter ?? 1;

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _loadTranslations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _loadTranslations() async {
    setState(() {
      _isLoadingTranslations = true;
      _error = null;
    });

    try {
      final result = await _bibleService.getTranslations();

      if (mounted) {
        setState(() {
          translations = result;
          _isLoadingTranslations = false;
        });
        _loadBooks();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load translations: $e';
          _isLoadingTranslations = false;
        });
      }
    }
  }

  Future<void> _loadBooks() async {
    setState(() {
      _isLoadingBooks = true;
      _error = null;
    });

    try {
      final result = await _bibleService.getBooks(
        translation: selectedTranslation,
      );

      if (mounted) {
        setState(() {
          books = result;
          if (widget.initialBook != null) {
            selectedBook = result.firstWhere(
              (book) =>
                  book.id.toLowerCase() == widget.initialBook!.toLowerCase(),
              orElse: () => result.isNotEmpty
                  ? result.first
                  : BibleBook(id: '', name: '', url: ''),
            );
          } else {
            selectedBook = result.isNotEmpty ? result.first : null;
          }
          _isLoadingBooks = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load books: $e';
          _isLoadingBooks = false;
        });
      }
    }
  }

  Future<void> _loadChapter() async {
    if (selectedBook == null) return;

    setState(() {
      _isLoadingChapter = true;
      _error = null;
    });

    try {
      final result = await _bibleService.getChapter(
        selectedTranslation,
        selectedBook!.id,
        selectedChapter,
      );

      if (mounted) {
        setState(() {
          currentChapter = result;
          _isLoadingChapter = false;
        });
        _fadeController.reset();
        _slideController.reset();
        _fadeController.forward();
        _slideController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load chapter: $e';
          _isLoadingChapter = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildModernAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    AppTheme.richBlack,
                    AppTheme.charcoalBlack,
                    AppTheme.richBlack,
                  ]
                : [Colors.grey.shade50, Colors.white, Colors.grey.shade100],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildModernControlPanel(),
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildModernFloatingActions(),
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.dark
            : Brightness.light,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
      title: ShaderMask(
        shaderCallback: (bounds) => AppTheme.primaryGoldGradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        child: const Text(
          'Holy Bible',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: AppTheme.primaryGold.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primaryGold.withOpacity(0.2)),
          ),
          child: IconButton(
            icon: Icon(
              isNightReading ? Icons.brightness_7 : Icons.brightness_4,
              color: AppTheme.primaryGold,
            ),
            onPressed: () {
              setState(() {
                isNightReading = !isNightReading;
              });
            },
            tooltip: isNightReading ? 'Day Reading' : 'Night Reading',
          ),
        ),
      ],
    );
  }

  Widget _buildModernControlPanel() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: Theme.of(context).brightness == Brightness.dark
              ? [
                  AppTheme.charcoalBlack.withOpacity(0.8),
                  AppTheme.softBlack.withOpacity(0.8),
                ]
              : [
                  Colors.white.withOpacity(0.9),
                  Colors.grey.shade50.withOpacity(0.9),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryGold.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGold.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          if (_error != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppTheme.errorRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.errorRed.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: AppTheme.errorRed, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _error!,
                      style: TextStyle(
                        color: AppTheme.errorRed,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          Row(
            children: [
              Expanded(
                child: _buildModernDropdown(
                  'Translation',
                  selectedTranslation,
                  _isLoadingTranslations,
                  translations
                      .map(
                        (t) => DropdownMenuItem(
                          value: t.identifier,
                          child: Text(
                            '${t.name} (${t.identifier.toUpperCase()})',
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  (value) {
                    if (value != null) {
                      setState(() {
                        selectedTranslation = value;
                        selectedBook = null;
                        currentChapter = null;
                      });
                      _loadBooks();
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildModernDropdown(
                  'Book',
                  selectedBook,
                  _isLoadingBooks,
                  books
                      .map(
                        (book) => DropdownMenuItem(
                          value: book,
                          child: Text(
                            book.name,
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  (value) {
                    setState(() {
                      selectedBook = value;
                      selectedChapter = 1;
                      currentChapter = null;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryGold.withOpacity(0.3),
                    ),
                  ),
                  child: TextFormField(
                    initialValue: selectedChapter.toString(),
                    decoration: InputDecoration(
                      labelText: 'Chapter',
                      labelStyle: TextStyle(
                        color: AppTheme.primaryGold,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    onChanged: (value) {
                      final chapter = int.tryParse(value);
                      if (chapter != null && chapter > 0) {
                        setState(() {
                          selectedChapter = chapter;
                          currentChapter = null;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGoldGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryGold.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: selectedBook != null ? _loadChapter : null,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.menu_book_rounded,
                            color: AppTheme.richBlack,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Read Chapter',
                            style: TextStyle(
                              color: AppTheme.richBlack,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernDropdown<T>(
    String label,
    T? value,
    bool isLoading,
    List<DropdownMenuItem<T>> items,
    void Function(T?)? onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryGold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primaryGold.withOpacity(0.3)),
          ),
          child: isLoading
              ? Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryGold,
                        ),
                      ),
                    ),
                  ),
                )
              : DropdownButtonFormField<T>(
                  value: value,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: InputBorder.none,
                  ),
                  items: items,
                  onChanged: onChanged,
                ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoadingChapter) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryGold.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primaryGold.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGold),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Loading sacred text...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryGold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );
    }

    if (currentChapter == null) {
      return _buildModernBookSelector();
    }

    return _buildModernBookInterface();
  }

  Widget _buildModernBookSelector() {
    if (books.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGold),
        ),
      );
    }

    final oldTestament = books.take(39).toList();
    final newTestament = books.skip(39).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildModernBookSection('Old Testament', oldTestament),
          const SizedBox(height: 32),
          _buildModernBookSection('New Testament', newTestament),
        ],
      ),
    );
  }

  Widget _buildModernBookSection(String title, List<BibleBook> books) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGoldGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppTheme.richBlack,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3.0,
          ),
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: Theme.of(context).brightness == Brightness.dark
                      ? [AppTheme.charcoalBlack, AppTheme.softBlack]
                      : [Colors.white, Colors.grey.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primaryGold.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryGold.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      selectedBook = book;
                      selectedChapter = 1;
                      currentChapter = null;
                    });
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        book.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryGold,
                          letterSpacing: 0.3,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildModernBookInterface() {
    final backgroundColor = isNightReading
        ? AppTheme.richBlack
        : Theme.of(context).brightness == Brightness.dark
        ? AppTheme.charcoalBlack
        : const Color(0xFFFFF8E1); // Warm paper color

    final textColor = isNightReading
        ? Colors.amber.shade100
        : Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF3E2723); // Dark brown

    return Column(
      children: [
        // Chapter Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGoldGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryGold.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.auto_stories_rounded,
                color: AppTheme.richBlack,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${selectedBook!.name} Chapter $selectedChapter',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.richBlack,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              _buildReadingControls(),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Scripture Content
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: isNightReading
                  ? Border.all(color: Colors.amber.withOpacity(0.3))
                  : Border.all(color: AppTheme.primaryGold.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Decorative elements
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGoldGradient,
                      ),
                    ),
                  ),

                  // Main content
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...currentChapter!.verses.map(
                                (verse) =>
                                    _buildModernVerseWidget(verse, textColor),
                              ),
                              const SizedBox(height: 40),
                              _buildModernChapterNavigation(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildReadingControls() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.richBlack.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(
              Icons.search_rounded,
              color: AppTheme.richBlack,
              size: 20,
            ),
            onPressed: _showModernSearchDialog,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
            tooltip: 'Search',
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.richBlack.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(Icons.tune_rounded, color: AppTheme.richBlack, size: 20),
            onPressed: _showModernSettingsDialog,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
            tooltip: 'Settings',
          ),
        ),
      ],
    );
  }

  Widget _buildModernVerseWidget(BibleVerse verse, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: RichText(
        text: TextSpan(
          children: [
            if (showVerseNumbers)
              WidgetSpan(
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGold.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${verse.verse}',
                    style: TextStyle(
                      fontSize: fontSize - 4,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryGold,
                    ),
                  ),
                ),
              ),
            TextSpan(
              text: verse.text.trim(),
              style: TextStyle(
                fontSize: fontSize,
                color: textColor,
                height: 1.8,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernChapterNavigation() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryGold.withOpacity(0.1),
            AppTheme.primaryGold.withOpacity(0.05),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavButton(
            'Previous',
            Icons.arrow_back_rounded,
            selectedChapter > 1 ? _previousChapter : null,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primaryGold.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Chapter $selectedChapter',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryGold,
              ),
            ),
          ),
          _buildNavButton('Next', Icons.arrow_forward_rounded, _nextChapter),
        ],
      ),
    );
  }

  Widget _buildNavButton(String label, IconData icon, VoidCallback? onPressed) {
    return Container(
      decoration: BoxDecoration(
        gradient: onPressed != null ? AppTheme.primaryGoldGradient : null,
        color: onPressed == null ? Colors.grey.shade300 : null,
        borderRadius: BorderRadius.circular(12),
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: AppTheme.primaryGold.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (label == 'Previous') ...[
                  Icon(
                    icon,
                    color: onPressed != null
                        ? AppTheme.richBlack
                        : Colors.grey.shade600,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  label,
                  style: TextStyle(
                    color: onPressed != null
                        ? AppTheme.richBlack
                        : Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (label == 'Next') ...[
                  const SizedBox(width: 4),
                  Icon(
                    icon,
                    color: onPressed != null
                        ? AppTheme.richBlack
                        : Colors.grey.shade600,
                    size: 18,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernFloatingActions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGoldGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryGold.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _scrollToTop,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.keyboard_arrow_up_rounded,
                  color: AppTheme.richBlack,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGoldGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryGold.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _showModernRandomVerse,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: AppTheme.richBlack,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _previousChapter() {
    if (selectedChapter > 1) {
      HapticFeedback.lightImpact();
      setState(() {
        selectedChapter--;
      });
      _loadChapter();
    }
  }

  void _nextChapter() {
    HapticFeedback.lightImpact();
    setState(() {
      selectedChapter++;
    });
    _loadChapter();
  }

  void _scrollToTop() {
    HapticFeedback.lightImpact();
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  void _showModernSearchDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 300),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: Theme.of(context).brightness == Brightness.dark
                  ? [AppTheme.charcoalBlack, AppTheme.softBlack]
                  : [Colors.white, Colors.grey.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.primaryGold.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGoldGradient,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      color: AppTheme.richBlack,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Search Scripture',
                      style: TextStyle(
                        color: AppTheme.richBlack,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.primaryGold.withOpacity(0.3),
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'e.g., John 3:16 or Romans 8:28',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                          prefixIcon: Icon(
                            Icons.menu_book_rounded,
                            color: AppTheme.primaryGold,
                          ),
                        ),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Enter verse reference like "John 3:16" or "Romans 8:28-30"',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => Navigator.pop(context),
                                borderRadius: BorderRadius.circular(12),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Text(
                                    'Cancel',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGoldGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _searchVerse,
                                borderRadius: BorderRadius.circular(12),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Text(
                                    'Search',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppTheme.richBlack,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  void _showModernSettingsDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: Theme.of(context).brightness == Brightness.dark
                    ? [AppTheme.charcoalBlack, AppTheme.softBlack]
                    : [Colors.white, Colors.grey.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.primaryGold.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGoldGradient,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.tune_rounded,
                        color: AppTheme.richBlack,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Reading Settings',
                        style: TextStyle(
                          color: AppTheme.richBlack,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGold.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.primaryGold.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.format_list_numbered_rounded,
                              color: AppTheme.primaryGold,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Show verse numbers',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Switch(
                              value: showVerseNumbers,
                              onChanged: (value) {
                                setState(() {
                                  showVerseNumbers = value;
                                });
                                setDialogState(() {});
                              },
                              activeColor: AppTheme.primaryGold,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGold.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.primaryGold.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.format_size_rounded,
                                  color: AppTheme.primaryGold,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Font Size: ${fontSize.round()}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: AppTheme.primaryGold,
                                inactiveTrackColor: AppTheme.primaryGold
                                    .withOpacity(0.3),
                                thumbColor: AppTheme.primaryGold,
                                overlayColor: AppTheme.primaryGold.withOpacity(
                                  0.2,
                                ),
                              ),
                              child: Slider(
                                value: fontSize,
                                min: 14.0,
                                max: 28.0,
                                divisions: 7,
                                onChanged: (value) {
                                  setState(() {
                                    fontSize = value;
                                  });
                                  setDialogState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGoldGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            borderRadius: BorderRadius.circular(12),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                'Done',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppTheme.richBlack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showModernRandomVerse() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450, maxHeight: 500),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: Theme.of(context).brightness == Brightness.dark
                  ? [AppTheme.charcoalBlack, AppTheme.softBlack]
                  : [Colors.white, Colors.grey.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.primaryGold.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGoldGradient,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      color: AppTheme.richBlack,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Daily Inspiration',
                      style: TextStyle(
                        color: AppTheme.richBlack,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<BibleVerseResponse>(
                  future: _bibleService.getRandomVerse(
                    translation: selectedTranslation,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryGold.withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.primaryGold.withOpacity(0.3),
                                ),
                              ),
                              child: const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryGold,
                                ),
                                strokeWidth: 3,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Finding inspiration...',
                              style: TextStyle(
                                color: AppTheme.primaryGold,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppTheme.errorRed.withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.errorRed.withOpacity(0.3),
                                ),
                              ),
                              child: Icon(
                                Icons.error_outline_rounded,
                                size: 48,
                                color: AppTheme.errorRed,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Unable to load verse',
                              style: TextStyle(
                                color: AppTheme.errorRed,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    if (snapshot.hasData) {
                      final verse = snapshot.data!;
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryGold.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppTheme.primaryGold.withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    verse.reference,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.primaryGold,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    verse.text,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      height: 1.6,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    verse.translationName.isNotEmpty
                                        ? verse.translationName
                                        : selectedTranslation.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return const Center(child: Text('No verse available'));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.primaryGold.withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {});
                              Navigator.pop(context);
                              _showModernRandomVerse();
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.refresh_rounded,
                                    color: AppTheme.primaryGold,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Another',
                                    style: TextStyle(
                                      color: AppTheme.primaryGold,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGoldGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            borderRadius: BorderRadius.circular(12),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                'Close',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppTheme.richBlack,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
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

  Future<void> _searchVerse() async {
    final reference = _searchController.text.trim();
    if (reference.isNotEmpty) {
      Navigator.pop(context);
      _showSearchResults(reference);
    }
  }

  void _showSearchResults(String reference) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450, maxHeight: 500),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: Theme.of(context).brightness == Brightness.dark
                  ? [AppTheme.charcoalBlack, AppTheme.softBlack]
                  : [Colors.white, Colors.grey.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.primaryGold.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGoldGradient,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      color: AppTheme.richBlack,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Search Results',
                      style: TextStyle(
                        color: AppTheme.richBlack,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<BibleVerseResponse>(
                  future: _bibleService.getVerse(
                    reference,
                    translation: selectedTranslation,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryGold.withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.primaryGold.withOpacity(0.3),
                                ),
                              ),
                              child: const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryGold,
                                ),
                                strokeWidth: 3,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Searching...',
                              style: TextStyle(
                                color: AppTheme.primaryGold,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppTheme.errorRed.withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.errorRed.withOpacity(0.3),
                                ),
                              ),
                              child: Icon(
                                Icons.search_off_rounded,
                                size: 48,
                                color: AppTheme.errorRed,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Verse not found',
                              style: TextStyle(
                                color: AppTheme.errorRed,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Please check your reference format\n(e.g., John 3:16)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    if (snapshot.hasData) {
                      final verse = snapshot.data!;
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGold.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.primaryGold.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                verse.reference,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primaryGold,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                verse.text,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.6,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                verse.translationName.isNotEmpty
                                    ? verse.translationName
                                    : selectedTranslation.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return const Center(child: Text('No results found'));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGoldGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Close',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.richBlack,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
