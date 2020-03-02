![Swift 5.0](https://img.shields.io/static/v1.svg?label=Swift&message=4.0&color=green&logo=swift)
![macOS 10.13](https://img.shields.io/static/v1.svg?label=macOS&message=10.13&color=green&logo=apple)
![macOS 10.14](https://img.shields.io/static/v1.svg?label=macOS&message=10.14&color=green&logo=apple)
![macOS 10.15](https://img.shields.io/static/v1.svg?label=macOS&message=10.15&color=green&logo=apple)
![macOS Dark Mode](https://img.shields.io/static/v1.svg?label=Dark%20Mode&message=enabled&color=green&logo=apple)

# Filevault-Reissue
Filevault-Reissue's goal is to provide a sleek and elegant UI for reissuing Apple's Filevault recovery key.
- Fully configurable using Preferences and Configuration Profiles
- Sleek and responsive UI and that is fully brandable
- Attempts to auto reissue using provided usernames and passwords

## In Action

## Quick Start

1. Download latest version from the Releases
    - We only have Betas right now
2. Configure preferences for the following keys:
| Key Name | Description | Type | Example |
| -------- | :---------: | :--: | :------ |
| viewTitle | This is the text displayed to the end user, usually set to the company's name | String | Acme Corporation |
| viewInstructions | This is the text displayed to the end user, usually a blurb around why this is occuring and why they should care | String | Our management server does not have a valid recovery key for this device. Please enter the username and password you use to unlock this machine after your system reboots. |
| viewLogoPath | This is the logo that is displayed to the end user. Usually the company logo. | String | /var/tmp/companyLogo.png |
| supressRecoveryKey | This will prevent the user from seeing the new recovery key when issued. | True / False | False |
| usernamePlaceholder | This is what will hold the place of the username field. Usually input a generic username that matches your scheme. | String | johnsmith |
| passwordPlaceholder | This is what will hold the place of the password field. Feel free to be creative according to your company policy | String | P@$5\/\/0rcl |
| moreInformationText | This is the text a user will be presented with if they click on the "More Information" button on the window | String | Acme uses the recovery key in our management servers to securely and safely enable your machine to unlock in the event your device has trouble unlocking. |
3. Edit `postinstall` in `installer/scripts/` with your administrative accounts and passwords.
    - `--admin-usernames` should look like `--admin-usernames="ladmin,itadmin,john"`
    - `--admin-passwords` should look like `--admin-passwords="SuperMonkey123"`
4. Run the `build.sh` script in `installer/` to build the package
5. Sign the package
6. Deploy
7. Drink coffee and watch results

## Release History

The release history is available here.

## Getting Help

The best way to get help for this item is to message me directly `@cybertunnel` on the MacAdmins Slack.

_Possibly in the future there will be a channel for support if interest grows around this project._

## Contributing
