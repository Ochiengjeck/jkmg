// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class YouTubeVideoPlayer extends StatefulWidget {
//   final String videoUrl;
//   final String? title;
//   final String? description;
  
//   const YouTubeVideoPlayer({
//     super.key,
//     required this.videoUrl,
//     this.title,
//     this.description,
//   });

//   @override
//   State<YouTubeVideoPlayer> createState() => _YouTubeVideoPlayerState();
// }

// class _YouTubeVideoPlayerState extends State<YouTubeVideoPlayer> {
//   late YoutubePlayerController _controller;
//   bool _isFullScreen = false;

//   @override
//   void initState() {
//     super.initState();
    
//     final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    
//     _controller = YoutubePlayerController(
//       initialVideoId: videoId ?? '',
//       flags: const YoutubePlayerFlags(
//         autoPlay: false,
//         mute: false,
//         enableCaption: true,
//         captionLanguage: 'en',
//         forceHD: false,
//         loop: false,
//         isLive: false,
//       ),
//     );

//     _controller.addListener(() {
//       if (_controller.value.isFullScreen != _isFullScreen) {
//         setState(() {
//           _isFullScreen = _controller.value.isFullScreen;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return YoutubePlayerBuilder(
//       onExitFullScreen: () {
//         SystemChrome.setPreferredOrientations(DeviceOrientation.values);
//       },
//       player: YoutubePlayer(
//         controller: _controller,
//         showVideoProgressIndicator: true,
//         progressIndicatorColor: const Color(0xFFFFD700),
//         topActions: <Widget>[
//           const SizedBox(width: 8.0),
//           Expanded(
//             child: Text(
//               widget.title ?? 'JKMG Ministry Video',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.w600,
//               ),
//               overflow: TextOverflow.ellipsis,
//               maxLines: 1,
//             ),
//           ),
//           IconButton(
//             icon: const Icon(
//               Icons.settings,
//               color: Colors.white,
//               size: 25.0,
//             ),
//             onPressed: () {
//               _showVideoSettings(context);
//             },
//           ),
//         ],
//         bottomActions: [
//           CurrentPosition(),
//           const SizedBox(width: 10.0),
//           ProgressBar(
//             isExpanded: true,
//             colors: const ProgressBarColors(
//               playedColor: Color(0xFFFFD700),
//               handleColor: Color(0xFFFFD700),
//             ),
//           ),
//           const SizedBox(width: 10.0),
//           RemainingDuration(),
//           IconButton(
//             icon: const Icon(
//               Icons.fullscreen,
//               color: Colors.white,
//             ),
//             onPressed: () => _controller.toggleFullScreenMode(),
//           ),
//         ],
//         onReady: () {
//           debugPrint('YouTube Player Ready');
//         },
//         onEnded: (data) {
//           _showVideoEndedDialog(context);
//         },
//       ),
//       builder: (context, player) {
//         return Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 const Color(0xFF1A1A1A),
//                 const Color(0xFF2A2A2A),
//                 const Color(0xFF1A1A1A),
//               ],
//             ),
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0xFFFFD700).withOpacity(0.3),
//                 blurRadius: 25,
//                 spreadRadius: 5,
//                 offset: const Offset(0, 8),
//               ),
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.6),
//                 blurRadius: 15,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(20),
//             child: Column(
//               children: [
//                 // Video Header with JKMG Branding
//                 if (!_isFullScreen) _buildVideoHeader(),
                
//                 // YouTube Player
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: _isFullScreen 
//                         ? BorderRadius.zero 
//                         : const BorderRadius.vertical(
//                             bottom: Radius.circular(20),
//                           ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.3),
//                         blurRadius: 8,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: ClipRRect(
//                     borderRadius: _isFullScreen 
//                         ? BorderRadius.zero 
//                         : const BorderRadius.vertical(
//                             bottom: Radius.circular(20),
//                           ),
//                     child: player,
//                   ),
//                 ),
                
//                 // Video Description and Actions
//                 if (!_isFullScreen && widget.description != null) 
//                   _buildVideoDescription(),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildVideoHeader() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             const Color(0xFFFFD700).withOpacity(0.1),
//             const Color(0xFFFFE066).withOpacity(0.05),
//           ],
//         ),
//         border: Border(
//           bottom: BorderSide(
//             color: const Color(0xFFFFD700).withOpacity(0.3),
//             width: 1,
//           ),
//         ),
//       ),
//       child: Row(
//         children: [
//           // JKMG Logo/Icon
//           Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               color: const Color(0xFFFFD700),
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFFFFD700).withOpacity(0.4),
//                   blurRadius: 12,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             child: const Icon(
//               Icons.play_circle_fill,
//               color: Color(0xFF1A1A1A),
//               size: 28,
//             ),
//           ),
//           const SizedBox(width: 16),
          
