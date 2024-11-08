license:

    this is open source to any person, as long as they follow any license associated with any sub-license files listed:

        license_weather

        please email me if you feel that any other licenses should apply: tylerwojo81@gmail.com

# Nacht des Schreckens

![demo of the map](demo.png)

Consider this a custom zombies map for 'Call of Duty: World at War' but in the vein of a Doom 2 mod using the GZDoom source port. This map pulls or modifies many assets from 'World at War'. Most likely, after the final release of the demo, further updates will have to be retrieved elsewhere and a valid copy of 'Call of Duty: World at War' will also be required to use this mod.

This mod is meant to bring the features and spirit of classic 'Call of Duty Zombies' maps into Doom 2 through a reimagining of their very first map. While this has been done before, I hope to bring this type of mod into a category of its own.

## Credit

### Base Games

- **id Software's Doom 2**: https://store.steampowered.com/app/10090/Call_of_Duty_World_at_War/

- **Freedoom**: https://freedoom.github.io/index.html

- **Treyarch's Call of Duty: World at War**: https://store.steampowered.com/app/10090/Call_of_Duty_World_at_War/
</br></br>
### Other Mods/Libraries Used

- **ZDL's COD Zombies**: https://www.moddb.com/mods/call-of-duty-nazi-zombies

- **dodopod's ZScript Weapons Library** (removed):  https://forum.zdoom.org/viewtopic.php?t=61172

- **Boondorl's Weather Library** https://github.com/Boondorl/Weather

- **[unknown]'s NTM Quick Kick** (could not find the exact link to the mod, so here's the inspirations/adaptations):

    - https://github.com/LocalInsomniac/NTMAi/blob/master/zscript/weapons/kick.txt

    - https://forum.zdoom.org/viewtopic.php?p=1181624#p1181624

### Crew

- **Alexis Dutcher**: Lead Artist

- **Tyler Wojciechowski**: Lead Developer

- **Jaquon Harvey**: Music composer

- **Jared De Laurentis**: Game Designer

## Installation & Configuration

Download the zip file from the 'Code' dropdown menu and unzip in directory of your choosing

Download and unzip GZDoom next to this projects's folder: https://zdoom.org/downloads

Rename folder to just 'gzdoom'

Extract the 'doom2.wad' file from a legal copy of Doom 2 OR extract the 'freedoom2.wad' file from the Freedoom project: https://freedoom.github.io/download.html

Place the extracted file into the 'gzdoom' folder.

To run using the 'launch.bat', 'host.bat', or 'join.bat' files, make sure the folder containing 'gzdoom.exe' is named 'gzdoom' and is next to the folder containing this project.

To avoid weapon sprite cropping, make sure the aspect ratio is set to 4:3 in-game (weapon sprites will be widened later to support wider ratios).

To play using the original rogues gallery of enemies, set the 'Use Varied Zombies' option to true in the full options menu.

## Default Controls

|Action|Keyboard|Xbox Controller|
|:---:|:---:|:---:|
|Movement|WASD Keys|Left Stick|
|Fire|Left Click|Right Trigger|
|Use|E Key|A Button|
|Reload|R Key|X Button|
|Zoom|Right Click|Left Trigger|
|Kick|F Key|Right Stick|
|Swap Weapon|Mouse Wheel|Y Button|
|Quick Swap|1-9 Keys|D-Pad (Clockwise starting from left)|
|Drop Weapon|C Key x2|Right Bumper x2|
|Repulse/Skip Intro|Q Key|Left Bumbper|

## Multiplayer

To host or join a multiplayer match, run the respective script.

To host, the number of players will have to manually be set in the script.

To join, the host's ip address will have to manually be set in the script.

## Cross Mod Support

While there is initial support for use with other mods, there is still a long ways to go.

## Android / Delta Touch

This mod is able to run on Android through Delta Touch, but manual set up of the controls is needed.

## Next Milestone

This mod is still early in development, so the map is very basic, the weapon roster is limited, and there are many placeholder textures. Currently, I am working towards a demo filling in these issues by creating a memorable starting area, porting more weapons from World at War, creating and pulling more assets, stabilizing the multiplayer experience, and adding an easter egg or two :)