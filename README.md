<div>
  <img src="https://img.shields.io/github/last-commit/nahuelmol/vlc-subs"/>
  <img src="https://img.shields.io/github/languages/code-size/nahuelmol/vlc-subs"/>
  <img src="https://img.shields.io/github/languages/top/nahuelmol/vlc-subs"/>
  <img src="https://img.shields.io/github/languages/count/nahuelmol/vlc-subs"/>
</div>

### Goal

This applicaction is an extension for VLC created with the purpose of agilizing the language learning. The idea is to a build a tool that controls subtitles corresponding to the video being played by VLC. Take into account that this is meant for japanese learning and also for korean language learning.

I'am looking for:

* integation with an online dictionary through an API
* navigation between words that compounds the current caption
* flashcards creation for saving words and sentences as examples (for adding context to the word being studied)
* ciclic playing of phrases (or something like that)

### APIs

The idea is to test different alternatives for japanese that do not use key tokens:
* kanjiapi (https://kanjiapi.dev/) **(proven, working)**
* JLPT Vocabulary API
* Jisho
* Jpdb offers an alternative but it requires authentication tokens

And also for korean, which APIs look like they were mostly implemented with tokens.
* Opendict
* Krdict (opendict is based on it)


