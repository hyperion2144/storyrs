use {
    block::ConcreteBlock,
    cocoa::{
        appkit::{NSOpenPanel, NSSavePanel},
        base::{id, nil},
        foundation::{NSArray, NSString, NSUInteger, NSURL},
    },
    nativeshell::shell::ContextRef,
    objc::{
        msg_send,
        rc::{autoreleasepool, StrongPtr},
    },
    platform_dirs::UserDirs,
    std::cell::RefCell,
};

fn from_nsstring(ns_string: id) -> String {
    use std::{os::raw::c_char, slice};
    unsafe {
        let bytes: *const c_char = msg_send![ns_string, UTF8String];
        let bytes = bytes as *const u8;
        let len = NSString::len(ns_string);
        let bytes = slice::from_raw_parts(bytes, len);
        std::str::from_utf8(bytes).unwrap().into()
    }
}

pub(super) fn open_file_dialog<F>(win: Option<StrongPtr>, _context: &ContextRef, reply: F)
where
    F: FnOnce(Option<String>) + 'static,
{
    let user_dirs = UserDirs::new().unwrap();

    autoreleasepool(|| unsafe {
        let panel = NSOpenPanel::openPanel(nil);
        let document_dir = NSURL::URLWithString_(
            nil,
            NSString::alloc(nil).init_str(user_dirs.document_dir.as_path().to_str().unwrap()),
        );
        let type_names = NSArray::arrayWithObject(nil, NSString::alloc(nil).init_str("story"));
        panel.setDirectoryURL(document_dir);
        let () = msg_send![panel, setAllowedFileTypes: type_names];

        // We know that the callback will be called only once, but rust doesn't;
        let reply = RefCell::new(Some(reply));

        let cb = move |response: NSUInteger| {
            let reply = reply.take();
            if let Some(reply) = reply {
                if response == 1 {
                    let urls: id = panel.URLs();
                    if NSArray::count(urls) > 0 {
                        let url = NSArray::objectAtIndex(urls, 0);
                        let string: id = msg_send![url, absoluteString];
                        let path = from_nsstring(string);
                        reply(Some(path));
                        return;
                    }
                }
                reply(None);
            }
        };

        let handler = ConcreteBlock::new(cb).copy();
        match win {
            None => handler.call((panel.runModal() as u64,)),
            Some(win) => msg_send![panel, beginSheetModalForWindow:win completionHandler:&*handler],
        }
    });
}
