# JKMG Application - Complete UI Documentation

This document provides a comprehensive description of every screen, widget, dialog, and visual element in the JKMG (Julian Kyula Ministries Global) Flutter application.

---

## Table of Contents

1. [Design System & Theme](#design-system--theme)
2. [Onboarding & Authentication](#onboarding--authentication)
3. [Home Screen & Navigation](#home-screen--navigation)
4. [Prayer Module](#prayer-module)
5. [Bible Study Module](#bible-study-module)
6. [Salvation Corner](#salvation-corner)
7. [Events Module](#events-module)
8. [Counseling & Care Module](#counseling--care-module)
9. [Testimonies Module](#testimonies-module)
10. [Partnership & Giving](#partnership--giving)
11. [Kingdom Commonwealth](#kingdom-commonwealth)
12. [Resources Module](#resources-module)
13. [Inbox & Notifications](#inbox--notifications)
14. [Profile & Settings](#profile--settings)
15. [Contact & Help](#contact--help)
16. [Reusable Widgets](#reusable-widgets)

---

## Design System & Theme

**File:** `lib/utils/app_theme.dart`

### Color Palette

| Token | Hex | Usage |
|-------|-----|-------|
| `primaryGold` | `#FFD700` | Primary accent, buttons, active indicators |
| `darkGold` | `#D4AF37` | Secondary gold, gradient stops |
| `deepGold` | `#B8860B` | Text headings, section titles |
| `richBlack` | `#000000` | Primary background (dark mode) |
| `charcoalBlack` | `#1A1A1A` | Card backgrounds, secondary surfaces |
| `softBlack` | `#2A2A2A` | Input field fills, tertiary surfaces |
| `accentGold` | `#FFF8DC` | Light gold tints, surface accents |
| `errorRed` | `#FF6B6B` | Error states, destructive actions |
| `successGreen` | `#4ECDC4` | Success states, completed indicators |

### Gradients

- **Primary Gold Gradient:** `primaryGold -> darkGold -> deepGold` (top-left to bottom-right) -- used on primary buttons and hero elements.
- **Dark Background Gradient:** `richBlack -> charcoalBlack -> richBlack` (top to bottom) -- used as the default screen background.
- **Gold Radial Gradient:** Radial emanation from center -- used on icons and avatars.

### Component Styling

- **Buttons:** 20px border radius, gold gradient fill, richBlack text, 8px elevation with gold glow shadow.
- **Cards:** 16-20px border radius, theme-adaptive fill, subtle gold border, gold-tinted shadow.
- **Text Fields:** 20px border radius, softBlack/accentGold fill, gold focused border, red error border.
- **Text:** White on dark backgrounds, richBlack on light backgrounds. Titles in gold/deepGold.

### Theme Modes

The app supports both **Dark Mode** (default, richBlack backgrounds) and **Light Mode** (white backgrounds, gold accents). Theme toggling is managed via Riverpod's `themeProvider`.

---

## Onboarding & Authentication

### Splash Screen

**File:** `lib/screens/onboarding/splash_screen.dart`

A full-screen animated splash displayed on every app launch.

- **Background:** Radial gradient (dark gray center to black edges).
- **Elements:**
  - 20 floating gold particle icons (`auto_awesome`) drifting vertically on a 4-second animation loop.
  - Three concentric pulsing golden rings (350px, 280px, 220px) oscillating between 0.8x and 1.2x scale.
  - Central Hero-tagged app logo (180px circle) with gold radial gradient, scaling up from 0.5x to 1.0x with elastic easing.
  - "DIVINE" title text with gold gradient shader, 42px, letter-spacing 8.
  - Tagline "Transforming Lives Through God's Word" in a gold-bordered pill container.
- **Duration:** 2 seconds, then auto-navigates to Onboarding Screen with an 800ms fade transition.
- **Interactions:** None (passive display).

### Onboarding Screen

**File:** `lib/screens/onboarding/onboarding.dart`
**Data:** `lib/screens/onboarding/onboarding_data.dart`

A 4-page horizontal swipeable introduction to the app.

**Pages:**

| # | Title | Subtitle | Icon/Image | Description |
|---|-------|----------|------------|-------------|
| 1 | Welcome to JKMG | Grow in God's Word | App icon image | Community, faith, prayer, Rev. Julian Kyula |
| 2 | Prayer & Devotion | Pray with Purpose | `Icons.schedule` | Daily prayer every 6 hours, midnight sessions |
| 3 | Salvation Corner | Find Your Path | `Icons.lightbulb` | Accepting Christ, rededication, counseling |
| 4 | Global Events | Connect & Serve | `Icons.public` | Rhema Feast, RXP, testimonies, global fellowship |

**Each page contains:**
- A floating 160x160 icon/image card with gold gradient, border, and glow shadow.
- Title with gold gradient shader.
- Subtitle in gold.
- Description in a bordered container with white text.

**Navigation controls:**
- **Skip button** (top-right): Gold pill, skips to Login Screen.
- **Bottom navigation bar:** Previous/Next buttons and animated page indicator dots. The last page's next button becomes a checkmark to complete onboarding.

**Persistence:** Saves `isFirstLaunch(false)` to SharedPreferences on completion.

### App Initializer

**File:** `lib/widgets/app_initializer.dart`

Invisible routing widget that determines the initial screen on app start:

1. First launch -> Onboarding Screen
2. Authenticated user with valid session -> Home Screen (wrapped in AuthWrapper)
3. Otherwise -> Login Screen

Displays a loading splash (gold spinner + app logo) while resolving.

### Auth Wrapper

**File:** `lib/widgets/auth_wrapper.dart`

Invisible wrapper around authenticated screens. Watches the user provider and:
- On authentication failure (401/Unauthenticated): clears session, navigates to Login Screen, shows "session expired" snackbar.
- On other errors: passes through to child screens to handle.

### Login Screen

**File:** `lib/auth/log_in.dart`

**Layout:** Dark gradient background with fade-in + slide-up entry animation (1200ms).

**Elements (top to bottom):**
1. **App Logo** (120x120): Hero-tagged, floating animation (8px oscillation, 4-second cycle), gold radial gradient with gold glow shadow.
2. **"Welcome Back"** title with gold gradient shader, 28px.
3. **Subtitle:** "Sign in to continue your journey".
4. **Login Type Toggle:** Two pill buttons ("Phone" / "Email") with animated active/inactive states.
5. **Phone Input** (phone mode): Custom `PhoneInputField` with country code selector.
6. **Email Input** (email mode): TextFormField with email validation.
7. **Password Field:** With lock icon and visibility toggle.
8. **"Sign In" Button:** Full-width gold gradient, shows spinner when loading.
9. **"Forgot Password?"** link navigating to Forgot Password Screen.
10. **"Don't have an account? Sign Up"** link navigating to Sign Up Screen.

**Navigation on success:** Replaces current route with Home Screen.

### Sign Up Screen

**File:** `lib/auth/sign_up.dart`

**Layout:** Same dark gradient + animation pattern as Login.

**Form fields:**
1. Full Name (required)
2. Country dropdown (~195 countries, defaults to Kenya)
3. Phone number with country code selector
4. Email (optional)
5. Timezone dropdown (37 options, optional)
6. Password with visibility toggle
7. Confirm Password with visibility toggle
8. **Prayer Times Section:** Gold-bordered container with 4 selectable time chips (6 AM, 12 PM, 6 PM, 12 AM). All selected by default. Chips toggle with animated gold gradient fill.
9. Terms & Conditions checkbox (required, gold when active)
10. Marketing opt-in checkbox (optional)
11. **"Create Account"** gold gradient button

**Navigation on success:** Replaces current route with Home Screen.

### Forgot Password Screen

**File:** `lib/auth/forgot_password.dart`

- Back button (gold, bordered).
- Lock-reset icon (120px, floating animation).
- "Reset Password" title.
- Email input field.
- "Send one time password (OTP)" button.
- "Remember your password? Sign In" link.

**Navigation:** On OTP sent -> OTP Verification Screen.

### OTP Verification Screen

**File:** `lib/auth/otp_verification.dart`

- Security icon (floating animation).
- "Verify OTP" title showing the target email.
- **6-digit OTP input:** Row of 6 individual input boxes (45x55px each), auto-advancing focus, auto-submitting on completion. Active boxes have gold border and glow.
- "Verify Code" button.
- **Resend timer:** 60-second countdown, then "Resend" link appears.

**Navigation:** On success -> Reset Password Screen.

### Reset Password Screen

**File:** `lib/auth/reset_password.dart`

- Lock-open icon (floating animation).
- "Set New Password" title.
- New Password field (min 8 characters, visibility toggle).
- Confirm Password field (visibility toggle, match validation).
- "Reset Password" button.
- **Success Dialog:** Non-dismissible dialog with check icon, "Success!" title, and "Continue to Login" button that clears navigation stack to Login Screen.

---

## Home Screen & Navigation

### Home Screen

**File:** `lib/screens/home.dart`

The main hub of the application, structured as a Scaffold with AppBar, Drawer, PageView body, and a FloatingActionButton.

#### AppBar
- **Title:** Dynamically shows the current page name.
- **Leading:** Hamburger menu icon (gold) to open the drawer.
- **Actions:**
  - Notification bell with red unread count badge (capped at "99+"). Tapping opens Inbox Screen.
  - Logout icon with confirmation dialog.

#### Drawer

A full-height navigation drawer with transparent background and gradient overlay.

**Drawer Header (300px):**
- Rounded gradient box with glassmorphism overlay.
- App icon in CircleAvatar (radius 32).
- "JKMG Ministry" title and tagline.
- "Welcome, [name]" chip if logged in.

**Drawer Sections:**

| Section | Items |
|---------|-------|
| Main Features | Home, Rhema Prayer Plan, Bible Study Corner, Salvation Corner |
| Services & Resources | Counseling & Care, JKMG Resources, Expression & Announcements (NEW badge), Partnership & Giving |
| Community | Kingdom Commonwealth, Contact Us |
| Account & Settings | Profile, Inbox, Settings, Help & Support |
| Account | Logout (red, destructive) |

Each item has an icon in a rounded container, title, forward arrow, and optional badges.

#### Body (PageView)

15 horizontally swipeable pages:

| Index | Page |
|-------|------|
| 0 | Landing Page |
| 1 | About Screen |
| 2 | Prayer Plan Screen |
| 3 | Bible Study Corner |
| 4 | Salvation Corner |
| 5 | Counseling Corner |
| 6 | JKMG Resources |
| 7 | Event List |
| 8 | Partnership & Giving |
| 9 | Kingdom Commonwealth |
| 10 | Coming Soon (placeholder) |
| 11 | Contact Screen |
| 12 | Profile Screen |
| 13 | Settings Screen |
| 14 | Help & Support |

#### Landing Page (Page 0)

**1. Hero Carousel:**
- 400px auto-scrolling `PageView` (5-second interval) with animated page indicators.
- Supports dynamic sliders from API (via `CachedNetworkImage`) with static fallbacks.
- Each slide: full background image, gradient overlays, floating "EXPLORE" button, subtitle badge, gold title pill, description text, and action CTA.
- Final slide: "Intro Video" with play button and "WELCOME TO JKMG" title.
- Pause/play button at top-right for auto-scroll control.

**2. Welcome Message from Pastor:**
- Dark container with play icon, pastor video title, "From Rev. Julian Kyula" subtitle, "Play Video" button, and info icon linking to About page.

**3. Quick Access Grid:**
- 3-column grid of 9 image-based cards: Rhema Prayer Plan, Bible Study Corner, Salvation Corner, About JKMG, Counseling & Care, JKMG Resources, Expression & Announcements, Partnership & Giving, Kingdom Commonwealth.

**4. Ministry Highlights:**
- Row of 3 stat cards: "50K+ Lives Transformed", "25+ Countries Reached", "1000+ Prayer Partners".
- Quote container from Rev. Julian Kyula.

#### Floating Action Button
- Gold gradient extended FAB labeled "Testify" with campaign icon. Navigates to Salvation Corner with testimony pre-selected.

---

## Prayer Module

### Prayer Plan Screen (Hub)

**File:** `lib/screens/prayer/prayer_plan_screen.dart`

The main container for the prayer module, orchestrating sub-sections via a dropdown selector.

**Hero Section:**
- Image (`prayer plan.png`) with dark gradient text area below.
- Title: "Daily Prayer Schedule".
- Feature chips: "Daily Prayer", "Spiritual Growth", "Divine Connection".

**Dropdown Selector:**
- "Choose Your Prayer Focus" with 3 options:
  - Daily Prayer Schedule
  - Request Prayer (disabled during active 7-day commitment)
  - Deeper Prayer

**Pull-to-refresh** invalidates the `deeperPrayerInfoProvider`.

### Prayer Schedule

**File:** `lib/screens/prayer/prayer_schedule.dart`

Displays the daily 3-time prayer schedule with alarm management.

**Schedule Info Banner:**
- Gold-tinted container with notification icon explaining 6-hour prayer intervals.

**Prayer Time Cards:**
- Three horizontal cards: Morning (6 AM, sun icon), Noon (12 PM, sun-outlined icon), Evening (6 PM, twilight icon).
- Active card (based on current time window): stronger gold styling, larger icon, gold dot indicator, gold box shadow.
- Tapping an active card fetches the current prayer and either plays audio (via Prayer Audio Dialog) or shows a no-audio message.

**Alarm Settings:**
- Regular Prayer Alarms toggle (6AM, 12PM, 6PM).
- Deeper Prayer Alarms toggle (midnight session).
- "Disable All Alarms" red button.
- Tune icon opens Alarm Settings Dialog for snooze configuration.

**Dialogs:**
- **Prayer Audio Dialog:** Title, message, StreamBuilder-based audio controls (Play/Stop), Close button.
- **No Audio Dialog:** Message directing to inbox.
- **Login Required Dialog:** For unauthenticated users.

### Request Prayer

**File:** `lib/screens/prayer/request_prayer.dart`

Allows users to select a prayer category and commit to a 7-day focused prayer plan.

**Active Commitment View:**
- Green container showing remaining days, end date, and a note that other categories are disabled.

**Category Selection (no active commitment):**
- `Wrap` of tappable category chips loaded from `prayerCategoriesProvider`. Selected chip has gold border and tint.

**Submit Section (visible when category selected):**
- Green info banner showing 7-day date range.
- "Get Daily Prayer" gold button.

**Commitment Confirmation Dialog:**
- Warning icon, commitment terms (7 days, no other requests, daily reminders), Cancel and "Start Commitment" buttons.

**Daily Prayer Popup:**
- Prayer title, scrollable message, optional pastor name, "Play Prayer" button (audio-dependent), Close button.

### Deeper Prayer

**File:** `lib/screens/prayer/deeper_prayer.dart`

Midnight prayer sessions (12:00 AM - 1:00 AM).

**Stats Section:**
- Two stat cards: "Total Sessions" (count) and "Today's Status" (Completed/Pending).

**Completed State:**
- Green container with check icon and thank-you message.

**Active State:**
- Duration dropdown (30 or 60 minutes).
- Time-gated "Pray Now" button (gold during midnight hour, grey/disabled otherwise).
- Orange warning outside midnight: "Prayer is only available from midnight to 1:00 AM."

---

## Bible Study Module

### Bible Study Corner (Hub)

**File:** `lib/screens/bible_study/bible_study_corner.dart`

The entry point for all Bible study features.

**Hero Section:**
- Image (`bible study.png`) with dark gradient text area.
- Title: "Deepen Your Faith Journey".
- Feature chips: "Daily Study", "Memory Verses", "Group Discussion".

**Study Dropdown:**
- "Choose Your Study Focus" with 3 options: Holy Bible Reading, Today's Study, Past Studies.

### Holy Bible Section

**File:** `lib/screens/bible_study/holy_bible_section.dart`

An embedded card providing Bible translation selection, verse of the day, and access to the full reader.

- **Translation Selector:** Dropdown of available Bible translations loaded from API.
- **Verse of Inspiration:** Random verse display with refresh button. Shows reference and text.
- **Full Bible Access:** "Open Bible Reader" button navigating to the Bible Reader Screen.

### Bible Reader Screen

**File:** `lib/screens/bible_study/bible_reader_screen.dart`

A full-featured Bible reading interface pushed as a separate route.

**Control Panel (auto-hides on scroll):**
- Translation dropdown and Book dropdown (side by side).
- Chapter number input and "Read Chapter" button.

**Book Selector (no chapter loaded):**
- Grid of books organized into "Old Testament" (39) and "New Testament" sections. 2-column grid with styled cards.

**Scripture View (chapter loaded):**
- **Chapter Header Bar:** Gold gradient with book name and chapter number, search and settings buttons.
- **Verse Display:** RichText rendering with optional verse number badges, configurable font size, and theme-adaptive background (including night reading mode with amber border).
- **Chapter Navigation:** Previous/Next buttons with "Chapter N" badge.

**Floating Actions:** Scroll-to-top button and Random Verse/Daily Inspiration button.

**Dialogs:**
- **Search Dialog:** Verse reference input (e.g., "John 3:16") with search results display.
- **Settings Dialog:** Verse numbers toggle, font size slider (14-28px).
- **Daily Inspiration Dialog:** Random verse with "Another" refresh option.

### Today's Study

**File:** `lib/screens/bible_study/todays_study.dart`

A display-only card showing the current day's Bible study.

- Header with topic and scripture reference chip.
- Excerpt text.
- Key Points section (if available): bulleted list with gold dots.
- Discussion Questions: numbered items with question-mark icons.

### Study List

**File:** `lib/screens/bible_study/study_list.dart`

A reusable list of past Bible studies with search, filter, and detail viewing.

- Search TextField and filter icon button.
- Study cards with topic, scripture, date, and forward arrow.
- **Detail Bottom Sheet:** Full study content with topic, scripture, devotional, and discussion questions.
- **Filter Dialog:** Start/End date pickers.

### Past Studies Calendar

Built into `bible_study_corner.dart`:
- Custom calendar with month navigation, weekday headers, and a 6-week grid.
- Day cells color-coded: Today (gold), Has Study (dark gold), No Study (charcoal), Future (grey).
- Calendar legend explaining the color codes.
- Selecting a day shows the study template card with Topic, Scripture, Devotional, and Discussion Questions.

---

## Salvation Corner

### Salvation Corner Screen

**File:** `lib/screens/salvation/salvation_corner.dart`

A comprehensive screen for salvation decisions, rededication, and testimony access.

**Hero Section:**
- Image (`salvation corner.png`) with info button overlay.
- Title: "Begin or Renew Your Journey with Christ".
- Feature chips: "Salvation", "Rededication", "Testimony", plus green "Stats" button.

**Dropdown Options:**

1. **Give My Life to Christ:** Form with Full Name, Gender dropdown, Age input, and "Submit Decision" button. On success, shows a prayer dialog with audio player.

2. **Rededicate My Life to Christ:** Identical form to salvation, with rededication-specific headers and submission endpoint.

3. **Testimony:**
   - Auto-sliding carousel (220px, 4-second interval) showing up to 5 approved testimonies with navigation dots.
   - 2x2 action grid: "View All Testimonies", "Share Your Testimony", "My Testimonies", "Learn More" (disabled).

**Dialogs:**
- **Prayer Dialog:** Celebration icon, prayer title, scrollable prayer text, audio player with play/pause and progress indicator, "Go to Inbox" button.
- **Success Message Dialog:** Green check, success text, inbox notification.
- **Salvation Stats Dialog:** Total decisions, dedications, re-dedications, testimonies, and recent activity list.
- **Info Dialog:** Explains what Salvation Corner offers.

---

## Events Module

### Event List Screen (Hub)

**File:** `lib/screens/events/event_list_screen.dart`

The main entry point for all ministry events.

**Hero Section:**
- Image (`events.png`) with "Expression & Announcements" title.
- Feature chips: "Rhema Feast", "RXP", "Outreach", "Business Forum".

**Event Categories (4 cards):**
- Rhema Feast (celebration icon, gold) -> navigates to Rhema Feast Screen
- RXP (schedule icon, deep gold) -> navigates to RXP Screen
- JKMG Evangelical Outreach (share icon, dark gold) -> navigates to Outreach Screen
- JKMG Business Forum (business icon, green) -> navigates to Business Forum Screen

Each card shows event count badge, title, description, and forward arrow.

**All Events Section:**
- Up to 3 EventCard widgets from `allEventsProvider`. "View All" button for more.

**My Registrations Section:**
- Up to 3 EventCard widgets from `myRegistrationsProvider`. "View All" button for more.

### Event Detail Screen

**File:** `lib/screens/events/event_detail_screen.dart`

A detailed view for any individual event.

**Hero (400px):**
- Event-type-specific placeholder image background.
- Gradient overlay with decorative pattern painter.
- Category badge, event title (32px), date with calendar icon, location with pin icon.

**Content:**
- **Info Row:** Registration count and volunteer count cards.
- **Description Section:** "About This Event" with full description.
- **Details Section:** Duration, Category, Event Type.
- **Registration Section:**
  - Not registered: "Register for Event" gold button -> navigates to Event Registration Screen.
  - Registered: Green status card with registration details + "Cancel Registration" red button (coming soon).

### Event Registration Screen

**File:** `lib/screens/events/event_registration_screen.dart`

A form for registering to an event with staggered field animations.

**Fields:**
1. Event header card showing event icon and title.
2. Emergency Contact (required, phone keyboard).
3. Special Requirements (optional, multi-line).
4. Attendance Mode dropdown: Physical or Virtual.
5. Volunteer checkbox with activism icon.
6. "Complete Registration" gold gradient button (60px tall).

### Rhema Feast Screen

**File:** `lib/screens/events/rhema_feast_screen.dart`

- Hero with image and "I WILL BUILD MY CHURCH" title.
- Dynamic next-event date chip from API.
- About section describing the annual gathering started in 2015.
- Four pillars: Word, Worship, Prayer, Fellowship.
- Upcoming events list and My Registrations list.

### RXP Screen (Rhema Experience)

**File:** `lib/screens/events/rxp_screen.dart`

- Hero with image and "Weekly Interdenominational Service" title.
- Dynamic next-event chip from API (fallback: "Every Wednesday 5:00-9:00 PM - All Saints Cathedral").
- About section explaining Rhema and Ruach meanings.
- Service details: Schedule, Venue, Community, Leadership.
- Upcoming services list and My Registrations list.

### Evangelical Outreach Screen

**File:** `lib/screens/events/evangelical_outreach_screen.dart`

- Hero with image and "Spreading the Gospel Across Nations" subtitle.
- Mission description.
- Upcoming outreach events and My Registrations.
- Impact gallery (2-column grid): Community Outreach, Global Missions, Volunteer Programs, Church Planting, Education Initiatives, Healing Miracles.
- Transformation Stories section with "View Stories" button (coming soon).

### Business Forum Screen

**File:** `lib/screens/events/business_forum_screen.dart`

- Hero with image and "Kingdom-Based Entrepreneurship" subtitle.
- About section describing business networking.
- **Calendar view** with monthly navigation, event day highlighting, and tap-to-view events in bottom sheet.
- My Business Forum Registrations.
- Forum Features: Panel Discussions, Networking Sessions, Skills Development, Growth Opportunities.
- Networking stats: 500+ Business Owners, 150+ Investors, 200+ Entrepreneurs, 75+ Industry Experts.

---

## Counseling & Care Module

### Counseling Corner (Hub)

**File:** `lib/screens/counceling/counseling_corner.dart`

Entry screen for all counseling features.

**Hero Section:**
- Image (`counseling & care.png`).
- Title: "Find Healing in Christ".
- Feature chips: "Professional Care", "Emergency Support".

**Dropdown Options:**

1. **Access Counseling:** Card with Telegram group link for private counseling.
2. **Start Healing Session:** Card describing spiritual healing, navigates to Healing Session Screen.
3. **Emergency Help:** Red-bordered card with emergency dialog containing WhatsApp crisis contact numbers.

### Healing Session Screen

**File:** `lib/screens/counceling/healing_session_screen.dart`

An inspirational landing page before counsellor selection.

- Hero with heart icon, "Welcome to Your Healing Space" title (26px), and sacred space subtitle.
- Psalm 147:3 quote with left gold border.
- Journey description with 3 features: Compassionate Guidance, Biblical Wisdom, Personalized Care.
- "Begin Your Healing Journey" gold button -> navigates to Agent Selection Screen.
- Blue "gentle reminder" container about healing being a journey.

### AI Counseling Screen

**File:** `lib/screens/counceling/ai_counseling_screen.dart`

Gateway to the AI counseling feature.

- Gold hero with psychology icon, title, and subtitle.
- Psalm 34:18 Bible verse quote.
- Features list: Biblical Guidance, Spiritual Support, 24/7 Availability, Confidential.
- "New Chat" and "My Chats" action buttons.
- "Open Web Version" button (launches external Pickaxe chatbot).
- Orange disclaimer about AI limitations.

### Agent Selection Screen

**File:** `lib/screens/counceling/agent_selection_screen.dart`

Choose an AI counsellor to begin a conversation.

- Gold header with "Meet Your Healing Counsellors" title.
- Counsellor cards showing: avatar (green border if online, grey if offline), name, status badge, specialization, personality description.
- "Begin Conversation" button (gold, enabled only for online counsellors).
- Counsellor details dialog with larger avatar, specialty info, and gender indicator.

### Counseling Chat Screen

**File:** `lib/screens/counceling/counseling_chat_screen.dart`

Real-time streaming chat interface with AI counsellors.

**AppBar:** Counsellor avatar (tappable), name, online status indicator (green/grey dot).

**Messages:**
- **User bubbles:** Right-aligned, gold background, black text, person icon avatar.
- **Bot bubbles:** Left-aligned, richBlack background with gold border, white text, counsellor image avatar.
- Each bubble has relative timestamp ("Just now", "5m ago", etc.).

**Welcome State (no messages):** Heart icon, "Welcome to your healing space" title, counsellor introduction.

**Typing Indicator:** Three animated bouncing gold dots with "Typing" text.

**Message Input:** Bottom-anchored text field ("Share what's on your heart...") with gold circular send button.

**Data:** Messages stored locally in SQLite. Streaming via SSE from the API.

### Conversation List Screen

**File:** `lib/screens/counceling/conversation_list_screen.dart`

List of past/existing chat conversations.

- Each conversation: counsellor avatar, name, specialization, last message preview (max 2 lines), relative timestamp.
- PopupMenu with "Delete" option (confirmation dialog).
- Tapping opens Counseling Chat Screen.
- Empty state with chat bubble icon and encouraging message.

### Book Counseling Form

**File:** `lib/screens/counceling/book_counseling.dart`

Form for booking a counseling session (currently not actively displayed in the UI).

- Session Topic, Describe Your Concern (4 lines), Priority Level dropdown (Low/Medium/High with color indicators), Preferred Counselor (optional), Preferred Date & Time picker.
- "Book My Session" gold gradient button.

### Counseling Session List

**File:** `lib/screens/counceling/counseling_list.dart`

Reusable list of counseling sessions with search, filter, and details.

- Search field and filter button.
- Session cards with status icon (green=completed, blue=scheduled, orange=pending, red=cancelled), topic, status badge, time, counselor name.
- **Session Detail Bottom Sheet:** Full details including intake form data (issue, urgency, counselor preference, goal, concern).
- **Filter Dialog:** Start/End date range pickers.

---

## Testimonies Module

### Testimonies Screen

**File:** `lib/screens/testimonies/testimonies_screen.dart`

Browse all approved testimonies.

**AppBar Actions:**
- PopupMenu: "Submit Testimony" and "My Testimonies".

**Header:** Heart icon, "Testimonies of Faith" title, description.

**Testimony Cards:**
- User initials avatar, name, relative date, title (gold, max 2 lines), excerpt (max 3 lines), status chip (green=approved), "Read more" link.
- Pull-to-refresh support.

**FAB:** "Share Testimony" extended button -> navigates to Submit Testimony Screen.

### Testimony Detail Screen

**File:** `lib/screens/testimonies/testimony_detail_screen.dart`

Full view of a single testimony.

- User avatar with initials, name, date, location, status chip.
- Title in gold.
- Full testimony body in a white card (16px, 1.6 line height).
- Media attachment section (if applicable).
- "Thank you for sharing!" gold gradient footer.

### Submit Testimony Screen

**File:** `lib/screens/testimonies/submit_testimony_screen.dart`

Form to submit a new testimony.

- Title field (max 100 chars, min 5).
- Body field (8 lines, max 2000 chars, min 20).
- Blue info banner: "Testimonies are reviewed before publishing."
- Submit button. On success, refreshes providers and pops back.

### My Testimonies Screen

**File:** `lib/screens/testimonies/my_testimonies_screen.dart`

View and manage your own testimonies (including non-approved).

- Testimony cards with status indicators: approved (green check), pending (orange clock), rejected (red cancel).
- Status helper text: "Published to community", "Under review", "Not approved".
- FAB: "New Testimony" -> Submit Testimony Screen.

---

## Partnership & Giving

### Partnership Giving Screen

**File:** `lib/screens/giving/partnership_giving_screen.dart`

Comprehensive giving interface with multiple partnership options.

**Hero Section:**
- Image (`partners.png`).
- Title: "Partner with God's Kingdom Work".
- Philippians 4:17 quote.
- Feature chips: "Monthly Partners", "One-Time Gifts", "Ministry Focus".

**Partnership Options (3 cards):**
1. **Monthly Partner:** Benefits list (updates, prayer requests, priority support, partner events), "Become a Monthly Partner" button.
2. **One-Time Donation:** Benefits list (Rhema Feast, media, youth, missions), "Give One-Time Donation" button.
3. **Support a Cause:** Benefits list (events, media, youth, global expansion), "Choose Ministry Focus" button.

**Secure Giving Options:**
- 2x2 grid of payment methods: M-Pesa, Bank, SendWave, PayPal (greyed out, "Coming Soon").

**Impact Section:**
- Quote from Rev. Julian Kyula.
- Stats: 50K+ Lives Touched, 25+ Countries, 1000+ Partners, $2M+ Raised.

### Giving Form Screen (Embedded)

A 3-step wizard:

| Step | Name | Content |
|------|------|---------|
| 0 | Select | Amount input, currency toggle (KES/USD), payment method cards |
| 1 | Pay | Payment instructions, copyable details (Paybill, account numbers), "I've Made Payment" button |
| 2 | Confirm | Name, Email, Phone, Transaction ID, Notes, "Submit Payment" button |

**Success Dialog:** Check icon, formatted amount, donation reference, "Done" button.

### Partner Dashboard (Embedded, Placeholder)

Centered layout with dashboard icon, "Coming Soon" message.

---

## Kingdom Commonwealth

### Kingdom Commonwealth Screen

**File:** `lib/screens/commonwealth/kingdom_commonwealth_screen.dart`

Informational screen about the Kingdom Commonwealth economic movement.

**Hero:** Image (`commonwealth.png`) with "A Kingdom Economic Movement" title.

**About Section:** Three points covering what it is, core mission, and JKMG connection.

**Key Features (4 cards):**
- Housing Solutions, Food Systems, Education, Health & Finance.

**Impact Metrics (2x2 grid):**
- 1,200+ Community Members, 45 Active Projects, 12 Countries Served, $2.3M Community Wealth.

**Access Section:**
- Mobile App and Website platform buttons.
- "Visit Website" button (launches kingdomcommonwealth.com).
- "Download Mobile App" button (launches Google Play Store).

---

## Resources Module

### JKMG Resources Screen

**File:** `lib/screens/resources/jkmg_resources_screen.dart`

Tabbed resource browser using `SimpleHeaderTabs`.

**Hero:** Image (`resources.png`) with "Expanding Your Kingdom Knowledge" title.

**3 Tabs:**
| Tab | Icon | Resource Type |
|-----|------|---------------|
| E-Books | menu_book | `ebook` |
| Audio | headphones | `audiobook` |
| Sermons | play_circle | `sermon` |

**Resource Cards:**
- 50x50 type-specific icon, title (max 2 lines), type badge, description (max 2 lines), language with globe icon.
- Tapping navigates to Resource Detail Screen.

### Resource Detail Screen

**File:** `lib/screens/resources/resource_detail_screen.dart`

Detailed view and media player for a single resource.

- **Header:** Type-colored background, large icon, title, type label badge.
- **Description:** Full text.
- **Resource Info:** Language and Added date.
- **Media Player (type-dependent):**
  - E-book: "Open E-Book" button (launches URL).
  - Audiobook: Audio player with rewind/forward, play/pause, seek slider, position/duration labels.
  - Sermon: Video player with progress indicator, play/pause overlay. Error fallback to "Open in Browser".
  - No media: "Media Not Available" message.

---

## Inbox & Notifications

### Inbox Screen

**File:** `lib/screens/inbox/inbox_screen.dart`

**AppBar:** "Inbox" with gold gradient, back button, "Mark all as read" action.

**Stats Row:** Three metrics -- Total, Unread (green), Prayers (gold).

**Filter Section:** Three filter chips: "All Messages", "Unread", "Read" with gold active styling.

**Combined List (prayers + notifications, sorted by date):**

**Prayer Cards:**
- Gold gradient styling, "PRAYER AUDIO" badge, title, optional "Led by" pastor info, message preview, "Tap to listen" or "Prayer coming soon" chip.
- Tapping opens Prayer Audio Dialog or Message Dialog.

**Notification Cards:**
- Color-coded by type (PRAYER, AUDIO, MIDNIGHT, EVENT, TESTIMONY, SYSTEM, MESSAGE).
- Unread: colored gradient, thicker border, gold dot indicator, bolder text.
- Read: muted styling.
- Tapping marks as read and shows type-appropriate dialog.

**Dialogs:**
- Prayer Audio: Title, message, audio player (StreamBuilder), Play/Stop button.
- Prayer Message: Title, message, "Audio prayer will be available soon" banner.
- Prayer Reminder: Body, "Later" and "Pray Now" buttons.
- Deeper Prayer: "Midnight Prayer" title, body, "Join Prayer" button.
- General Notification: Title, body, "OK" button.

**Pull-to-refresh** and auto-refresh on app resume.

---

## Profile & Settings

### Profile Screen

**File:** `lib/screens/profile/profile_screen.dart`

Uses `SimpleHeaderTabs` with 3 tabs.

**Hero:** Circular avatar (100px, gold border), display name, email, church role badge.

**Profile Tab:**
- View mode: 6 info rows (Name, Email, Phone, Country, Timezone, Role) with edit toggle.
- Edit mode: Form with Full Name, Email, Phone, Country fields and "Update Profile" button.
- Account Statistics: 2x2 grid (Prayer Requests: 12, Events Attended: 5, Bible Studies: 8, Days Active: 45).

**Settings Tab:**
- Dark Mode toggle.
- Notification toggles: Prayer Reminders, Event Notifications, Study Reminders.
- Prayer Times display with "Customize" button (coming soon).

**Activity Tab:**
- 5 recent activity items with colored icons, titles, subtitles, and timestamps.

### Settings Screen

**File:** `lib/screens/settings/settings_screen.dart`

Uses `SimpleHeaderTabs` with 4 tabs.

**Hero:** Settings icon, "Settings" title, "Customize Your App Experience" subtitle.

**General Tab:**
- Language dropdown (English, Swahili, French, Spanish). Persisted to SharedPreferences.
- Prayer Settings (coming soon): Prayer Times, Prayer Sound.
- Account (coming soon): Privacy & Security, Change Password.

**Notifications Tab:**
- Master notification toggle.
- Sub-toggles: Prayer Reminders, Event Notifications, Study Reminders. Disabled when master is off.
- Quiet Hours (coming soon): 22:00-06:00.

**Appearance Tab:**
- Dark Mode toggle.
- Font Size slider (12-24px, 6 divisions) with live preview text.

**Data Tab:**
- Offline Mode toggle with "Download Content" option.
- Storage Usage: App Data (12.5 MB), Cached Images (8.2 MB), Offline Content (25.1 MB) with progress bars. "Clear Cache" with confirmation dialog.
- Data Management: Backup, Restore, Reset App Data (destructive, with confirmation dialog).

---

## Contact & Help

### About Screen

**File:** `lib/screens/about/about_screen.dart`

Informational page with fade-in animation.

**Sections:**
1. Hero image (`about.png`) with feature chips: "Global Ministry", "Apostolic Insight", "Kingdom Impact".
2. About JKMG: Three paragraphs on ministry mission and founding.
3. Vision & Mission: Two cards.
4. Core Goals: 4 numbered items (Advance the Gospel, Solve Systemic Challenges, Create Equitable Opportunities, Mobilize Strategic Alliances).
5. About Rev. Julian Kyula: 120px circular avatar, "Founder & Overseer" badge, 5 achievement highlights (Leadership, Innovation, Housing, Global Impact, Family).
6. App Features: 5 feature rows (Prayer Engagement, Spiritual Resources, Live Events, Counseling & Care, Community Features).

### Contact Screen

**File:** `lib/screens/contact/contact_screen.dart`

Uses `SimpleHeaderTabs` with 3 tabs.

**Contact Tab:**
- Email: `info@jkministriesglobal.org` (tappable, launches email client).
- Phone: `+254 703 349 237` (tappable, launches dialer).
- Office Hours: Mon-Fri 9AM-5PM EAT, Saturday 10AM-2PM EAT.
- "Share Your Feedback" button opening Feedback Dialog.

**Location Tab:**
- JKMG Headquarters: Waterfront Mall, Karen, Nairobi. "View on Map" button.
- 5 Church Assemblies (RUACH branches): Tabernacle, West, South, East, Rivers. Each with address, "Call" and "Directions" buttons.

**Social Tab:**
- Facebook (`facebook.com/juliankyula`), TikTok (`@juliankyulaofficial`), Instagram (`@jkyula`).
- Newsletter Signup (coming soon).

### Help & Support Screen

**File:** `lib/screens/help/help_support_screen.dart`

Uses `SimpleHeaderTabs` with 3 tabs.

**FAQ Tab:**
- 4 categories (Getting Started, Prayer & Worship, Events & Community, Technical Issues), each with 3 expandable Q&A items.

**Contact Tab:**
- Quick Contact: Email Support, Phone Support, WhatsApp, Schedule a Call.
- Contact Form: Name, Email, Subject, Message (5 lines). "Send Message" button (simulated 2-second delay).

**Resources Tab:**
- 4 categories (Getting Started, Prayer & Worship, Community Features, Technical Support), each with 3 resource links (all coming soon).
- "Still Need Help?" card with "Contact Us" button switching to Contact tab.

---

## Reusable Widgets

### Common Widgets

**File:** `lib/widgets/common_widgets.dart`

| Widget | Description |
|--------|-------------|
| `WelcomeSection` | Gold gradient banner with optional icon, title, subtitle, and action widget |
| `LoadingWidget` | Gold circular spinner with optional message |
| `EmptyStateWidget` | Centered icon, title, subtitle, optional action button |
| `ErrorStateWidget` | Red icon, title, subtitle, optional retry button |
| `GradientButton` | Gold gradient pill button with icon, text, and loading spinner |
| `CustomCard` | Theme-adaptive card with gold shadow, optional border and tap handler |
| `ThemeToggleButton` | Light/dark mode toggle icon button |
| `StatusChip` | Small colored badge with optional icon and label |
| `SectionHeader` | DeepGold title with optional subtitle and trailing action |

### Event Card

**File:** `lib/widgets/event_card.dart`

Press-animated card (scale 0.98) with gold gradient border. Shows event title, description, formatted date badge, location, and registration status indicator (green check if registered, gold icon if not).

### Feedback Dialog

**File:** `lib/widgets/feedback_dialog.dart`

Modal dialog with: feedback type dropdown (from API), subject field, message field (4 lines), 5-star rating selector, optional email, and submit button. Success shows a separate thank-you dialog.

### Phone Input Field

**File:** `lib/widgets/phone_input_field.dart`

Composite widget: country code selector (tappable, showing flag + dial code) and phone text field. Country picker bottom sheet with search, flag emojis, and ~195 country entries.

### Alarm Settings Dialog

**File:** `lib/widgets/alarm_settings_dialog.dart`

Modal for configuring prayer alarm snooze duration. Selectable chips: 1m, 2m, 5m, 10m, 15m, 20m, 30m. Auto-stop info: "Alarms will automatically stop ringing after 30 seconds."

### Header Tab Layouts

Three variants for tabbed screen layouts:

| Widget | File | Pattern | Tab Bar Behavior |
|--------|------|---------|-----------------|
| `ScrollableHeaderTabs` | `scrollable_header_tabs.dart` | CustomScrollView + SliverPersistentHeader | Pinned on scroll |
| `SimpleHeaderTabs` | `simple_header_tabs.dart` | NestedScrollView + SliverAppBar | Pinned, independent tab scroll |
| `UnifiedHeaderTabs` | `unified_header_tabs.dart` | NestedScrollView + floating tab bar | Inline + floating duplicate after 200px |

All share the same tab bar styling: white10 background, 25px border radius, gold border, gold pill indicator.

### YouTube Video Player

**File:** `lib/widgets/youtube_video_player.dart`

**Status:** Currently disabled (entirely commented out). Would provide a branded video player with JKMG header, progress bar, settings, and related video features.

---

## Navigation Flow Summary

```
App Launch
  |
  +-- First Launch --> Splash --> Onboarding (4 pages) --> Login
  |
  +-- Returning User (no session) --> Login
  |       |
  |       +-- Forgot Password --> OTP Verification --> Reset Password --> Login
  |       +-- Sign Up --> Home
  |       +-- Login Success --> Home
  |
  +-- Returning User (valid session) --> Home (via AuthWrapper)

Home Screen (PageView Hub)
  |
  +-- Drawer Navigation --> Any of 15 pages
  |
  +-- Landing Page
  |     +-- Hero Carousel (swipe/auto-scroll)
  |     +-- Quick Access Grid --> Page navigation
  |     +-- Welcome Video --> Video dialog
  |
  +-- Prayer Module
  |     +-- Prayer Schedule (alarm management, audio playback)
  |     +-- Request Prayer (7-day commitment flow)
  |     +-- Deeper Prayer (midnight time-gated)
  |
  +-- Bible Study Module
  |     +-- Holy Bible Section --> Bible Reader Screen
  |     +-- Today's Study (inline display)
  |     +-- Past Studies (calendar navigation)
  |
  +-- Salvation Corner
  |     +-- Salvation / Rededication forms
  |     +-- Testimony carousel --> Testimonies screens
  |
  +-- Events Module
  |     +-- Event Categories --> Category screens
  |     +-- Event Cards --> Event Detail --> Event Registration
  |
  +-- Counseling Module
  |     +-- Telegram Link / Healing Session / Emergency Help
  |     +-- Agent Selection --> Chat Screen (streaming)
  |     +-- Conversation List --> Chat Screen
  |
  +-- Testimonies --> Detail / Submit / My Testimonies
  |
  +-- Giving --> 3-step payment wizard
  |
  +-- Kingdom Commonwealth --> External links
  |
  +-- Resources --> Detail (audio/video/ebook players)
  |
  +-- Inbox (notifications + prayers, filter, audio playback)
  |
  +-- Profile (edit, stats) / Settings (4 tabs) / Contact (3 tabs) / Help (3 tabs)
```
