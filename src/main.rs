#[cfg(target_os = "macos")]
#[macro_use]
extern crate objc;

use {
    crate::{
        app_delegate::AppDelegate,
        file_open_dialog::{FileOpenDialog, FileOpenDialogChannel},
        store::{KVStore, KVStoreChannel},
        window::WindowManagerChannel,
    },
    nativeshell::{
        codec::Value,
        shell::{exec_bundle, register_observatory_listener, Context, ContextOptions},
    },
    platform_dirs::AppDirs,
    std::rc::Rc,
};

mod app_delegate;
mod file_open_dialog;
mod store;
mod window;

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

    // register channels
    let _kv_store_channel = KVStoreChannel::new(context.weak(), store.clone()).register();
    let _file_open_dialog = FileOpenDialogChannel::new(file_selector.clone()).register();
    let _window_manager_channel = WindowManagerChannel::new(context.weak()).register();

    let main_win = context
        .window_manager
        .borrow_mut()
        .create_window(Value::Null, None)
        .unwrap();

    // add app delegate
    let app_delegate = AppDelegate::new(&context, main_win, store.clone(), file_selector.clone());
    app_delegate.init_window(true);
    context
        .application_delegate_manager
        .borrow()
        .set_delegate(app_delegate);

    context.run_loop.borrow().run();
}
