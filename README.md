# OMG Lifecycle Plugin iOS

Godot iOS plugin (`.gdip` + static xcframework) that exposes application lifecycle events and deep-link URLs to GDScript.

## API

Singleton `OMGLifecyclePlugin_iOS` (check with `Engine.has_singleton`):

- signal `received_url(url: String)` — emitted when the app is opened via a custom URL scheme while running.
- `get_last_url_string() -> String` — last received URL, including the cold-launch URL (available at startup).
- signal `application_did_become_active` — **deprecated**: use `MainLoop.NOTIFICATION_APPLICATION_RESUMED`, which is engine-native and works again since Godot 4.7. Kept for compatibility; emits a one-time warning.
- `foo()` — test method.

## Godot versions

- **4.7** — current target. Godot 4.7 exports use the UIScene lifecycle; the plugin implements both the legacy `UIApplicationDelegate` callbacks and the UIScene callbacks (`sceneDidBecomeActive:`, `scene:willConnectToSession:options:`, `scene:openURLContexts:`), so URLs work cold and warm. Requires Godot 4.7+ (4.6 never forwarded scene URL events to plugins).
- **4.5** — legacy; still buildable (`just build-45`). Last released 4.5 artifact: v0.0.0.

## Building

Needs a Godot source tree of the matching version with a few generated headers:

```
git clone --depth 1 --branch 4.7.1-stable https://github.com/godotengine/godot.git ../godot-4.7
cd ../godot-4.7
scons platform=ios target=template_debug arch=arm64 \
    core/version_generated.gen.h \
    core/extension/gdextension_interface.gen.h \
    core/disabled_classes.gen.h
```

Then in this repo:

```
mkdir -p bin
just build        # Godot 4.7 against ../godot-4.7
just build-45     # Godot 4.5 against ../godot-4.5
```

The engine tree can also be passed directly: `scons ... version=4.7 engine_path=../godot-4.7`. The build fails if the tree's version does not match the `version` flag.

## Releases

GitHub Actions builds on tag push (`v*`) or manual dispatch and attaches `omg_lifecycle_plugin_ios-<tag>-godot-4.7.zip` to a release. Unzip into your project's `godot/ios/plugins/` and enable the plugin in the iOS export preset.
