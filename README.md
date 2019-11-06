# chocolatey-aapt2

AAPT2 (Android Asset Packaging Tool) is a build tool that Android Studio and Android Gradle Plugin use to compile and package your app’s resources. AAPT2 parses, indexes, and compiles the resources into a binary format that is optimized for the Android platform.

See <https://developer.android.com/studio/command-line/aapt2>

## Please Note

This is an automatically updating package. It will download the latest package from dl.google.com/dl/android/maven2/com/android/tools/build/aapt2/`version`/aapt2-`version`-windows.jar. You can find all available versions at <https://dl.google.com/dl/android/maven2/com/android/tools/build/aapt2/maven-metadata.xml.>
If you find there is an update available, reinstall using `choco install aapt2 --force` and please contact the maintainer(s) to let them know the package is updated so that a new version number can be pushed.

## Package Parameters

`/Channel:['stable'|'alpha'|'beta'|'rc']` - Specify from which channel to download. Default = stable. Also defaults to stable if nonexistant, null, or whitespace. Channel:stable will download the latest full release.
Example: `choco install aapt2 --params '/Channel:beta'`
