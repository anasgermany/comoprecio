import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase configuration and client
class SupabaseConfig {
  // TODO: Replace with your Supabase URL and anon key
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  
  static SupabaseClient? _client;
  
  /// Initialize Supabase - call in main.dart before runApp
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: true,
    );
    _client = Supabase.instance.client;
  }
  
  /// Get the Supabase client
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase not initialized. Call SupabaseConfig.initialize() first.');
    }
    return _client!;
  }
  
  /// Check if Supabase is configured (not using placeholder)
  static bool get isConfigured => 
      supabaseUrl != 'YOUR_SUPABASE_URL' && 
      supabaseAnonKey != 'YOUR_SUPABASE_ANON_KEY';
}
