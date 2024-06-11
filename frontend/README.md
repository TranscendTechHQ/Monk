To create TestFlight

- Do this once
  sudo gem uninstall ffi && sudo gem install ffi -- --enable-libffi-alloc

- On Xcode
  - open Runner
  - in the Xcode menu, click product->archive
  - if needed, run 'cd macos;pod install' 
