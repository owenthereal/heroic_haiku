# Heroic Haiku

[Heroic Haiku](https://en.wikipedia.org/wiki/Heroku#Etymology) is a game powered by [Flutter](https://flutter.dev) and [Flame](https://flame-engine.org).
It is an excercise that I did to re-learn Flutter.
The game is heavily inspired by [Chrome's Dino Game](https://www.blog.google/products/chrome/chrome-dino).

## Demo

I am impressed that the web and mobile version behave pretty much the same! It is really "write once, run everywhere"!

* [Web](https://owenthereal.github.io/heroic_haiku)
* [Android](https://owenthereal.github.io/heroic_haiku/android/heroic_haiku.apk)

## Build

```
$ flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=true
$ flutter build android --release
$ flutter build ios --release
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Reference

* https://www.blog.google/products/chrome/chrome-dino
* https://github.com/flame-engine/trex-flame
