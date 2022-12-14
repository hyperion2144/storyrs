use {
    crate::{
        file_open_dialog::FileOpenDialog,
        store::{KVMode, KVRequest, KVStore},
    },
    nativeshell::{
        codec::Value,
        shell::{platform::app_delegate::ApplicationDelegate, ContextRef, WindowHandle},
        Context,
    },
    std::{borrow::Borrow, collections::HashMap, rc::Rc},
};

pub struct AppDelegate {
    context: Context,
    main_win: WindowHandle,
    store: Rc<KVStore>,
    file_selector: Rc<FileOpenDialog>,
}

impl AppDelegate {
    pub fn new(
        context: &ContextRef,
        main_win: WindowHandle,
        store: Rc<KVStore>,
        file_selector: Rc<FileOpenDialog>,
    ) -> Self {
        Self {
            context: context.weak(),
            main_win,
            store,
            file_selector,
        }
    }

    pub fn init_window(&self, launch: bool) {
        if let Some(context) = self.context.get() {
            let store = self.store.clone();
            let file_selector = self.file_selector.clone();
            let context_weak = context.weak();
            let main_win = self.main_win;

            let schedule_handle = move || {
                let show_launch_window = store
                    .get(KVRequest {
                        mode: KVMode::CONFIG,
                        key: "show_launches".to_string(),
                        value: None,
                    })
                    .expect("get show_launch_window configure");
                match show_launch_window {
                    Value::Bool(false) => {
                        AppDelegate::open_file_dialog(
                            context_weak.get().unwrap(),
                            file_selector.borrow(),
                            main_win,
                        );
                    }
                    _ => {
                        if launch {
                            context_weak
                                .get()
                                .unwrap()
                                .window_manager
                                .borrow_mut()
                                .create_window(
                                    Value::Map(HashMap::from([(
                                        Value::String("class".into()),
                                        Value::String("launchWindow".into()),
                                    )])),
                                    Some(main_win),
                                )
                                .unwrap();
                        }
                    }
                }
            };

            context
                .run_loop
                .borrow()
                .schedule_now(schedule_handle)
                .detach();
        }
    }

    fn open_file_dialog(
        context: ContextRef,
        file_selector: &FileOpenDialog,
        main_win: WindowHandle,
    ) {
        file_selector.open_file_dialog(None, move |result| match result {
            Ok(Some(name)) => {
                context
                    .window_manager
                    .borrow_mut()
                    .create_window(
                        Value::Map(HashMap::from([
                            (
                                Value::String("class".into()),
                                Value::String("editorWindow".into()),
                            ),
                            (Value::String("filePath".into()), Value::String(name)),
                        ])),
                        Some(main_win),
                    )
                    .unwrap();
            }

            _ => {}
        });
    }
}

impl ApplicationDelegate for AppDelegate {
    #[cfg(target_os = "macos")]
    fn application_should_terminate_after_last_window_closed(&mut self) -> bool {
        false
    }

    #[cfg(target_os = "macos")]
    fn application_should_handle_reopen(&mut self, _has_visible_windows: bool) -> bool {
        if !_has_visible_windows {
            if let Some(context) = self.context.get() {
                let file_selector = self.file_selector.clone();
                let context_weak = context.weak();
                let main_win = self.main_win.clone();

                context
                    .run_loop
                    .borrow()
                    .schedule_now(move || {
                        AppDelegate::open_file_dialog(
                            context_weak.get().unwrap(),
                            file_selector.borrow(),
                            main_win,
                        );
                    })
                    .detach();
            }
        }
        true
    }
}
