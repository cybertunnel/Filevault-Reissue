![Swift 5.0](https://img.shields.io/static/v1.svg?label=Swift&message=4.0&color=green&logo=swift)
![macOS 11.x](https://img.shields.io/static/v1.svg?label=macOS&message=11.x&color=green&logo=apple)
![macOS 12.x](https://img.shields.io/static/v1.svg?label=macOS&message=12.x&color=green&logo=apple)
![macOS 13.x](https://img.shields.io/static/v1.svg?label=macOS&message=13.x&color=green&logo=apple)

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![Current Filevault-Reissue Version](https://img.shields.io/static/v1.svg?label=version&message=1.2&color=lightgrey)

# Filevault-Reissue
Filevault-Reissue's goal is to provide a sleek and elegant UI for reissuing Apple's Filevault recovery key.
- Fully configurable using Preferences and Configuration Profiles
- Sleek and responsive UI and that is fully brandable using SwiftUI
- Attempts to auto reissue using provided usernames and passwords

## In Action

### Prompt User Sees
![Filevault Reissue Prompt](https://user-images.githubusercontent.com/23121750/192052495-f87a95e5-fb3e-4fd2-9300-1a908fe7f163.png)

### More Information Dialog
![Filevault Reissue Info Dialog](https://user-images.githubusercontent.com/23121750/192052554-2ad83402-532b-439a-8ab9-b59f3b23af47.png)

![Filevault Reissue Key Display](https://user-images.githubusercontent.com/23121750/192052806-22ea4c56-56db-4660-88cb-77f1640bbb4f.png)

### Silent Reissue
Filevault-Reissue has the ability to silently reissue the recovery key if a administrator username and password is provided.

Ex: `/Utilities/Filevault\ Reissue.app/Content/MacOS/Filevault\ Reissue --admin-usernames=uniadmin,localadmin --admin-passwords=supers3cret,monkeybones123`

The above example will try to authenticate to Filevault using both `uniadmin` and `localadmin` with both of the provided passwords `supers3cret` and `monkeybones123`. Keep in mind you may need to properly escape special characters.

## Quick Start

1. Download latest version from the Releases
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
