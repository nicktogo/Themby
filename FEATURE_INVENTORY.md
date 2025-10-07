# Themby App - Complete Feature Inventory

## Overview
This document catalogs all features currently available in Themby, organized by functional domain. Use this as a checklist to ensure the redesigned app maintains feature parity while exploring new user experiences and information architecture.

---

## 1. Server Management

### Connection Management
- **Add Emby Server**: Connect to new Emby media servers
- **Server Search**: Discover available servers on the network
- **Quick Scan**: Automatic server discovery/scanning
- **Multiple Servers**: Manage connections to multiple Emby servers simultaneously
- **Server List**: View all saved server connections
- **Server Details**: Display server name, username, and connection status
- **Edit/Delete Servers**: Manage existing server connections via options menu
- **Server Switching**: Switch between different server connections

### Authentication
- User login per server connection
- Credential persistence for saved servers

---

## 2. Content Discovery & Browsing

### Library Organization
- **Media Type Filtering**: Separate views for Movies and TV Shows
- **Library Categories**: Browse by predefined media library types
- **Recently Added**: View newly added content to the server
- **Continue Watching**: Quick access to partially-watched content with progress indicators

### Filtering & Sorting
- **All Content**: View entire library
- **Recent**: Recently added items
- **Collections**: Browse curated collections
- **Genre Filter**: Filter content by genre
- **Tag Filter**: Filter content by custom tags
- **Favorites Filter**: Show only favorited items

### Content Presentation
- **Grid View**: Display media as poster grid
- **List View**: Display media in list format (episode lists)
- **Poster Art**: Show official poster images for all content
- **Backdrop Images**: Display backdrop/hero images on detail pages
- **Thumbnail Previews**: Episode and scene thumbnails

---

## 3. Search

### Search Capabilities
- **Universal Search**: Search across all movies and TV shows
- **Search History**: Display previous search queries
- **Search Suggestions**: Quick access to commonly searched titles
- **Real-time Search**: Search as user types
- **Clear Search**: Quick clear functionality

---

## 4. Content Details & Metadata

### Movie/TV Show Information
- **Title & Subtitle**: Primary content identification
- **Synopsis/Description**: Full plot description
- **Rating**: User/critic ratings (e.g., 8.8/10)
- **Content Rating**: Age/maturity rating (e.g., TV-MA, PG-13)
- **Release Year**: Production year
- **Runtime/Duration**: Total length for movies, episode duration for TV
- **Genre Tags**: Category classification
- **Cast Information**: Actor names with photos
- **Character Names**: Role information for cast members

### Episode Information (TV Shows)
- **Season Organization**: Browse by season
- **Episode List**: All episodes with thumbnails
- **Episode Numbers & Titles**: Clear episode identification
- **Episode Descriptions**: Individual episode synopses
- **Episode Progress**: Visual indicator of watch progress

### Media Technical Details
- **Available Subtitles**: List of subtitle tracks with languages
- **Audio Tracks**: Available audio tracks with language/codec info
- **Video Quality**: Resolution and bitrate information

---

## 5. Video Playback

### Core Playback
- **Play/Pause**: Standard playback controls
- **Seek/Scrub**: Navigate through video timeline with progress bar
- **Time Display**: Current time and total duration
- **Continuous Playback**: Auto-play next episode
- **Resume Playback**: Continue from last watched position

### Playback Controls
- **Previous Episode**: Jump to previous episode (TV shows)
- **Next Episode**: Jump to next episode (TV shows)
- **Episode Selector**: Quick access to episode picker during playback
- **Playback Speed**: Adjust playback speed (e.g., 0.5x, 1.0x, 1.5x, 2.0x)

### Player Gestures
- **Positioning Gestures**: Horizontal swipe to seek/scrub timeline
- **Volume Control**: Vertical swipe to adjust volume
- **Brightness Control**: Vertical swipe to adjust brightness
- **Double-tap Pause**: Double-tap center to pause/play
- **Double-tap Skip**: Double-tap left/right to skip backward/forward
- **Long Press Speed**: Hold screen to temporarily speed up playback
- **Configurable Skip Intervals**: Set custom fast-forward/rewind time (in seconds)

### Display Controls
- **Fullscreen Mode**: Immersive playback experience
- **Orientation Lock**: Landscape playback mode
- **Screen Lock**: Lock controls to prevent accidental touches
- **Picture-in-Picture**: Minimize player while using other apps
- **Aspect Ratio Toggle**: Switch between aspect ratios/zoom modes

### Subtitle Controls
- **Subtitle On/Off**: Toggle subtitle display
- **Subtitle Track Selection**: Choose from available subtitle languages
- **Subtitle Appearance**: Customize subtitle styling
  - Font size adjustment (slider control)
  - Bold text toggle
  - Preview of subtitle appearance

### Audio Controls
- **Audio Track Selection**: Switch between available audio tracks
- **Audio Language**: Choose audio language

### Streaming Information
- **Network Speed Display**: Real-time bitrate/speed indicator
- **Buffering Status**: Visual feedback during buffering

### External Players
- **External Player Support**: Send video to third-party players
- **VLC Integration**: Play in VLC media player
- **Infuse Integration**: Play in Infuse player
- **System Share Sheet**: Additional player options via iOS share

