/// Inventory/Item Model
/// Power-ups, collectibles, and game items
class InventoryItem {
  final String id;
  final String name;
  final String description;
  final ItemType type;
  final String icon;
  final int? quantity;
  final int? maxQuantity;
  final bool isConsumable;
  final bool isActive;
  final ItemEffect? effect;
  final int? cost; // For shop items
  final String? category;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.icon,
    this.quantity,
    this.maxQuantity,
    this.isConsumable = false,
    this.isActive = false,
    this.effect,
    this.cost,
    this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name,
      'icon': icon,
      'quantity': quantity,
      'maxQuantity': maxQuantity,
      'isConsumable': isConsumable,
      'isActive': isActive,
      'effect': effect?.toJson(),
      'cost': cost,
      'category': category,
    };
  }

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: ItemType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ItemType.collectible,
      ),
      icon: json['icon'] as String,
      quantity: json['quantity'] as int?,
      maxQuantity: json['maxQuantity'] as int?,
      isConsumable: json['isConsumable'] as bool,
      isActive: json['isActive'] as bool,
      effect: json['effect'] != null
          ? ItemEffect.fromJson(json['effect'] as Map<String, dynamic>)
          : null,
      cost: json['cost'] as int?,
      category: json['category'] as String?,
    );
  }

  /// Check if item is at max quantity
  bool get isMaxQuantity =>
      maxQuantity != null && quantity != null && quantity! >= maxQuantity!;

  /// Get a copy with updated quantity
  InventoryItem withQuantity(int newQuantity) {
    return InventoryItem(
      id: id,
      name: name,
      description: description,
      type: type,
      icon: icon,
      quantity: newQuantity,
      maxQuantity: maxQuantity,
      isConsumable: isConsumable,
      isActive: isActive,
      effect: effect,
      cost: cost,
      category: category,
    );
  }
}

enum ItemType { powerUp, collectible, badge, cosmetic, currency }

class ItemEffect {
  final EffectType type;
  final int? value;
  final int? duration; // in seconds
  final String? description;

  const ItemEffect({
    required this.type,
    this.value,
    this.duration,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'value': value,
      'duration': duration,
      'description': description,
    };
  }

  factory ItemEffect.fromJson(Map<String, dynamic> json) {
    return ItemEffect(
      type: EffectType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => EffectType.extraTime,
      ),
      value: json['value'] as int?,
      duration: json['duration'] as int?,
      description: json['description'] as String?,
    );
  }
}

enum EffectType {
  extraTime,
  hintReveal,
  skipLevel,
  doubleCoins,
  doubleStars,
  freezeTime,
  slowDown,
  autoComplete,
}

