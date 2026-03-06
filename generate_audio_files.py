#!/usr/bin/env python3
"""Generate placeholder audio files for Cebuano vocabulary words"""

import os
import json

# List of vocabulary words with their IDs
vocabulary_words = [
    # Greetings
    {'id': 'mark1', 'word': 'Ang', 'cebuano': 'Ang'},
    {'id': 'mark2', 'word': 'Si', 'cebuano': 'Si'},
    {'id': 'mark3', 'word': 'Kini', 'cebuano': 'Kini'},
    {'id': 'mark4', 'word': 'Kana', 'cebuano': 'Kana'},
    {'id': 'mark5', 'word': 'Kanaa', 'cebuano': 'Kanaa'},
    {'id': 'mark6', 'word': 'Kiniy', 'cebuano': 'Kiniy'},
    {'id': 'mark7', 'word': 'Kanay', 'cebuano': 'Kanay'},
    {'id': 'mark8', 'word': 'Kiniha', 'cebuano': 'Kiniha'},
    {'id': 'mark9', 'word': 'Kanaha', 'cebuano': 'Kanaha'},
    
    # Interrogatives
    {'id': 'int1', 'word': 'Ngano', 'cebuano': 'Ngano'},
    {'id': 'int2', 'word': 'Hain', 'cebuano': 'Hain'},
    {'id': 'int3', 'word': 'Tagpila', 'cebuano': 'Tagpila'},
    {'id': 'int4', 'word': 'Kinsay', 'cebuano': 'Kinsay'},
    {'id': 'int5', 'word': 'Kanus-a', 'cebuano': 'Kanus-a'},
    
    # Honorifics
    {'id': 'hon1', 'word': 'Manong', 'cebuano': 'Manong'},
    {'id': 'hon2', 'word': 'Manang', 'cebuano': 'Manang'},
    {'id': 'hon3', 'word': 'Toto', 'cebuano': 'Toto'},
    {'id': 'hon4', 'word': 'Inday', 'cebuano': 'Inday'},
    {'id': 'hon5', 'word': 'Nong', 'cebuano': 'Nong'},
    {'id': 'hon6', 'word': 'Nang', 'cebuano': 'Nang'},
    {'id': 'hon7', 'word': 'Dong', 'cebuano': 'Dong'},
    {'id': 'hon8', 'word': 'Day', 'cebuano': 'Day'},
    
    # Existentials
    {'id': 'ex1', 'word': 'May', 'cebuano': 'May'},
    {'id': 'ex2', 'word': 'Wala', 'cebuano': 'Wala'},
    {'id': 'ex3', 'word': 'Walâ', 'cebuano': 'Walâ'},
    {'id': 'neg1', 'word': 'Dili', 'cebuano': 'Dili'},
    {'id': 'neg2', 'word': 'Dilì', 'cebuano': 'Dilì'},
    
    # Linker
    {'id': 'link1', 'word': 'Nga', 'cebuano': 'Nga'},
    
    # Response particles
    {'id': 'res1', 'word': 'Sab', 'cebuano': 'Sab'},
    {'id': 'res2', 'word': 'Sad', 'cebuano': 'Sad'},
    {'id': 'res3', 'word': 'Pod', 'cebuano': 'Pod'},
    
    # Adjectives
    {'id': 'adj1', 'word': 'Dako', 'cebuano': 'Dako'},
    {'id': 'adj2', 'word': 'Gamay', 'cebuano': 'Gamay'},
    {'id': 'adj3', 'word': 'Taas', 'cebuano': 'Taas'},
    {'id': 'adj4', 'word': 'Mubo', 'cebuano': 'Mubo'},
    {'id': 'adj5', 'word': 'Bug-at', 'cebuano': 'Bug-at'},
    {'id': 'adj6', 'word': 'Gamay', 'cebuano': 'Gamay'},
    {'id': 'adj7', 'word': 'Bag-o', 'cebuano': 'Bag-o'},
    {'id': 'adj8', 'word': 'Daan', 'cebuano': 'Daan'},
    {'id': 'adj9', 'word': 'Maayo', 'cebuano': 'Maayo'},
    {'id': 'adj10', 'word': 'Daut', 'cebuano': 'Daut'},
    {'id': 'adj11', 'word': 'Gwapa', 'cebuano': 'Gwapa'},
    {'id': 'adj12', 'word': 'Gwapo', 'cebuano': 'Gwapo'},
    {'id': 'adj13', 'word': 'Pildi', 'cebuano': 'Pildi'},
    {'id': 'adj14', 'word': 'Pait', 'cebuano': 'Pait'},
    {'id': 'adj15', 'word': 'Tam-is', 'cebuano': 'Tam-is'},
    {'id': 'adj16', 'word': 'Aslum', 'cebuano': 'Aslum'},
    {'id': 'adj17', 'word': 'Init', 'cebuano': 'Init'},
    {'id': 'adj18', 'word': 'Bugnaw', 'cebuano': 'Bugnaw'},
    
    # Verbs
    {'id': 'act1', 'word': 'Mangaon', 'cebuano': 'Mangaon'},
    {'id': 'act2', 'word': 'Moinom', 'cebuano': 'Moinom'},
    {'id': 'act3', 'word': 'Matulog', 'cebuano': 'Matulog'},
    {'id': 'act4', 'word': 'Magsabot', 'cebuano': 'Magsabot'},
    {'id': 'act5', 'word': 'Magsulti', 'cebuano': 'Magsulti'},
    {'id': 'act6', 'word': 'Maminaw', 'cebuano': 'Maminaw'},
    {'id': 'act7', 'word': 'Mabasa', 'cebuano': 'Mabasa'},
    {'id': 'act8', 'word': 'Magsulat', 'cebuano': 'Magsulat'},
    {'id': 'act9', 'word': 'Moadto', 'cebuano': 'Moadto'},
    {'id': 'act10', 'word': 'Muli', 'cebuano': 'Muli'},
    {'id': 'act11', 'word': 'Mangita', 'cebuano': 'Mangita'},
    {'id': 'act12', 'word': 'Nagtrabaho', 'cebuano': 'Nagtrabaho'},
    {'id': 'act13', 'word': 'Nag-eskwela', 'cebuano': 'Nag-eskwela'},
    {'id': 'act14', 'word': 'Nagluto', 'cebuano': 'Nagluto'},
    {'id': 'act15', 'word': 'Lakaw', 'cebuano': 'Lakaw'},
    {'id': 'act16', 'word': 'Dagan', 'cebuano': 'Dagan'},
    
    # Body
    {'id': 'body1', 'word': 'Ulo', 'cebuano': 'Ulo'},
    {'id': 'body2', 'word': 'Baba', 'cebuano': 'Baba'},
    {'id': 'body3', 'word': 'Lingkod', 'cebuano': 'Lingkod'},
    {'id': 'body4', 'word': 'Tindog', 'cebuano': 'Tindog'},
    {'id': 'body5', 'word': 'Lakaw', 'cebuano': 'Lakaw'},
    {'id': 'body6', 'word': 'Dagan', 'cebuano': 'Dagan'},
    
    # Food
    {'id': 'food9', 'word': 'Pan', 'cebuano': 'Pan'},
    {'id': 'food10', 'word': 'Saging', 'cebuano': 'Saging'},
    {'id': 'food11', 'word': 'Manga', 'cebuano': 'Manga'},
    
    # Emotions
    {'id': 'emo1', 'word': 'Saya', 'cebuano': 'Saya'},
    {'id': 'emo2', 'word': 'Luoy', 'cebuano': 'Luoy'},
    {'id': 'emo3', 'word': 'Kabalaka', 'cebuano': 'Kabalaka'},
    {'id': 'emo4', 'word': 'Kahadlok', 'cebuano': 'Kahadlok'},
    {'id': 'emo5', 'word': 'Gutom', 'cebuano': 'Gutom'},
    {'id': 'emo6', 'word': 'Utan', 'cebuano': 'Utan'},
    {'id': 'emo7', 'word': 'Sakit', 'cebuano': 'Sakit'},
    {'id': 'emo8', 'word': 'Pahiyom', 'cebuano': 'Pahiyom'},
    {'id': 'emo9', 'word': 'Kasaba', 'cebuano': 'Kasaba'},
    
    # Weather
    {'id': 'wea1', 'word': 'Uwan', 'cebuano': 'Uwan'},
    {'id': 'wea2', 'word': 'Hangin', 'cebuano': 'Hangin'},
    {'id': 'wea3', 'word': 'Kilat', 'cebuano': 'Kilat'},
    {'id': 'wea4', 'word': 'Kahilak', 'cebuano': 'Kahilak'},
    {'id': 'wea5', 'word': 'Aldaw', 'cebuano': 'Aldaw'},
    {'id': 'wea6', 'word': 'Bulan', 'cebuano': 'Bulan'},
    {'id': 'wea7', 'word': 'Langit', 'cebuano': 'Langit'},
    {'id': 'wea8', 'word': 'Yuta', 'cebuano': 'Yuta'},
]

