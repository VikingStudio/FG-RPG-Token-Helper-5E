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

v1.1.1 (March 15th, 2019)
- Include medium and long range numbers cut off numbers in distance calculations (<= instead of <) [scripts/ranged_attacks: getRangeModifier5e]    
- Automatic range modifiers code now includes ranged spells that have an Attack Roll (ATK) as well. [scripts/ranged_attacks.lua: getWeaponRanges5e]