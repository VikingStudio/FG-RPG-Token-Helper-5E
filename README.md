# FG-Token-Helper
Fantasy Grounds Extension that has helper APIs for handling Tokens and their ranges on a battlemap in FG.

Changelog / Added / Modified:
Versioning: v(Major.Minor.Patch) https://en.wikipedia.org/wiki/Software_versioning

v1.0.0 (March 11th, 2019)
* Created token_helper.lua [scripts/token_helper.lua]
- APIs for handling various token related calls and queries.    
* Created ranged_attacks.lua [scripts/ranged_attacks.lua]
- Handles automatic ranged attack modifiers.

* Finds ranged weapon ranges by looking up their range in the database.
* Usable from character sheet or CT, for players and NPCs.
* Finds actual distance betwen tokens on map, including height differences.
* Compares weapon range to attack distance on the map.
* Includes logic for feats that have an effect on this, the Crossbow feat and Sharpshooter feat.
* Considers if there are active enemy in melee range (of 5'). 
    - Active meaning not suffering from the following conditions: Incapacitated, Paralyzed, Petrified, Restrained, Stunned, Unconscious.        
    - Only for medium and smaller sized tokens, 1 grid of width.
- Prints out message information about the ranged attack, weapon name, ranges, actual range, conditions the attack took place under.
* Created 5e_flanking.lua [scripts/5e_flanking.lua]
    - Automatic flanking advantage given if active ally found opposite of side of enemy the actor is attacking.
    - Active meaning not suffering from the following conditions: Incapacitated, Paralyzed, Petrified, Restrained, Stunned, Unconscious.    
* Prints out message notifying of a flanking melee attack if applicable.
* Only for medium and smaller sized tokens, 1 grid of width.

v1.1.0 (March 15th, 2019)
* Include medium and long range numbers cut off numbers in distance calculations (<= instead of <) [scripts/ranged_attacks: getRangeModifier5e]    
* Automatic range modifiers code now includes ranged spells that have an Attack Roll (ATK) as well. [scripts/ranged_attacks.lua: getWeaponRanges5e]

v1.1.1 (March 15th, 2019)
* Added exception for when no maps are open (theater of the mind combat), in that case no ranged or flanked logic is run. [scripts/ranged_attacks.lua: getRangeModifier5e, getRangeBetweenTokens5e | scripts/token_helper.lua: getTokenMap, isEnemyInMeleeRange5e, postChatMessage]

v1.1.2 (March 18th, 2019)
* Added conditions checking function before running ranged modifier logic. This was done to cover various situations, such as when running theater of the mind combat, entries on CT but missing or no tokens on map, no map open, attacking from CT entry (without token) onto token on map, etc. [scripts/ranged_attacks.lua: checkConditions]
* Exception added for missing token on map, that has CT entry [scripts/token_helper.lua: getTokenMap]

v1.1.3 (March 28th, 2019)
* Bugfix: If actor not on map flanking threw error. Fix: Flanking returns false if actor not on map. [scripts/5e_flanking.lua: isFlanking]

v1.1.3 (March 29th, 2019)
* Version number updated to v1.1.3 in extension.xml

v1.1.4 (March 29th, 2019)
* Bugfix: If PC didn't have target and rolled melee attack while flanking enabled it would throw an error. Now returns false in that situation. [scripts/5e_flanking.lua: isFlanking]

v1.1.5 (April 16th, 2019)
* Bugfix: If weapon or spell was deleted from the actions tab, the range finder would break at that point as there would be a gap in the iteration numbers. Fix: DB.getChildren used instead of manual iterator. [scripts/ranged_attacks.lua: getWeaponRanges5e]

v1.1.6 (May 21st, 2019)
* Bugfix: Flanking and ranged attacks didn't work if the target was 'Unidentified" / not named. This is because the DB looked up search by name. Now searching for CT entry nodepath. [scripts/token_helper.lua: getTokenMap, getActorByGrid, getActorIndexInTokenMap | scripts/5e_flanking.lua: isFlanking | scripts/ranged_attacks.lua: isEnemyInMeleeRange5e]

v1.1.7 (June 1st, 2019)
* In certain modules the parsing code broke due to an extra 'ft.' in front of the '/' in the range text. Exception added. [scripts/ranged_attacks.lua: getWeaponRanges5e]