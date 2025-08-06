```
jkmg_app/
├── assets/
│   ├── images/
│   │   ├── jkmg_logo.png
│   │   ├── image2.jpg
│   │   ├── image3.jpg
│   │   ├── image4.jpg
│   │   ├── image5.png
│   ├── videos/
│   │   ├── intro_video.mp4
│   ├── audio/
│   │   ├── prayer_sessions/
│   │   ├── sermons/
│   │   ├── devotionals/
│   ├── fonts/
│   ├── data/
│   │   ├── bible.json
├── lib/
│   ├── auth/
│   │   ├── log_in.dart
│   │   ├── sign_up.dart
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── onboarding.dart
│   │   ├── home.dart
│   │   ├── about/
│   │   │   ├── about_screen.dart
│   │   │   ├── vision_mission.dart
│   │   │   ├── about_julian.dart
│   │   ├── prayer/
│   │   │   ├── prayer_plan_screen.dart
│   │   │   ├── prayer_schedule.dart
│   │   │   ├── request_prayer.dart
│   │   │   ├── deeper_prayer.dart
│   │   ├── bible_study/
│   │   │   ├── bible_study_corner.dart
│   │   ├── salvation/
│   │   │   ├── salvation_corner.dart
│   │   │   ├── give_life_to_christ.dart
│   │   │   ├── rededicate_life.dart
│   │   │   ├── testimonies.dart
│   │   ├── counseling/
│   │   │   ├── counseling_care_screen.dart
│   │   │   ├── access_counseling.dart
│   │   │   ├── self_guided_healing.dart
│   │   │   ├── feedback_form.dart
│   │   │   ├── mood_tracker.dart
│   │   ├── resources/
│   │   │   ├── resources_screen.dart
│   │   │   ├── digital_materials.dart
│   │   │   ├── merchandise.dart
│   │   ├── events/
│   │   │   ├── events_announcements.dart
│   │   │   ├── rhema_feast.dart
│   │   │   ├── rhema_experience.dart
│   │   │   ├── evangelical_outreach.dart
│   │   │   ├── business_forum.dart
│   │   ├── partnership/
│   │   │   ├── partnership_giving.dart
│   │   ├── kingdom_commonwealth/
│   │   │   ├── kingdom_commonwealth_screen.dart
│   │   ├── coming_soon/
│   │   │   ├── coming_soon_screen.dart
│   │   ├── contact/
│   │   │   ├── contact_screen.dart
│   ├── widgets/
│   │   ├── custom_button.dart
│   │   ├── sliding_image_carousel.dart
│   │   ├── prayer_notification.dart
│   │   ├── testimony_card.dart
│   │   ├── event_card.dart
│   │   ├── booking_calendar.dart
│   │   ├── mood_tracker_widget.dart
│   │   ├── video_player_widget.dart
│   │   ├── audio_player_widget.dart
│   ├── models/
│   │   ├── user.dart
│   │   ├── prayer_request.dart
│   │   ├── testimony.dart
│   │   ├── event.dart
│   │   ├── bible_study.dart
│   │   ├── donation.dart
│   │   ├── counseling_session.dart
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── prayer_service.dart
│   │   ├── notification_service.dart
│   │   ├── analytics_service.dart
│   │   ├── payment_service.dart
│   │   ├── api_service.dart
│   │   ├── database_service.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   ├── utils/
│   │   ├── constants.dart
│   │   ├── helpers.dart
│   ├── main.dart
├── pubspec.yaml
```

### File Structure Explanation:

#### **Root Directories**:
- **`assets/`**: Stores static assets like images, videos, audio, and JSON files for the Bible.
  - `images/`: Contains the JKMG logo and onboarding images (`image2.jpg`, `image3.jpg`, `image4.jpg`, `image5.png`).
  - `videos/`: Holds the introductory video (`intro_video.mp4`).
  - `audio/`: Organized subdirectories for prayer sessions, sermons, and devotionals.
  - `data/`: Includes `bible.json` for Bible study content.
- **`lib/`**: Main source code directory for the Flutter app.

#### **`lib/` Subdirectories**:
- **`auth/`**:
  - `log_in.dart`: Login screen with country selection, mandatory Terms and Conditions checkbox, and optional marketing checkbox.
  - `sign_up.dart`: Sign-up screen for user registration.
