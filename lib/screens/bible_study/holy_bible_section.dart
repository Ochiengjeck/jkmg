import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class HolyBibleSection extends StatefulWidget {
  const HolyBibleSection({super.key});

  @override
  State<HolyBibleSection> createState() => _HolyBibleSectionState();
}

class _HolyBibleSectionState extends State<HolyBibleSection> {
  String _selectedLanguage = 'English';
  String _selectedVersion = 'KJV';
  
  final List<Map<String, dynamic>> _languages = [
    {'name': 'English', 'versions': ['KJV', 'NIV', 'ESV', 'NASB']},
    {'name': 'Swahili', 'versions': ['Biblia Takatifu']},
    {'name': 'French', 'versions': ['Louis Segond']},
    {'name': 'Spanish', 'versions': ['Reina Valera']},
  ];

  final List<Map<String, dynamic>> _bibleBooks = [
    {'category': 'Old Testament', 'books': [
      'Genesis', 'Exodus', 'Leviticus', 'Numbers', 'Deuteronomy',
      'Joshua', 'Judges', 'Ruth', '1 Samuel', '2 Samuel',
      '1 Kings', '2 Kings', '1 Chronicles', '2 Chronicles',
      'Ezra', 'Nehemiah', 'Esther', 'Job', 'Psalms', 'Proverbs',
      'Ecclesiastes', 'Song of Solomon', 'Isaiah', 'Jeremiah',
      'Lamentations', 'Ezekiel', 'Daniel', 'Hosea', 'Joel',
      'Amos', 'Obadiah', 'Jonah', 'Micah', 'Nahum', 'Habakkuk',
      'Zephaniah', 'Haggai', 'Zechariah', 'Malachi'
    ]},
    {'category': 'New Testament', 'books': [
      'Matthew', 'Mark', 'Luke', 'John', 'Acts', 'Romans',
      '1 Corinthians', '2 Corinthians', 'Galatians', 'Ephesians',
      'Philippians', 'Colossians', '1 Thessalonians', '2 Thessalonians',
      '1 Timothy', '2 Timothy', 'Titus', 'Philemon', 'Hebrews',
      'James', '1 Peter', '2 Peter', '1 John', '2 John', '3 John',
      'Jude', 'Revelation'
    ]},
  ];

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildLanguageSelector(),
          const SizedBox(height: 16),
          _buildQuickAccess(),
          const SizedBox(height: 16),
          _buildBibleBooks(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryGold.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.book,
            color: AppTheme.primaryGold,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Holy Bible Access',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.deepGold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.accentGold.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Language & Version',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.deepGold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedLanguage,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: AppTheme.primaryGold.withOpacity(0.3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: AppTheme.primaryGold.withOpacity(0.3)),
                    ),
                  ),
                  items: _languages.map((language) {
                    return DropdownMenuItem<String>(
                      value: language['name'],
                      child: Text(
                        language['name'],
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value!;
                      _selectedVersion = _languages
                          .firstWhere((lang) => lang['name'] == value)['versions'][0];
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedVersion,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: AppTheme.primaryGold.withOpacity(0.3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: AppTheme.primaryGold.withOpacity(0.3)),
                    ),
                  ),
                  items: _languages
                      .firstWhere((lang) => lang['name'] == _selectedLanguage)['versions']
                      .map<DropdownMenuItem<String>>((version) {
                    return DropdownMenuItem<String>(
                      value: version,
                      child: Text(
                        version,
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedVersion = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccess() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Access',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppTheme.deepGold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildQuickAccessChip('Psalms'),
            _buildQuickAccessChip('Proverbs'),
            _buildQuickAccessChip('Matthew'),
            _buildQuickAccessChip('John'),
            _buildQuickAccessChip('Romans'),
            _buildQuickAccessChip('1 Corinthians'),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAccessChip(String book) {
    return InkWell(
      onTap: () => _openBook(book),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.primaryGold.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.primaryGold.withOpacity(0.3)),
        ),
        child: Text(
          book,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.deepGold,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBibleBooks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Browse Books',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppTheme.deepGold,
          ),
        ),
        const SizedBox(height: 8),
        ..._bibleBooks.map((category) => _buildBookCategory(category)),
      ],
    );
  }

  Widget _buildBookCategory(Map<String, dynamic> category) {
    return ExpansionTile(
      title: Text(
        category['category'],
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppTheme.deepGold,
        ),
      ),
      iconColor: AppTheme.primaryGold,
      collapsedIconColor: AppTheme.primaryGold,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: category['books'].map<Widget>((book) {
              return InkWell(
                onTap: () => _openBook(book),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGold.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.primaryGold.withOpacity(0.2)),
                  ),
                  child: Text(
                    book,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _openBook(String bookName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '$bookName ($_selectedVersion)',
          style: const TextStyle(
            color: AppTheme.deepGold,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.construction,
              size: 48,
              color: AppTheme.primaryGold,
            ),
            const SizedBox(height: 16),
            Text(
              'Bible reading feature is under development.\n\nThis will allow you to access the complete Bible text in multiple languages and versions.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: AppTheme.primaryGold),
            ),
          ),
        ],
      ),
    );
  }
}