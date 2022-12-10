use {
    nativeshell_build::{AppBundleOptions, BuildResult, Flutter, FlutterOptions, MacOSBundle},
    std::collections::HashMap,
};

fn build_flutter() -> BuildResult<()> {
    Flutter::build(FlutterOptions {
        ..Default::default()
    })?;

    if cfg!(target_os = "macos") {
        let options = AppBundleOptions {
            bundle_name: "Storyrs.app".into(),
            bundle_display_name: "Storyrs".into(),
            icon_file: "icons/AppIcon.icns".into(),
            // info_plist_template: Some("macos/Runner/Info.plist".into()),
            info_plist_additional_args: HashMap::from([(
                "com.apple.security.files.user-selected.read-write".into(),
                "true".into(),
            )]),
            ..Default::default()
        };
        let resources = MacOSBundle::build(options)?;
        resources.mkdir("icons")?;
        resources.link("resources/mac_icon.icns", "icons/AppIcon.icns")?;
    }

    Ok(())
}

fn main() {
    if let Err(error) = build_flutter() {
        println!("\n** Build failed with error **\n\n{}", error);
        panic!();
    }
}
