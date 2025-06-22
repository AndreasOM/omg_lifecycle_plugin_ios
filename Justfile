
build:
	./scripts/generate_xcframework.sh plugin debug 4.0
	./scripts/generate_xcframework.sh plugin release 4.0

copy:
	cp -R bin/plugin.debug.xcframework ../fiiish-v3/godot/ios/plugins/omg_lifecycle_plugin_ios/
	cp -R bin/plugin.release.xcframework ../fiiish-v3/godot/ios/plugins/omg_lifecycle_plugin_ios/
	cp omg_lifecycle_plugin_ios.gdip ../fiiish-v3/godot/ios/plugins/omg_lifecycle_plugin_ios/


