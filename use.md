# Bible API Documentation

## Overview
This document describes the Bible API available at https://bible.helloao.org/api/ which provides access to Bible translations, commentaries, and related content.

## Base URL
```
https://bible.helloao.org/api/
```

## Authentication
No authentication is required for this API.

## Endpoints

### 1. Available Translations
Get a list of all available Bible translations.

**Endpoint:** `/available_translations.json`
**Method:** `GET`
**Description:** Returns a list of Bible translations with detailed metadata

**Example Request:**
```
GET https://bible.helloao.org/api/available_translations.json
```

**Response:** List of translation objects with metadata including:
- Translation ID
- Full name
- Language
- Copyright information
- Available books

---

### 2. Books in Translation
Get all books available in a specific translation.

**Endpoint:** `/{translation}/books.json`
**Method:** `GET`
**Parameters:**
- `translation` (path parameter): Translation ID (e.g., 'BSB', 'KJV', 'NIV')

**Example Request:**
```
GET https://bible.helloao.org/api/BSB/books.json
```

**Response:** List of book objects containing:
- Book ID (e.g., 'GEN', 'EXO', 'MAT')
- Book name
- Testament (Old/New)
- Chapter count

---

### 3. Chapter Content
Get the complete content of a specific chapter.

**Endpoint:** `/{translation}/{book}/{chapter}.json`
**Method:** `GET`
**Parameters:**
- `translation` (path parameter): Translation ID
- `book` (path parameter): Book ID (e.g., 'GEN', 'PSA', 'JOH')
- `chapter` (path parameter): Chapter number

**Example Request:**
```
GET https://bible.helloao.org/api/BSB/GEN/1.json
```

**Response:** Chapter object containing:
- Chapter metadata
- Verses with text and verse numbers
- Formatting information
- Cross-references (if available)

---

### 4. Available Commentaries
Get a list of all available Bible commentaries.

**Endpoint:** `/available_commentaries.json`
**Method:** `GET`
**Description:** Returns a list of Bible commentaries with metadata

**Example Request:**
```
GET https://bible.helloao.org/api/available_commentaries.json
```

**Response:** List of commentary objects with:
- Commentary ID
- Commentary name
- Author information
- Available books

---

### 5. Commentary Books
Get books covered in a specific commentary.

**Endpoint:** `/c/{commentary}/books.json`
**Method:** `GET`
**Parameters:**
- `commentary` (path parameter): Commentary ID

**Example Request:**
```
GET https://bible.helloao.org/api/c/mhc/books.json
```

**Response:** List of books covered in the commentary

---

### 6. Commentary Chapter
Get commentary content for a specific chapter.

**Endpoint:** `/c/{commentary}/{book}/{chapter}.json`
**Method:** `GET`
**Parameters:**
- `commentary` (path parameter): Commentary ID
- `book` (path parameter): Book ID
- `chapter` (path parameter): Chapter number

**Example Request:**
```
GET https://bible.helloao.org/api/c/mhc/GEN/1.json
```

**Response:** Commentary content for the specified chapter

---

### 7. Commentary Profiles
Get available profiles for a commentary.

**Endpoint:** `/c/{commentary}/profiles.json`
**Method:** `GET`
**Parameters:**
- `commentary` (path parameter): Commentary ID

**Example Request:**
```
GET https://bible.helloao.org/api/c/mhc/profiles.json
```

**Response:** List of available profiles

---

### 8. Specific Commentary Profile
Get detailed content for a specific commentary profile.

**Endpoint:** `/c/{commentary}/profiles/{profile}.json`
**Method:** `GET`
**Parameters:**
- `commentary` (path parameter): Commentary ID
- `profile` (path parameter): Profile ID

**Example Request:**
```
GET https://bible.helloao.org/api/c/mhc/profiles/noah.json
```

**Response:** Detailed profile content

---

## Common Book IDs
Here are some common book abbreviations used in the API:

### Old Testament
- `GEN` - Genesis
- `EXO` - Exodus
- `LEV` - Leviticus
- `NUM` - Numbers
- `DEU` - Deuteronomy
- `JOS` - Joshua
- `JDG` - Judges
- `RUT` - Ruth
- `1SA` - 1 Samuel
- `2SA` - 2 Samuel
- `1KI` - 1 Kings
- `2KI` - 2 Kings
- `1CH` - 1 Chronicles
- `2CH` - 2 Chronicles
- `EZR` - Ezra
- `NEH` - Nehemiah
- `EST` - Esther
- `JOB` - Job
- `PSA` - Psalms
- `PRO` - Proverbs
- `ECC` - Ecclesiastes
- `SNG` - Song of Songs
- `ISA` - Isaiah
- `JER` - Jeremiah
- `LAM` - Lamentations
- `EZK` - Ezekiel
- `DAN` - Daniel
- `HOS` - Hosea
- `JOL` - Joel
- `AMO` - Amos
- `OBA` - Obadiah
- `JON` - Jonah
- `MIC` - Micah
- `NAM` - Nahum
- `HAB` - Habakkuk
- `ZEP` - Zephaniah
- `HAG` - Haggai
- `ZEC` - Zechariah
- `MAL` - Malachi

