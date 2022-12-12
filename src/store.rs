use {
    anyhow::Result,
    nativeshell::{
        codec::{value::from_value, MethodCall, MethodCallReply, Value},
        shell::{EngineHandle, MethodCallHandler, MethodChannel},
        Context,
    },
    platform_dirs::AppDirs,
    rkv::{
        backend::{SafeMode, SafeModeDatabase, SafeModeEnvironment},
        Rkv, SingleStore, StoreOptions,
    },
    std::{fs, path::PathBuf},
};

#[derive(serde::Deserialize, Debug)]
pub enum KVMode {
    CONFIG,
    CACHE,
    DATA,
}

#[derive(serde::Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct KVRequest {
    pub mode: KVMode,
    pub key: String,
    pub value: Option<Value>,
}

pub struct KvStoreChannel {
    context: Context,
    config: KvStore,
    cache: KvStore,
    data: KvStore,
}

impl KvStoreChannel {
    pub fn new(context: Context, app_dirs: AppDirs) -> Self {
        let config = KvStore::new(app_dirs.config_dir, "config");
        let cache = KvStore::new(app_dirs.cache_dir, "cache");
        let data = KvStore::new(app_dirs.data_dir, "data");

        Self {
            context,
            config,
            cache,
            data,
        }
    }

    pub fn register(self) -> MethodChannel {
        MethodChannel::new(self.context.clone(), "kv_store_channel", self)
    }

    pub fn put(&self, request: KVRequest) -> Result<()> {
        let mut writer;
        let store;
        match request.mode {
            KVMode::CONFIG => {
                writer = self.config.env.write()?;
                store = self.config.store;
            }
            KVMode::CACHE => {
                writer = self.cache.env.write()?;
                store = self.cache.store;
            }
            KVMode::DATA => {
                writer = self.data.env.write()?;
                store = self.data.store;
            }
        }

        let value = match request.value {
            Some(Value::Bool(value)) => rkv::OwnedValue::Bool(value),
            Some(Value::I64(value)) => rkv::OwnedValue::I64(value),
            Some(Value::F64(value)) => rkv::OwnedValue::F64(value.into()),
            Some(Value::String(value)) => rkv::OwnedValue::Str(value),
            _ => rkv::OwnedValue::Str("".into()),
        };

        store.put(&mut writer, request.key, &rkv::Value::from(&value))?;
        writer.commit()?;
        Ok(())
    }

    pub fn get(&self, request: KVRequest) -> Result<Value> {
        let reader;
        let store;
        match request.mode {
            KVMode::CONFIG => {
                reader = self.config.env.read()?;
                store = self.config.store;
            }
            KVMode::CACHE => {
                reader = self.cache.env.read()?;
                store = self.cache.store;
            }
            KVMode::DATA => {
                reader = self.data.env.read()?;
                store = self.data.store;
            }
        }

        let value = store.get(&reader, request.key)?;
        match value {
            Some(rkv::Value::Bool(value)) => Ok(Value::Bool(value)),
            Some(rkv::Value::I64(value)) => Ok(Value::I64(value)),
            Some(rkv::Value::F64(value)) => Ok(Value::F64(value.0)),
            Some(rkv::Value::Str(value)) => Ok(Value::String(value.into())),
            _ => Ok(Value::Null),
        }
    }
}

impl MethodCallHandler for KvStoreChannel {
    fn on_method_call(
        &mut self,
        call: MethodCall<Value>,
        reply: MethodCallReply<Value>,
        _engine: EngineHandle,
    ) {
        match call.method.as_str() {
            "get" => {
                let request: KVRequest = from_value(&call.args).unwrap();
                match self.get(request) {
                    Ok(value) => {
                        reply.send_ok(value);
                    }
                    Err(err) => {
                        reply.send_error(
                            "get error",
                            Some(format!("{}", err).as_str()),
                            Value::Null,
                        );
                    }
                }
            }
            "put" => {
                let request: KVRequest = from_value(&call.args).unwrap();
                match self.put(request) {
                    Ok(_) => {
                        reply.send_ok(Value::Null);
                    }
                    Err(err) => {
                        reply.send_error(
                            "put error",
                            Some(format!("{}", err).as_str()),
                            Value::Null,
                        );
                    }
                }
            }
            _ => {
                reply.send_error("invalid_method", Some("Invalid method"), Value::Null);
            }
        }
    }
}

pub struct KvStore {
    env: Rkv<SafeModeEnvironment>,
    store: SingleStore<SafeModeDatabase>,
}

impl KvStore {
    pub fn new(path: PathBuf, name: &str) -> Self {
        fs::create_dir_all(path.clone()).expect(format!("{} dir created", name).as_str());

        let env =
            Rkv::new::<SafeMode>(&path).expect(format!("{} store new succeeded", name).as_str());
        let store = env
            .open_single("store", StoreOptions::create())
            .expect(format!("open store {}", name).as_str());

        Self { env, store }
    }
}
