use {
    crate::{
        file_open_dialog::{FileOpenDialog, FileOpenDialogChannel},
        store::{KVMode, KVRequest, KVStore, KVStoreChannel},
    },
    nativeshell::{
        codec::Value,
        shell::{platform::app_delegate::ApplicationDelegate, ContextRef},
        Context,
    },
    std::{collections::HashMap, rc::Rc},
};

pub struct AppDelegate {
    context: Context,
    store: Rc<KVStore>,
    file_selector: Rc<FileOpenDialog>,
}

impl AppDelegate {
    pub fn new(
        context: &ContextRef,
        store: Rc<KVStore>,
        file_selector: Rc<FileOpenDialog>,
    ) -> Self {
        // register channels
        let _kv_store_channel = KVStoreChannel::new(context.weak(), store.clone()).register();
        let _file_open_dialog =
            FileOpenDialogChannel::new(file_selector.clone()).register(context.weak());

        Self {
            context: context.weak(),
            store,
            file_selector,
        }
    }

    fn init_window(&self) {
        if let Some(context) = self.context.get() {
            let store = self.store.clone();
            let file_selector = self.file_selector.clone();
            let context_weak = context.weak();

            context
                .run_loop
                .borrow()
                .schedule_now(move || {
                    // 程序启动时是否显示启动窗口, 若不显示启动窗口,则打开文件选择框，选择文件打开。
                    let init_data = AppDelegate::select_file_init_data(store, file_selector);
                    if let Some(init_data) = init_data {
                        context_weak
                            .get()
                            .unwrap()
                            .window_manager
                            .borrow_mut()
                            .create_window(init_data, None)
                            .unwrap();
                    }
                })
                .detach();
        }
    }

    fn select_file_init_data(
        store: Rc<KVStore>,
        file_selector: Rc<FileOpenDialog>,
    ) -> Option<Value> {
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
                    let file = file_selector.open_file_dialog(None).unwrap();
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
                        _ => return None,
                    }
                }
            }
            _ => {}
        }
        Some(init_data)
    }
}

impl ApplicationDelegate for AppDelegate {
    fn application_did_finish_launching(&mut self) {
        self.init_window();
    }

    fn application_should_terminate_after_last_window_closed(&mut self) -> bool {
        false
    }

    fn application_should_handle_reopen(&mut self, _has_visible_windows: bool) -> bool {
        if !_has_visible_windows {
            self.init_window();
        }
        true
    }
}
