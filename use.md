we have added some api endpoint

GET {{base_url}}/prayers/scheduled
{
    "prayer": {
        "id": 3,
        "title": "Morning prayers",
        "message": "Heavenly Father, I thank You for the gift of a new day. Thank You for watching over me through the night, and for waking me up with strength and life. I ask for Your guidance today— lead my thoughts, my words, and my actions. Bless the work of my hands, and keep me safe from harm and discouragement. Fill my heart with peace, my mind with wisdom, and my spirit with joy. Help me to walk in love, patience, and kindness, and to be a blessing to everyone I meet. Amen",
        "audio_url": "https://908f9000d297c0a39a4080c541c245c2.r2.cloudflarestorage.com/jkmgbackend/prayers/audio/01K30NJP8WFJY75FHZ5D61KJXG.mp3?X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=77fe8da26bb26413ced38fd2d4859eb7%2F20250819%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250819T102321Z&X-Amz-SignedHeaders=host&X-Amz-Expires=30&X-Amz-Signature=d99949d3a9bcb3063ff94cc48c23c4c72a1ec950467f80d6c9ebe56e4667dba7",
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

and 

GET {{base_url}}/prayers/scheduled?prayer_id=3


{
    "prayer": {
        "id": 3,
        "title": "Morning prayers",
        "message": "Heavenly Father, I thank You for the gift of a new day. Thank You for watching over me through the night, and for waking me up with strength and life. I ask for Your guidance today— lead my thoughts, my words, and my actions. Bless the work of my hands, and keep me safe from harm and discouragement. Fill my heart with peace, my mind with wisdom, and my spirit with joy. Help me to walk in love, patience, and kindness, and to be a blessing to everyone I meet. Amen",
        "audio_url": "https://908f9000d297c0a39a4080c541c245c2.r2.cloudflarestorage.com/jkmgbackend/prayers/audio/01K30NJP8WFJY75FHZ5D61KJXG.mp3?X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=77fe8da26bb26413ced38fd2d4859eb7%2F20250819%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250819T102910Z&X-Amz-SignedHeaders=host&X-Amz-Expires=30&X-Amz-Signature=302b3aa7b8696d0620f9eb74250d7fd97eefae959584122d8c29b20b1baa4d68",
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

intergrate these to the system lib\services and lib/screens/prayer

