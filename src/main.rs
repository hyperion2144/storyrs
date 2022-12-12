#[cfg(target_os = "macos")]
#[macro_use]
extern crate objc;

use {
    crate::{
        file_open_dialog::FileOpenDialog,
        store::{KVMode, KVRequest, KvStoreChannel},
    },
    nativeshell::{
        codec::Value,
        shell::{exec_bundle, register_observatory_listener, Context, ContextOptions},
    },
    platform_dirs::AppDirs,
    std::collections::HashMap,
};

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

    let store = KvStoreChannel::new(context.weak(), app_dirs);
    let file_selector = FileOpenDialog::new(context.weak());

    // 程序启动时是否显示启动窗口, 若不显示启动窗口,则打开文件选择框，选择文件打开。
    let show_launch_window = store
        .get(KVRequest {
            mode: KVMode::CONFIG,
            key: "show_launches".to_string(),
            value: None,
        })
        .expect("get show_launch_window configure");
    let mut init_data = Value::Null;
    match show_launch_window {
        Value::Bool(show_launch_window) => {
            if !show_launch_window {
                let file = file_selector.open_file_modal();
                match file {
                    Some(file) => {
                        init_data = Value::Map(HashMap::from([
                            (
                                Value::String("class".into()),
                                Value::String("editorWindow".into()),
                            ),
                            (Value::String("filePath".into()), Value::String(file)),
                        ]));
                    }
                    _ => return,
                }
            }
        }
        _ => {}
    }

    let _kv_store_channel = store.register();
    let _file_open_dialog = file_selector.register();

    context
        .window_manager
        .borrow_mut()
        .create_window(init_data, None)
        .unwrap();

    context.run_loop.borrow().run();
}
