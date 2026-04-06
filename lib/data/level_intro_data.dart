/// Per-level narrative introductions and NPC pre-quiz dialogue.

class LevelNarrative {
  final String title;
  final String sceneSetting;
  final List<String> mcThoughts;

  const LevelNarrative({
    required this.title,
    required this.sceneSetting,
    required this.mcThoughts,
  });
}

/// A single line in a pre-quiz NPC dialogue sequence.
class NpcDialogueLine {
  /// Whether this line is spoken by the player (true) or the NPC (false).
  final bool isPlayer;
  final String text;

  const NpcDialogueLine({required this.isPlayer, required this.text});
}

class LevelIntroData {
  // ── Level narrative intros ─────────────────────────────────────────────
  static const Map<String, LevelNarrative> _narratives = {
    '1_1': LevelNarrative(
      title: 'World 1 · Introduction to Cebuano',
      sceneSetting: 'Mercado district, Cebu City',
      mcThoughts: [
        'This is my first real step into Cebuano.',
        'Before I talk to anyone, I should learn what Cebuano is and how people use it every day.',
        'There is a sign ahead. Maybe it has the introduction I need before the first quiz.',
      ],
    ),
    '1_2': LevelNarrative(
      title: 'World 1 · Counting at the Market',
      sceneSetting: 'A busy stall with baskets, fruit, and price boards',
      mcThoughts: [
        'Now that I know a few Cebuano words, I need to count items and prices.',
        'If I want to order properly, I should practice numbers first.',
        'I hope the vendors here can help me count in Cebuano.',
      ],
    ),
    '1_3': LevelNarrative(
      title: 'World 1 · Ordering Food',
      sceneSetting: 'Rows of barbecue stalls near the plaza',
      mcThoughts: [
        'I can count now, but ordering food is a different challenge.',
        'I need to use short Cebuano phrases that feel natural in a real stall.',
        'Maybe this level will teach me how to place a simple order.',
      ],
    ),
    '1_4': LevelNarrative(
      title: 'World 1 · Asking for the Time',
      sceneSetting: 'A shaded plaza near a clock tower',
      mcThoughts: [
        'I already know how to greet, count, and order a little.',
        'The next useful skill is asking what time it is.',
        'If I miss the time, I might miss my next ride too.',
      ],
    ),
    '1_5': LevelNarrative(
      title: 'World 1 · Everyday Conversation',
      sceneSetting: 'A relaxed street corner with locals chatting nearby',
      mcThoughts: [
        'I have learned the basics. Now I need to answer naturally in conversation.',
        'Short replies, matching words, and context clues will matter more now.',
        'Let me see if I can keep up with a real Cebuano exchange.',
      ],
    ),
    '2_1': LevelNarrative(
      title: 'World 2 · Colon Street',
      sceneSetting: 'The oldest street in the Philippines',
      mcThoughts: [
        'I reached World 2! Things are getting more challenging.',
        'The streets here are full of life and conversation.',
        "Let's see if my Cebuano skills are good enough!",
      ],
    ),
  };

  // ── NPC pre-quiz dialogue ──────────────────────────────────────────────
  // Key format: "${world}_${level}_${npcIndex}" (0-based NPC index in level)
  static const List<NpcDialogueLine> _introSignDialogue = [
    NpcDialogueLine(
      isPlayer: false,
      text:
          '"Introduction to Cebuano: Cebuano, also called Bisaya or Binisaya, is one of the main languages spoken in Cebu and many parts of the Visayas and Mindanao."',
    ),
    NpcDialogueLine(
      isPlayer: true,
      text: '"So this is the language I need to learn here."',
    ),
    NpcDialogueLine(
      isPlayer: false,
      text:
          '"Start with simple greetings, polite words, and everyday phrases. Talk to people, collect words, and use each quiz to practice in context."',
    ),
    NpcDialogueLine(
      isPlayer: false,
      text:
          '"Tutorial: Move with the arrows, press B to jump, press X to dash, and press A to interact with signs and NPCs before taking quizzes."',
    ),
    NpcDialogueLine(
      isPlayer: true,
      text:
          '"Got it. Read the sign, talk to the locals, then answer the quiz."',
    ),
  ];