/// Inventory Database
class InventoryDatabase {
  static const List<InventoryItem> shopItems = [
    // Power-ups
    InventoryItem(
      id: 'item_extra_time',
      name: 'Extra Time',
      description: 'Add 30 seconds to the timer',
      type: ItemType.powerUp,
      icon: '⏱️',
      cost: 50,
      category: 'power_ups',
      isConsumable: true,
      effect: ItemEffect(
        type: EffectType.extraTime,
        value: 30,
        description: '+30 seconds',
      ),
    ),
    InventoryItem(
      id: 'item_hint_reveal',
      name: 'Hint Reveal',
      description: 'Reveal the correct answer for one word',
      type: ItemType.powerUp,
      icon: '💡',
      cost: 30,
      category: 'power_ups',
      isConsumable: true,
      effect: ItemEffect(
        type: EffectType.hintReveal,
        value: 1,
        description: 'Reveal 1 word',
      ),
    ),
    InventoryItem(
      id: 'item_skip_level',
      name: 'Skip Level',
      description: 'Skip the current level and move to the next',
      type: ItemType.powerUp,
      icon: '⏭️',
      cost: 100,
      category: 'power_ups',
      isConsumable: true,
      effect: ItemEffect(
        type: EffectType.skipLevel,
        value: 1,
        description: 'Skip level',
      ),
    ),
    InventoryItem(
      id: 'item_double_coins',
      name: 'Double Coins',
      description: 'Double coins earned for the next level',
      type: ItemType.powerUp,
      icon: '💰',
      cost: 75,
      category: 'power_ups',
      isConsumable: true,
      effect: ItemEffect(
        type: EffectType.doubleCoins,
        value: 2,
        description: '2x coins',
      ),
    ),
    InventoryItem(
      id: 'item_freeze_time',
      name: 'Time Freeze',
      description: 'Freeze the timer for 10 seconds',
      type: ItemType.powerUp,
      icon: '❄️',
      cost: 60,
      category: 'power_ups',
      isConsumable: true,
      effect: ItemEffect(
        type: EffectType.freezeTime,
        value: 10,
        duration: 10,
        description: 'Freeze 10s',
      ),
    ),

    // Collectibles
    InventoryItem(
      id: 'item_coin_bag',
      name: 'Coin Bag',
      description: 'A bag containing 100 coins',
      type: ItemType.collectible,
      icon: '👛',
      cost: 200,
      category: 'collectibles',
      maxQuantity: 10,
      effect: ItemEffect(
        type: EffectType.doubleCoins,
        value: 100,
        description: '+100 coins',
      ),
    ),
    InventoryItem(
      id: 'item_star_box',
      name: 'Star Box',
      description: 'A box containing 10 stars',
      type: ItemType.collectible,
      icon: '🎁',
      cost: 150,
      category: 'collectibles',
      maxQuantity: 5,
      effect: ItemEffect(
        type: EffectType.doubleStars,
        value: 10,
        description: '+10 stars',
      ),
    ),

    // Badges
    InventoryItem(
      id: 'badge_first_win',
      name: 'First Win',
      description: 'Won your first level',
      type: ItemType.badge,
      icon: '🏆',
      category: 'badges',
      maxQuantity: 1,
    ),
    InventoryItem(
      id: 'badge_perfect_10',
      name: 'Perfect 10',
      description: 'Got perfect score on 10 levels',
      type: ItemType.badge,
      icon: '🎯',
      category: 'badges',
      maxQuantity: 1,
    ),
    InventoryItem(
      id: 'badge_speed_demon',
      name: 'Speed Demon',
      description: 'Completed 5 levels in record time',
      type: ItemType.badge,
      icon: '⚡',
      category: 'badges',
      maxQuantity: 1,
    ),

    // Cosmetics
    InventoryItem(
      id: 'cosmetic_avatar_1',
      name: 'Traditional Outfit',
      description: 'Unlock traditional Filipino avatar outfit',
      type: ItemType.cosmetic,
      icon: '👘',
      cost: 500,
      category: 'cosmetics',
      maxQuantity: 1,
    ),
    InventoryItem(
      id: 'cosmetic_avatar_2',
      name: 'Modern Outfit',
      description: 'Unlock modern avatar outfit',
      type: ItemType.cosmetic,
      icon: '👤',
      cost: 500,
      category: 'cosmetics',
      maxQuantity: 1,
    ),
    InventoryItem(
      id: 'cosmetic_avatar_3',
      name: 'Festival Outfit',
      description: 'Unlock festival avatar outfit',
      type: ItemType.cosmetic,
      icon: '🎭',
      cost: 750,
      category: 'cosmetics',
      maxQuantity: 1,
    ),
  ];

  /// Get item by ID
  static InventoryItem? getItem(String id) {
    try {
      return shopItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get items by category
  static List<InventoryItem> getItemsByCategory(String category) {
    return shopItems.where((item) => item.category == category).toList();
  }

  /// Get items by type
  static List<InventoryItem> getItemsByType(ItemType type) {
    return shopItems.where((item) => item.type == type).toList();
  }

  /// Get consumable items
  static List<InventoryItem> getConsumableItems() {
    return shopItems.where((item) => item.isConsumable).toList();
  }
}
