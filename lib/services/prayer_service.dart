import 'package:audioplayers/audioplayers.dart';
import 'api_service.dart';

class PrayerService {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static final ApiService _apiService = ApiService();

  static Future<Map<String, dynamic>?> getCurrentScheduledPrayer() async {
    try {
      final response = await _apiService.getScheduledPrayer();
      return response;
    } catch (e) {
      print('Error fetching scheduled prayer: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getSpecificPrayer(int prayerId) async {
    try {
      final response = await _apiService.getScheduledPrayer(prayerId: prayerId);
      return response;
    } catch (e) {
      print('Error fetching prayer with ID $prayerId: $e');
      return null;
    }
  }

  static Future<bool> playPrayerAudio(String audioUrl) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(audioUrl));
      return true;
    } catch (e) {
      print('Error playing prayer audio: $e');
      return false;
    }
  }

  static Future<void> stopPrayerAudio() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print('Error stopping prayer audio: $e');
    }
  }

  static Future<void> pausePrayerAudio() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      print('Error pausing prayer audio: $e');
    }
  }

  static Future<void> resumePrayerAudio() async {
    try {
      await _audioPlayer.resume();
    } catch (e) {
      print('Error resuming prayer audio: $e');
    }
  }

  static Stream<PlayerState> get playerStateStream =>
      _audioPlayer.onPlayerStateChanged;

  static Stream<Duration> get positionStream => _audioPlayer.onPositionChanged;

  static Stream<Duration?> get durationStream => _audioPlayer.onDurationChanged;

  static Future<Duration?> getDuration() async {
    return await _audioPlayer.getDuration();
  }

  static Future<Duration> getCurrentPosition() async {
    return await _audioPlayer.getCurrentPosition() ?? Duration.zero;
  }

  static Future<void> seekTo(Duration position) async {
    await _audioPlayer.seek(position);
  }

  static void dispose() {
    _audioPlayer.dispose();
  }
}
