class CountryCode {
  final String name;
  final String code;
  final String flag;
  final String dialCode;

  const CountryCode({
    required this.name,
    required this.code,
    required this.flag,
    required this.dialCode,
  });

  @override
  String toString() => '$flag $dialCode';
}

class CountryCodes {
  static const List<CountryCode> countries = [
    CountryCode(name: 'Kenya', code: 'KE', flag: '🇰🇪', dialCode: '+254'),
    CountryCode(name: 'Uganda', code: 'UG', flag: '🇺🇬', dialCode: '+256'),
    CountryCode(name: 'Tanzania', code: 'TZ', flag: '🇹🇿', dialCode: '+255'),
    CountryCode(name: 'Rwanda', code: 'RW', flag: '🇷🇼', dialCode: '+250'),
    CountryCode(name: 'South Sudan', code: 'SS', flag: '🇸🇸', dialCode: '+211'),
    CountryCode(name: 'Ethiopia', code: 'ET', flag: '🇪🇹', dialCode: '+251'),
    CountryCode(name: 'South Africa', code: 'ZA', flag: '🇿🇦', dialCode: '+27'),
    CountryCode(name: 'Nigeria', code: 'NG', flag: '🇳🇬', dialCode: '+234'),
    CountryCode(name: 'Ghana', code: 'GH', flag: '🇬🇭', dialCode: '+233'),
    CountryCode(name: 'Cameroon', code: 'CM', flag: '🇨🇲', dialCode: '+237'),
    CountryCode(name: 'Democratic Republic of the Congo', code: 'CD', flag: '🇨🇩', dialCode: '+243'),
    CountryCode(name: 'Zambia', code: 'ZM', flag: '🇿🇲', dialCode: '+260'),
    CountryCode(name: 'Zimbabwe', code: 'ZW', flag: '🇿🇼', dialCode: '+263'),
    CountryCode(name: 'Botswana', code: 'BW', flag: '🇧🇼', dialCode: '+267'),
    CountryCode(name: 'Malawi', code: 'MW', flag: '🇲🇼', dialCode: '+265'),
    CountryCode(name: 'Mozambique', code: 'MZ', flag: '🇲🇿', dialCode: '+258'),
    CountryCode(name: 'United States', code: 'US', flag: '🇺🇸', dialCode: '+1'),
    CountryCode(name: 'United Kingdom', code: 'GB', flag: '🇬🇧', dialCode: '+44'),
    CountryCode(name: 'Canada', code: 'CA', flag: '🇨🇦', dialCode: '+1'),
    CountryCode(name: 'Australia', code: 'AU', flag: '🇦🇺', dialCode: '+61'),
    CountryCode(name: 'Germany', code: 'DE', flag: '🇩🇪', dialCode: '+49'),
    CountryCode(name: 'France', code: 'FR', flag: '🇫🇷', dialCode: '+33'),
    CountryCode(name: 'Italy', code: 'IT', flag: '🇮🇹', dialCode: '+39'),
    CountryCode(name: 'Spain', code: 'ES', flag: '🇪🇸', dialCode: '+34'),
    CountryCode(name: 'Netherlands', code: 'NL', flag: '🇳🇱', dialCode: '+31'),
    CountryCode(name: 'Sweden', code: 'SE', flag: '🇸🇪', dialCode: '+46'),
    CountryCode(name: 'Norway', code: 'NO', flag: '🇳🇴', dialCode: '+47'),
    CountryCode(name: 'Denmark', code: 'DK', flag: '🇩🇰', dialCode: '+45'),
    CountryCode(name: 'Switzerland', code: 'CH', flag: '🇨🇭', dialCode: '+41'),
    CountryCode(name: 'Austria', code: 'AT', flag: '🇦🇹', dialCode: '+43'),
    CountryCode(name: 'Belgium', code: 'BE', flag: '🇧🇪', dialCode: '+32'),
    CountryCode(name: 'Portugal', code: 'PT', flag: '🇵🇹', dialCode: '+351'),
    CountryCode(name: 'Finland', code: 'FI', flag: '🇫🇮', dialCode: '+358'),
    CountryCode(name: 'Ireland', code: 'IE', flag: '🇮🇪', dialCode: '+353'),
    CountryCode(name: 'Japan', code: 'JP', flag: '🇯🇵', dialCode: '+81'),
    CountryCode(name: 'South Korea', code: 'KR', flag: '🇰🇷', dialCode: '+82'),
    CountryCode(name: 'China', code: 'CN', flag: '🇨🇳', dialCode: '+86'),
    CountryCode(name: 'India', code: 'IN', flag: '🇮🇳', dialCode: '+91'),
    CountryCode(name: 'Singapore', code: 'SG', flag: '🇸🇬', dialCode: '+65'),
    CountryCode(name: 'Malaysia', code: 'MY', flag: '🇲🇾', dialCode: '+60'),
    CountryCode(name: 'Thailand', code: 'TH', flag: '🇹🇭', dialCode: '+66'),
    CountryCode(name: 'Philippines', code: 'PH', flag: '🇵🇭', dialCode: '+63'),
    CountryCode(name: 'Indonesia', code: 'ID', flag: '🇮🇩', dialCode: '+62'),
    CountryCode(name: 'Vietnam', code: 'VN', flag: '🇻🇳', dialCode: '+84'),
    CountryCode(name: 'Brazil', code: 'BR', flag: '🇧🇷', dialCode: '+55'),
    CountryCode(name: 'Argentina', code: 'AR', flag: '🇦🇷', dialCode: '+54'),
    CountryCode(name: 'Mexico', code: 'MX', flag: '🇲🇽', dialCode: '+52'),
    CountryCode(name: 'Chile', code: 'CL', flag: '🇨🇱', dialCode: '+56'),
    CountryCode(name: 'Colombia', code: 'CO', flag: '🇨🇴', dialCode: '+57'),
    CountryCode(name: 'Peru', code: 'PE', flag: '🇵🇪', dialCode: '+51'),
    CountryCode(name: 'Venezuela', code: 'VE', flag: '🇻🇪', dialCode: '+58'),
    CountryCode(name: 'Ecuador', code: 'EC', flag: '🇪🇨', dialCode: '+593'),
    CountryCode(name: 'Uruguay', code: 'UY', flag: '🇺🇾', dialCode: '+598'),
    CountryCode(name: 'Paraguay', code: 'PY', flag: '🇵🇾', dialCode: '+595'),
    CountryCode(name: 'Bolivia', code: 'BO', flag: '🇧🇴', dialCode: '+591'),
  ];

  static CountryCode get defaultCountry => countries.first; // Kenya is first

  static CountryCode? findByCode(String code) {
    try {
      return countries.firstWhere((country) => country.code == code);
    } catch (e) {
      return null;
    }
  }

  static CountryCode? findByDialCode(String dialCode) {
    try {
      return countries.firstWhere((country) => country.dialCode == dialCode);
    } catch (e) {
      return null;
    }
  }
}