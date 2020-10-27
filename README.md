![Swift 5.0](https://img.shields.io/static/v1.svg?label=Swift&message=4.0&color=green&logo=swift)
![macOS 10.13](https://img.shields.io/static/v1.svg?label=macOS&message=10.13&color=green&logo=apple)
![macOS 10.14](https://img.shields.io/static/v1.svg?label=macOS&message=10.14&color=green&logo=apple)
![macOS 10.15](https://img.shields.io/static/v1.svg?label=macOS&message=10.15&color=green&logo=apple)
![macOS 10.16](https://img.shields.io/static/v1.svg?label=macOS&message=10.16&color=yellow&logo=apple)
![macOS Dark Mode](https://img.shields.io/static/v1.svg?label=Dark%20Mode&message=enabled&color=green&logo=apple)

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![Current Filevault-Reissue Version](https://img.shields.io/static/v1.svg?label=version&message=1.1&color=lightgrey)

# Filevault-Reissue
Filevault-Reissue's goal is to provide a sleek and elegant UI for reissuing Apple's Filevault recovery key.
- Fully configurable using Preferences and Configuration Profiles
- Sleek and responsive UI and that is fully brandable
- Attempts to auto reissue using provided usernames and passwords

## In Action

### Prompt User Sees
![Filevault Reissue Prompt](https://user-images.githubusercontent.com/23121750/75719634-129e2480-5ca3-11ea-9f48-3537c0c1a6e2.png)

### More Information Dialog
![Filevault Reissue Info Dialog](https://user-images.githubusercontent.com/23121750/75719779-5a24b080-5ca3-11ea-9d8f-e791a31fafa8.png)

![Filevault Reissue Key Display](https://user-images.githubusercontent.com/23121750/75719867-893b2200-5ca3-11ea-863c-b079a629cb8b.png)

### Silent Reissue
Filevault-Reissue has the ability to silently reissue the recovery key if a administrator username and password is provided.

Ex: `/path/to/filevault --admin-usernames=uniadmin,localadmin --admin-passwords=supers3cret,monkeybones123`

The above example will try to authenticate to Filevault using both `uniadmin` and `localadmin` with both of the provided passwords `supers3cret` and `monkeybones123`. Keep in mind you may need to properly escape special characters.

## Quick Start

1. Download latest version from the Releases
    - We only have Betas right now
2. Sign & Notarize the app for best results.
3. Configure preferences for the following keys:

| Key Name | Description | Type | Example |
| -------- | :---------: | :--: | :------ |
| viewTitle | This is the text displayed to the end user, usually set to the company's name | String | Acme Corporation |
| viewInstructions | This is the text displayed to the end user, usually a blurb around why this is occuring and why they should care | String | Our management server does not have a valid recovery key for this device. Please enter the username and password you use to unlock this machine after your system reboots. |
| viewLogoPath | This is the logo that is displayed to the end user. Usually the company logo. | String | /var/tmp/companyLogo.png |
| suppressRecoveryKey | This will prevent the user from seeing the new recovery key when issued. | True / False | False |
| successAlert | If `suppressRecoveryKey` is true, you can set this to show an alert after the key is rotated witout it being shown. By default, no alert is shown and the app will quit. | Truse / False | True |
| successKeyMessage | If the `successAlert` key is set, you can customize the success message. By default, the message is "Successfully reissued the recovery key on this machine." | String | Your key has been reissued! | 
| usernamePlaceholder | This is what will hold the place of the username field. Usually input a generic username that matches your scheme. | String | johnsmith |
| passwordPlaceholder | This is what will hold the place of the password field. Feel free to be creative according to your company policy | String | P@$5\\/\\/0rcl |
| moreInformationText | This is the text a user will be presented with if they click on the "More Information" button on the window | String | Acme uses the recovery key in our management servers to securely and safely enable your machine to unlock in the event your device has trouble unlocking. |

4. Edit `postinstall` in `installer/scripts/` with your administrative accounts and passwords.
    - `--admin-usernames` should look like `--admin-usernames="ladmin,itadmin,john"`
    - `--admin-passwords` should look like `--admin-passwords="SuperMonkey123","Password"`
5. Run the `build.sh` script in `installer/` to build the package
6. Sign the package
7. Deploy
8. Drink coffee and watch results

## Release History
The release history is available [here](https://github.com/cybertunnel/Filevault-Reissue/blob/master/CHANGELOG.md).

## Getting Help
This project does not have a dedicated channel on the [MacAdmins Slack](https://macadmins.org) instance, but you can directly message me under the username `@cybertunnel`. As always, if you have an issue, please open an issue in this repository so I can allocate time to resolve the issue, or add the feature requested.

## Contributing
I [cybertunnel](https://github.com/cybertunnel) have been working on this project for the company I currently work for. I have spent these past few months making it more customizable and stable for general use.

Please feel free to fork and contribute.
