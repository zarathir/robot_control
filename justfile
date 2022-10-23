default: gen lint

gen:
    flutter pub get
    flutter_rust_bridge_codegen \
        --rust-input robot_node/src/api.rs \
        --dart-output lib/bridge_generated.dart \
        --c-output ios/Runner/bridge_generated.h \
        --c-output macos/Runner/bridge_generated.h \
        --dart-decl-output lib/bridge_definitions.dart \
        --wasm

lint:
    cd robot_node && cargo fmt
    dart format .

clean:
    flutter clean
    cd robot_node && cargo clean
    
serve *args='':
    flutter pub run flutter_rust_bridge:serve {{args}}