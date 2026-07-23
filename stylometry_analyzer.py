import sys
import re
from collections import Counter

def analyze_style(text):
    words = re.findall(r'\b\w+\b', text.lower())
    sentences = re.split(r'[.!?]', text)
    sentences = [s.strip() for s in sentences if len(s.strip()) > 0]

    avg_word_length = sum(len(word) for word in words) / len(words) if words else 0
    avg_sentence_length = len(words) / len(sentences) if sentences else 0
    vocabulary_richness = len(set(words)) / len(words) if words else 0

    punctuation_marks = re.findall(r'[.,;:!?]', text)
    punctuation_freq = len(punctuation_marks) / len(sentences) if sentences else 0

    functional_words = ["the", "of", "and", "to", "a", "in", "that", "is", "was", "he", "for", "it"]
    functional_words_count = sum(words.count(word) for word in functional_words)
    functional_words_freq = functional_words_count / len(words) if words else 0

    # Combine into stylometric fingerprint
    fingerprint = {
        "avg_word_length": avg_word_length,
        "avg_sentence_length": avg_sentence_length,
        "vocabulary_richness": vocabulary_richness,
        "punctuation_freq": punctuation_freq,
        "functional_words_freq": functional_words_freq
    }

    return fingerprint

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python stylometry_analyzer.py textfile.txt")
        sys.exit(1)

    filepath = sys.argv[1]
    with open(filepath, 'r', encoding='utf-8') as file:
        text = file.read()

    fingerprint = analyze_style(text)
    print(fingerprint)