def create_audio_file(word_data, output_dir):
    """Create a placeholder audio file for a word"""
    word = word_data['word']
    cebuano = word_data['cebuano']
    
    # Create a simple placeholder audio file
    # In a real implementation, this would be an actual audio recording
    # For now, we'll create a text file that documents what should be recorded
    
    filename = f"{word.lower()}.txt"
    filepath = os.path.join(output_dir, filename)
    
    content = f"""Cebuano Word: {word}
    Pronunciation: /{word_data.get('pronunciation', word_data['cebuano'])}/
    English Translation: {word_data.get('english', word_data['cebuano'])}
    
    Example Sentence: {word_data.get('exampleSentence', '')}
    Example Translation: {word_data.get('exampleTranslation', '')}
    
    Recording Instructions:
    1. Speak the Cebuano word clearly
    2. Use the correct pronunciation guide
    3. Record in a quiet environment
    4. Keep the recording short (1-2 seconds)
    5. Save as MP3 format
    
    Category: {word_data.get('category', 'general')}
    Difficulty: {word_data.get('difficulty', 1)}
    """
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f"Created: {filename}")

def main():
    output_dir = 'assets/audio/voice'
    
    # Create directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)
    
    # Create audio files for each vocabulary word
    for word_data in vocabulary_words:
        create_audio_file(word_data, output_dir)
    
    # Create a manifest file
    manifest = {
        'audio_files': [f"{w['word'].lower()}.txt" for w in vocabulary_words],
        'total_files': len(vocabulary_words)
    }
    
    manifest_path = os.path.join(output_dir, 'manifest.json')
    with open(manifest_path, 'w', encoding='utf-8') as f:
        json.dump(manifest, f, indent=2)
    
    print(f"\nCreated {len(vocabulary_words)} audio files in {output_dir}")
    print(f"Created manifest file: {manifest_path}")
    print("\nNote: These are placeholder text files.")
    print("In a real implementation, replace these with actual MP3 audio files.")
    print("The audio service will need to be updated to play these files.")

if __name__ == '__main__':
    main()
