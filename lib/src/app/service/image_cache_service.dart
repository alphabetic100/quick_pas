import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ImageCacheService {
  static final ImageCacheService instance = ImageCacheService._internal();
  
  factory ImageCacheService() {
    return instance;
  }
  
  ImageCacheService._internal();

  // Cache a profile image from URL
  Future<String?> cacheProfileImage(String userId, String imageUrl) async {
    try {
      if (imageUrl.isEmpty) return null;
      
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        return await _saveImageToLocal(userId, bytes);
      }
    } catch (error) {
      log('Error caching profile image: $error');
    }
    return null;
  }

  // Cache a profile image from bytes
  Future<String?> cacheProfileImageFromBytes(String userId, Uint8List bytes) async {
    try {
      return await _saveImageToLocal(userId, bytes);
    } catch (error) {
      log('Error caching profile image from bytes: $error');
    }
    return null;
  }

  // Save image bytes to local storage
  Future<String> _saveImageToLocal(String userId, Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final profileImagesDir = Directory('${directory.path}/profile_images');
    
    if (!await profileImagesDir.exists()) {
      await profileImagesDir.create(recursive: true);
    }
    
    final fileName = 'profile_$userId.jpg';
    final file = File('${profileImagesDir.path}/$fileName');
    await file.writeAsBytes(bytes);
    
    log('Profile image cached locally: ${file.path}');
    return file.path;
  }

  // Get cached profile image path
  Future<String?> getCachedProfileImagePath(String userId) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/profile_images/profile_$userId.jpg');
      
      if (await file.exists()) {
        log('Found cached profile image: ${file.path}');
        return file.path;
      }
    } catch (error) {
      log('Error getting cached profile image: $error');
    }
    return null;
  }

  // Check if profile image is cached
  Future<bool> isProfileImageCached(String userId) async {
    final path = await getCachedProfileImagePath(userId);
    return path != null;
  }

  // Delete cached profile image
  Future<void> deleteCachedProfileImage(String userId) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/profile_images/profile_$userId.jpg');
      
      if (await file.exists()) {
        await file.delete();
        log('Deleted cached profile image for user: $userId');
      }
    } catch (error) {
      log('Error deleting cached profile image: $error');
    }
  }

  // Clear all cached profile images
  Future<void> clearAllCachedImages() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final profileImagesDir = Directory('${directory.path}/profile_images');
      
      if (await profileImagesDir.exists()) {
        await profileImagesDir.delete(recursive: true);
        log('All cached profile images cleared');
      }
    } catch (error) {
      log('Error clearing cached profile images: $error');
    }
  }
}
