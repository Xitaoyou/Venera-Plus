# Venera+ custom iOS edition

Fork: https://github.com/Xitaoyou/Venera-Plus

Features:
- Drag down to exit an unzoomed horizontal comic reader.
- Existing "Swipe" picture collection takes precedence; user sees a one-time change notification.
- Vertical reading automatically disables dismissal without a notification.
- Drag down to dismiss comic-cover and image-favorites fullscreen previews; zoomed images retain pan.
- iOS-only preferences; no changes to Android gesture defaults.
- Manual and startup update checks use only this fork's GitHub Releases.
- The user must install updates using their iOS sideloading/signing app. Silent iOS IPA installation is not supported.

Release:
1. Merge the feature branch into main.
2. The custom-ios-release workflow tests, builds an unsigned iOS IPA and publishes it in this fork's Releases.
3. Daily sync merges official upstream main into this fork and dispatches the custom build on changes.
4. If merging or testing fails, the workflow fails rather than replacing the published package.

Important:
- A GitHub Actions IPA is unsigned; use a compatible sideload signer.
- Changing signing team or bundle ID can prevent an in-place update.
- Follow the custom fork's Releases, not the original application's releases.
- Never install the upstream IPA over this customized build, because doing so removes its UI features.
- All gestures and workflows require iPhone validation before being considered production-ready.
