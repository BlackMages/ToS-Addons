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
  
- /fs_draw_mon [integer]
  
  Change how many monster are shown inside the screen.

- /fs_ex

  Show help text for exception list through system messages. See Version History v2.5.0.
  
- /fs_del

  Show help text for delete list through system messages. See Version History v2.5.0.
---
### Version History

---

**-v2.5.0** 

Challenge Mode got revamped with the introduction of Episode 13-2. The content has so many mobs such that the old setting of SetDrawMonster (and possibly also SetDrawActor) became obsolete. In this version we introduce a way to change the SetDrawMonster value through the following command:
- /fs_draw_mon [integer]

The usual value of this variable is known to be 100, but we think it can be set to be higher. Note that the value of SetDrawMonster on High mode will always be 100 regardless of the setting.

We also implement a way to change SetDrawActor using the following command:
- /fs_draw_pl [integer]

However, we fail to notice any changes from the game visual. Any info regarding what this value affect is appreciated.

To acomodate guild content that involves a lot of player (such as GTW or Blockade Battle) where the heavy lag is expected on weaker system, we introduce an option to completely remove any player that is not inside the same party of the user from the screen. 

There was concern from players since the addon also remove the players shop. The opinion regarding this matter is split into two equally, so we conclude that an option for showing/hiding the shop is necessary and introduced it in this version.

There was a problem with the option to only able to see your party member in GTW, that is it makes the coordination harder because you don't know where your other guildmates exactly is on the screen. We introduce an exception list feature to solve this problem. The player that registered inside that list will always be shown on the screen regardless of the options that the player use, so you can put strategic player like guildmaster or war commander inside the list to have them always shown on your screen. The command list for exception list can be found using the following command:
- /fs_ex

Please refer to the following video to see this feature in action:

https://www.youtube.com/watch?v=cr237zMz8Fk

There's also delete list, where all player inside the list is removed from the screen regardless of the option that the player use. The command list for delet list can be found using the following command:
- /fs_del

There was an Extreme Mode from the old version of FPS Savior that help reduce the lag a lot. However, many function on this mode is deprecrated when Ep 12 is introduced. The mode was removed since then. We put it back and renamed it as U2 or Ultra Low 2 just for the sake of history, also some function is still working but the effect is hard to be noticed. Basically it's Ultra Low + whatever function remains from the old Extreme Mode that can be called.

---

**-v2.4.4** 

We realized that L and UL are only different by 1 option that got turned off on UL. To make both mode has distict use, L is modified so that it will show the boss gimmick similar to H and M. The drawback is:
- The option that disable the fallen leaves on orsha must be turned on on L. 
- The "Show Other Character's Effects" option are turned on on L (This include the effect generate by appearance equipment).

The reason why we don't just turn on EnableOtherPCEffect alone on L is that when certain gimmick is already shown inside the map, simply turning off EnableOtherPCEffect won't erase those gimmick. By toggling EnableOtherPCEffect along with EnableIMCEffect, the toggle-like effect on boss gimmick can be achieved.

---

**-v2.4.3** a.k.a ep13fix-c.
- The "View Boss Magic Circle Range" option can be freely toogled on M, L, and UL.
- Someone inform us that the fog(?) and fallen leaves on Orsha hurts fps. After further investigation, we conclude that EnableGlow and EnableIMCEffect is responsible for that respectively. Both options are disabled on L and UL.
- There's an issue with certain boss gimmick such as firewall or tornado not shown on map on M, L, and UL. We're not sure what cause this (looks like it's not depends on just one option), but now it's only gone on L and UL.
- Show damage of other character can be toggled freely on H and M.
