### 12.0.0.0
* Initial updates to support 12.0.0.0

### 11.2.5.0
* Added support for the "raid" world quest icon in Broken Isles
* Updated TOC for 11.2.5

### 11.2.0.0
* Added support for K'aresh (TWW)
* Added support for Tazavesh (TWW)
* Added support for Weathered Ethereal Crest currency

### 11.1.0.2
* Added support for The Bilgewater Cartel reputation currency
* Added support for The Blackwater Cartel reputation currency
* Added support for The Steamwheedle Cartel reputation currency
* Added support for The Venture Company reputation currency

### 11.1.0.1
* Added support for Weathered Undermine Crest currency
* Added support for Carved Undermine Crest currency
* Added support for The Cartels of Undermine reputation currency

### 11.1.0.0
* Added support for Undermine (TWW)

### 11.0.7.0
* Added support for Siren Isle (TWW)
* Added icon for world quests that involve Legion world bosses (quest TagID 144)

### 11.0.5.2
* Added support for Bronze Celebration Token currency

### 11.0.5.1
* Fixed error caused by recent World of Warcraft patch.

### 11.0.5.0
* Added functionality to allow for multiple icons. In other words, for the "boss"
  type world quests, it can show the skull icon surrounded by the silver dragon.
  (This update is purely cosmetic.)
* There is now a configuration setting labeled "Show 'NEW' text for recently found
  world quests".  It defaults to ON (checked), since that's how the addon has always
  worked.  But, if you prefer not to see the "NEW" text at the beginning of lines,
  you can toggle this setting.  This is likely more useful for those who are switching
  between expansions regularly and don't want to see everything listed as "NEW" every
  time the switch is made.

### 11.0.2.21
* Fixed bug with the quest icons

### 11.0.2.20
* The addon will now automatically change expansions if you zone into a zone
  associated with that expansion (including when you first enter the game).  This
  should make things easier for those playing alts or who are still completing 
  world quests in past expansions for achievements, etc.  If you dislike this feature,
  you can disable it in the settings -- look for "Auto switch expansions based on 
  current zone".
* The "Time Remaining" column will now give the remaining time in days/hours for 
  any quest with more than one day remaining, hours/minutes for any quest with more
  than one hour remaining, and just minutes for any quest with less than one hour
  remaining.  (The coloring logic has not changed.)
  
### 11.0.2.19
* Tom Tom is now an optional dependency (i.e., the Tom Tom addon is 
  no longer required.)
* TWW Epic PvP type world quests now have the pvp icon at the front
  of the row, similar to pet battles, etc.

### 11.0.2.18
* Added support for City of Threads World Quests

### 11.0.2.17
* Fixed bug:  https://github.com/Amadeus-/Broker_WorldQuests/issues/21

### 11.0.2.16
* Fixed a bug with the "attach list frame to world map" feature as described at
  https://github.com/Amadeus-/Broker_WorldQuests/issues/20

### 11.0.2.15
* When enabled in settings, the Tom Tom waypoints support feature will now "add"
  waypoints rather than just adding/removing a single waypoint.
* TWW Epic Boss type world quests now have the appropriate icon at the front
  of the row, similar to pet battles, etc.
* Fixed a bug that was introduced in version 11.0.2.13.
* Now that Bloody Tokens are also part of the TWW expansion, the filter settings
  for that currency has been moved next to "Honor".

### 11.0.2.14
* The locked "Special Assignment" (Capstone) world quests are now included. While
  locked, what's provided by the addon is primarily informational. Once unlocked, then
  it becomes like any other world quest. 
* Dragon Rider Racing type world quests now have the appropriate icon at the front
  of the row, similar to pet battles, etc.
* Updated settings options:
  * Added new option to filter out Dragon Rider Racing type world quests.  It's 
    under "Filter by type".
  * Moved the filter setting for "Bloody Tokens" to within the Dragon Isles section.
  * Added new checkbox option (at the bottom of the list) to enable/disable
    "Spew Debug Information".  This is intended for use by those working on the 
    addon and should be unchecked for most users unless requested by a developer.

### 11.0.2.13
* Added support for world quests that only provide information regarding
  an XP reward to the addon API. In other words, there are world quests that
  have a line of blue text when you inspect it, "Awards a one-time Warband
  reputation bonus", but the addon API provides no other information about it.
  So, long story short, for these particular quests, the broker window will only
  show how much XP it provides.
