.PHONY: gerbera
gerbera:
	docker build -t mirakc/timeshift-gerbera:main --build-arg prefix=main- gerbera

.PHONY: samba
samba:
	docker build -t mirakc/timeshift-samba:main --build-arg prefix=main- samba
