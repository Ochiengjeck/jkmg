# JKMG Spiritual Ministry Mobile App - Additional API Endpoints

## Table of Contents
- [Overview](#overview)  
- [Authentication](#authentication)
- [Base URL & Headers](#base-url--headers)
- [Error Handling](#error-handling)
- [New Endpoints](#new-endpoints)
  - [Salvation Management](#salvation-management)
  - [Prayer Schedule](#prayer-schedule)
  - [Deeper Prayer](#deeper-prayer)
  - [Counseling Feedback](#counseling-feedback)
- [Prayer Request Categories Update](#prayer-request-categories-update)

## Overview

This document outlines additional API endpoints for the JKMG Spiritual Ministry mobile application, complementing the main API documentation. These endpoints provide enhanced functionality for salvation tracking, prayer management, and counseling feedback.

**API Version:** 1.0  
**Authentication:** Laravel Sanctum (Bearer Token)  
**Data Format:** JSON  

## Authentication

All endpoints marked with 🔒 require authentication. Include the Bearer token in the Authorization header.

### Headers for Authenticated Requests
```http
Authorization: Bearer {your_access_token}
Content-Type: application/json
Accept: application/json
```

## Base URL & Headers

**Base URL:** `{{base_url}}/api/`

**Required Headers:**
```http
Content-Type: application/json
Accept: application/json
```

## Error Handling

### HTTP Status Codes
- `200` - Success
- `201` - Created  
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `422` - Validation Error
- `500` - Server Error

### Error Response Format
```json
{
  "message": "Error description",
  "errors": {
    "field_name": ["Validation error message"]
  }
}
```

---

# New Endpoints

## Salvation Management

### Record Salvation Decision
**POST** `/salvation` 🔒

Record a salvation or rededication decision with detailed information.

**Parameters:**
```json
{
  "type": "salvation",
  "full_name": "John Doe Smith",
  "email": "john.doe@example.com",
  "phone": "+1234567890",
  "reason": "I felt the Holy Spirit calling me during the service"
}
```

**Required Fields:** `type`, `full_name`  
**Optional Fields:** `email`, `phone`, `reason`

**Type Options:** `salvation`, `rededication`

**Response (201):**
```json
{
  "success": true,
  "message": "Salvation decision recorded successfully. Welcome to the Kingdom of God!",
  "decision": {
    "decision_id": "550e8400-e29b-41d4-a716-446655440000",
    "decision_type": "salvation",
    "full_name": "John Doe Smith",
    "email": "john.doe@example.com", 
    "phone": "+1234567890",
    "reason": "I felt the Holy Spirit calling me during the service",
    "submitted_at": "2025-08-14T10:30:00.000000Z"
  },
  "audio_url": "https://storage.example.com/salvation/welcome-message.mp3"
}
```

**Response (422) - Validation Error:**
```json
{
  "message": "The given data was invalid",
  "errors": {
    "type": ["The type field is required"],
    "full_name": ["The full name field is required"],
    "email": ["The email must be a valid email address"]
  }
}
```

---

## Prayer Schedule

### Get Prayer Schedule
**GET** `/prayers/schedule` 🔒

Retrieve the current prayer schedule with audio content for the active time slot.

**Response (200):**
```json
{
  "success": true,
  "data": {
    "current_slot": {
      "time_slot": "evening",
      "display_name": "Evening Prayer (6:00 PM)",
      "audio_url": "https://storage.example.com/prayers/evening-prayer-guide.mp3",
      "message": "Join us for evening prayer. Take time to thank God for the day's blessings.",
      "scripture": "Psalm 141:2 - Let my prayer be set before you as incense, the lifting up of my hands as the evening sacrifice.",
      "duration_minutes": 15
    },
    "next_slot": {
      "time_slot": "morning", 
      "display_name": "Morning Prayer (6:00 AM)",
      "scheduled_at": "2025-08-15T06:00:00.000000Z"
    },
    "user_timezone": "Africa/Nairobi",
    "prayer_times": ["06:00", "12:00", "18:00"]
  },
  "time_slot": "evening",
  "audio_url": "https://storage.example.com/prayers/evening-prayer-guide.mp3",
  "message": "Join us for evening prayer. Take time to thank God for the day's blessings."
}
```

**Time Slot Options:** `morning`, `noon`, `evening`

**Response (404) - No Active Schedule:**
```json
{
  "success": false,
  "message": "No prayer schedule available at this time",
  "data": {
    "next_slot": {
      "time_slot": "morning",
      "display_name": "Morning Prayer (6:00 AM)", 
      "scheduled_at": "2025-08-15T06:00:00.000000Z"
    }
  }
}
```

---

## Deeper Prayer

### Record Deeper Prayer Participation
**POST** `/prayers/deeper` 🔒

Record participation in a deeper prayer session with specified duration.

**Parameters:**
```json
{
  "user_id": "12345",
  "duration": "30min"
}
```

**Required Fields:** `user_id`, `duration`  
**Duration Options:** `30min`, `60min`

**Response (201):**
```json
{
  "success": true,
  "message": "Deeper prayer participation recorded successfully",
  "participation": {
    "id": "uuid-participation-123",
    "user_id": "12345",
    "date": "2025-08-14",
    "duration": "30min",
    "duration_minutes": 30,
    "completed": true,
    "completed_at": "2025-08-14T23:30:00.000000Z",
    "audio_url": "https://storage.example.com/prayers/deeper-prayer-30min.mp3"
  },
  "audio_url": "https://storage.example.com/prayers/deeper-prayer-30min.mp3",
  "message": "Thank you for joining deeper prayer. Your participation has been recorded."
}
```

**Response (422) - Validation Error:**
```json
{
  "message": "The given data was invalid", 
  "errors": {
    "user_id": ["The user id field is required"],
    "duration": ["The duration field must be either 30min or 60min"]
  }
}
```

**Response (409) - Already Participated:**
```json
{
  "success": false,
  "message": "You have already participated in deeper prayer today",
  "participation": {
    "id": "uuid-participation-123",
    "date": "2025-08-14",
    "duration": "60min",
    "completed_at": "2025-08-14T01:00:00.000000Z"
  }
}
```

---

## Counseling Feedback

### Submit Counseling Feedback
**POST** `/counseling/feedback` 🔒

Submit feedback about counseling services and experience.

**Parameters:**
```json
{
  "user_id": "12345",
  "session_id": "uuid-session-456",
  "rating": "5",
  "experience": "The counselor was very understanding and provided excellent biblical guidance. I felt heard and supported throughout the session.",
  "suggestion": "Perhaps extend session times to 90 minutes for more in-depth discussions.",
  "counselor_id": "counselor-789",
  "would_recommend": true
}
```

**Required Fields:** `user_id`, `rating`, `experience`  
**Optional Fields:** `session_id`, `suggestion`, `counselor_id`, `would_recommend`

**Rating Options:** `1`, `2`, `3`, `4`, `5` (string format)

**Response (201):**
```json
{
  "success": true,
  "message": "Thank you for your feedback. Your input helps us improve our counseling services.",
  "feedback": {
    "id": "uuid-feedback-123",
    "user_id": "12345", 
    "session_id": "uuid-session-456",
    "rating": "5",
    "rating_numeric": 5,
    "experience": "The counselor was very understanding and provided excellent biblical guidance. I felt heard and supported throughout the session.",
    "suggestion": "Perhaps extend session times to 90 minutes for more in-depth discussions.",
    "counselor_id": "counselor-789",
    "would_recommend": true,
    "status": "submitted",
    "submitted_at": "2025-08-14T14:30:00.000000Z"
  },
  "reference_id": "CF-000123"
}
```

**Response (422) - Validation Error:**
```json
{
  "message": "The given data was invalid",
  "errors": {
    "rating": ["The rating field is required and must be between 1 and 5"],
    "experience": ["The experience field is required and must be at least 10 characters"]
  }
}
```

---

## Prayer Request Categories Update

### Available Prayer Categories

The prayer request system now supports additional categories. Here are all available options:

**Updated Categories:**
- `healing` - Physical, emotional, or spiritual healing
- `marriage` - Marriage and relationship guidance  
- `protection` - Safety and divine protection
- `financial` - Financial breakthrough and provision
- `family` - Family unity and relationships
- `career` - Professional growth and direction
- `salvation` - Salvation of loved ones
- `guidance` - Divine direction and wisdom
- `thanksgiving` - Gratitude and praise
- `praise` - **NEW** - Expressions of worship and adoration
- `mercy` - **NEW** - Seeking God's mercy and forgiveness
- `other` - Other prayer requests

### Create Prayer Request (Updated)
**POST** `/prayers/request` 🔒

Create a new prayer request with expanded category options.

**Parameters:**
```json
{
  "category": "praise",
  "start_date": "2025-08-14",
  "end_date": "2025-08-21", 
  "description": "Praising God for His faithfulness and provision in my life"
}
```

**Available Categories:** `healing`, `marriage`, `protection`, `financial`, `family`, `career`, `salvation`, `guidance`, `thanksgiving`, `praise`, `mercy`, `other`

**Response (201):**
```json
{
  "message": "Prayer request created successfully",
  "prayer_request": {
    "id": 15,
    "category": {
      "value": "praise",
      "label": "Praise & Worship"
    },
    "start_date": "2025-08-14",
    "end_date": "2025-08-21",
    "description": "Praising God for His faithfulness and provision in my life",
    "completed": false,
    "days_remaining": 7,
    "is_active": true,
    "created_at": "2025-08-14T10:30:00.000000Z",
    "updated_at": "2025-08-14T10:30:00.000000Z"
  }
}
```

---

## Common Response Patterns

### Success Response Format
```json
{
  "success": true,
  "message": "Operation completed successfully",
  "data": {
    // Response data
  }
}
```

### Error Response Format
```json
{
  "success": false,
  "message": "Error description",
  "errors": {
    "field_name": ["Validation error message"]
  }
}
```

## Rate Limiting

These endpoints follow the same rate limiting as other API endpoints:
- **General endpoints**: 60 requests per minute
- **Prayer endpoints**: 30 requests per minute (to prevent spam)
- **Feedback endpoints**: 10 requests per minute

## Notes for Developers

1. **Salvation Decisions**: Store locally until successful submission to prevent data loss
2. **Prayer Schedule**: Cache current schedule and refresh based on time slots
3. **Deeper Prayer**: Implement participation validation to prevent duplicate entries
4. **Feedback**: Provide rich feedback forms with appropriate validation
5. **Categories**: Update prayer category selection UI with new options
6. **Audio Integration**: Handle audio URLs with appropriate streaming/download logic

## Security Considerations

1. **User ID Validation**: Always validate that user_id matches authenticated user
2. **Input Sanitization**: Sanitize all text inputs, especially testimonial content
3. **Rate Limiting**: Respect API rate limits to prevent service disruption
4. **Data Privacy**: Handle personal information (phone, email) according to privacy policies
5. **Session Management**: Ensure proper session handling for counseling feedback

---

**Last Updated**: August 14, 2025  
**API Version**: 1.0  
**Documentation Version**: 1.2  

For additional API endpoints, refer to the main [API Documentation](docs/ApiDocumentation.md).