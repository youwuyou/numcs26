DIST := dist

.PHONY: html clean serve

html:
	python3 build.py

serve: html
	python3 -m http.server 8001 -d $(DIST)

clean:
	rm -rf $(DIST)