  static const Map<String, List<NpcDialogueLine>> _preNPCDialogue = {
    // World 1, Level 1 ────────────────────────────────────────────────────
    '1_1_0': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"Maayong buntag! Since this is your first day, let us start with greetings and polite Cebuano words you will hear all the time."',
      ),
      NpcDialogueLine(
        isPlayer: true,
        text: '"Perfect. I want to answer properly when I meet people here."',
      ),
    ],
    '1_1_1': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"Kumusta! If someone greets you or says salamat, you should know how to respond. Let us practice those basics."',
      ),
      NpcDialogueLine(
        isPlayer: true,
        text: '"Sige. I am ready for a few everyday Cebuano questions."',
      ),
    ],
    '1_1_2': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"One more round. Think of this as your first real conversation checkpoint before moving deeper into Cebu."',
      ),
      NpcDialogueLine(
        isPlayer: true,
        text: '"Kaya nako! Let me show that I understand the basics."',
      ),
    ],

    // World 1, Level 2 — Numbers and counting ─────────────────────────────
    '1_2_0': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"If you want to order in the market, you need numbers first. How many bananas? How much water? Let us count in Cebuano."',
      ),
      NpcDialogueLine(
        isPlayer: true,
        text:
            '"That makes sense. I should learn the numbers before I buy anything."',
      ),
      NpcDialogueLine(
        isPlayer: false,
        text: '"Exactly. Answer these first, then ordering will feel easier."',
      ),
    ],
    '1_2_1': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"A customer might say duha ka tubig or tulo ka puso. You need to catch the number right away."',
      ),
      NpcDialogueLine(
        isPlayer: true,
        text: '"Okay. I will listen carefully and count in Cebuano."',
      ),
    ],
    '1_2_2': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"Last round for numbers. Once you pass this, you can start building small ordering phrases too."',
      ),
      NpcDialogueLine(isPlayer: true, text: '"Andam na ko. Let us count!"'),
    ],

    // World 1, Level 3 — Ordering food ────────────────────────────────────
    '1_3_0': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"Hungry? Good. This is the best time to practice ordering. Listen to the food words and short request phrases."',
      ),
      NpcDialogueLine(
        isPlayer: true,
        text: '"Yes. I want to ask for food without sounding lost."',
      ),
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"Then answer these first. They are the same kinds of words you will use at the stall."',
      ),
    ],
    '1_3_1': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"Try to picture a real order: please, water, rice, fish. The quiz will sound more natural if you imagine that scene."',
      ),
      NpcDialogueLine(
        isPlayer: true,
        text: '"Sige. I will think like I am already ordering dinner."',
      ),
    ],
    '1_3_2': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"Final order check. Put the words together the way a customer would say them."',
      ),
      NpcDialogueLine(
        isPlayer: true,
        text: '"Palihug, one more quiz. I am ready."',
      ),
    ],

    // World 1, Level 4 — Asking the time ─────────────────────────────────
    '1_4_0': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"You have the basics now. Next, learn how to ask for the time and understand time-related clues in Cebuano."',
      ),
      NpcDialogueLine(
        isPlayer: true,
        text: '"Right. If I miss the time, I miss the plan."',
      ),
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"Then let me test you with time words, quick responses, and useful phrases."',
      ),
    ],
    '1_4_1': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"When someone says a time expression, answer clearly and quickly. That is what this round is for."',
      ),
      NpcDialogueLine(
        isPlayer: true,
        text: '"Okay. I will treat this like a real question on the street."',
      ),
    ],
    '1_4_2': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"One last timing challenge. After this, you should be able to ask and respond with more confidence."',
      ),
      NpcDialogueLine(
        isPlayer: true,
        text: '"Here we go. Unsa na orasa? I am ready to learn."',
      ),
    ],

    // World 1, Level 5 — Conversation and matching ──────────────────────
    '1_5_0': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"Now we go beyond single words. Listen to the situation and choose the most natural response."',
      ),
      NpcDialogueLine(
        isPlayer: true,
        text: '"So this round is more like a real conversation."',
      ),
    ],
    '1_5_1': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"Some questions will ask you to match Cebuano words with their meanings. Think fast and connect them correctly."',
      ),
      NpcDialogueLine(
        isPlayer: true,
        text: '"Got it. I need to understand, not just memorize."',
      ),
    ],
    '1_5_2': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"Final checkpoint. A little conversation, a little matching, and a little confidence."',
      ),
      NpcDialogueLine(
        isPlayer: true,
        text: '"Maayo. Let me finish World 1 strong."',
      ),
    ],
  };

  /// Returns the level narrative intro for the given world/level, or null.
  static LevelNarrative? getIntro(int world, int level) =>
      _narratives['${world}_$level'];

  /// Returns the intro sign dialogue shown before the first level quiz.
  static List<NpcDialogueLine>? getIntroSignDialogue(int world, int level) {
    if (world == 1 && level == 1) {
      return _introSignDialogue;
    }
    return null;
  }

  /// Returns the pre-quiz NPC dialogue for the specified NPC, or null.
  static List<NpcDialogueLine>? getPreNPCDialogue(
    int world,
    int level,
    int npcIndex,
  ) => _preNPCDialogue['${world}_${level}_$npcIndex'];
}
