import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// User entity
@JsonSerializable()
class User extends Equatable {
  final String id;
  final String email;
  final UserPreferences preferences;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    required this.preferences,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? email,
    UserPreferences? preferences,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, email];
}

/// User preferences
@JsonSerializable()
class UserPreferences extends Equatable {
  final String currency;
  final String country;
  final bool notificationsEnabled;
  final bool darkMode;
  final List<String> favoriteStores;

  const UserPreferences({
    this.currency = 'EUR',
    this.country = 'ES',
    this.notificationsEnabled = true,
    this.darkMode = true,
    this.favoriteStores = const [],
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);

  UserPreferences copyWith({
    String? currency,
    String? country,
    bool? notificationsEnabled,
    bool? darkMode,
    List<String>? favoriteStores,
  }) {
    return UserPreferences(
      currency: currency ?? this.currency,
      country: country ?? this.country,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkMode: darkMode ?? this.darkMode,
      favoriteStores: favoriteStores ?? this.favoriteStores,
    );
  }

  @override
  List<Object?> get props => [
        currency,
        country,
        notificationsEnabled,
        darkMode,
        favoriteStores,
      ];
}
