# Themby App - Screen Inventory & Design Summary

## Overview
Themby is a third-party Emby media client for iOS, focused on streaming movies and TV shows from Emby media servers. The app follows iOS design patterns with bottom tab navigation and standard list/grid layouts.

---

## Screen Inventory

### 1. Server Connection Screen (16.png)
**Purpose**: Manage Emby server connections
- Search bar for finding servers
- List of saved servers with icons, names, and usernames
- Options menu (three dots) for each server
- Add button (floating action button) to connect new servers
- Quick scan icon in top-right toolbar

---

### 2. Home Screen (14.png)
**Purpose**: Main landing page showing personalized content
- Hero backdrop image with gradient overlay
- **Continue Watching** section with horizontal carousel of partially-watched content
- **Media Library** section with category cards:
  - Movies (电影 The movies)
  - TV Shows (电视剧 The TV play)
- Bottom navigation: Library | Favorite (with active state indicator)

---

### 3. Library Screen - Movies (2.png)
**Purpose**: Browse movie collection
- Horizontal filter tabs: all | recent | collection | genre | tag | favorite
- Grid layout showing movie posters with play overlay icons
- Movie titles displayed below posters
- Bottom navigation: Library (active) | Favorite

---

### 4. Search Screen (15.png)
**Purpose**: Search and discover movies/TV shows
- Search bar with clear (X) and search icons
- Search history/suggestions displayed as pill-shaped chips in a flow layout
- Shows previously searched titles
- Bottom navigation: Library | Favorite

---

### 5. Movie Detail Screen (6.png, 13.png)
**Purpose**: Display comprehensive movie/show information
- Full-width backdrop image with gradient overlay
- Movie title overlaid on backdrop
- Rating badge (e.g., 8.8), content rating (TV-MA), year, duration
- Synopsis/description text
- Genre tags
- **Related Recommendations** section with horizontal scrolling thumbnails
- **Cast** section with actor photos, names, and character names
- Subtitle and audio track information
- Primary "Play" button (blue, full-width) at bottom
- Top-right icons: Done/Check, Favorite heart, Share

---

### 6. Episode List Screen (9.png)
**Purpose**: Browse episodes for TV series
- Hero backdrop at top
- Vertical list of episodes, each showing:
  - Episode thumbnail
  - Episode number and title
  - Duration
  - Brief description/synopsis
- Breadcrumb navigation shows series title

---

### 7. External Player Selection Dialog (12.png)
**Purpose**: Choose playback method
- Modal dialog overlaying movie detail
- Title: "外部播放器" (External Player)
- Grid of player options with icons:
  - VLC
  - Infuse
  - More options (...)
- Appears when user initiates playback

---

### 8. Video Player (10.jpg)
**Purpose**: Full-screen video playback
- Landscape orientation
- Video content fills screen
- **Top bar** (appears on tap):
  - Back button
  - Movie title
  - Network speed indicator (e.g., 7.86Mbps)
  - Picture-in-Picture toggle
  - Audio/subtitle track selector
  - Aspect ratio/screen mode toggle
- **Bottom controls** (appears on tap):
  - Progress bar with current/total time (1:03:29 / 3:00:22)
  - Previous episode button
  - Play/Pause button
  - Next episode button
  - Episode selector button ("选集")
  - Playback speed (1.0x)
- Lock icon on right side

---

### 9. Favorites Screen (11.png)
**Purpose**: Access user's favorited content
- Section header: "喜欢的电影" (Favorite Movies) with chevron
- Grid layout showing favorited items with posters
- Empty state illustration (mailbox graphic) when no additional favorites
- Bottom navigation: Library | Favorite (active)

---

### 10. Settings Screen (8.png)
**Purpose**: Main settings hub
- List of settings categories with icons:
  - **Appearance** (外观) - Language, dark mode, theme color
  - **Player** (播放器) - Player appearance, gestures, controls
  - **Subtitle Appearance** (字幕外观) - Playback options
  - **Cache** (缓存) - Image cache management
  - **Sync** (同步) - WebDAV, sync settings
  - **About** (关于) - About, thanks

---

### 11. Appearance Settings (Not shown but referenced in 8.png)
**Purpose**: Customize visual theme
- Language selection
- Dark/light mode toggle
- Theme color picker

---

### 12. Player Settings (7.png)
**Purpose**: Configure video player behavior
- **Gesture Controls** section:
  - Positioning Gestures toggle - horizontal swipe adjusts playback position
  - Swipe Gestures toggle - vertical swipe adjusts volume/brightness
  - Double-tap Pause toggle - double-tap middle to pause
  - Double-tap Skip toggle - double-tap sides to skip
- **Skip Time sliders**:
  - Fast forward time (10 seconds)
  - Rewind time (10 seconds)
- Long Press Speed Up toggle - hold screen to speed up playback
- **Display** section below (partially visible)

---

### 13. Subtitle Appearance Settings (4.png)
**Purpose**: Customize subtitle display
- Preview box showing sample subtitle text
- **Font Size** slider (current: 16)
- **Bold Subtitles** toggle - enable/disable bold font

---

### 14. Cache Management (5.png)
**Purpose**: Clear app cache to free storage
- "Clear Image Cache" button showing cache size (51.13 MB)

---

### 15. Sync Settings (1.png)
**Purpose**: Configure WebDAV synchronization
- Section header: "webdav 配置" (WebDAV Configuration)
- **Enable Site Sync** toggle - activates WebDAV sync
- **WebDAV Configuration** button - opens config form
- **Auto Sync** toggle - sync automatically on app launch
- Primary "Start Sync" button (blue, full-width)

---

### 16. About Screen (3.png)
**Purpose**: App information and external links
- App logo (Themby - blue/green gradient play icon)
- App name and version (1.0.5)
- List of action buttons:
  - Check for Updates (with refresh icon)
  - Github (with star icon)
  - Telegram Channel (with telegram icon)
  - Dependencies (with shield icon)
  - FAQ (with info icon)
- Footer text: "第三方emby客户端" (Third-party Emby client)

---

## Key Design Patterns

### Navigation Structure
- **Bottom Tab Navigation**: Primary navigation between Library and Favorites
- **Stack Navigation**: Detail screens push onto navigation stack with back button
- **Modal Dialogs**: Settings and player selection presented as modals

### Visual Hierarchy
- Large backdrop images create visual interest
- Content organized in clear sections with headers
- White/light background with dark text (light mode shown)
- Accent color: Blue for primary actions

### Content Layout
- Horizontal carousels for browsing (Continue Watching, Recommendations)
- Grid layouts for library browsing (2-column portrait)
- Vertical lists for episodes and settings
- Full-bleed images for movie details

### Interactive Elements
- Toggle switches for settings
- Sliders for adjustable values
- Icon buttons in toolbars
- Full-width primary action buttons
- Pill-shaped chips for filters/tags

---

## Design Notes for New Interface

### Maintain These Elements
- Bottom tab navigation structure
- Server connection workflow as entry point
- Movie/TV detail screen information architecture
- Video player controls layout (standard and effective)
- Settings categorization

### Opportunities for Enhancement
- More sophisticated typography hierarchy
- Richer color palette and theming
- Enhanced empty states
- More engaging loading states
- Refined spacing and padding throughout
- Modern card designs for media items
- Improved iconography system
