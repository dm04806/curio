start:
	@gnode `which coffee` `which brunch` watch --server

server:
	@gnode `which coffee` `which brunch` watch -P --server

build:
	rm -rf ./bower_components/
	bower install
	npm install --production
	brunch build --production

extract_fonts:
	@rm -rf ./misc/curio
	@unzip ./misc/curio.zip -d ./misc/curio
	@cp -v ./misc/curio/style.css ./vendor/font-icons.css
	@cp -v ./misc/curio/fonts/* ./app/assets/css/fonts/

deploy:
	@npm install
	@bower install
	@brunch build --production
