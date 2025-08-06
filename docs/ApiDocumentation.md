# JKMG Spiritual Ministry Mobile App - API Documentation

## Table of Contents
- [Overview](#overview)
- [Authentication](#authentication)
- [Base URL & Headers](#base-url--headers)
- [Error Handling](#error-handling)
- [Endpoints](#endpoints)
  - [Authentication](#authentication-endpoints)
  - [User Management](#user-management)
  - [Prayer System](#prayer-system)
  - [Bible Studies](#bible-studies)
  - [Events](#events)
  - [Resources](#resources)
  - [Testimonies](#testimonies)
  - [Donations](#donations)
  - [Counseling](#counseling)
  - [Salvation](#salvation)
  - [Notifications](#notifications)
  - [Feedback](#feedback)

## Overview

This API provides backend services for the JKMG Spiritual Ministry mobile application. It supports user authentication, prayer requests, Bible studies, event management, donations, and more.

**API Version:** 1.0  
**Authentication:** Laravel Sanctum (Bearer Token)  
**Data Format:** JSON  

## Authentication

The API uses Laravel Sanctum for authentication with Bearer tokens.

### Authentication Flow
1. Register or login to receive an access token
2. Include the token in all subsequent requests
3. Token remains valid until logout or expiration

### Headers for Authenticated Requests
```http
Authorization: Bearer {your_access_token}
Content-Type: application/json
Accept: application/json
```

## Base URL & Headers

**Base URL:** `https://your-domain.com/api/`

**Required Headers:**
```http
Content-Type: application/json
Accept: application/json
```

## Error Handling

### HTTP Status Codes
- `200` - Success
- `201` - Created
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

# Endpoints

## Authentication Endpoints

### Register User
**POST** `/register`

Register a new user account.

**Parameters:**
```json
{
  "name": "John Doe",
  "phone": "+1234567890",
  "email": "john@example.com",
  "country": "Kenya",
  "password": "password123",
  "password_confirmation": "password123",
  "timezone": "Africa/Nairobi",
  "prayer_times": ["06:00", "12:00", "18:00"]
}
```

**Required Fields:** `name`, `phone`, `country`, `password`, `password_confirmation`

**Response (201):**
```json
{
  "message": "Registration successful",
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "+1234567890",
    "country": "Kenya",
    "timezone": "Africa/Nairobi",
    "prayer_times": ["06:00", "12:00", "18:00"],
    "church_role": {
      "value": "user",
      "label": "User"
    },
    "initials": "JD",
    "created_at": "2025-08-05T10:30:00.000000Z",
    "updated_at": "2025-08-05T10:30:00.000000Z"
  },
  "token": "1|abc123...token"
}
```

### Login
**POST** `/login`

Authenticate user and receive access token.

**Parameters:**
```json
{
  "phone": "+1234567890",
  "password": "password123"
}
```

**Response (200):**
```json
{
  "message": "Login successful",
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "+1234567890",
    "country": "Kenya",
    "timezone": "Africa/Nairobi",
    "prayer_times": ["06:00", "12:00", "18:00"],
    "church_role": {
      "value": "user",
      "label": "User"
    },
    "initials": "JD",
    "created_at": "2025-08-05T10:30:00.000000Z",
    "updated_at": "2025-08-05T10:30:00.000000Z"
  },
  "token": "2|def456...token"
}
```

### Logout
**POST** `/logout` 🔒

Revoke current access token.

**Response (200):**
```json
{
  "message": "Logged out successfully"
}
```

## User Management

### Get Current User
**GET** `/user` 🔒

Get currently authenticated user details.

**Response (200):**
```json
{
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "+1234567890",
    "country": "Kenya",
    "timezone": "Africa/Nairobi",
    "prayer_times": ["06:00", "12:00", "18:00"],
    "church_role": {
      "value": "user",
      "label": "User"
    },
    "initials": "JD",
    "created_at": "2025-08-05T10:30:00.000000Z",
    "updated_at": "2025-08-05T10:30:00.000000Z"
  }
}
```

### Update Profile
**PUT** `/user/profile` 🔒

Update user profile information.

**Parameters:**
```json
{
  "name": "John Smith",
  "email": "john.smith@example.com",
  "country": "Kenya",
  "timezone": "Africa/Nairobi",
  "prayer_times": ["05:30", "12:00", "18:30"]
}
```

**Response (200):**
```json
{
  "message": "Profile updated successfully",
  "user": {
    "id": 1,
    "name": "John Smith",
    "email": "john.smith@example.com",
    "phone": "+1234567890",
    "country": "Kenya",
    "timezone": "Africa/Nairobi",
    "prayer_times": ["05:30", "12:00", "18:30"],
    "church_role": {
      "value": "user",
      "label": "User"
    },
    "initials": "JS",
    "created_at": "2025-08-05T10:30:00.000000Z",
    "updated_at": "2025-08-05T11:15:00.000000Z"
  }
}
```

## Prayer System

### Get Prayer Schedule
**GET** `/prayers/schedule` 🔒

Get user's prayer schedule with active and completed prayers.

**Response (200):**
```json
{
  "active_prayers": [
    {
      "id": 1,
      "category": {
        "value": "healing",
        "label": "Healing"
      },
      "start_date": "2025-08-01",
      "end_date": "2025-08-15",
      "completed": false,
      "days_remaining": 10,
      "is_active": true,
      "created_at": "2025-08-01T10:00:00.000000Z",
      "updated_at": "2025-08-01T10:00:00.000000Z"
    }
  ],
  "completed_prayers": [
    {
      "id": 2,
      "category": {
        "value": "thanksgiving",
        "label": "Thanksgiving"
      },
      "start_date": "2025-07-01",
      "end_date": "2025-07-07",
      "completed": true,
      "days_remaining": -29,
      "is_active": false,
      "created_at": "2025-07-01T10:00:00.000000Z",
      "updated_at": "2025-07-07T18:00:00.000000Z"
    }
  ],
  "prayer_times": ["06:00", "12:00", "18:00"],
  "user_timezone": "Africa/Nairobi"
}
```

### Create Prayer Request
**POST** `/prayers/request` 🔒

Create a new prayer request.

**Parameters:**
```json
{
  "category": "healing",
  "start_date": "2025-08-05",
  "end_date": "2025-08-19"
}
```

**Available Categories:** `healing`, `marriage`, `protection`, `financial`, `family`, `career`, `salvation`, `guidance`, `thanksgiving`, `other`

**Response (201):**
```json
{
  "message": "Prayer request created successfully",
  "prayer_request": {
    "id": 3,
    "category": {
      "value": "healing",
      "label": "Healing"
    },
    "start_date": "2025-08-05",
    "end_date": "2025-08-19",
    "completed": false,
    "days_remaining": 14,
    "is_active": true,
    "created_at": "2025-08-05T10:30:00.000000Z",
    "updated_at": "2025-08-05T10:30:00.000000Z"
  }
}
```

### Get Deeper Prayer Info
**GET** `/prayers/deeper` 🔒

Get deeper prayer participation information.

**Response (200):**
```json
{
  "today_participation": {
    "id": 1,
    "date": "2025-08-05",
    "duration": 60,
    "completed": true,
    "completed_at": "2025-08-05T18:30:00"
  },
  "recent_participations": [
    {
      "id": 1,
      "date": "2025-08-05",
      "duration": 60,
      "completed": true,
      "completed_at": "2025-08-05T18:30:00"
    },
    {
      "id": 2,
      "date": "2025-08-04",
      "duration": 30,
      "completed": true,
      "completed_at": "2025-08-04T19:00:00"
    }
  ],
  "total_completed": 15,
  "available_durations": [30, 60]
}
```

### Participate in Deeper Prayer
**POST** `/prayers/deeper` 🔒

Record participation in deeper prayer session.

**Parameters:**
```json
{
  "duration": 60,
  "date": "2025-08-05"
}
```

**Available Durations:** `30`, `60` (minutes)

**Response (201):**
```json
{
  "message": "Deeper prayer participation recorded successfully",
  "participation": {
    "id": 3,
    "date": "2025-08-05",
    "duration": 60,
    "completed": true,
    "completed_at": "2025-08-05T19:15:00"
  }
}
```

## Bible Studies

### Get Today's Bible Study
**GET** `/bible/today` 🔒

Get today's Bible study or the latest available study.

**Response (200):**
```json
{
  "study": {
    "id": 1,
    "date": "2025-08-05",
    "topic": "Faith in Action",
    "scripture": "James 2:14-26",
    "devotional": "Faith without works is dead. Today we explore how genuine faith must be accompanied by action...",
    "excerpt": "Faith without works is dead. Today we explore how genuine faith must be accompanied by action...",
    "discussion_json": {
      "questions": [
        "How can you show your faith through actions today?",
        "What practical steps can you take to live out your beliefs?"
      ],
      "key_points": [
        "Faith requires action",
        "Works are evidence of faith"
      ]
    },
    "is_today": true,
    "created_at": "2025-08-05T06:00:00.000000Z",
    "updated_at": "2025-08-05T06:00:00.000000Z"
  }
}
```

### Get Bible Studies
**GET** `/bible/studies` 🔒

Get list of Bible studies with optional filtering.

**Query Parameters:**
- `start_date` (optional): Filter by start date (YYYY-MM-DD)
- `end_date` (optional): Filter by end date (YYYY-MM-DD)
- `search` (optional): Search by topic
- `per_page` (optional): Items per page (default: 15)

**Response (200):**
```json
{
  "data": [
    {
      "id": 1,
      "date": "2025-08-05",
      "topic": "Faith in Action",
      "scripture": "James 2:14-26",
      "devotional": "Faith without works is dead...",
      "excerpt": "Faith without works is dead. Today we explore...",
      "discussion_json": {
        "questions": ["How can you show your faith through actions today?"],
        "key_points": ["Faith requires action"]
      },
      "is_today": true,
      "created_at": "2025-08-05T06:00:00.000000Z",
      "updated_at": "2025-08-05T06:00:00.000000Z"
    }
  ],
  "links": {
    "first": "http://localhost/api/bible/studies?page=1",
    "last": "http://localhost/api/bible/studies?page=10",
    "prev": null,
    "next": "http://localhost/api/bible/studies?page=2"
  },
  "meta": {
    "current_page": 1,
    "from": 1,
    "last_page": 10,
    "per_page": 15,
    "to": 15,
    "total": 150
  }
}
```

## Events

### Get Events
**GET** `/events` 🔒

Get list of events with filtering options.

**Query Parameters:**
- `type` (optional): Filter by event type (`rhema_feast`, `rxp`, `outreach`, `business`)
- `status` (optional): Filter by status (`upcoming`, `active`, `past`) - default: `upcoming`
- `with_livestream` (optional): Filter events with livestream
- `per_page` (optional): Items per page (default: 15)

**Response (200):**
```json
{
  "data": [
    {
      "id": "uuid-123-456-789",
      "title": "Rhema Feast 2025",
      "slug": "rhema-feast-2025",
      "start_date": "2025-12-25 10:00:00",
      "end_date": "2025-12-27 18:00:00",
      "type": {
        "value": "rhema_feast",
        "label": "Rhema Feast"
      },
      "location": "Nairobi Conference Center",
      "banner_url": "https://example.com/banners/rhema-feast.jpg",
      "livestream_url": "https://stream.example.com/rhema-feast",
      "description": "Join us for our annual Rhema Feast celebration...",
      "registration_count": 1250,
      "volunteer_count": 45,
      "is_upcoming": true,
      "is_active": false,
      "is_past": false,
      "has_livestream": true,
      "created_at": "2025-08-05T10:00:00.000000Z",
      "updated_at": "2025-08-05T10:00:00.000000Z"
    }
  ],
  "links": {
    "first": "http://localhost/api/events?page=1",
    "last": "http://localhost/api/events?page=5",
    "prev": null,
    "next": "http://localhost/api/events?page=2"
  },
  "meta": {
    "current_page": 1,
    "from": 1,
    "last_page": 5,
    "per_page": 15,
    "to": 15,
    "total": 75
  }
}
```

### Get Event Details
**GET** `/events/{event_id}` 🔒

Get detailed information about a specific event.

**Response (200):**
```json
{
  "event": {
    "id": "uuid-123-456-789",
    "title": "Rhema Feast 2025",
    "slug": "rhema-feast-2025",
    "start_date": "2025-12-25 10:00:00",
    "end_date": "2025-12-27 18:00:00",
    "type": {
      "value": "rhema_feast",
      "label": "Rhema Feast"
    },
    "location": "Nairobi Conference Center",
    "banner_url": "https://example.com/banners/rhema-feast.jpg",
    "livestream_url": "https://stream.example.com/rhema-feast",
    "description": "Join us for our annual Rhema Feast celebration with powerful worship, teachings, and fellowship...",
    "registration_count": 1250,
    "volunteer_count": 45,
    "is_upcoming": true,
    "is_active": false,
    "is_past": false,
    "has_livestream": true,
    "created_at": "2025-08-05T10:00:00.000000Z",
    "updated_at": "2025-08-05T10:00:00.000000Z"
  }
}
```

### Register for Event
**POST** `/events/register` 🔒

Register for an event.

**Parameters:**
```json
{
  "event_id": "uuid-123-456-789",
  "attendance": "physical",
  "volunteer": true
}
```

**Attendance Options:** `physical`, `online`

**Response (201):**
```json
{
  "message": "Successfully registered for event",
  "registration": {
    "id": 1,
    "event": {
      "id": "uuid-123-456-789",
      "title": "Rhema Feast 2025",
      "start_date": "2025-12-25 10:00:00",
      "end_date": "2025-12-27 18:00:00"
    },
    "attendance": {
      "value": "physical",
      "label": "Physical"
    },
    "volunteer": true,
    "registered_at": "2025-08-05T10:30:00"
  }
}
```

### Get My Event Registrations
**GET** `/events/my-registrations` 🔒

Get user's event registrations.

**Query Parameters:**
- `per_page` (optional): Items per page (default: 15)

**Response (200):**
```json
{
  "registrations": [
    {
      "id": 1,
      "event": {
        "id": "uuid-123-456-789",
        "title": "Rhema Feast 2025",
        "start_date": "2025-12-25 10:00:00",
        "end_date": "2025-12-27 18:00:00",
        "location": "Nairobi Conference Center"
      },
      "attendance": {
        "value": "physical",
        "label": "Physical"
      },
      "volunteer": true,
      "registered_at": "2025-08-05T10:30:00"
    }
  ],
  "pagination": {
    "current_page": 1,
    "last_page": 3,
    "per_page": 15,
    "total": 45
  }
}
```

## Resources

### Get Resources
**GET** `/resources` 🔒

Get list of resources (ebooks, audiobooks, sermons).

**Query Parameters:**
- `type` (optional): Filter by type (`ebook`, `audiobook`, `sermon`)
- `language` (optional): Filter by language (e.g., `en`, `sw`)
- `search` (optional): Search in title and description
- `per_page` (optional): Items per page (default: 15)

**Response (200):**
```json
{
  "data": [
    {
      "id": 1,
      "type": {
        "value": "ebook",
        "label": "E-Book"
      },
      "title": "Walking in Faith",
      "description": "A comprehensive guide to strengthening your faith journey...",
      "download_url": "https://resources.example.com/books/walking-in-faith.pdf",
      "language": "en",
      "created_at": "2025-08-01T10:00:00.000000Z",
      "updated_at": "2025-08-01T10:00:00.000000Z"
    }
  ],
  "links": {
    "first": "http://localhost/api/resources?page=1",
    "last": "http://localhost/api/resources?page=8",
    "prev": null,
    "next": "http://localhost/api/resources?page=2"
  },
  "meta": {
    "current_page": 1,
    "from": 1,
    "last_page": 8,
    "per_page": 15,
    "to": 15,
    "total": 120
  }
}
```

### Get Resource Details
**GET** `/resources/{resource_id}` 🔒

Get detailed information about a specific resource.

**Response (200):**
```json
{
  "resource": {
    "id": 1,
    "type": {
      "value": "ebook",
      "label": "E-Book"
    },
    "title": "Walking in Faith",
    "description": "A comprehensive guide to strengthening your faith journey with practical insights and biblical wisdom...",
    "download_url": "https://resources.example.com/books/walking-in-faith.pdf",
    "language": "en",
    "created_at": "2025-08-01T10:00:00.000000Z",
    "updated_at": "2025-08-01T10:00:00.000000Z"
  }
}
```

## Testimonies

### Get Testimonies
**GET** `/testimonies` 🔒

Get list of approved testimonies.

**Query Parameters:**
- `search` (optional): Search in title and body
- `per_page` (optional): Items per page (default: 15)

**Response (200):**
```json
{
  "data": [
    {
      "id": 1,
      "title": "Miraculous Healing",
      "body": "I want to share how God miraculously healed me from a chronic illness...",
      "excerpt": "I want to share how God miraculously healed me from a chronic illness...",
      "media_path": "testimonies/healing-photo.jpg",
      "has_media": true,
      "status": {
        "value": "approved",
        "label": "Approved"
      },
      "user": {
        "id": 1,
        "name": "Jane Doe",
        "initials": "JD"
      },
      "created_at": "2025-08-01T10:00:00.000000Z",
      "updated_at": "2025-08-02T15:30:00.000000Z"
    }
  ],
  "links": {
    "first": "http://localhost/api/testimonies?page=1",
    "last": "http://localhost/api/testimonies?page=12",
    "prev": null,
    "next": "http://localhost/api/testimonies?page=2"
  },
  "meta": {
    "current_page": 1,
    "from": 1,
    "last_page": 12,
    "per_page": 15,
    "to": 15,
    "total": 180
  }
}
```

### Submit Testimony
**POST** `/testimonies` 🔒

Submit a new testimony for approval.

**Parameters:**
```json
{
  "title": "God's Provision",
  "body": "I want to share how God provided for my family during difficult times...",
  "media": "base64_encoded_image_or_video" // optional
}
```

**Note:** Media should be sent as multipart/form-data for file uploads
**Supported Media:** JPG, JPEG, PNG, GIF, MP4, AVI, MOV (max 10MB)

**Response (201):**
```json
{
  "message": "Testimony submitted successfully and is pending approval",
  "testimony": {
    "id": 2,
    "title": "God's Provision",
    "body": "I want to share how God provided for my family during difficult times...",
    "excerpt": "I want to share how God provided for my family during difficult times...",
    "media_path": "testimonies/provision-story.jpg",
    "has_media": true,
    "status": {
      "value": "pending",
      "label": "Pending"
    },
    "user": {
      "id": 1,
      "name": "John Doe",
      "initials": "JD"
    },
    "created_at": "2025-08-05T11:00:00.000000Z",
    "updated_at": "2025-08-05T11:00:00.000000Z"
  }
}
```

### Get My Testimonies
**GET** `/testimonies/my` 🔒

Get user's own testimonies (all statuses).

**Query Parameters:**
- `per_page` (optional): Items per page (default: 15)

**Response (200):**
```json
{
  "data": [
    {
      "id": 2,
      "title": "God's Provision",
      "body": "I want to share how God provided for my family...",
      "excerpt": "I want to share how God provided for my family...",
      "media_path": "testimonies/provision-story.jpg",
      "has_media": true,
      "status": {
        "value": "pending",
        "label": "Pending"
      },
      "user": {
        "id": 1,
        "name": "John Doe",
        "initials": "JD"
      },
      "created_at": "2025-08-05T11:00:00.000000Z",
      "updated_at": "2025-08-05T11:00:00.000000Z"
    }
  ],
  "links": {
    "first": "http://localhost/api/testimonies/my?page=1",
    "last": "http://localhost/api/testimonies/my?page=2",
    "prev": null,
    "next": "http://localhost/api/testimonies/my?page=2"
  },
  "meta": {
    "current_page": 1,
    "from": 1,
    "last_page": 2,
    "per_page": 15,
    "to": 15,
    "total": 3
  }
}
```

## Donations

### Create Donation
**POST** `/donate` 🔒

Initiate a new donation.

**Parameters:**
```json
{
  "amount": 1000.00,
  "method": "mpesa",
  "purpose": "Church Building Fund"
}
```

**Payment Methods:** `mpesa`, `bank`, `sendwave`, `paypal`

**Response (201):**
```json
{
  "message": "Donation initiated successfully",
  "donation": {
    "id": "uuid-donation-123",
    "amount": "1000.00",
    "method": {
      "value": "mpesa",
      "label": "M-Pesa"
    },
    "purpose": "Church Building Fund",
    "status": {
      "value": "pending",
      "label": "Pending"
    },
    "payment_ref": "JKMG-ABC123DEF4",
    "is_completed": false,
    "is_pending": true,
    "is_failed": false,
    "created_at": "2025-08-05T11:30:00.000000Z",
    "updated_at": "2025-08-05T11:30:00.000000Z"
  },
  "next_steps": {
    "message": "Please complete payment via M-Pesa",
    "instructions": [
      "Go to M-Pesa on your phone",
      "Select Paybill",
      "Enter Business Number: 123456",
      "Enter Account Number: JKMG-ABC123DEF4",
      "Enter Amount: 1000.00",
      "Enter PIN and send"
    ]
  }
}
```

### Get My Donations
**GET** `/donations/my` 🔒

Get user's donation history.

**Query Parameters:**
- `status` (optional): Filter by status (`pending`, `completed`, `failed`, `cancelled`, `refunded`)
- `per_page` (optional): Items per page (default: 15)

**Response (200):**
```json
{
  "data": [
    {
      "id": "uuid-donation-123",
      "amount": "1000.00",
      "method": {
        "value": "mpesa",
        "label": "M-Pesa"
      },
      "purpose": "Church Building Fund",
      "status": {
        "value": "completed",
        "label": "Completed"
      },
      "payment_ref": "JKMG-ABC123DEF4",
      "is_completed": true,
      "is_pending": false,
      "is_failed": false,
      "created_at": "2025-08-05T11:30:00.000000Z",
      "updated_at": "2025-08-05T12:00:00.000000Z"
    }
  ],
  "links": {
    "first": "http://localhost/api/donations/my?page=1",
    "last": "http://localhost/api/donations/my?page=5",
    "prev": null,
    "next": "http://localhost/api/donations/my?page=2"
  },
  "meta": {
    "current_page": 1,
    "from": 1,
    "last_page": 5,
    "per_page": 15,
    "to": 15,
    "total": 75
  }
}
```

## Counseling

### Book Counseling Session
**POST** `/counseling/book` 🔒

Book a counseling session.

**Parameters:**
```json
{
  "topic": "Marriage Guidance",
  "intake_form": {
    "preferred_time": "Morning",
    "urgency": "medium",
    "previous_counseling": false,
    "specific_concerns": "Communication issues with spouse",
    "preferred_counselor_gender": "any"
  }
}
```

**Urgency Options:** `low`, `medium`, `high`
**Gender Options:** `male`, `female`, `any`

**Response (201):**
```json
{
  "message": "Counseling session booked successfully. We will assign a counselor and contact you soon.",
  "session": {
    "id": 1,
    "topic": "Marriage Guidance",
    "intake_form": {
      "preferred_time": "Morning",
      "urgency": "medium",
      "previous_counseling": false,
      "specific_concerns": "Communication issues with spouse",
      "preferred_counselor_gender": "any"
    },
    "scheduled_at": null,
    "status": {
      "value": "booked",
      "label": "Booked"
    },
    "user": {
      "id": 1,
      "name": "John Doe",
      "initials": "JD"
    },
    "counselor": null,
    "created_at": "2025-08-05T12:00:00.000000Z",
    "updated_at": "2025-08-05T12:00:00.000000Z"
  }
}
```

### Get My Counseling Sessions
**GET** `/counseling/sessions` 🔒

Get user's counseling sessions.

**Query Parameters:**
- `status` (optional): Filter by status (`booked`, `completed`, `cancelled`)
- `per_page` (optional): Items per page (default: 15)

**Response (200):**
```json
{
  "data": [
    {
      "id": 1,
      "topic": "Marriage Guidance",
      "intake_form": {
        "preferred_time": "Morning",
        "urgency": "medium",
        "previous_counseling": false,
        "specific_concerns": "Communication issues with spouse",
        "preferred_counselor_gender": "any"
      },
      "scheduled_at": "2025-08-10 14:00:00",
      "status": {
        "value": "booked",
        "label": "Booked"
      },
      "user": {
        "id": 1,
        "name": "John Doe",
        "initials": "JD"
      },
      "counselor": {
        "id": 5,
        "name": "Pastor Mary Smith",
        "initials": "MS"
      },
      "created_at": "2025-08-05T12:00:00.000000Z",
      "updated_at": "2025-08-05T14:30:00.000000Z"
    }
  ],
  "links": {
    "first": "http://localhost/api/counseling/sessions?page=1",
    "last": "http://localhost/api/counseling/sessions?page=2",
    "prev": null,
    "next": "http://localhost/api/counseling/sessions?page=2"
  },
  "meta": {
    "current_page": 1,
    "from": 1,
    "last_page": 2,
    "per_page": 15,
    "to": 15,
    "total": 3
  }
}
```

## Salvation

### Record Salvation Decision
**POST** `/salvation` 🔒

Record a salvation or rededication decision.

**Parameters:**
```json
{
  "type": "salvation",
  "audio_sent": false
}
```

**Types:** `salvation`, `rededication`

**Response (201):**
```json
{
  "message": "Salvation decision recorded successfully",
  "salvation_decision": {
    "id": 1,
    "type": {
      "value": "salvation",
      "label": "Salvation"
    },
    "submitted_at": "2025-08-05T15:00:00",
    "audio_sent": false
  }
}
```

## Notifications

### Get Notifications
**GET** `/notifications` 🔒

Get user's notifications.

**Query Parameters:**
- `status` (optional): Filter by status (`read`, `unread`)
- `per_page` (optional): Items per page (default: 20)

**Response (200):**
```json
{
  "data": [
    {
      "id": 1,
      "type": {
        "value": "prayer_reminder",
        "label": "Prayer Reminder"
      },
      "title": "Prayer Time Reminder",
      "body": "It's time for your evening prayer session",
      "sent_at": "2025-08-05T18:00:00",
      "read_at": null,
      "is_read": false,
      "created_at": "2025-08-05T18:00:00.000000Z"
    }
  ],
  "links": {
    "first": "http://localhost/api/notifications?page=1",
    "last": "http://localhost/api/notifications?page=3",
    "prev": null,
    "next": "http://localhost/api/notifications?page=2"
  },
  "meta": {
    "current_page": 1,
    "from": 1,
    "last_page": 3,
    "per_page": 20,
    "to": 20,
    "total": 60,
    "unread_count": 15,
    "total_count": 60
  }
}
```

### Mark Notification as Read
**POST** `/notifications/{notification_id}/read` 🔒

Mark a specific notification as read.

**Response (200):**
```json
{
  "message": "Notification marked as read",
  "notification": {
    "id": 1,
    "type": {
      "value": "prayer_reminder",
      "label": "Prayer Reminder"
    },
    "title": "Prayer Time Reminder",
    "body": "It's time for your evening prayer session",
    "sent_at": "2025-08-05T18:00:00",
    "read_at": "2025-08-05T18:30:00",
    "is_read": true,
    "created_at": "2025-08-05T18:00:00.000000Z"
  }
}
```

## Feedback

### Get Feedback Types
**GET** `/feedback-types`

Get available feedback types (public endpoint).

**Response (200):**
```json
{
  "feedback_types": [
    {
      "value": "bug_report",
      "label": "Bug Report",
      "description": "Report a bug or technical problem"
    },
    {
      "value": "feature_request",
      "label": "Feature Request",
      "description": "Request a new feature"
    },
    {
      "value": "general_feedback",
      "label": "General Feedback",
      "description": "General comments about the app"
    },
    {
      "value": "app_rating",
      "label": "App Rating",
      "description": "Rate your overall app experience"
    },
    {
      "value": "content_feedback",
      "label": "Content Feedback",
      "description": "Feedback about content (studies, resources, etc.)"
    },
    {
      "value": "technical_issue",
      "label": "Technical Issue",
      "description": "Technical problems or errors"
    },
    {
      "value": "suggestion",
      "label": "Suggestion",
      "description": "Suggestions for improvement"
    },
    {
      "value": "complaint",
      "label": "Complaint",
      "description": "Report an issue or concern"
    },
    {
      "value": "praise",
      "label": "Praise",
      "description": "Share positive feedback"
    }
  ]
}
```

### Submit Feedback
**POST** `/feedback` 🔒

Submit feedback about the app.

**Parameters:**
```json
{
  "type": "feature_request",
  "subject": "Add Dark Mode",
  "message": "Please add a dark mode option for better usage during evening prayers",
  "rating": null,
  "contact_email": "user@example.com",
  "metadata": {
    "device_info": "iPhone 13 Pro",
    "app_version": "1.2.3",
    "platform": "ios",
    "screen": "Settings"
  }
}
```

**Required for app_rating type:** `rating` (1-5)
**Platforms:** `ios`, `android`, `web`

**Response (201):**
```json
{
  "message": "Feedback submitted successfully. Thank you for helping us improve!",
  "feedback": {
    "id": 1,
    "type": {
      "value": "feature_request",
      "label": "Feature Request",
      "description": "Request a new feature"
    },
    "subject": "Add Dark Mode",
    "message": "Please add a dark mode option for better usage during evening prayers",
    "rating": null,
    "contact_email": "user@example.com",
    "status": {
      "value": "open",
      "label": "Open",
      "description": "Feedback submitted and awaiting review"
    },
    "admin_response": null,
    "responded_at": null,
    "has_response": false,
    "is_high_priority": false,
    "metadata": {
      "device_info": "iPhone 13 Pro",
      "app_version": "1.2.3",
      "platform": "ios",
      "screen": "Settings"
    },
    "created_at": "2025-08-05T16:00:00",
    "updated_at": "2025-08-05T16:00:00"
  },
  "reference_id": "FB-000001"
}
```

### Get My Feedback
**GET** `/feedback` 🔒

Get user's feedback submissions.

**Query Parameters:**
- `type` (optional): Filter by feedback type
- `status` (optional): Filter by status (`open`, `in_progress`, `resolved`, `closed`)
- `per_page` (optional): Items per page (default: 15)

**Response (200):**
```json
{
  "data": [
    {
      "id": 1,
      "type": {
        "value": "feature_request",
        "label": "Feature Request",
        "description": "Request a new feature"
      },
      "subject": "Add Dark Mode",
      "message": "Please add a dark mode option for better usage during evening prayers",
      "rating": null,
      "contact_email": "user@example.com",
      "status": {
        "value": "in_progress",
        "label": "In Progress",
        "description": "Feedback is being worked on"
      },
      "admin_response": "Thank you for your suggestion! We're currently working on implementing dark mode and it should be available in the next update.",
      "responded_at": "2025-08-06T10:00:00",
      "has_response": true,
      "is_high_priority": false,
      "metadata": {
        "device_info": "iPhone 13 Pro",
        "app_version": "1.2.3",
        "platform": "ios",
        "screen": "Settings"
      },
      "created_at": "2025-08-05T16:00:00",
      "updated_at": "2025-08-06T10:00:00"
    }
  ],
  "links": {
    "first": "http://localhost/api/feedback?page=1",
    "last": "http://localhost/api/feedback?page=2",
    "prev": null,
    "next": "http://localhost/api/feedback?page=2"
  },
  "meta": {
    "current_page": 1,
    "from": 1,
    "last_page": 2,
    "per_page": 15,
    "to": 15,
    "total": 5
  }
}
```

### Get Specific Feedback
**GET** `/feedback/{feedback_id}` 🔒

Get details of a specific feedback submission.

**Response (200):**
```json
{
  "feedback": {
    "id": 1,
    "type": {
      "value": "feature_request",
      "label": "Feature Request",
      "description": "Request a new feature"
    },
    "subject": "Add Dark Mode",
    "message": "Please add a dark mode option for better usage during evening prayers",
    "rating": null,
    "contact_email": "user@example.com",
    "status": {
      "value": "resolved",
      "label": "Resolved",
      "description": "Feedback has been addressed"
    },
    "admin_response": "Dark mode has been implemented and is now available in version 1.3.0 of the app!",
    "responded_at": "2025-08-10T14:00:00",
    "has_response": true,
    "is_high_priority": false,
    "metadata": {
      "device_info": "iPhone 13 Pro",
      "app_version": "1.2.3",
      "platform": "ios",
      "screen": "Settings"
    },
    "created_at": "2025-08-05T16:00:00",
    "updated_at": "2025-08-10T14:00:00"
  }
}
```

### Get My Feedback Stats
**GET** `/feedback-stats/my` 🔒

Get user's feedback statistics.

**Response (200):**
```json
{
  "stats": {
    "total_feedback": 8,
    "open_feedback": 2,
    "resolved_feedback": 5,
    "average_rating_given": 4.5,
    "recent_feedback": [
      {
        "id": 8,
        "type": {
          "value": "praise",
          "label": "Praise"
        },
        "subject": "Love the new update!",
        "status": {
          "value": "open",
          "label": "Open"
        },
        "created_at": "2025-08-05T16:00:00"
      },
      {
        "id": 7,
        "type": {
          "value": "app_rating",
          "label": "App Rating"
        },
        "subject": "Overall Experience",
        "rating": 5,
        "status": {
          "value": "resolved",
          "label": "Resolved"
        },
        "created_at": "2025-08-04T12:00:00"
      }
    ]
  }
}
```

---

## Common Status Codes & Meanings

- **200 OK**: Request successful
- **201 Created**: Resource created successfully
- **401 Unauthorized**: Invalid or missing authentication token
- **403 Forbidden**: User doesn't have permission to access resource
- **404 Not Found**: Resource not found
- **422 Unprocessable Entity**: Validation errors in request data
- **500 Internal Server Error**: Server error

## Rate Limiting

The API implements rate limiting to prevent abuse:
- **General endpoints**: 60 requests per minute
- **Authentication endpoints**: 5 attempts per minute
- **File upload endpoints**: 10 requests per minute

## Pagination

Most list endpoints support pagination with the following parameters:
- `page`: Page number (starting from 1)
- `per_page`: Items per page (max 100, default varies by endpoint)

Pagination response includes:
- `data`: Array of results
- `links`: Navigation links (first, last, prev, next)
- `meta`: Pagination metadata (current_page, last_page, total, etc.)

## File Uploads

For endpoints that accept file uploads (like testimony media):
- Use `multipart/form-data` content type
- Maximum file size: 10MB
- Supported formats: JPG, JPEG, PNG, GIF, MP4, AVI, MOV

## Notes for Mobile Developers

1. **Authentication**: Always include the Bearer token for protected endpoints
2. **Error Handling**: Check HTTP status codes and handle validation errors appropriately
3. **Offline Support**: Consider caching frequently accessed data like Bible studies and events
4. **Push Notifications**: Integrate with your push notification service using the notifications endpoint
5. **File Management**: Handle media uploads for testimonies with appropriate progress indicators
6. **User Experience**: Use the feedback system to gather user input and improve the app

## Support

For API support or questions, please contact the development team or create a feedback submission through the API.

---

**Last Updated**: August 5, 2025  
**API Version**: 1.0  
**Documentation Version**: 1.0