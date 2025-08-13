# API Updates for JKMG App

## Overview
This document outlines the required API updates for the JKMG app based on the requirements from the PDF update document, including authentication improvements and salvation corner functionality.

## Authentication API Updates

### 1. Enhanced Login Endpoint
**Endpoint:** `POST /api/auth/login`

**Description:** Updated to support both email and phone number authentication

**Request Body:**
```json
{
  "email": "string (optional - use either email or phone)",
  "phone": "string (optional - use either email or phone)", 
  "password": "string"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "name": "string",
      "email": "string",
      "phone": "string",
      "country": "string",
      "timezone": "string",
      "prayer_times": ["array of times"], 
      "created_at": "datetime"
    },
    "token": "jwt_token",
    "refresh_token": "refresh_token"
  }
}
```

### 2. Forgot Password Endpoint
**Endpoint:** `POST /api/auth/forgot-password`

**Description:** Sends password reset email with functional email delivery

**Request Body:**
```json
{
  "email": "string"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Password reset link sent to your email"
}
```

### 3. Enhanced Registration Endpoint
**Endpoint:** `POST /api/auth/register`

**Description:** Updated signup with comprehensive country/timezone options and standardized prayer times

**Request Body:**
```json
{
  "name": "string",
  "phone": "string",
  "email": "string (optional)",
  "country": "string (from comprehensive list)",
  "timezone": "string (from comprehensive list)",
  "password": "string",
  "password_confirmation": "string",
  "prayer_times": ["06:00", "12:00", "18:00", "00:00"] // Optional, standardized times
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "name": "string",
      "email": "string",
      "phone": "string",
      "country": "string",
      "timezone": "string",
      "prayer_times": ["array of times"],
      "created_at": "datetime"
    },
    "token": "jwt_token",
    "refresh_token": "refresh_token"
  }
}
```

### 4. Session Management Endpoints

#### Refresh Token
**Endpoint:** `POST /api/auth/refresh`

**Request Body:**
```json
{
  "refresh_token": "string"
}
```

#### Logout
**Endpoint:** `POST /api/auth/logout`

**Request Body:**
```json
{
  "refresh_token": "string"
}
```

#### Check Session
**Endpoint:** `GET /api/auth/me`

**Headers:**
```
Authorization: Bearer {token}
```

## Country and Timezone Data

### Countries List
The API should provide a comprehensive list of 195+ countries including:
- Afghanistan, Albania, Algeria, Andorra, Angola, Argentina, Armenia, Australia...
- [Complete alphabetical list as implemented in signup screen]

### Timezone List
The API should support all 24+ major timezones:
- UTC-12:00 (Baker Island) through UTC+14:00 (Line Islands)
- Including half-hour and quarter-hour offsets
- [Complete list as implemented in signup screen]

## Prayer Time Standardization

### Updated Prayer Times
The system now uses standardized prayer times:
- **06:00** - 6 AM (Morning Prayer)
- **12:00** - 12 PM (Midday Prayer) 
- **18:00** - 6 PM (Evening Prayer)
- **00:00** - 12 AM (Deep in Prayer)

These replace the previous "Preferred Prayer Times" concept with fixed, universal prayer times for all users.

## Salvation Corner API Endpoints

### 1. Submit Salvation Decision
**Endpoint:** `POST /api/salvation/decisions`

**Description:** Records a user's salvation decision (Give Life to Christ, Rededicate Life to Christ, or Testimony)

**Request Body:**
```json
{
  "type": "give_life_to_christ" | "rededicate_life_to_christ" | "testimony",
  "name": "string",
  "email": "string",
  "phone": "string (optional for testimony)",
  "reason": "string (for salvation decisions)",
  "testimony": "string (for testimonies only)"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Decision recorded successfully",
  "data": {
    "id": "uuid",
    "type": "string",
    "submitted_at": "datetime",
    "notification_sent": true
  }
}
```

### 2. Get Testimonies
**Endpoint:** `GET /api/salvation/testimonies`

**Description:** Retrieves approved testimonies for display in the testimony slides

**Query Parameters:**
- `limit` (optional): Number of testimonies to return (default: 10)
- `offset` (optional): Pagination offset (default: 0)

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "name": "string",
      "testimony": "string",
      "submitted_at": "datetime",
      "approved": true
    }
  ],
  "total": "number",
  "limit": "number",
  "offset": "number"
}
```

## Notification System API Endpoints

### 3. Send Audio Prayer Notification
**Endpoint:** `POST /api/notifications/audio-prayer`

**Description:** Sends an automated audio prayer notification to the user after salvation decisions

**Request Body:**
```json
{
  "user_id": "uuid",
  "decision_id": "uuid",
  "decision_type": "give_life_to_christ" | "rededicate_life_to_christ",
  "audio_url": "string",
  "message": "string"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Audio prayer notification sent",
  "notification_id": "uuid"
}
```

### 4. Get User Notifications
**Endpoint:** `GET /api/notifications/user/{user_id}`

**Description:** Retrieves all notifications for a specific user

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "type": "audio_prayer",
      "title": "Prayer from Rev Julian Kyula",
      "message": "string",
      "audio_url": "string",
      "read": false,
      "created_at": "datetime",
      "expires_at": "datetime"
    }
  ]
}
```

