/// Tutorial dialogue data — shown once to first-time players.

enum TutorialSpeaker { mc, sign, npc, narrator, info }

class TutorialLine {
  final TutorialSpeaker speaker;
  final String name;
  final String text;

  /// If non-null, display a scene-transition banner above this line.
  final String? sceneLabel;

  const TutorialLine({
    required this.speaker,
    required this.name,
    required this.text,
    this.sceneLabel,
  });
}

class TutorialData {
  static const List<TutorialLine> lines = [
    // ── Scene 1: Waking up ──────────────────────────────────────────────
    TutorialLine(
      speaker: TutorialSpeaker.narrator,
      name: 'Narrator',
      sceneLabel: 'Somewhere unknown…',
      text:
          'A blinding flash of light. Then total silence.\nYou open your eyes slowly.',
    ),
    TutorialLine(
      speaker: TutorialSpeaker.mc,
      name: 'You',
      text:
          '"Uhh… Where am I? This place… how did I even get here?"',
    ),
    TutorialLine(
      speaker: TutorialSpeaker.sign,
      name: '📋 Sign',
      text: 'Welcome, dear player.\nYou are now inside a game.',
    ),
    TutorialLine(
      speaker: TutorialSpeaker.mc,
      name: 'You',
      text: '"A game?! How do I get out of here?!"',
    ),
    TutorialLine(
      speaker: TutorialSpeaker.sign,
      name: '📋 Sign',
      text:
          'In this game, you need to learn a couple of things that will help you escape…\n\nSuch as learning a new language!',
    ),
    TutorialLine(
      speaker: TutorialSpeaker.mc,
      name: 'You',
      text: '"A language? What language might that be, huh?"',
    ),

    // ── Controls tutorial ────────────────────────────────────────────────
    TutorialLine(
      speaker: TutorialSpeaker.sign,
      name: '🎮 Controls',
      sceneLabel: 'How to play',
      text:
          'Use the ← → arrow buttons to move left and right.\n\nPress (B) to jump — you can double-jump too!\n\nPress (A) to talk to characters.\n\nPress (X) to dash forward.',
    ),
    TutorialLine(
      speaker: TutorialSpeaker.mc,
      name: 'You',
      text: '"Got it! Simple enough. Let\'s see where this goes…"',
    ),

    // ── Scene 2: Cebu marketplace ────────────────────────────────────────
    TutorialLine(
      speaker: TutorialSpeaker.narrator,
      name: 'Narrator',
      sceneLabel: 'A busy marketplace — Cebu City',
      text:
          'You step through a glowing tunnel and emerge into a bustling marketplace.\n\nThe air smells of grilled meat, ripe mangoes, and sea breeze.',
    ),
    TutorialLine(
      speaker: TutorialSpeaker.mc,
      name: 'You',
      text: '"This is… where exactly? There are so many people!"',
    ),
    TutorialLine(
      speaker: TutorialSpeaker.sign,
      name: '📋 Sign',
      text: 'Go near an NPC and press (A) to interact with them.',
    ),

    // ── NPC: Tatay Benito ────────────────────────────────────────────────
    TutorialLine(
      speaker: TutorialSpeaker.npc,
      name: 'Tatay Benito',
      sceneLabel: 'A familiar stranger…',
      text:
          '"Hoy! You don\'t look like you\'re from here. Welcome to Cebu, anak!"',
    ),
    TutorialLine(
      speaker: TutorialSpeaker.mc,
      name: 'You',
      text: '"Cebu? So… I have to learn Cebuano to escape this game?"',
    ),
    TutorialLine(
      speaker: TutorialSpeaker.npc,
      name: 'Tatay Benito',
      text:
          '"No need to worry, young one! You will learn just the basics — and I can guide you. It\'s not as hard as it sounds, haha!"',
    ),
    TutorialLine(
      speaker: TutorialSpeaker.mc,
      name: 'You',
      text: '"Okay… thank you. I\'m ready! Where do we start?"',
    ),
    TutorialLine(
      speaker: TutorialSpeaker.npc,
      name: 'Tatay Benito',
      text:
          '"First, try collecting those glowing words floating around the marketplace. They will help you in your lessons!"',
    ),

    // ── Cebuano language info card ───────────────────────────────────────
    TutorialLine(
      speaker: TutorialSpeaker.info,
      name: '📖 About Cebuano',
      sceneLabel: 'The language you will learn',
      text:
          'Cebuano (also called Bisaya or Binisaya) is spoken across the Visayas — Cebu, Bohol, Negros Oriental — and parts of Mindanao in the Philippines.\n\n'
          'In Cebuano, the verb comes first, then the subject, then the object:\n'
          '"Moadto ko sa tindahan" = "I will go to the store"\n'
          '(Moadto = will go,  ko = I,  sa tindahan = to the store)\n\n'
          'Verbs also change with tense:\n'
          '  • Mi-kaon ko = I ate\n'
          '  • Ga-kaon ko = I am eating\n'
          '  • Mo-kaon ko = I will eat',
    ),

    // ── Closing ──────────────────────────────────────────────────────────
    TutorialLine(
      speaker: TutorialSpeaker.npc,
      name: 'Tatay Benito',
      text:
          '"Kaya nimo! (You can do it!) Kada adlaw, usa ka lakang — every day, one step at a time. Now go collect those words!"',
    ),
    TutorialLine(
      speaker: TutorialSpeaker.mc,
      name: 'You',
      text:
          '"Every day, one step. I won\'t forget that. Salamat, Tatay! Let\'s go!"',
    ),
  ];
}
