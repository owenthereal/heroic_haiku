SHELL=/bin/bash -o pipefail

.PHONY: build release

build:
	flutter clean
	flutter build web -d chrome --release --dart-define=FLUTTER_WEB_USE_SKIA=true
	flutter build apk --release

release: build
	$(eval DIR := $(shell mktemp -d))
	cp -r build $(DIR)
	git checkout gh-pages
	git add .
	git stash
	cp -r $(DIR)/build/web/* .
	cp -r $(DIR)/build/app/outputs/apk/release/app-release.apk android/heroic_haiku.apk
	git add .
	git commit -m "New release"
	git push origin gh-pages
	git checkout master


