curl -fsSL https://github.com/flutter/flutter/releases/download/3.16.0/flutter_linux_3.16.0-stable.tar.xz | tar -xJ
export PATH="$PATH:$PWD/flutter/bin"
flutter config --enable-web
flutter pub get