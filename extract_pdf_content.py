#!/usr/bin/env python3
"""Extract and format Cebuano learning content from PDF"""

import PyPDF2
import re
import json

def extract_pdf_content(pdf_path):
    """Extract text from PDF"""
    pdf = open(pdf_path, 'rb')
    reader = PyPDF2.PdfReader(pdf)
    text = ''
    for page in reader.pages:
        text += page.extract_text() + '\n\n'
    pdf.close()
    return text

def extract_lessons(text):
    """Extract lesson content from text"""
    lessons = []
    
    # Find lesson sections
    lesson_pattern = r'Lesson\s+(\d+):\s*([^\n]+)'
    lesson_matches = list(re.finditer(lesson_pattern, text))
    
    for i, match in enumerate(lesson_matches):
        lesson_num = match.group(1)
        lesson_title = match.group(2)
        start_pos = match.start()
        
        # Find end of this lesson (start of next lesson or end of text)
        if i < len(lesson_matches) - 1:
            end_pos = lesson_matches[i + 1].start()
        else:
            end_pos = len(text)
        
        lesson_text = text[start_pos:end_pos]
        
        lessons.append({
            'number': int(lesson_num),
            'title': lesson_title.strip(),
            'content': lesson_text
        })
    
    return lessons

def extract_vocabulary(text):
    """Extract vocabulary words with translations"""
    vocabulary = []
    
    # Pattern for Cebuano word - English translation
    # Look for patterns like: "Word - Translation" or "Word: Translation"
    vocab_patterns = [
        r'([A-Za-zâêîôûàèìòùáéíóúñÑ]+)\s*[-–:]\s*([A-Za-zâêîôûàèìòùáéíóúñÑ\s/]+)',
        r'([A-Za-zâêîôûàèìòùáéíóúñÑ]+)\s*\(\s*([A-Za-zâêîôûàèìòùáéíóúñÑ\s/]+)\s*\)',
    ]
    
    for pattern in vocab_patterns:
        matches = re.finditer(pattern, text)
        for match in matches:
            word = match.group(1).strip()
            translation = match.group(2).strip()
            
            # Filter out common words and short matches
            if len(word) > 2 and len(translation) > 2:
                # Check if already exists
                if not any(v['cebuano'].lower() == word.lower() for v in vocabulary):
                    vocabulary.append({
                        'cebuano': word,
                        'english': translation,
                        'pronunciation': ''  # Will be filled later
                    })
    
    return vocabulary

def extract_dialogues(text):
    """Extract dialogue/conversation examples"""
    dialogues = []
    
    # Find conversation sections
    conversation_pattern = r'Conversation:\s*([^\n]+)\s*(.*?)(?=\n\s*(?:Lesson|Vocabulary|Conversation:|$))'
    conversation_matches = re.finditer(conversation_pattern, text, re.DOTALL)
    
    for match in conversation_matches:
        title = match.group(1).strip()
        content = match.group(2).strip()
        
        dialogues.append({
            'title': title,
            'content': content
        })
    
    return dialogues

def main():
    pdf_path = 'CEB4Learners-Module-1-Final.pdf'
    
    print("Extracting PDF content...")
    text = extract_pdf_content(pdf_path)
    
    print("Extracting lessons...")
    lessons = extract_lessons(text)
    print(f"Found {len(lessons)} lessons")
    
    print("Extracting vocabulary...")
    vocabulary = extract_vocabulary(text)
    print(f"Found {len(vocabulary)} vocabulary words")
    
    print("Extracting dialogues...")
    dialogues = extract_dialogues(text)
    print(f"Found {len(dialogues)} dialogues")
    
    # Save to JSON
    output = {
        'lessons': lessons,
        'vocabulary': vocabulary,
        'dialogues': dialogues
    }
    
    with open('pdf_content_extracted.json', 'w', encoding='utf-8') as f:
        json.dump(output, f, indent=2, ensure_ascii=False)
    
    print("Content saved to pdf_content_extracted.json")
    
    # Print sample vocabulary
    print("\nSample vocabulary:")
    for i, word in enumerate(vocabulary[:20]):
        print(f"  {word['cebuano']} - {word['english']}")

if __name__ == '__main__':
    main()
