start:
	@gnode `which coffee` `which brunch` watch --server

deploy:
	@npm install
	@bower install
	@brunch build --production
