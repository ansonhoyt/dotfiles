# Android SDK (Hotwire Native, React Native, Kotlin)
# https://developer.android.com/tools/variables
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"

# JDK: use Android Studio's bundled JBR for CLI gradle builds
_jbr="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
[ -d "$_jbr" ] && export JAVA_HOME="$_jbr"
unset _jbr
