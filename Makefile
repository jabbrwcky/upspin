btime = $(shell date +%Y%m%d%H%M)

.PHONY : build .ts publish

.ts :
	echo $(btime) > .ts

build : .ts
	docker build . -t upspin:$(btime) -t upspin:latest

publish : btime = $(shell cat .ts)
publish : .ts 
	docker tag upspin:$(btime) jabbrwcky/upspin:latest
	docker tag upspin:$(btime) jabbrwcky/upspin:$(btime) 
	docker push jabbrwcky/upspin:latest