- **`screens/`**: Contains all main screens and sub-screens corresponding to the app’s menus.
  - `splash_screen.dart`: Displays the logo, tagline, and introductory video.
  - `onboarding.dart`: Sliding onboarding screens introducing JKMG, prayer plan, salvation, and community.
  - `home.dart`: Main dashboard linking to all menu options.
  - **About Menu**:
    - `about_screen.dart`: Displays JKMG introduction with a pre-recorded welcome voice from Rev. Julian.
    - `vision_mission.dart`: Shows the vision, mission, and core goals.
    - `about_julian.dart`: Details about Rev. Julian Kyula.
  - **Rhema Prayer Plan Menu**:
    - `prayer_plan_screen.dart`: Main screen for the prayer plan.
    - `prayer_schedule.dart`: Manages 6-hour prayer reminders.
    - `request_prayer.dart`: Allows users to select a prayer category for a 7-day commitment.
    - `deeper_prayer.dart`: Facilitates midnight prayer sessions.
  - **Bible Study Corner Menu**:
    - `bible_study_corner.dart`: Displays the Bible study template with memory verse, topic, scripture, devotional, and discussion questions.
  - **Salvation Corner Menu**:
    - `salvation_corner.dart`: Main screen for salvation options.
    - `give_life_to_christ.dart`: Form for accepting Christ with a pre-recorded message.
    - `rededicate_life.dart`: Form for rededicating life to Christ with a pre-recorded message.
    - `testimonies.dart`: Sliding carousel for user-submitted testimonies with pause functionality.
  - **Counseling & Care Menu**:
    - `counseling_care_screen.dart`: Main screen for counseling options.
    - `access_counseling.dart`: Booking calendar and Telegram group link for counseling.
    - `self_guided_healing.dart`: AI-driven devotional therapy and voice-guided prayers.
    - `feedback_form.dart`: Form for user feedback on counseling.
    - `mood_tracker.dart`: Daily mood check-in with Bible prompts.
  - **JKMG Resources Menu**:
    - `resources_screen.dart`: Main screen for digital and physical resources.
    - `digital_materials.dart`: Access to eBooks, audiobooks, and sermons.
    - `merchandise.dart`: Links to JKMG merchandise with a shipping form.
  - **Events & Announcements Menu**:
    - `events_announcements.dart`: Main screen for events and news.
    - `rhema_feast.dart`: Details and registration for the annual Rhema Feast.
    - `rhema_experience.dart`: Weekly RXP service with live stream and reminders.
    - `evangelical_outreach.dart`: Displays images and videos of outreach efforts.
    - `business_forum.dart`: Information on the 7D JKMG Business Forum.
  - **Partnership & Giving Menu**:
    - `partnership_giving.dart`: Form for donations via M-Pesa, Sendwave, and bank transfers.
  - **Kingdom Commonwealth Menu**:
    - `kingdom_commonwealth_screen.dart`: Introduction and link to the external platform.
  - **Coming Soon Menu**:
    - `coming_soon_screen.dart`: Placeholder for future features.
  - **Contact Menu**:
    - `contact_screen.dart`: Contact form, social media links, and map integration.
- **`widgets/`**: Reusable UI components.
  - `custom_button.dart`: Custom buttons styled with the black and gold theme.
  - `sliding_image_carousel.dart`: Carousel for onboarding images and testimonies.
  - `prayer_notification.dart`: Notification widget for prayer reminders.
  - `testimony_card.dart`: Card for displaying testimonies.
  - `event_card.dart`: Card for event details.
  - `booking_calendar.dart`: Calendar widget for counseling bookings.
  - `mood_tracker_widget.dart`: Widget for mood tracking with Bible prompts.
  - `video_player_widget.dart`: Reusable video player for intro and event videos.
  - `audio_player_widget.dart`: Audio player for prayers, sermons, and devotionals.
- **`models/`**: Data models for app entities.
  - `user.dart`: User profile data (name, email, country, etc.).
  - `prayer_request.dart`: Structure for prayer requests.
  - `testimony.dart`: Structure for user testimonies.
  - `event.dart`: Data for events like Rhema Feast and RXP.
  - `bible_study.dart`: Model for Bible study content.
  - `donation.dart`: Structure for donation transactions.
  - `counseling_session.dart`: Data for counseling bookings.
- **`services/`**: Business logic and backend integration.
  - `auth_service.dart`: Handles user authentication.
  - `prayer_service.dart`: Manages prayer schedules and content delivery.
  - `notification_service.dart`: Handles push notifications for prayers and events.
  - `analytics_service.dart`: Tracks user engagement and metrics.
  - `payment_service.dart`: Integrates with M-Pesa, Sendwave, and bank transfers.
  - `api_service.dart`: Manages API calls to the backend (Node.js services).
  - `database_service.dart`: Handles local caching and data storage.
- **`theme/`**:
  - `app_theme.dart`: Black and gold theme as provided in the AppTheme class.
- **`utils/`**:
  - `constants.dart`: App-wide constants (e.g., colors, API endpoints).
  - `helpers.dart`: Utility functions for time zone detection, formatting, etc.
- **`main.dart`**: Entry point for the app, initializing the theme and splash screen.
- **`pubspec.yaml`**: Declares dependencies (e.g., `video_player`, `http`, `firebase_analytics`) and assets.

### Notes:
- **Assets**: Ensure all images, videos, and audio files are included in `pubspec.yaml` under the `assets` section.
- **Backend Integration**: The document mentions Node.js backend services (User, Prayer, Scheduler, Analytics). The `api_service.dart` will handle communication with these services.
- **Notifications**: The `notification_service.dart` supports the prayer schedule and event reminders with customizable sound, vibration, and LED options.
- **Analytics**: The `analytics_service.dart` tracks metrics like DAU, WAU, MAU, session times, and feature usage, integrating with Firebase or Mixpanel as suggested.
- **Multilingual Support**: The app supports English, Swahili, French, and Spanish, which can be implemented using a localization package like `intl`.
- **Admin Panel**: Backend-related files (e.g., content management, analytics) are assumed to be handled server-side, but the app includes client-side logic to interact with the admin panel via APIs.

This structure provides a scalable foundation for the JKMG App, covering all specified screens and features while maintaining modularity and reusability. Let me know if you need a specific file implemented or further details!