### 5. Mark Notification as Read
**Endpoint:** `PUT /api/notifications/{notification_id}/read`

**Description:** Marks a notification as read

**Response:**
```json
{
  "success": true,
  "message": "Notification marked as read"
}
```

## Additional Requirements

### Audio Prayer Content
The system should include pre-recorded audio prayers from Rev Julian Kyula for:
1. **Give Life to Christ** - Welcome to the family prayer
2. **Rededicate Life to Christ** - Renewal and restoration prayer

### Notification Expiry
- Audio prayer notifications should be automatically deleted after 24 hours
- Implement a background job to clean up expired notifications

### Admin Panel Requirements
An admin interface should be created to:
1. Manage testimony approvals
2. Upload and manage audio prayer files
3. View salvation decision statistics
4. Send custom notifications

### Database Schema Updates

#### Salvation Decisions Table
```sql
CREATE TABLE salvation_decisions (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  type VARCHAR(50) NOT NULL,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  phone VARCHAR(20),
  reason TEXT,
  testimony TEXT,
  approved BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

#### Notifications Table
```sql
CREATE TABLE notifications (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  type VARCHAR(50) NOT NULL,
  title VARCHAR(255) NOT NULL,
  message TEXT,
  audio_url VARCHAR(500),
  read BOOLEAN DEFAULT FALSE,
  expires_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

## Implementation Notes

### Authentication Updates
1. **Session Persistence:** Implement secure session storage to prevent automatic logout when navigating to home
2. **Email Service:** Configure reliable email service (SendGrid, AWS SES, etc.) for password reset functionality
3. **Token Management:** Implement refresh token rotation for enhanced security
4. **Country/Timezone Data:** Consider caching country and timezone lists for better performance

### Prayer Time Updates
1. **Migration:** Update existing user prayer preferences to new standardized times
2. **Notifications:** Update notification scheduling to use new time format
3. **Timezone Handling:** Ensure prayer times are properly adjusted for user timezones

### Salvation Corner Updates
1. **Audio File Storage:** Audio prayers should be stored in a CDN or cloud storage service for optimal performance
2. **Push Notifications:** Integrate with Firebase Cloud Messaging for real-time notifications
3. **Email Integration:** Send confirmation emails after salvation decisions
4. **Analytics:** Track conversion rates and user engagement with salvation content
5. **Security:** Implement rate limiting to prevent spam submissions
6. **Validation:** Ensure proper email format validation and content moderation for testimonies

## Testing Requirements

### Authentication Testing
1. **Login Testing:** Test both email and phone number login flows
2. **Session Testing:** Verify users remain logged in across app restarts
3. **Password Reset:** Test complete email delivery and reset flow
4. **Registration Testing:** Verify all country/timezone combinations work

### Integration Testing
1. **Complete Auth Flow:** Test registration → login → session persistence
2. **Salvation Flow:** Test form submission to notification delivery
3. **Cross-platform:** Ensure consistent behavior across devices

### Security Testing
1. **Input Validation:** Test email/phone format validation
2. **Rate Limiting:** Verify protection against spam and abuse
3. **Token Security:** Test JWT expiration and refresh mechanisms

## Migration Plan

1. **Phase 1:** Deploy enhanced authentication endpoints
2. **Phase 2:** Update mobile app authentication screens
3. **Phase 3:** Migrate existing user data to support email login
4. **Phase 4:** Deploy salvation corner updates
5. **Phase 5:** Update prayer time standardization
6. **Phase 6:** Decommission old endpoints after successful migration

## Database Schema Updates

### Users Table Updates
```sql
ALTER TABLE users 
ADD COLUMN email VARCHAR(255) UNIQUE,
ADD COLUMN login_type ENUM('phone', 'email', 'both') DEFAULT 'phone',
ADD COLUMN email_verified_at TIMESTAMP NULL,
MODIFY COLUMN prayer_times JSON; -- Update to new standardized times
```

### Password Reset Tokens Table
```sql
CREATE TABLE password_reset_tokens (
  email VARCHAR(255) PRIMARY KEY,
  token VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  INDEX idx_token (token),
  INDEX idx_created_at (created_at)
);
```

This comprehensive API update addresses all authentication requirements from the PDF specifications while maintaining security and user experience standards.