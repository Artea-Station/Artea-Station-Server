## Artea Station (TG Fork)

**This repository currently does not contain 18+ content, but the server which runs it allows r18 themes in roleplay. The server attached to this repository is not suitable for under 18s.**

[![CI Suite](https://github.com/Nosha-Industries/Nosha-Industries-Server/actions/workflows/ci_suite.yml/badge.svg)](https://github.com/Nosha-Industries/Nosha-Industries-Server/actions/workflows/ci_suite.yml)
[![Percentage of issues still open](https://isitmaintained.com/badge/open/Nosha-Industries/Nosha-Industries-Server.svg)](https://isitmaintained.com/project/Nosha-Industries/Nosha-Industries-Server "Percentage of issues still open")
[![Average time to resolve an issue](https://isitmaintained.com/badge/resolution/Nosha-Industries/Nosha-Industries-Server.svg)](https://isitmaintained.com/project/Nosha-Industries/Nosha-Industries-Server "Average time to resolve an issue")
![Coverage](https://img.shields.io/codecov/c/github/Nosha-Industries/Nosha-Industries-Server)

[![resentment](https://forthebadge.com/images/badges/built-with-resentment.svg)](https://www.monkeyuser.com/assets/images/2019/131-bug-free.png) [![resentment](https://forthebadge.com/images/badges/contains-technical-debt.svg)](https://user-images.githubusercontent.com/8171642/50290880-ffef5500-043a-11e9-8270-a2e5b697c86c.png) [![forinfinityandbyond](https://user-images.githubusercontent.com/5211576/29499758-4efff304-85e6-11e7-8267-62919c3688a9.gif)](https://www.reddit.com/r/SS13/comments/5oplxp/what_is_the_main_problem_with_byond_as_an_engine/dclbu1a)

* **Git / GitHub cheatsheet:** https://www.notion.so/Git-GitHub-61bc81766b2e4c7d9a346db3078ce833
* **Website:** N/A
* **Discord:** https://discord.gg/BrwHEt8Hdc
* **Code:** https://github.com/Nosha-Industries/Nosha-Industries-Server
* **Wiki:** https://tgstation13.org/wiki/Main_Page
* **Codedocs:** N/A
* **Coderbus Discord:** https://discord.gg/Vh8TJp9

This is Nosha Industry's fork of TG created in byond.

Unlisted community for now until the requisite systems for moderation are put in place.

Space Station 13 is a paranoia-laden round-based roleplaying game set against the backdrop of a nonsensical, metal death trap masquerading as a space station, with charming spritework designed to represent the sci-fi setting and its dangerous undertones. Have fun, and survive!

**Note**: Artea Station is less focused on the metal deathtrap part, and is more geared towards HRP with a mostly relaxed environment, unless a player makes the environment less safe, or the round rolls a high chaos value, and players approve it.

## Important Note - TEST YOUR PULL REQUESTS

You are responsible for the testing of your content. You should not mark a pull request ready for review until you have actually tested it. If there are easy to find errors or warnings in the console, your PR will be unreadied.

Mappers: Make sure to spawn your map in and ensure it has no warnings about duplicate APCs, wirenets, or atmos pipe networks. Remember, many machines have builtin atmos/plumping pipes!

Coders: Just make sure your stuff works as intended, and doesn't drop runtimes.

## DOWNLOADING
[Downloading](.github/guides/DOWNLOADING.md)

[Running on the server](.github/guides/RUNNING_A_SERVER.md)

[Maps and Away Missions](.github/guides/MAPS_AND_AWAY_MISSIONS.md)

## :exclamation: How to compile :exclamation:

Find `BUILD.bat` or `RUN_SERVER.bat` here in the root folder of this project, and double click it to initiate the build. It consists of multiple steps and might take around 1-5 minutes to compile.

**The long way**. Find `bin/build.cmd` in this folder, and double click it to initiate the build. It consists of multiple steps and might take around 1-5 minutes to compile. If it closes, it means it has finished its job. You can then [setup the server](.github/guides/RUNNING_A_SERVER.md) normally by opening `tgstation.dmb` in DreamDaemon.

**Building tgstation in DreamMaker directly is now deprecated and might produce errors**, such as `'tgui.bundle.js': cannot find file`.

**[How to compile in VSCode and other build options](tools/build/README.md).**

## Contributors
[Guides for Contributors](.github/CONTRIBUTING.md)

[/tg/station HACKMD account](https://hackmd.io/@tgstation) - TG design documentation here

**Interested in some starting lore?**  
Unfortunately, we do not have any at this time. Message RimiNosha on discord if you're interested in writing compact, concise lore! Extra fluff may come later.

## LICENSE

All code after [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/31/12 at 4:38 PM PST](https://github.com/tgstation/tgstation/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU AGPL v3](https://www.gnu.org/licenses/agpl-3.0.html).

All code before [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/31/12 at 4:38 PM PST](https://github.com/tgstation/tgstation/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html).
(Including tools unless their readme specifies otherwise.)

See LICENSE and GPLv3.txt for more details.

The TGS DMAPI API is licensed as a subproject under the MIT license.

See the footer of [code/__DEFINES/tgs.dm](./code/__DEFINES/tgs.dm) and [code/modules/tgs/LICENSE](./code/modules/tgs/LICENSE) for the MIT license.

All assets including icons and sound are under a [Creative Commons 3.0 BY-SA license](https://creativecommons.org/licenses/by-sa/3.0/) unless otherwise indicated.
