#[cfg(target_os = "macos")]
#[macro_use]
extern crate objc;

use {
    crate::{app_delegate::AppDelegate, file_open_dialog::FileOpenDialog, store::KVStore},
    nativeshell::shell::{exec_bundle, register_observatory_listener, Context, ContextOptions},
    platform_dirs::AppDirs,
    std::rc::Rc,
};

mod app_delegate;
mod file_open_dialog;
mod store;

nativeshell::include_flutter_plugins!();

fn main() {
    exec_bundle();
    register_observatory_listener("storyrs".into());

    env_logger::builder().format_timestamp(None).init();

    let context = Context::new(ContextOptions {
        app_namespace: "Storyrs".into(),
        flutter_plugins: flutter_get_plugins(),
        ..Default::default()
    });

    let context = context.unwrap();
    let app_dirs = AppDirs::new(Some("storyrs"), true).unwrap();

    let store = Rc::new(KVStore::new(app_dirs));
    let file_selector = Rc::new(FileOpenDialog::new(context.weak()));
    let app_delegate = AppDelegate::new(&context, store.clone(), file_selector.clone());

    context
        .application_delegate_manager
        .borrow()
        .set_delegate(app_delegate);

    loop {
        context.run_loop.borrow().run();
    }
}
