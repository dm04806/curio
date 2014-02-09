start:
	@gnode `which coffee` `which brunch` watch --server

copyfont:
	@cp -v ~/Downloads/curio/fonts/curio.* app/assets/css/fonts/
	@cp -v ~/Downloads/curio/style.css vendor/font-icons.css
	#@rm -rf ~/Downloads/curio.zip ~/Downloads/curio/

deploy:
	@npm install
	@bower install
	@brunch build --production
