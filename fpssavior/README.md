## FPSSavior
Technically it's an EP13fix derived from [Xinxs's FPSSavior](https://github.com/xinxs/ToS-Addons/tree/master/fpssavior) (which is derived from [FiftyCaliber](https://github.com/FiftyCaliber)). The settings got modified further to accomodate large portion of the player base based on certain judgements.

Notes:
- Fallen Leaves on orsha are disabled only on UL because it's related with boss gimmick, and when disabled can cause some trouble for people that doing those gimmick.
---
### Commands:
- /fpssavior help

  Display FPS Savior help text through system messages.

- /fpssavior lock

  Lock/unlock the ui to move around.

- /fpssavior

  Toggle betwen modes.
---
### Version History
**-v2.5.0** 

Challenge Mode got revamped with the introduction of Episode 13-2. The content has so many mobs such that the old setting of SetDrawMonster (and possibly also SetDrawActor) became obsolete. In this version we introduce a way to change the SetDrawMonster value through the following command:
- /fs_draw_mon [integer]

We also implement a way to change SetDrawActor using the following command:
- /fs_draw_pl [integer]

but we fail to notice any changes from the game visual. Any info on what this value affect is appreciated.

**-v2.4.4** 

I just realized that L and UL are only different by 1 option that got turned off on UL. To make both mode has distict use, I modified L so that it will show the boss gimmick similar to H and M. The drawback is:
- The option that disable the fallen leaves on orsha must be turned on on L. 
- The "Show Other Character's Effects" option are turned on on L (This include the effect generate by appearance equipment).

The reason why I don't just turn on EnableOtherPCEffect alone on L is that when certain gimmick is already shown inside the map, simply turning off EnableOtherPCEffect won't erase those gimmick. By toggling EnableOtherPCEffect along with EnableIMCEffect, the toggle-like effect on boss gimmick can be achieved.

**-v2.4.3** a.k.a ep13fix-c.
- The "View Boss Magic Circle Range" option can be freely toogled on M, L, and UL.
- Someone inform me that the fog(?) and fallen leaves on Orsha hurts fps. After further investigation, I conclude that EnableGlow and EnableIMCEffect is responsible for that respectively. Both options are disabled on L and UL.
- There's an issue with certain boss gimmick such as firewall or tornado not shown on map on M, L, and UL. I'm not sure what cause this (looks like it's not depends on just one option), but now it's only gone on L and UL.
- Show damage of other character can be toggled freely on H and M.
