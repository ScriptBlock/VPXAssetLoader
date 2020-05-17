# VPXAssetLoader

This small utility will help backup and restore the various components of a VPX table.  This includes:
* Tables (VPX, VBS, B2S, and POV)
* Roms
* altcolor
* altsound
* PupPacks

## Getting Started

All you need from this repo is the .ps1 file.  This script has a shitload of parameters.  Strap in.
You will also need the full path for your VPX, PUP, and Assets dierctory.  When I refer to an "assets" directory, I mean some arbitrary directory that will hold the assets organized by table name.  

## Parameters

### These are more or less mandatory
| Parameter | Description | Example
| --- | --- | --- |
| `-vpxLocation` | the location of your VPX directory | "C:\Pinball\Visual Pinball X" |
| `-pupLocation` |  the location of your PUP directory | "C:\Pinball\PinUPPlayer" |
| `-assetLocation` | the location of your assets directory | "D:\VPXAssets" |
| `-tableName` | a regular expression for matching table names | ^Indiana |

### Then pick a function
| Parameter | Description | 
| --- | --- |
| `-list` | Lists the tables that match the regular expression.  This is good for testing your search criteria |
| ~~`-backup`~~  | ~~Pull assets from your `-assetLocation` directory into the appropriate VPX & PUP directories~~ |
| `-restore` | Pushes assets from the various VPX & PUP directories into yout `-assetLocation` directory |

### If using backup or restore, choose the specific assets you want.  
| Parameter | Description | 
| --- | --- |
| `-copyAll` | Copy everything.  I am a leaf on the wind... |
| `-copyTable` | Copy the table files... see the next table below |
| `-copyRom` | Copy the ROM files |
| `-copyAltSound` | Copy the AltSound files - this is an unzip action and may take a while |
| `-copyAltColor` | Copy the AltColor files |
| `-copyNVRam` | Copy the NVRam file |
| `-copyPUPPack` | Copy the PUPPack files - this is an unzip action and may take a while |

### Aaaaand some optional-ish flags.  
| Parameter | Description | 
| --- | --- |
| `-tableAll` | If -copyTable is selected, this will copy all table files (VPX, VBS, POV, and B2S |
| `-tableVPX` | If -copyTable is selected, this will copy the VPX files |
| `-tableVBS` | If -copyTable is selected, this will copy the VBS files |
| `-tablePOV` | If -copyTable is selected, this will copy the POV files |
| `-tableB2S` | If -copyTable is selected, this will copy the B2S files |
| `-gridView` | When using -list, you can output the results into a spreadsheet-like GUI view for extra sexyness

## Examples

*Which games do I have that contain the word "of"?*

`& .\VPXAssetLoader.ps1 -assetLocation "C:\VPXAssets" -list -tableName "of"`

*Which games do I have that start with the word "Star"?*

`& .\VPXAssetLoader.ps1 -assetLocation "C:\VPXAssets" -list -tableName "^Star"`

*How about just show me all of my tables, and show me which assets that have in a spreadsheet!  My Excel game is strong.*

`& .\VPXAssetLoader.ps1 -assetLocation "C:\VPXAssets" -list -tableName "." -gridView`

*I want that sweet ass Indiana Jones VPX table.  That shit gots colors, sounds, pups, roms... all the things.. gimme*

`& .\VPXAssetLoader.ps1 -assetLocation "C:\VPXAssets" -vpxLocation "C:\Pinball\Visual Pinball X" -pupLocation "C:\Pinball\PinUPPlayer" -restore -copyAll -tableAll -tableName "^Indiana Jones"`

*I just downloaded the new South Park, but all I want is the ROM and the VPX so that I don't overwite my POV and other files*

`& .\VPXAssetLoader.ps1 -assetLocation "C:\VPXAssets" -vpxLocation "C:\Pinball\Visual Pinball X" -pupLocation "C:\Pinball\PinUPPlayer" -restore -copyTable -tableVPX -copyROM -tableName "^South Park"`

## Some notes about this script

* There's about zero error checking.  Don't fuck up.  Consider your parameters wisely.  If you overwrite all your shit because you didn't read the directions or because my code sucks, that's on you.  *Maybe run this a few times in a test directory to make sure it does what you intend*.
* Make sure your directories are enclosed in double quotes.  I have no idea what will happen if you pass paths with spaces and don't wrap them in quotes.
* The asset format is meant to be compatible with ModRetro's filing strategy of folder names that match the table names, with the assets embedded within.  
* -backup has not been implemented yet.

## Contributing

This is a dead simple script for checking whether files exist and copying them from point A to point B based on some rules.   If you want to add some stuff like error checking, parameter sets, or other hotness go ahead an submit a merge request.  Make it better however you can.

## Versioning

This is version 0.1.1, once I get -backup written and some basic end to end testing has been done I'll move this up to 1.0.0.  

## License

This project is licensed under the MIT License - have at it.

## Acknowledgements

Big shout out to ModRetro for all of the legwork in building out an easy to use and straightforward asset directory structure for the VPX/PUP integration.