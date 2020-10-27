# 1.2

- Added new config key `successAlert`: If `suppressRecoveryKey` is true, you can set this to show an alert after the key is rotated witout the key being shown
- Added new config key `successKeyMessage`: If the `successAlert` key is set, you can customize the success message
- Created JSON schema manifest for use with Jamf deployments

# 1.1

- Fixed typo in preferences key `supress` to `suppress`
- Offically have an Apple Signed release (Yes I ended up buying a developer license finally)
- Officially notarized release.
- New Icon
  - Icon was switched to prevent confusion between the native macOS Filevault app and this app.


# 0.1 Beta Release

- Reissue recovery key automatically using admin provided credentials.
- Reissue recovery key using provided user credentials
- Fully customizable through configuration profiles and preferences
- Displays newly issue recovery key to end user
  - Able to be supressed
- Displays a "More Information" dialog if user wants to learn more about this prompt
- Functionality for `CMD + A` and `CMD + Q` inside TextFields
