build:
	docker build -t issakuss/docdock:latest .

run:
	docker run -itd --name issakdoc \
               -v /home/vermeer/issakuss/Zotero:/home/issakuss/Zotero \
               --mount type=bind,source=/home/vermeer/issakuss/,target=/mnt \
			   issakuss/docdock:latest

exec:
	docker exec -it -u $(shell id -u) issakdoc bash

rm:
	docker rm -f issakdoc
