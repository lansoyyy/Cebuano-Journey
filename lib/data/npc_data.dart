/// NPC (Non-Playable Character) Data
/// Character profiles, dialogue trees, and interactions
class NPC {
  final String id;
  final String name;
  final String role;
  final String description;
  final String avatar;
  final NPCType type;
  final List<DialogueNode> dialogueTree;
  final List<String> unlockedByLevel;
  final int? requiredStars;

  const NPC({
    required this.id,
    required this.name,
    required this.role,
    required this.description,
    required this.avatar,
    required this.type,
    required this.dialogueTree,
    required this.unlockedByLevel,
    this.requiredStars,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'description': description,
      'avatar': avatar,
      'type': type.name,
      'dialogueTree': dialogueTree.map((d) => d.toJson()).toList(),
      'unlockedByLevel': unlockedByLevel,
      'requiredStars': requiredStars,
    };
  }

  factory NPC.fromJson(Map<String, dynamic> json) {
    return NPC(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      description: json['description'] as String,
      avatar: json['avatar'] as String,
      type: NPCType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NPCType.tutor,
      ),
      dialogueTree: (json['dialogueTree'] as List<dynamic>)
          .map((d) => DialogueNode.fromJson(d as Map<String, dynamic>))
          .toList(),
      unlockedByLevel: (json['unlockedByLevel'] as List<dynamic>)
          .cast<String>(),
      requiredStars: json['requiredStars'] as int?,
    );
  }
}

enum NPCType { tutor, guide, merchant, friend, elder, boss }

class DialogueNode {
  final String id;
  final String speaker;
  final String text;
  final String? translation;
  final List<DialogueOption> options;
  final String? nextNodeId;

  const DialogueNode({
    required this.id,
    required this.speaker,
    required this.text,
    this.translation,
    this.options = const [],
    this.nextNodeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'speaker': speaker,
      'text': text,
      'translation': translation,
      'options': options.map((o) => o.toJson()).toList(),
      'nextNodeId': nextNodeId,
    };
  }

  factory DialogueNode.fromJson(Map<String, dynamic> json) {
    return DialogueNode(
      id: json['id'] as String,
      speaker: json['speaker'] as String,
      text: json['text'] as String,
      translation: json['translation'] as String?,
      options:
          (json['options'] as List<dynamic>?)
              ?.map((o) => DialogueOption.fromJson(o as Map<String, dynamic>))
              .toList() ??
          [],
      nextNodeId: json['nextNodeId'] as String?,
    );
  }
}

class DialogueOption {
  final String text;
  final String? translation;
  final String? nextNodeId;
  final int? requiredLevel;
  final int? requiredStars;
  final String? rewardId;

  const DialogueOption({
    required this.text,
    this.translation,
    this.nextNodeId,
    this.requiredLevel,
    this.requiredStars,
    this.rewardId,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'translation': translation,
      'nextNodeId': nextNodeId,
      'requiredLevel': requiredLevel,
      'requiredStars': requiredStars,
      'rewardId': rewardId,
    };
  }

  factory DialogueOption.fromJson(Map<String, dynamic> json) {
    return DialogueOption(
      text: json['text'] as String,
      translation: json['translation'] as String?,
      nextNodeId: json['nextNodeId'] as String?,
      requiredLevel: json['requiredLevel'] as int?,
      requiredStars: json['requiredStars'] as int?,
      rewardId: json['rewardId'] as String?,
    );
  }
}

