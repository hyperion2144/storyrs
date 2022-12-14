use {
    nativeshell::{
        codec::{
            value::{from_value, to_value},
            MethodCall, MethodCallReply, Value,
        },
        shell::{EngineHandle, MethodCallHandler, MethodChannel, WindowHandle},
        Context,
    },
    std::collections::HashMap,
};

#[derive(serde::Deserialize, serde::Serialize, Debug, Clone)]
#[serde(rename_all = "camelCase")]
pub struct WindowInfo {
    name: String,
    window: WindowHandle,
}

pub struct WindowManagerChannel {
    context: Context,
    window_handles: HashMap<String, WindowInfo>,
}

impl WindowManagerChannel {
    pub fn new(context: Context) -> Self {
        Self {
            context,
            window_handles: HashMap::new(),
        }
    }

    pub fn register(self) -> MethodChannel {
        MethodChannel::new(self.context.clone(), "local_window_manager_channel", self)
    }

    fn add(&mut self, window: WindowInfo) {
        self.window_handles.insert(window.name.clone(), window);
    }

    pub fn list(&self) -> Vec<&WindowInfo> {
        let mut result = vec![];
        for (_, window) in self.window_handles.iter() {
            result.push(window)
        }
        result
    }

    pub fn get(&self, name: &str) -> Option<WindowInfo> {
        self.window_handles.get(name).cloned()
    }

    pub fn remove(&mut self, name: &str) {
        self.window_handles.remove(name);
    }
}

impl MethodCallHandler for WindowManagerChannel {
    fn on_method_call(
        &mut self,
        call: MethodCall<Value>,
        reply: MethodCallReply<Value>,
        _engine: EngineHandle,
    ) {
        match call.method.as_str() {
            "add" => {
                let window: WindowInfo = from_value(&call.args).unwrap();
                self.add(window);
                reply.send_ok(Value::Null);
            }
            "list" => {
                reply.send_ok(Value::I64(self.list().len() as i64));
            }
            "get" => {
                let name: String = from_value(&call.args).unwrap();
                match self.get(name.as_str()) {
                    Some(window) => {
                        reply.send_ok(to_value(window).unwrap());
                    }
                    None => reply.send_ok(Value::Null),
                }
            }
            "remove" => {
                let name: String = from_value(&call.args).unwrap();
                self.remove(name.as_str());
                reply.send_ok(Value::Null);
            }
            _ => reply.send_error("invalid method", None, Value::Null),
        }
    }
}
