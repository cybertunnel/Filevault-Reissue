![Swift 5.0](https://img.shields.io/static/v1.svg?label=Swift&message=5.0&color=green&logo=swift)
![macOS 10.12](https://img.shields.io/static/v1.svg?label=macOS&message=10.12&color=green&logo=apple)
![macOS 10.13](https://img.shields.io/static/v1.svg?label=macOS&message=10.13&color=green&logo=apple)
![macOS 10.14](https://img.shields.io/static/v1.svg?label=macOS&message=10.14&color=green&logo=apple)
![macOS 10.15](https://img.shields.io/static/v1.svg?label=macOS&message=10.15&color=green&logo=apple)
![macOS 10.16](https://img.shields.io/static/v1.svg?label=macOS&message=10.16&color=yellow&logo=apple)
![macOS Dark Mode](https://img.shields.io/static/v1.svg?label=Dark%20Mode&message=enabled&color=green&logo=apple)

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![Current Filevault-Reissue Version](https://img.shields.io/static/v1.svg?label=version&message=1.0&color=lightgrey)

# Filevault-Reissue
This application prompts end users for username and password to automatically reissue a recovery key.

## In Action
![Filevault-Reissue Running](https://user-images.githubusercontent.com/23121750/88068216-e6921b80-cb3d-11ea-84ba-a22e05f1b924.png)

### User Prompt
Filevault-Reissue will prompt the user for their username and password to then attempt to reissue the recovery key. This whole window can be branded, and a more info window can be configured to better allow people to validate where the prompt came from.

### Silent Reissue
Filevault-Reissue has the ability to silently reissue the recovery key if a administrator username and password is provided.
Ex: `/path/to/filevault --admin-usernames=uniadmin,localadmin --admin-passwords=supers3cret,monkeybones123`
The above example will try to authenticate to Filevault using both `uniadmin` and `localadmin` with both of the provided passwords `supers3cret` and `monkeybones123`. Keep in mind you may need to properly escape special characters.

## Quick Start
The best way to start is the [Kickstart Guide](https://github.com/cybertunnel/Filevault-Reissue/wiki)

## Release History
The release history is available [here](https://github.com/cybertunnel/Filevault-Reissue/blob/master/CHANGELOG.md).

## Getting Help
This project does not have a dedicated channel on the [MacAdmins Slack](https://macadmins.org) instance, but you can directly message me under the username `@cybertunnel`. As always, if you have an issue, please open an issue in this repository so I can allocate time to resolve the issue, or add the feature requested.

## Contributing
I [cybertunnel](https://github.com/cybertunnel) have been working on this project for the company I currently work for. I have spent these past few months making it more customizable and stable for general use.

Please feel free to fork and contribute.

# Preferences
Filevault-Reissue uses the below keys in the preferences file. These keys are recommended for best results.
`viewTitle`
`viewInstructions`
`viewLogoPath`
`infoURL`
`supressRecoveryKey`
`usernamePlaceholder`
`passwordPlaceholder`
`moreInformationText`

# Arguments
`--admin-usernames=`
`--admin-passwords=`