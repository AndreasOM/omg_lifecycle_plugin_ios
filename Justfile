
# NOTE: bin/ artifact names are shared across versions - copy artifacts out before switching.
build: build-47

build-47:
	./scripts/generate_xcframework.sh plugin debug 4.7 ../godot-4.7
	./scripts/generate_xcframework.sh plugin release 4.7 ../godot-4.7

build-45:
	./scripts/generate_xcframework.sh plugin debug 4.5 ../godot-4.5
	./scripts/generate_xcframework.sh plugin release 4.5 ../godot-4.5

copy:
	cp -R bin/plugin.debug.xcframework ../fiiish-v3/godot/ios/plugins/omg_lifecycle_plugin_ios/
	cp -R bin/plugin.release.xcframework ../fiiish-v3/godot/ios/plugins/omg_lifecycle_plugin_ios/
	cp omg_lifecycle_plugin_ios.gdip ../fiiish-v3/godot/ios/plugins/omg_lifecycle_plugin_ios/


