# APK Testing Troubleshooting Guide

## 🐛 Common Issues When Sharing APKs for Testing

### Issue 1: Architecture Compatibility
**Problem**: App crashes or won't install on some devices
**Solution**: Use the universal APK

**✅ Fixed**: Built universal APK at:
- `build/app/outputs/flutter-apk/app-release.apk` (21.8MB)

### Issue 2: Android Version Compatibility  
**Check**: Your app requires Android API level based on Flutter's minSdk
**Ask testers**: What Android version are they running?
- Android 5.0+ (API 21+) should work
- Older versions will fail to install

### Issue 3: Installation from Unknown Sources
**Problem**: "App not installed" or "Can't install unknown apps"
**Solution**: Testers need to enable installation from unknown sources

**Instructions for testers:**
1. **Android 8.0+**: Settings → Apps → Special Access → Install Unknown Apps → Enable for the app they're using to install (Chrome, File Manager, etc.)
2. **Android 7.1 and below**: Settings → Security → Unknown Sources → Enable

### Issue 4: Package Conflicts
**Problem**: "App not installed" due to package conflicts
**Current Package**: `com.jkmg.app`
**Solution**: Testers should uninstall any previous versions first

### Issue 5: Insufficient Storage
**Problem**: Device doesn't have enough space
**APK Size**: 21.8MB
**Required Space**: ~50MB (including installation overhead)

### Issue 6: Corrupted Download
**Problem**: APK gets corrupted during transfer
**Solutions**:
- Use cloud storage (Google Drive, Dropbox) instead of messaging apps
- Verify file size matches: 21.8MB
- Check SHA1 hash if needed

## 🧪 Testing Instructions for Your Testers

### Pre-Installation Checklist:
1. **Device Requirements**:
   - Android 5.0+ (API 21+)
   - 50MB free storage
   - ARM, ARM64, or x86_64 processor

2. **Enable Unknown Sources**:
   - Follow instructions above for your Android version

3. **Download Method**:
   - Use cloud storage links (Google Drive, Dropbox)
   - Don't use WhatsApp/Telegram file sharing (compresses files)

### Installation Steps:
1. Download the APK file
2. Tap the downloaded file
3. Tap "Install" 
4. If prompted, allow installation from this source
5. Wait for installation to complete
6. Look for "JKMG" app icon

### If Installation Fails:
1. **Check Android version**: Settings → About Phone → Android Version
2. **Check free storage**: Settings → Storage
3. **Clear Downloads cache**: Settings → Apps → Downloads → Storage → Clear Cache
4. **Restart device** and try again
5. **Try installing a different APK** to verify the device can install unknown apps

## 🔧 Alternative Distribution Methods

### Method 1: Internal Testing (Recommended)
Upload to Google Play Console for internal testing:
1. Upload the AAB file (`app-release.aab`)
2. Create internal testing track
3. Add testers' Gmail addresses
4. Testers install via Play Store

### Method 2: Firebase App Distribution
1. Upload APK to Firebase
2. Send download links to testers
3. Easier installation process

### Method 3: APK Sharing Best Practices
1. **Use Google Drive or Dropbox** (not messaging apps)
2. **Provide installation instructions**
3. **Test the APK yourself** on a different device first
4. **Check file integrity** after upload

## 📱 Debug Information Collection

Ask testers to provide:
1. **Device Model**: (e.g., Samsung Galaxy S21)
2. **Android Version**: (e.g., Android 12)
3. **Error Message**: Screenshot of any error
4. **Installation Method**: How they downloaded/installed
5. **File Size**: What size shows when downloaded

## 🔍 Quick Debug Commands

If you have access to the device via ADB:
```bash
# Check device architecture
adb shell getprop ro.product.cpu.abi

# Check Android version  
adb shell getprop ro.build.version.release

# Check available storage
adb shell df /data

# Install APK manually
adb install app-release.apk
```

## ✅ Verified Working Configuration
- **Package**: com.jkmg.app
- **Min SDK**: Android 5.0+ (API 21+)
- **Architectures**: ARM, ARM64, x86_64 (universal APK)
- **Size**: 21.8MB
- **Signed**: ✅ Release keystore
- **Tested**: ✅ Works on developer device