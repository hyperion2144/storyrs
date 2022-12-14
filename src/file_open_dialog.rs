use {
    anyhow::{Error, Result},
    nativeshell::{
        codec::{value::from_value, MethodCall, MethodCallReply, Value},
        shell::{Context, MethodCallHandler, MethodChannel, WindowHandle},
    },
    std::rc::Rc,
};

#[derive(serde::Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
struct FileOpenRequest {
    parent_window: WindowHandle,
}

#[cfg(target_os = "macos")]
#[path = "file_open_dialog_mac.rs"]
mod platform;

#[cfg(target_os = "windows")]
#[path = "file_open_dialog_win.rs"]
mod platform;

#[cfg(target_os = "linux")]
#[path = "file_open_dialog_linux.rs"]
mod platform;

pub struct FileOpenDialog {
    context: Context,
}

impl FileOpenDialog {
    pub fn new(context: Context) -> Self {
        Self { context }
    }

    pub fn open_file_dialog<F>(&self, parent_window: Option<WindowHandle>, reply: F)
    where
        F: FnOnce(Result<Option<String>>) + 'static,
    {
        if let Some(context) = self.context.get() {
            match parent_window {
                None => platform::open_file_dialog(None, &context, |name| reply(Ok(name))),
                Some(parent_window) => {
                    let win = context
                        .window_manager
                        .borrow()
                        .get_platform_window(parent_window);
                    match win {
                        None => reply(Err(Error::msg("Platform window not found"))),
                        Some(_) => {
                            platform::open_file_dialog(win, &context, |name| reply(Ok(name)))
                        }
                    }
                }
            }
        }
    }
}

pub struct FileOpenDialogChannel {
    file_open_dialog: Rc<FileOpenDialog>,
}

impl FileOpenDialogChannel {
    pub fn new(file_open_dialog: Rc<FileOpenDialog>) -> Self {
        Self { file_open_dialog }
    }

    pub fn register(self) -> MethodChannel {
        MethodChannel::new(
            self.file_open_dialog.context.clone(),
            "file_open_dialog_channel",
            self,
        )
    }
}

impl MethodCallHandler for FileOpenDialogChannel {
    fn on_method_call(
        &mut self,
        call: MethodCall<Value>,
        reply: MethodCallReply<Value>,
        _engine: nativeshell::shell::EngineHandle,
    ) {
        match call.method.as_str() {
            "showFileOpenDialog" => {
                let request: FileOpenRequest = from_value(&call.args).unwrap();
                self.file_open_dialog
                    .open_file_dialog(Some(request.parent_window), |result| match result {
                        Ok(name) => match name {
                            None => reply.send_ok(Value::Null),
                            Some(name) => reply.send_ok(Value::String(name)),
                        },
                        Err(err) => reply.send_error(
                            "no_window",
                            Some(format!("{}", err).as_str()),
                            Value::Null,
                        ),
                    });
            }
            _ => {
                reply.send_error("invalid_method", Some("Invalid method"), Value::Null);
            }
        }
    }
}