---

## 6. Content Organization & Personalization

### Favorites
- **Add to Favorites**: Mark content as favorite (heart icon)
- **Remove from Favorites**: Unmark favorite content
- **Favorites Library**: Dedicated view for favorited movies
- **Favorites TV Shows**: Dedicated view for favorited TV shows
- **Favorites Indicator**: Visual indicator on content cards

### Watch History
- **Continue Watching**: Track partially-watched content
- **Watch Progress**: Visual progress bars on content thumbnails
- **Resume Points**: Automatic bookmarking of playback position
- **Mark as Watched**: Track completion status

### Recommendations
- **Related Content**: Show similar/related movies and shows
- **Personalized Suggestions**: Based on viewing history

---

## 7. Synchronization & Backup

### WebDAV Sync
- **WebDAV Configuration**: Set up WebDAV server connection
- **Sync Site Configuration**: Configure sync endpoints
- **Enable/Disable Sync**: Toggle sync feature on/off
- **Manual Sync**: Trigger sync on demand ("Start Sync" button)
- **Auto Sync on Launch**: Automatically sync when app opens
- **Sync Settings**: Manage what data syncs (watch history, favorites, etc.)

---

## 8. App Customization & Settings

### Appearance
- **Language Selection**: Change app interface language
- **Dark/Light Mode**: Toggle between color schemes
- **Theme Color**: Customize accent color
- **Font Size**: Adjust text size throughout app (with live preview)
- **Bold Text**: Enable bold fonts for subtitles and UI text

### Player Settings
- **Player Appearance**: Customize player interface
- **Gesture Configuration**: Enable/disable individual gestures
- **Skip Time Intervals**: Set custom forward/backward skip duration
- **Control Behavior**: Configure double-tap and long-press actions
- **Display Settings**: Configure playback screen behavior

### Cache Management
- **View Cache Size**: Display current image cache size
- **Clear Image Cache**: Free up storage by clearing cached images
- **Cache Statistics**: Show amount of storage used

### General Settings
- **Organized Settings Menu**: Categorized settings for easy navigation
- **Settings Search**: (Potential feature if needed)

---

## 9. App Information & Support

### About
- **App Version Display**: Show current version number
- **Update Check**: Manually check for app updates
- **Auto Update**: (Potentially handled by App Store)

### External Links & Resources
- **GitHub Repository**: Link to source code/issues
- **Telegram Channel**: Community support and updates
- **Dependencies List**: View open-source libraries used
- **FAQ/Help**: Access frequently asked questions
- **Third-party Client Label**: Clearly identify as unofficial Emby client

---

## 10. System Integration

### iOS Features
- **Background Playback**: Audio playback continues when app is backgrounded
- **Control Center Integration**: Media controls in iOS Control Center
- **Lock Screen Controls**: Playback controls on lock screen
- **AirPlay Support**: Stream to Apple TV and AirPlay devices (likely supported)
- **Picture-in-Picture**: Native iOS PiP mode
- **Handoff**: (Potential feature for continuity across devices)

### Notifications
- **Download Progress**: (If downloads are supported)
- **Server Connection Status**: (Potential feature)
- **New Content Alerts**: (Potential feature)

---

## 11. Performance & Quality

### Streaming Optimization
- **Adaptive Bitrate**: Automatically adjust quality based on network
- **Network Speed Monitoring**: Real-time display of streaming speed
- **Buffer Management**: Smooth playback with minimal buffering
- **Cache Strategy**: Intelligent image and metadata caching

### Offline Features
- **Image Caching**: Reduce bandwidth with persistent image cache
- **Metadata Caching**: Browse library without constant server requests
- **Resume Point Sync**: Maintain watch progress across sessions

---

## Feature Categories Summary

**Total Feature Domains**: 11 major functional areas

**Core Features** (Must Have):
- Server connection and management
- Content browsing (movies/TV shows)
- Video playback with standard controls
- Search functionality
- Favorites management

**Enhanced Features** (Differentiators):
- Advanced player gestures (double-tap, swipe controls)
- Customizable subtitle appearance
- External player integration
- WebDAV sync
- Extensive player customization

**Quality of Life**:
- Continue watching
- Multiple server support
- Cache management
- Dark/light mode
- Speed controls

---

## Design Considerations for New Architecture

### Feature Groupings to Consider
- Could "Continue Watching" be promoted to a primary navigation item?
- Should "Search" be more prominent (tab bar vs. nested)?
- Can server switching be more seamless (profile switcher)?
- Could favorites and watch history merge into "My Content"?
- Should settings be flattened or remain categorized?

### Features That Could Be Enhanced
- Social features (watch with friends, shared watchlists)
- Download for offline viewing
- Parental controls
- User profiles (if server supports)
- Smart recommendations engine
- Watch party / sync watch features

### Workflow Opportunities
- Onboarding flow for first-time server setup
- Quick actions (long-press on content cards)
- Contextual menus for faster navigation
- Unified media detail experience (movies + TV shows)
- In-player episode browsing without exiting playback

### Accessibility Features to Add
- VoiceOver optimization
- Dynamic Type support
- High contrast mode
- Reduced motion options
- Subtitle reading support