### New Testament
- `MAT` - Matthew
- `MRK` - Mark
- `LUK` - Luke
- `JOH` - John
- `ACT` - Acts
- `ROM` - Romans
- `1CO` - 1 Corinthians
- `2CO` - 2 Corinthians
- `GAL` - Galatians
- `EPH` - Ephesians
- `PHP` - Philippians
- `COL` - Colossians
- `1TH` - 1 Thessalonians
- `2TH` - 2 Thessalonians
- `1TI` - 1 Timothy
- `2TI` - 2 Timothy
- `TIT` - Titus
- `PHM` - Philemon
- `HEB` - Hebrews
- `JAS` - James
- `1PE` - 1 Peter
- `2PE` - 2 Peter
- `1JO` - 1 John
- `2JO` - 2 John
- `3JO` - 3 John
- `JUD` - Jude
- `REV` - Revelation

## Example Usage

### Get Genesis Chapter 1 from BSB Translation
```bash
curl "https://bible.helloao.org/api/BSB/GEN/1.json"
```

### Get all books in KJV translation
```bash
curl "https://bible.helloao.org/api/KJV/books.json"
```

### Get Matthew Henry's Commentary on Genesis 1
```bash
curl "https://bible.helloao.org/api/c/mhc/GEN/1.json"
```

## Response Format
All responses are in JSON format. The structure varies by endpoint but generally includes:
- Metadata about the requested content
- The actual content (verses, commentary text, etc.)
- Additional reference information where applicable

## Rate Limiting
No specific rate limiting information is provided in the documentation. Use responsibly to avoid overwhelming the service.

## CORS
The API appears to support CORS requests, making it suitable for web applications.

## Error Handling
The API returns appropriate HTTP status codes:
- `200` - Success
- `404` - Resource not found
- Other standard HTTP error codes as applicable

## Notes
- All content is provided in JSON format
- The API is free to use with no authentication required
- Multiple translations and commentaries are available
- The service provides both biblical text and scholarly commentary
- Suitable for integration into Bible study applications, websites, and mobile apps

---

# JKMG Prayer API Endpoints

## Overview
These are additional API endpoints for the JKMG prayer system that provide scheduled prayers functionality.

## Endpoints

### 1. Get Scheduled Prayer (Current)
Get the current scheduled prayer based on time.

**Endpoint:** `GET {{base_url}}/prayers/scheduled`
**Method:** `GET`
**Description:** Returns the current scheduled prayer with timing information

**Example Request:**
```
GET {{base_url}}/prayers/scheduled
```

**Response:**
```json
{
    "prayer": {
        "id": 3,
        "title": "Morning prayers",
        "message": "Heavenly Father, I thank You for the gift of a new day...",
        "audio_url": "https://908f9000d297c0a39a4080c541c245c2.r2.cloudflarestorage.com/...",
        "status": "active",
        "pastor": {
            "id": 2,
            "name": "Sarah Johnson"
        },
        "prayed_at": "2025-08-04T13:10:19.000000Z",
        "created_at": "2025-08-05T13:10:19.000000Z"
    },
    "current_time": "13:23",
    "closest_prayer_time": "12:00",
    "timezone": "Africa/Nairobi",
    "next_prayer_times": [
        "05:30",
        "12:00",
        "18:30"
    ],
    "message": "Prayer for your schedule retrieved successfully"
}
```

**Response Fields:**
- `prayer`: Prayer object with details
- `current_time`: Current time in HH:MM format
- `closest_prayer_time`: The prayer time closest to current time
- `timezone`: Current timezone
- `next_prayer_times`: Array of upcoming prayer times
- `message`: Status message

---

### 2. Get Specific Scheduled Prayer
Get a specific scheduled prayer by ID.

**Endpoint:** `GET {{base_url}}/prayers/scheduled?prayer_id={id}`
**Method:** `GET`
**Parameters:**
- `prayer_id` (query parameter): Prayer ID to retrieve

**Example Request:**
```
GET {{base_url}}/prayers/scheduled?prayer_id=3
```

**Response:**
```json
{
    "prayer": {
        "id": 3,
        "title": "Morning prayers",
        "message": "Heavenly Father, I thank You for the gift of a new day...",
        "audio_url": "https://908f9000d297c0a39a4080c541c245c2.r2.cloudflarestorage.com/...",
        "status": "active",
        "pastor": {
            "id": 2,
            "name": "Sarah Johnson"
        },
        "prayed_at": "2025-08-04T13:10:19.000000Z",
        "created_at": "2025-08-05T13:10:19.000000Z"
    },
    "message": "Prayer retrieved successfully"
}
```

**Prayer Object Fields:**
- `id`: Unique prayer identifier
- `title`: Prayer title
- `message`: Full prayer text content
- `audio_url`: URL to audio file of the prayer
- `status`: Prayer status (active/inactive)
- `pastor`: Pastor information object with id and name
- `prayed_at`: Timestamp when prayer was recorded
- `created_at`: Timestamp when prayer was created

## Integration Requirements
These endpoints should be integrated into:
- `lib/services`: Create prayer service classes
- `lib/screens/prayer`: Prayer screen implementations

## Usage Notes
- Audio URLs are signed and temporary
- Times are provided in 24-hour format
- Timezone is Africa/Nairobi
- Prayer times follow a schedule (05:30, 12:00, 18:30)