* Began the process of cleaning up the source to be easier to read, consolidate 
  local variables together, avoid using local variables that aren't needed, etc.
  There will be a lot of line changes, but this (and future similar changes) will
  not affect functionality unless it's described in this file.

### 11.0.2.12
* Added support for The Weaver, The General, and The Vizier currencies

### 11.0.2.11
* Fixed shift-clicking rows to set quest tracker

### 11.0.2.10
* Added support for Council of Dornogal currency

### 11.0.2.9
* Fixed currencies being incorrect or showing as zero.
* Increased the max width of the BWQ window.
* Increased the size of the red highlight arrow (that appears on the map
  when you click on a WQ in the addon) by 35%.

### 11.0.2.8
* Added support for Kej currency

### 11.0.2.7
* Added support for Valorstones currency

### 11.0.2.6
* Added support for Azj-Kahet

### 11.0.2.5
* Added support for Hallowfall Arathi currency

### 11.0.2.4
* World Quests will now properly unlock for all appropriate characters in The War Within

### 11.0.2.3
* Disabled text notification for unhandled currency.  This is intended for developers.

### 11.0.2.2
* Fixed criteria for unlocking World Quests in The War Within
* Added support for currency:  Resonance Crystals
* Added support for currency:  The Assembly of the Deeps

### 11.0.2.1
* Initial updates required for The War Within
* New users will be set to the expansion appropriate to their current level instead of defaulting
  to the latest expansion.

### 11.0.2.0
* Fixed deprecated call to IsAddonLoaded()

### 11.0.0.2
* Updates to Faction related calls due to API changes with 11.0.0

### 11.0.0.1
* Updates for WoW version 11.0.0

### 10.2.7.0
* Updates for Dragonflight 10.2.7

### 10.2.5.1
* Fixed an issue affecting Polished Pet Charms (thanks tflo for catching it.)

### 10.2.5.0
* Updates for Dragonflight 10.1, 10.2 and 10.2.5

### 10.1.7
* TOC Bump

### 10.1.0
* Added Zaralek Cavern and Flightstone currency

### 10.0.7
* Added Forbidden Reach zone and Elemental Overflow currency 

### 10.0.2.8
* Fixed WQs not properly showing for "Primalist Tomorrow" zone (Dragonflight)

### 10.0.2.7
* Added support for "Rustbolt Resistance" reputation currency (added in WoW v. 8.2.0.30918)

### 10.0.2.6
* Added support for "Primalist Tomorrow" zone (Dragonflight)

### 10.0.2.5
Changes below submitted by ntowle (github)
* Broker options for Dragon Isles Supplies, Bloody Tokens, Polished Pet Charms
* Filters for Dragon Isles Supplies, Bloody Tokens
* Split DF reputation out
* Options for DF reputation by faction
* Total Polished Pet Charms available
* Total Dragon Isles Supplies available
* Reorganize menus to move old expansion options to submenus
* Fix Grateful Offering checkbox
* Fix Conduits icon

### 10.0.2.4
* Add support for Valdrakken Accord (Dragonflight reputation currency)

### 10.0.2.3
* Add support for Bloody Tokens (Dragonflight PVP Currency)

### 10.0.2.1
* Updates for Shadowlands compatibility
* Initial Updates for Dragonflight compatibility

### 9.0.63
* Bug fixes

### 9.0.62
* Added BfA assault zones
* Fixed paragon faction bar performance issue
* Fixed some filters

### 9.0.61
* Bug fixes for Shadowlands pre-patch

### 8.1.58
* Fixed incorrect questIds for Battle on Zandalar and Kul Tiras

### 8.1.57
* Added quest title highlight for achievement quest criterias
    - Fishing 'Round The Isles (Legion Fishing)
    - Battle on the Broken Isles (Legion Pet Battle)
    - Battle on Zandalar and Kul Tiras (Legion Pet Battle)
* Fixed faction display anchoring/width
* Fixed no world quests error message showing when all zones are collapsed

### 8.1.56
* Added basic TomTom support. Clicking a row will set this quest as waypoint.
* Added option to hide paragon reputation bars
* Removed expansion toggle in dropdown menu (use the buttons in the top-right corner)
* Moved some options to reduce number of dropdown items
