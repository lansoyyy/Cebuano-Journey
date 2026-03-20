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
      title: 'World 1 · Street Food Market',
      sceneSetting: 'Mercado district, Cebu City',
      mcThoughts: [
        'I now have some ideas about the Cebuano language…',
        "I'm feeling thirsty. Maybe I can try buying something at the street food stalls!",
        'Let me collect some vocabulary first, then try to order.',
      ],
    ),
    '1_2': LevelNarrative(
      title: 'World 1 · Plaza Independencia',
      sceneSetting: 'A sunny plaza near the clock tower',
      mcThoughts: [
        "I've been travelling for hours now…",
        "I don't have a watch. I should ask someone what time it is.",
        'But how do I ask that in Cebuano?',
      ],
    ),
    '1_3': LevelNarrative(
      title: 'World 1 · Mactan Waterfront',
      sceneSetting: 'By the Mactan Channel, coconut palms swaying',
      mcThoughts: [
        "I'm doing great — but small talk is the next challenge.",
        'I need to learn some conversational phrases.',
        'Maybe someone here can help me practice!',
      ],
    ),
    '1_4': LevelNarrative(
      title: 'World 1 · Sinulog Festival',
      sceneSetting: 'Fuente Osmeña Boulevard — festival banners everywhere',
      mcThoughts: [
        '"Viva Pit Señor!" — The energy here is unbelievable!',
        'This must be the famous Sinulog festival.',
        'I need to learn the festival words to join in!',
      ],
    ),
    '1_5': LevelNarrative(
      title: 'World 1 · Cebu Heritage District',
      sceneSetting: 'Cobblestone streets near Magellan\'s Cross',
      mcThoughts: [
        'The history here is incredible…',
        'Every corner tells a story.',
        'I wonder what the locals call these places in Cebuano.',
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
  static const Map<String, List<NpcDialogueLine>> _preNPCDialogue = {
    // World 1, Level 1 ────────────────────────────────────────────────────
    '1_1_0': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"Huy! Come here, anak. I can see you\'re new here — let me test what you know!"',
      ),
      NpcDialogueLine(
        isPlayer: true,
        text: '"Okay, I\'m ready. Let\'s try!"',
      ),
    ],
    '1_1_1': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"Kumusta! You\'ve been collecting words, I see. Let\'s see how well you remember them."',
      ),
      NpcDialogueLine(
        isPlayer: true,
        text: '"Sure! I\'ve picked up quite a few along the way."',
      ),
    ],
    '1_1_2': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"Wow, you made it this far! Time for your final challenge in this area — are you ready?"',
      ),
      NpcDialogueLine(
        isPlayer: true,
        text: '"I can do it! Kaya nako!"',
      ),
    ],

    // World 1, Level 2 — Asking the time ─────────────────────────────────
    '1_2_0': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"You look a bit lost, friend! Are you trying to find out the time?"',
      ),
      NpcDialogueLine(
        isPlayer: true,
        text: '"Yes! But… how do I ask in Cebuano?"',
      ),
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"I can help you with that — but first, answer a few questions for me!"',
      ),
    ],
    '1_2_1': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"Oy! Pagal ka na? Pila na ka oras? — Tired already? What time is it?"',
      ),
      NpcDialogueLine(
        isPlayer: true,
        text: '"Ha, I\'m not sure… Let\'s figure this out together!"',
      ),
    ],
    '1_2_2': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"You\'ve learned how to ask the time — impressive! One last quiz before you go."',
      ),
      NpcDialogueLine(
        isPlayer: true,
        text: '"Bring it on! Andam na ko!"',
      ),
    ],

    // World 1, Level 3 — Small talk ───────────────────────────────────────
    '1_3_0': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"Hoy! Diin ka gikan? — Hey, where are you from? You\'re not local, are you?"',
      ),
      NpcDialogueLine(
        isPlayer: true,
        text: '"Ha! I\'m just visiting. Nice to meet you!"',
      ),
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"Well then, let\'s have a little chat! I\'ll start you off with some questions."',
      ),
    ],
    '1_3_1': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"Kumusta ka? — How are you? Small talk is important in Cebuano culture. Let me quiz you!"',
      ),
      NpcDialogueLine(
        isPlayer: true,
        text: '"Maayo ko! I\'m good — I think!"',
      ),
    ],
    '1_3_2': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"You\'re almost a local now, haha! Last challenge for this area — show me what you\'ve got."',
      ),
      NpcDialogueLine(
        isPlayer: true,
        text: '"Sige! Let\'s do it!"',
      ),
    ],

    // World 1, Level 4 — Sinulog Festival ─────────────────────────────────
    '1_4_0': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"Welcome to the Grand Sinulog Procession! Every chant of \'Pit Señor\' is a prayer of gratitude."',
      ),
      NpcDialogueLine(
        isPlayer: true,
        text: '"This is amazing! Teach me the festival words!"',
      ),
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"Of course! First — let\'s see if you can handle a festival quiz. ¡Viva Pit Señor!"',
      ),
    ],
    '1_4_1': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"The procession is moving! Keep up — and answer my questions as we march."',
      ),
      NpcDialogueLine(
        isPlayer: true,
        text: '"I can march and quiz at the same time — challenge accepted!"',
      ),
    ],
    '1_4_2': [
      NpcDialogueLine(
        isPlayer: false,
        text:
            '"You\'ve almost learned all the Sinulog vocabulary. Final round — make Cebu proud!"',
      ),
      NpcDialogueLine(
        isPlayer: true,
        text: '"Pit Señor! Here we go!"',
      ),
    ],
  };

  /// Returns the level narrative intro for the given world/level, or null.
  static LevelNarrative? getIntro(int world, int level) =>
      _narratives['${world}_$level'];

  /// Returns the pre-quiz NPC dialogue for the specified NPC, or null.
  static List<NpcDialogueLine>? getPreNPCDialogue(
      int world, int level, int npcIndex) =>
      _preNPCDialogue['${world}_${level}_$npcIndex'];
}
