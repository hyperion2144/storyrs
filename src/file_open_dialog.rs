use {
    anyhow::Error,
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

    pub fn open_file_dialog(
        &self,
        parent_window: Option<WindowHandle>,
    ) -> anyhow::Result<Option<String>> {
        if let Some(context) = self.context.get() {
            return match parent_window {
                None => Ok(platform::open_file_dialog(None, &context)),
                Some(parent_window) => {
                    let win = context
                        .window_manager
                        .borrow()
                        .get_platform_window(parent_window);
                    match win {
                        None => Err(Error::msg("Platform window not found")),
                        Some(_) => Ok(platform::open_file_dialog(win, &context)),
                    }
                }
            };
        }
        Ok(None)
    }
}

pub struct FileOpenDialogChannel {
    file_open_dialog: Rc<FileOpenDialog>,
}

impl FileOpenDialogChannel {
    pub fn new(file_open_dialog: Rc<FileOpenDialog>) -> Self {
        Self { file_open_dialog }
    }

    pub fn register(self, context: Context) -> MethodChannel {
        MethodChannel::new(context, "file_open_dialog_channel", self)
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
                match self
                    .file_open_dialog
                    .open_file_dialog(Some(request.parent_window))
                {
                    Ok(name) => match name {
                        None => reply.send_ok(Value::Null),
                        Some(name) => reply.send_ok(Value::String(name)),
                    },
                    Err(err) => reply.send_error(
                        "no_window",
                        Some(format!("{}", err).as_str()),
                        Value::Null,
                    ),
                }
            }
            _ => {
                reply.send_error("invalid_method", Some("Invalid method"), Value::Null);
            }
        }
    }
}
