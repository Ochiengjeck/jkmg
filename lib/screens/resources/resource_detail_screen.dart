import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/resource.dart';
import '../../provider/api_providers.dart';
import '../../utils/app_theme.dart';

class ResourceDetailScreen extends ConsumerWidget {
  final String resourceId;

  const ResourceDetailScreen({super.key, required this.resourceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resourceAsync = ref.watch(resourceDetailsProvider(resourceId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resource Details'),
        centerTitle: true,
        elevation: 0,
      ),
      body: resourceAsync.when(
        data: (resource) => ResourceDetailView(resource: resource),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load resource',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.refresh(resourceDetailsProvider(resourceId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResourceDetailView extends StatelessWidget {
  final Resource resource;

  const ResourceDetailView({super.key, required this.resource});

  IconData _getResourceIcon() {
    switch (resource.type.value) {
      case 'ebook':
        return Icons.menu_book;
      case 'audiobook':
        return Icons.headphones;
      case 'sermon':
        return Icons.play_circle;
      default:
        return Icons.description;
    }
  }

  Color _getResourceColor() {
    switch (resource.type.value) {
      case 'ebook':
        return Colors.blue;
      case 'audiobook':
        return Colors.green;
      case 'sermon':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildDescription(context),
          const SizedBox(height: 24),
          _buildResourceInfo(context),
          const SizedBox(height: 24),
          _buildMediaPlayer(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _getResourceColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getResourceColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _getResourceColor().withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _getResourceIcon(),
              color: _getResourceColor(),
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            resource.displayTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: _getResourceColor(),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              resource.type.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          resource.displayDescription,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildResourceInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resource Information',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          context,
          Icons.language,
          'Language',
          resource.displayLanguage,
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          context,
          Icons.calendar_today,
          'Added',
          _formatDate(resource.createdAt),
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildMediaPlayer(BuildContext context) {
    if (!resource.hasValidDownloadUrl) {
      return _buildNoMediaAvailable(context);
    }

    switch (resource.type.value) {
      case 'ebook':
        return _buildEbookViewer(context);
      case 'audiobook':
        return AudioPlayerWidget(audioUrl: resource.downloadUrl);
      case 'sermon':
        return VideoPlayerWidget(videoUrl: resource.downloadUrl);
      default:
        return _buildGenericDownload(context);
    }
  }

  Widget _buildNoMediaAvailable(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.cloud_off,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            'Media Not Available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This resource is not currently available for online access.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEbookViewer(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.shade200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.picture_as_pdf,
            size: 48,
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          Text(
            'Open E-Book',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap to open and read this e-book',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.blue.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _launchUrl(resource.downloadUrl),
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open E-Book'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenericDownload(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryGold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryGold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.download,
            size: 48,
            color: AppTheme.primaryGold,
          ),
          const SizedBox(height: 12),
          Text(
            'Download Resource',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryGold,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Download this resource to access it',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.primaryGold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _launchUrl(resource.downloadUrl),
            icon: const Icon(Icons.download),
            label: const Text('Download'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGold,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }
}

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerWidget({super.key, required this.audioUrl});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        setState(() => _isLoading = true);
        await _audioPlayer.play(UrlSource(widget.audioUrl));
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Error playing audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.shade200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.audiotrack,
            size: 48,
            color: Colors.green,
          ),
          const SizedBox(height: 16),
          Text(
            'Audio Player',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.green.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => _audioPlayer.seek(Duration(seconds: _position.inSeconds - 10)),
                icon: const Icon(Icons.replay_10),
                iconSize: 32,
                color: Colors.green,
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: _togglePlayPause,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: _isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 36,
                        ),
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () => _audioPlayer.seek(Duration(seconds: _position.inSeconds + 10)),
                icon: const Icon(Icons.forward_10),
                iconSize: 32,
                color: Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.green,
                  inactiveTrackColor: Colors.green.shade200,
                  thumbColor: Colors.green,
                  overlayColor: Colors.green.withOpacity(0.2),
                ),
                child: Slider(
                  value: _position.inSeconds.toDouble(),
                  max: _duration.inSeconds.toDouble(),
                  onChanged: (value) {
                    _audioPlayer.seek(Duration(seconds: value.toInt()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_position),
                      style: TextStyle(color: Colors.green.shade700),
                    ),
                    Text(
                      _formatDuration(_duration),
                      style: TextStyle(color: Colors.green.shade700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _controller!.initialize();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      debugPrint('Error initializing video: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.shade200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(
                  Icons.video_library,
                  size: 48,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Sermon Video',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (_hasError)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Unable to load video',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.red.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _launchUrl(widget.videoUrl),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open in Browser'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          else if (!_isInitialized)
            const Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            )
          else
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    VideoPlayer(_controller!),
                    VideoProgressIndicator(
                      _controller!,
                      allowScrubbing: true,
                      colors: VideoProgressColors(
                        playedColor: Colors.red,
                        backgroundColor: Colors.black26,
                        bufferedColor: Colors.red.shade200,
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      child: FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            if (_controller!.value.isPlaying) {
                              _controller!.pause();
                            } else {
                              _controller!.play();
                            }
                          });
                        },
                        backgroundColor: Colors.red,
                        child: Icon(
                          _controller!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }
}