/// NPC Database
class NPCDatabase {
  static const List<NPC> npcs = [
    // Tutorial NPC
    NPC(
      id: 'npc_tutor_lola',
      name: 'Lola Maria',
      role: 'Language Tutor',
      description: 'A wise elder who teaches Cebuano language',
      avatar: 'assets/images/npc_lola.png',
      type: NPCType.tutor,
      unlockedByLevel: ['1'],
      dialogueTree: [
        DialogueNode(
          id: 'tutor_1',
          speaker: 'Lola Maria',
          text: 'Maayong buntag, bata! Welcome to Cebuano Journey.',
          translation: 'Good morning, child! Welcome to Cebuano Journey.',
          options: [
            DialogueOption(
              text: 'Kumusta, Lola!',
              translation: 'Hello, Grandma!',
              nextNodeId: 'tutor_2',
            ),
            DialogueOption(
              text: 'Unsa man ang Cebuano?',
              translation: 'What is Cebuano?',
              nextNodeId: 'tutor_3',
            ),
          ],
        ),
        DialogueNode(
          id: 'tutor_2',
          speaker: 'Lola Maria',
          text: 'Kumusta ka! I am happy to see you. Let us learn together.',
          translation:
              'How are you! I am happy to see you. Let us learn together.',
          options: [
            DialogueOption(
              text: 'Salamat, Lola!',
              translation: 'Thank you, Grandma!',
              nextNodeId: 'tutor_end',
            ),
            DialogueOption(
              text: 'Unsa ang akong unahon?',
              translation: 'What should I do?',
              nextNodeId: 'tutor_4',
            ),
          ],
        ),
        DialogueNode(
          id: 'tutor_3',
          speaker: 'Lola Maria',
          text:
              'Cebuano is the language spoken here in the Visayas region. Many people use it!',
          translation:
              'Cebuano is the language spoken here in the Visayas region. Many people use it!',
          options: [
            DialogueOption(
              text: 'I want to learn!',
              translation: 'I want to learn!',
              nextNodeId: 'tutor_2',
            ),
          ],
        ),
        DialogueNode(
          id: 'tutor_4',
          speaker: 'Lola Maria',
          text: 'Start with the first level. Learn greetings and basic words.',
          translation:
              'Start with the first level. Learn greetings and basic words.',
          options: [
            DialogueOption(
              text: 'Adto ko!',
              translation: 'I will go!',
              nextNodeId: 'tutor_end',
            ),
          ],
        ),
        DialogueNode(
          id: 'tutor_end',
          speaker: 'Lola Maria',
          text: 'Pag-ampingon! Good luck on your journey!',
          translation: 'Good luck on your journey!',
          options: [],
        ),
      ],
    ),

    // Guide NPC
    NPC(
      id: 'npc_guide_kuya',
      name: 'Kuya Pedro',
      role: 'Village Guide',
      description: 'A friendly guide who helps players navigate the village',
      avatar: 'assets/images/npc_kuya.png',
      type: NPCType.guide,
      unlockedByLevel: ['5'],
      dialogueTree: [
        DialogueNode(
          id: 'guide_1',
          speaker: 'Kuya Pedro',
          text: 'Adto! You are doing great with your lessons.',
          translation: 'Go! You are doing great with your lessons.',
          options: [
            DialogueOption(
              text: 'Salamat, Kuya!',
              translation: 'Thank you, Kuya!',
              nextNodeId: 'guide_2',
            ),
            DialogueOption(
              text: 'Unsa ang sunod?',
              translation: 'What is next?',
              nextNodeId: 'guide_3',
            ),
          ],
        ),
        DialogueNode(
          id: 'guide_2',
          speaker: 'Kuya Pedro',
          text: 'Keep practicing every day. Practice makes perfect!',
          translation: 'Keep practicing every day. Practice makes perfect!',
          options: [
            DialogueOption(
              text: 'Oo, kuya!',
              translation: 'Yes, kuya!',
              nextNodeId: 'guide_end',
            ),
          ],
        ),
        DialogueNode(
          id: 'guide_3',
          speaker: 'Kuya Pedro',
          text: 'Try the new level. It will be challenging but fun!',
          translation: 'Try the new level. It will be challenging but fun!',
          options: [
            DialogueOption(
              text: 'Adto ko!',
              translation: 'I will go!',
              nextNodeId: 'guide_end',
            ),
          ],
        ),
        DialogueNode(
          id: 'guide_end',
          speaker: 'Kuya Pedro',
          text: 'Kita ta sunod! See you next time!',
          translation: 'See you next time!',
          options: [],
        ),
      ],
    ),

    // Merchant NPC
    NPC(
      id: 'npc_merchant_aling',
      name: 'Aling Nena',
      role: 'Item Merchant',
      description: 'Sells power-ups and collectibles',
      avatar: 'assets/images/npc_aling.png',
      type: NPCType.merchant,
      unlockedByLevel: ['3'],
      dialogueTree: [
        DialogueNode(
          id: 'merchant_1',
          speaker: 'Aling Nena',
          text: 'Maayong buntag! What can I get for you today?',
          translation: 'Good morning! What can I get for you today?',
          options: [
            DialogueOption(
              text: 'Tan-awa koy mga power-ups.',
              translation: 'Please give me power-ups.',
              nextNodeId: 'merchant_shop',
              requiredLevel: 5,
            ),
            DialogueOption(
              text: 'Wala lang, salamat.',
              translation: 'Nothing, thank you.',
              nextNodeId: 'merchant_end',
            ),
          ],
        ),
        DialogueNode(
          id: 'merchant_shop',
          speaker: 'Aling Nena',
          text: 'Here are my items. Use your coins wisely!',
          translation: 'Here are my items. Use your coins wisely!',
          options: [
            DialogueOption(
              text: 'Extra Time (+30 seconds) - 50 coins',
              translation: 'Extra Time (+30 seconds) - 50 coins',
              rewardId: 'extra_time',
            ),
            DialogueOption(
              text: 'Hint Reveal - 30 coins',
              translation: 'Hint Reveal - 30 coins',
              rewardId: 'hint_reveal',
            ),
            DialogueOption(
              text: 'Skip Level - 100 coins',
              translation: 'Skip Level - 100 coins',
              rewardId: 'skip_level',
            ),
            DialogueOption(
              text: 'Balik sunod.',
              translation: 'Come back next time.',
              nextNodeId: 'merchant_end',
            ),
          ],
        ),
        DialogueNode(
          id: 'merchant_end',
          speaker: 'Aling Nena',
          text: 'Salamat! Balik kog kung naa kayoy kinahanglan.',
          translation: 'Thank you! Come back if you have something to buy.',
          options: [],
        ),
      ],
    ),

    // Friend NPC
    NPC(
      id: 'npc_friend_pepe',
      name: 'Pepe',
      role: 'Best Friend',
      description: 'Your best friend who loves to practice Cebuano with you',
      avatar: 'assets/images/npc_pepe.png',
      type: NPCType.friend,
      unlockedByLevel: ['2'],
      dialogueTree: [
        DialogueNode(
          id: 'friend_1',
          speaker: 'Pepe',
          text: 'Kumusta ka, tol? How was your practice?',
          translation: 'How are you, friend? How was your practice?',
          options: [
            DialogueOption(
              text: 'Maayong! Naa koy bag-o.',
              translation: 'Good! I learned a lot.',
              nextNodeId: 'friend_2',
            ),
            DialogueOption(
              text: 'Medyo lisod. Lisod kaayo?',
              translation: 'A bit difficult. Was it difficult for you?',
              nextNodeId: 'friend_3',
            ),
          ],
        ),
        DialogueNode(
          id: 'friend_2',
          speaker: 'Pepe',
          text: 'Malipayon kaayo! Let us practice more together.',
          translation: 'Very happy! Let us practice more together.',
          options: [
            DialogueOption(
              text: 'Oo! Adto ta!',
              translation: 'Yes! Let us go!',
              nextNodeId: 'friend_end',
            ),
          ],
        ),
        DialogueNode(
          id: 'friend_3',
          speaker: 'Pepe',
          text: 'Dili kabalo. Lisod pud ko. But we can practice together!',
          translation:
              'No problem. It was also difficult for me. But we can practice together!',
          options: [
            DialogueOption(
              text: 'Salamat, Pepe!',
              translation: 'Thank you, Pepe!',
              nextNodeId: 'friend_end',
            ),
          ],
        ),
        DialogueNode(
          id: 'friend_end',
          speaker: 'Pepe',
          text: 'Kita sunod! Keep learning!',
          translation: 'See you next time! Keep learning!',
          options: [],
        ),
      ],
    ),

    // Elder NPC
    NPC(
      id: 'npc_elder_lolo',
      name: 'Lolo Jose',
      role: 'Village Elder',
      description: 'The wise elder who shares stories and wisdom',
      avatar: 'assets/images/npc_lolo.png',
      type: NPCType.elder,
      unlockedByLevel: ['10'],
      requiredStars: 50,
      dialogueTree: [
        DialogueNode(
          id: 'elder_1',
          speaker: 'Lolo Jose',
          text: 'Maayong hapon. You have come far, bata.',
          translation: 'Good afternoon. You have come far, child.',
          options: [
            DialogueOption(
              text: 'Kumusta po, Lolo?',
              translation: 'How are you, Grandpa?',
              nextNodeId: 'elder_2',
            ),
          ],
        ),
        DialogueNode(
          id: 'elder_2',
          speaker: 'Lolo Jose',
          text:
              'Maayo. I see you are learning our language well. This makes me happy.',
          translation:
              'Good. I see you are learning our language well. This makes me happy.',
          options: [
            DialogueOption(
              text: 'Unsa ang imong pasabot, Lolo?',
              translation: 'What is your advice, Grandpa?',
              nextNodeId: 'elder_3',
            ),
          ],
        ),
        DialogueNode(
          id: 'elder_3',
          speaker: 'Lolo Jose',
          text:
              'Continue learning with all your heart. Language is the key to understanding culture.',
          translation:
              'Continue learning with all your heart. Language is the key to understanding culture.',
          options: [
            DialogueOption(
              text: 'Salamat sa imong pagtubag, Lolo.',
              translation: 'Thank you for your wisdom, Grandpa.',
              nextNodeId: 'elder_end',
            ),
          ],
        ),
        DialogueNode(
          id: 'elder_end',
          speaker: 'Lolo Jose',
          text: 'Pag-ampingon! May you become a true Cebuano speaker.',
          translation: 'May you become a true Cebuano speaker.',
          options: [],
        ),
      ],
    ),
  ];

  /// Get NPC by ID
  static NPC? getNPC(String id) {
    try {
      return npcs.firstWhere((npc) => npc.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get NPCs by type
  static List<NPC> getNPCsByType(NPCType type) {
    return npcs.where((npc) => npc.type == type).toList();
  }

  /// Get unlocked NPCs
  static List<NPC> getUnlockedNPCs(int currentLevel, int currentStars) {
    return npcs.where((npc) {
      final levelUnlocked = npc.unlockedByLevel.any(
        (l) => int.parse(l) <= currentLevel,
      );
      final starsUnlocked =
          npc.requiredStars == null || currentStars >= npc.requiredStars!;
      return levelUnlocked && starsUnlocked;
    }).toList();
  }

  /// Check if NPC is unlocked
  static bool isNPCUnlocked(NPC npc, int currentLevel, int currentStars) {
    final levelUnlocked = npc.unlockedByLevel.any(
      (l) => int.parse(l) <= currentLevel,
    );
    final starsUnlocked =
        npc.requiredStars == null || currentStars >= npc.requiredStars!;
    return levelUnlocked && starsUnlocked;
  }
}
