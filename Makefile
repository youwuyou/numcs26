DIST := dist

.PHONY: html clean serve watch

html:
	python3 build.py

serve: html
	python3 -m http.server 8001 -d $(DIST)

# Live-reloading dev server: rebuilds on save and auto-refreshes the browser.
watch:
	python3 dev.py

clean:
	rm -rf $(DIST)
