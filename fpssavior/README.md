## FPSSavior
Technically it's an EP13fix derived from [Xinxs's FPSSavior](https://github.com/xinxs/ToS-Addons/tree/master/fpssavior) (which is derived from [FiftyCaliber](https://github.com/FiftyCaliber)). The settings got modified further to accomodate large portion of the player base based on certain judgements.

Currently there are 5 modes for FPSSavior, that is `High`, `Medium`, `Low`, `Ultra Low`, and `Custom`. These settings are represented by button with their abbreviation written inside. You can change the modes by clicking the button or using `/fpssavior` command. These modes will force you to use a predetermined setting except for custom where you can use the in-game setting instead.

- **High** is where almost all settings are turned on and set to high.
- **Medium** is the most preferable setting for majority of players.
- **Low** is the mode where almost all settings are turned off, and only those that are essential for gameplay (both PvE and PvP) are turned on.
- **Ultra Low** is the mode where almost all settings are turned off. This mode offer the highest FPS but skill effects and some raid mechanics are hidden which may cause some trouble on the gameplay.

Aside from modes, there are some options added to FPS Savior. They are categorized as Player and Summon options. You can access these options by clicking the gear icon inside FPSSavior interface.

Player Options:
- `Hide all` Ticking this option will hide all player except for yourself.
- `Show pt/guild only` Ticking this option will hide all player except your party member and your guild member.
- `Show pt only` Ticking this option will hide all player except your party member.
- `Hide player shops` Ticking this option will hide player shop. Note that if this is unticked, the player shops will always be visible even when other option is ticked.

Summon Options:
- `Hide all` This will hide all summon.
- `Show mine only` Thiss will hide all summon except the one that is created by player.

Note that when any of the summon options are ticked, it will also affected summons from enemy such as elite mosters or bosses. This might hide some of the boss mechanics thus create some problem with the raid.

Other Notes:
- Fallen Leaves on orsha are disabled only on UL because it's related with boss gimmick, and when disabled can cause some trouble for people that doing those gimmick.
- If you're upgrading from any version before 2.5.0, your `/fs_draw_mon` and `/fs_draw_pl` might be set to 0 and might cause people name stuck on screen and most stuff dissapeared. Deleting the settings.json file (see below) or adjusting the value will fix this issue.
- <details>
  <summary>tldr: when in doubt, delete settings.json.</summary>
  <p>FPS Savior saves the settings on settings.json file inside the addon/fpssavior folder. There are newer version that add new stuff the settings.json content, and this make the old one incompatible without some adjustment and might cause the addon to behave weirdly or not work at all. So, in case where the addon didn't work, deleting settings.json file might help.</p>
  </details>
---
### Important Commands:
- /fpssavior help

  Display FPS Savior help text through system messages.

- /fpssavior lock

  Lock/unlock the ui to move around.

- /fpssavior

  Toggle betwen modes.

- /fs_draw_mon `integer`
  
  Change how many monster are shown inside the screen.
  
- /fs_ex

  Show help text for exception list through system messages. See Version History v2.5.0.
  
- /fs_del

  Show help text for delete list through system messages. See Version History v2.5.0.
---
### Version History

---

**-v2.5.2** 

- Merge Ultra Low and Ultra Low 2.
- Add Custom mode where it use in-game setting instead of predetermined setting.

---

**-v2.5.1** 

- Fix a bug where player are getting deleted by Hide Player Shop option.

---

**-v2.5.0** 

Challenge Mode got revamped with the introduction of Episode 13-2. The content has so many mobs such that the old setting of SetDrawMonster (and possibly also SetDrawActor) became obsolete. In this version we introduce a way to change the SetDrawMonster value through the following command:
- /fs_draw_mon `integer`

The usual value of this variable is known to be 100, but we think it can be set to be higher. Note that the value of SetDrawMonster on High mode will always be 100 regardless of the setting.

We also implement a way to change SetDrawActor using the following command:
- /fs_draw_pl `integer`

However, we fail to notice any changes from the game visual. Any info regarding what this value affect is appreciated.

To acomodate guild content that involves a lot of player (such as GTW or Blockade Battle) where the heavy lag is expected on weaker system, we introduce an option to completely remove any player that is not inside the same party of the user from the screen. 

There was concern from players since the addon also remove the players shop. The opinion regarding this matter is split into two equally, so we conclude that an option for showing/hiding the shop is necessary and introduced it in this version.

There was a problem with the option where you only able to see your party member in GTW. This option makes the coordination harder because you don't know where your other guildmates exactly is on the screen. We introduce an exception list feature to solve this problem. The player that registered inside that list will always be shown on the screen regardless of the options that the player use, so you can put strategic player like guildmaster or war commander inside the list to have them always shown on your screen. The command list for exception list can be found using the following command:
- /fs_ex

Please refer to the following video to see this feature in action:

https://www.youtube.com/watch?v=cr237zMz8Fk

There's also delete list, where all player inside the list is removed from the screen regardless of the option that the player use. The command list for delet list can be found using the following command:
- /fs_del

There was an Extreme Mode from the old version of FPS Savior that help reduce the lag a lot. However, lots of important function on this mode are removed when Ep 12 is introduced. The mode was also removed since then. We put it back and renamed it as U2 or Ultra Low 2 just for the sake of history, also some function is still working but the effect is hard to be noticed. Basically it's Ultra Low + whatever function remains from the old Extreme Mode that can be invoked.

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
