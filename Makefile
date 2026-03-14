.PHONY: check
check: check-github-actions

.PHONY: check-github-actions
check-github-actions:
	zizmor -p .github

.PHONY: pin
pin: pin-github-actions

.PHONY: pin-github-actions
pin-github-actions:
	pinact run

.PHONY: gerbera
gerbera:
	docker build -t mirakc/timeshift-gerbera:main --build-arg prefix=main- gerbera

.PHONY: samba
samba:
	docker build -t mirakc/timeshift-samba:main --build-arg prefix=main- samba