//           // Video Info
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'JKMG MINISTRY',
//                   style: TextStyle(
//                     color: const Color(0xFFFFD700),
//                     fontSize: 14,
//                     fontWeight: FontWeight.w800,
//                     letterSpacing: 1.5,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   widget.title ?? 'Welcome Video',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
          
//           // Action Buttons
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               IconButton(
//                 icon: const Icon(
//                   Icons.share,
//                   color: Color(0xFFFFD700),
//                   size: 22,
//                 ),
//                 onPressed: () => _shareVideo(),
//                 tooltip: 'Share Video',
//               ),
//               IconButton(
//                 icon: const Icon(
//                   Icons.favorite_border,
//                   color: Color(0xFFFFD700),
//                   size: 22,
//                 ),
//                 onPressed: () => _likeVideo(),
//                 tooltip: 'Like Video',
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildVideoDescription() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             Colors.transparent,
//             const Color(0xFF1A1A1A).withOpacity(0.5),
//           ],
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'About this video',
//             style: TextStyle(
//               color: const Color(0xFFFFD700),
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               letterSpacing: 0.5,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             widget.description!,
//             style: const TextStyle(
//               color: Colors.white70,
//               fontSize: 14,
//               height: 1.5,
//             ),
//           ),
//           const SizedBox(height: 16),
          
//           // Action Buttons Row
//           Row(
//             children: [
//               Expanded(
//                 child: ElevatedButton.icon(
//                   onPressed: () => _subscribeToChannel(),
//                   icon: const Icon(Icons.notifications_active),
//                   label: const Text('Subscribe'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red.shade600,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: OutlinedButton.icon(
//                   onPressed: () => _viewMoreVideos(),
//                   icon: const Icon(Icons.video_library),
//                   label: const Text('More Videos'),
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: const Color(0xFFFFD700),
//                     side: const BorderSide(color: Color(0xFFFFD700)),
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void _showVideoSettings(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(20),
//         decoration: const BoxDecoration(
//           color: Color(0xFF1A1A1A),
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 50,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade600,
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Video Settings',
//               style: TextStyle(
//                 color: Color(0xFFFFD700),
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 20),
//             ListTile(
//               leading: const Icon(Icons.hd, color: Color(0xFFFFD700)),
//               title: const Text('Quality', style: TextStyle(color: Colors.white)),
//               subtitle: const Text('Auto', style: TextStyle(color: Colors.grey)),
//               onTap: () {
//                 // Quality selection would go here
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.speed, color: Color(0xFFFFD700)),
//               title: const Text('Playback Speed', style: TextStyle(color: Colors.white)),
//               subtitle: const Text('Normal', style: TextStyle(color: Colors.grey)),
//               onTap: () {
//                 // Speed selection would go here
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.closed_caption, color: Color(0xFFFFD700)),
//               title: const Text('Captions', style: TextStyle(color: Colors.white)),
//               subtitle: const Text('English', style: TextStyle(color: Colors.grey)),
//               onTap: () {
//                 // Caption selection would go here
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showVideoEndedDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: const Color(0xFF1A1A1A),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         title: Row(
//           children: [
//             Icon(Icons.check_circle, color: Colors.green.shade400, size: 28),
//             const SizedBox(width: 12),
//             const Text(
//               'Video Completed',
//               style: TextStyle(color: Color(0xFFFFD700)),
//             ),
//           ],
//         ),
//         content: const Text(
//           'Thank you for watching! Would you like to explore more JKMG content?',
//           style: TextStyle(color: Colors.white70),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Close', style: TextStyle(color: Colors.grey)),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _viewMoreVideos();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFFFFD700),
//               foregroundColor: const Color(0xFF1A1A1A),
//             ),
//             child: const Text('More Videos'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _shareVideo() {
//     // Implement share functionality
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Text('Video link copied to clipboard!'),
//         backgroundColor: const Color(0xFFFFD700),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//   }

//   void _likeVideo() {
//     // Implement like functionality
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Text('Thank you for liking this video!'),
//         backgroundColor: Colors.red.shade600,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//   }

//   void _subscribeToChannel() {
//     // Implement subscription functionality
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: const Color(0xFF1A1A1A),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         title: const Text(
//           'Subscribe to JKMG',
//           style: TextStyle(color: Color(0xFFFFD700)),
//         ),
//         content: const Text(
//           'Stay updated with our latest messages, teachings, and ministry updates by subscribing to our YouTube channel.',
//           style: TextStyle(color: Colors.white70),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Later', style: TextStyle(color: Colors.grey)),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // Open YouTube channel
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red.shade600,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Subscribe'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _viewMoreVideos() {
//     // Navigate to resources or video library
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Text('Check out more videos in JKMG Resources!'),
//         backgroundColor: const Color(0xFFFFD700),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         action: SnackBarAction(
//           label: 'Go',
//           textColor: const Color(0xFF1A1A1A),
//           onPressed: () {
//             // Navigate to resources section
//           },
//         ),
//       ),
//     );
//   }
// }