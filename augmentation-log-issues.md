**This list is continously updated whenever we confirm findings.**

**Log hooks are provided by Blizzard. WCL cannot fix it.**

Maintained by the WCL Team. If you have any question, additions or updates, please reach out on our [Discord](https://discord.gg/5ebPJSsy5y) or dm me (`xepher1s` discord & twitter).
Thanks to all the folks helping spotting these and reporting them.

**Last updated: July 31**. [Click for an overview of changes](https://gist.github.com/ljosberinn/a2f08a53cfe8632a18350eea44e9da3e/revisions).

Note this document was overhauled in June 2024 to allow a better overview. Older bugs and their context can be seen in the changelog linked above.

- [General Bugs](#general-bugs)
  - [Shifting Sands Reattribution does not factor in throughput-increasing debuffs](#shifting-sands-reattribution-does-not-factor-in-throughput-increasing-debuffs)
  - [Negative Reattribution](#negative-reattribution)
  - [Enemies with shared health reattribute an additional time](#enemies-with-shared-health-reattribute-an-additional-time)
  - [Friendly Fire can reattribute](#friendly-fire-can-reattribute)
  - [Empty Support Events](#empty-support-events)
- [Per Class](#per-class)
  - [Warrior](#warrior)
    - [The War Within](#the-war-within)
  - [Mage](#mage)
    - [The War Within](#the-war-within-1)
  - [Warlock](#warlock)
    - [Special Cases](#special-cases)
  - [Priest](#priest)
    - [Special Cases](#special-cases-1)
  - [Shaman](#shaman)
    - [The War Within](#the-war-within-2)
  - [Rogue](#rogue)
    - [The War Within](#the-war-within-3)
  - [Paladin](#paladin)
    - [The War Within](#the-war-within-4)
  - [Evoker](#evoker)
    - [The War Within](#the-war-within-5)
  - [Demon Hunter](#demon-hunter)
  - [Monk](#monk)
    - [The War Within](#the-war-within-6)
    - [Special Cases](#special-cases-2)
  - [Death Knight](#death-knight)
    - [The War Within](#the-war-within-7)
  - [Druid](#druid)
  - [Hunter](#hunter)
    - [The War Within](#the-war-within-8)
    - [Special Cases](#special-cases-3)
  - [Other](#other)

# General Bugs

In order of importance.

## Shifting Sands Reattribution does not factor in throughput-increasing debuffs

<details><summary>click to expand</summary>

Quite the mouthful of a description, I know. An example:

In scenarios where you gain a debuff increasing player throughput, the increase is not reflected in the support log lines for `Shifting Sands`, meaning too little damage is subtracted from buffed players.

This applies to all seen cases where debuffs increase throughput, such as:

- Smolderon intermission orbs
- Tindral, Dream Essence
- Throne of the Tides, last boss, P2 empowerment
- Black Rook Hold, last boss, P2 empowerment

</details>

## Negative Reattribution

<details><summary>click to expand</summary>

**WCL could zero these events out but this makes it intransparent whether it's fixed. Additionally, the negative values are commonly disproportionally low so it's not as simple as multiplying them by -1.**

Whenever there's a lot of enemies present in a pull, support events may write negative values. Instead of being _granted_ the damage, this results in the buffing evoker to have damage subtracted from them, meaning they appear to have done less contribution than they actually did.

Notable examples:

- [Tindral, the roots / treants overlap at ~0:45min](https://www.warcraftlogs.com/reports/X7gPAR2Vthn1BNcG#fight=14&type=damage-done&pins=2%24Off%24%23244F4B%24expression%24effectiveDamage%20%3C%200&view=events)
- any very large pull in dungeons, such as:
  - Brackenhide Hollow between 1st and 2nd boss whenever lots of lashers are present
  - [Neltharion's Lair first pull with lots of small Crawlers](https://www.warcraftlogs.com/reports/23ncHaKrhQRzVvMW#fight=47&type=damage-done&pins=2$Off$#244F4B$expression$effectiveDamage%20%3C%200&view=events)

</details>

## Enemies with shared health reattribute an additional time

<details><summary>click to expand</summary>

**WCL is fixing these on our end.**

Given bosses with shared healthpools, the game writes support event lines for the damage mirrored to the shared health target, but sources these events to the NPC.

This not only inflates the buff damage of the Aug, but also makes it appear as if the Aug buffed the bosses which does not happen.

These damage events are however entirely incorrect and did not occur ingame.

Examples:

- Erunak Stonespeaker/Mindbender Ghur'sha (Throne of the Tides, 3rd boss; excluded on WCL end)
  - [example link](https://www.warcraftlogs.com/reports/AjW2PHxf14pnYcwX#fight=8&type=summary&pull=11&pins=2%24Off%24%23244F4B%24expression%24supportedActor.type%20%3D%20%22npc%22&view=events)
- Teera & Maruuk (Nokhud Offensive, 3rd boss; excluded on WCL end)
  - [example link](https://www.warcraftlogs.com/reports/X6hQKLVW9RAtrbfP#fight=9&type=damage-done&pull=15&source=5&pins=2%24Off%24%23244F4B%24expression%24supportedActor.type%20%3D%20%22npc%22&view=events)
- The Silken Court (Nerub'ar Palace)
  - [example link](<https://www.warcraftlogs.com/reports/Gwyh4TrFd7gbfVxn#fight=5&type=damage-done&ability=-442204&view=events&pins=2%24Off%24%23244F4B%24expression%24effectiveDamage%20in%20(2377766,%201094996,%201529984,%20339806,%201142270,%201079850,%20146105,%20320522)>)
  </details>

## Friendly Fire can reattribute

<details><summary>click to expand</summary>

- [trinket friendly fire on yourself reattributes](<https://www.warcraftlogs.com/reports/zCdypcK83xaLvfnh#fight=67&type=summary&view=events&start=11609328&end=11613883&pins=2%24Off%24%23244F4B%24expression%24(target.name%20%3D%20%22Gigadb%22%20or%20supportedActor.name%20%3D%20%22Gigadb%22)%20and%20ability.id%20in%20(401394,%20413984)%20and%20target.name%20!%3D%20%22Magmorax%22>), e.g. Echo of Neltharion trinkets or `Vessel of Searing Shadows`

</details>

## Empty Support Events

<details><summary>click to expand</summary>

https://www.warcraftlogs.com/reports/X2yBtArq6RbVkD1Z#fight=5&type=damage-done&start=1285631&end=1285631&view=events

Note how these:

![image](https://user-images.githubusercontent.com/29307652/278869773-8a64de12-f409-458a-b693-4cf0bc7891e3.png)

are not only empty but also, the hunter does not have Shifting Sands from these evokers at the time:

![image](https://user-images.githubusercontent.com/29307652/278869767-2e4e5e6b-9f30-4c5c-991a-073a8e12a1a5.png)

</details>

# Class-Specific Bugs

## Warrior

- `Finishing Wound` (id 426284) does not reattribute anything
- `Fervid Bite` (id 425534) does not reattribute `Shifting Sands` or `Ebon Might`

### The War Within

- `Thunder Blast` (id 436793) does not reattribute anything
  - this is via `Ground Current` hero talent
  - note that 435222, the primary effect, does fully reattribute

## Mage

- `Glacial Blast` (id 424120) -- should NOT reattribute `Prescience` but `Ebon Might` and `Shifting Sands`

### The War Within

- `Frostfire Empowerment` (id 431186) does not reattribute `Ebon Might`
  - tooltip is misleading, this is the 11.0 set 2pc
- `Magi's Spark Echo` (id 458375) is not reattributing anything
- `Embedded Arcane Splinter` (id 444736) is not reattributing anything
  - note that `Embedded Arcane Splinter` (id 444735) _is_ fully reattributing
- `Embedded Frost Splinter` (id 443934) is not reattributing anything
  - note that `Embedded Frost Splinter` (id 443740) _is_ fully reattributing  
- `Dematerialize` (id 461498) is only reattributing `Shifting Sands` - cannot crit, so only `Ebon Might` missing
- `Controlled Instincts` (id 444720) does not reattribute anything (Arcane)
- `Controlled Instincts` (id 444487) does not reattribute anything (Frost)
- nothing from `Arcane Phoenix` (id 448659) reattributes

## Warlock

- `Dimensional Cinder` (id 427285) does not reattribute anything
- `Soul Cleave` (id 387502) via `Fel Guard` does not reattribute `Ebon Might`

### Special Cases

- `Prescience` does not seem to increase `Chaos Bolt` damage
  - if it does, the damage increase does not get forwarded to the Evoker, probably because `Chaos Bolt` is a guaranteed crit and these abilities are exempted

## Priest

- `Vampiric Embrace` (id 15290) healing does not reattribute anything
- `Devouring Plague` (id 335467) healing does not reattribute anything
- `Vampiric Touch` (id 34914) healing does not reattribute anything
- `Halo` (id 390971) - healing does not reattribute anything
- `Binding Heal` (id 368276) does not reattribute anything
- `Sanctuary` (id 208771) does not reattribute anything

### Special Cases

- `Prescience` does not tax `Shadowy Apparitions` or `Tormented Spirits`

## Shaman

- `Lightning Rod` (id 197568) does not reattribute anything
- `Ancestral Guidance` (id 114911) does not reattribute anything
- `Lava Slag` (id 427729) T31 4pc does not reattribute anything
- `Earthquake` (id 77478) does not reattribute `Ebon Might`
- `Flametongue Attack`(id 10444) does not reattribute `Ebon Might`
- `Restorative Mists` (id 114083) does not reattribute anything
  - note that 294020 does

### The War Within

- `Ancestral Awakening` (id 382311) does not reattribute anything

## Rogue

- `Soulreave` (id 409605) and `Soulrip` (id 409604) do not reattribute anything
  - both components of Aberrus T30 so not terribly important at this point
- `Poisoned Edges` (id 409483) does not reattribute anything
- `Sudden Demise` (id 343769) does not reattribute anything
- `Shadow Rupture` (id 424493) does not reattribute `Shifting Sands` or `Ebon Might`

### The War Within

- `Fate Intertwined` (id 456306) does not reattribute anything
- `Ethereal Rampage` (id 459002) does not reattribute anything

## Paladin

- `Cleansing Flame` (ids 425261, 425262) T31 4pc does not reattribute anything
- `Blessed Hammer` (id 229976) healing doesn't reattribute anything
- `Bulwark of Order` (id 209388) does not reattribute anything
- `Hammer of Wrath` (id 24275) does not reattribute `Shifting Sands`

### The War Within

- `Truth Prevails` (id 461529) does not reattribute anything
  - this is the party overheal part, note that the self heal (id 461546) does reattribute
- `Dawnlight` (id 431399) does not reattribute anything
  - this is the initial damage
  - note that the dot (id 431380) does fully reattribute

## Evoker

- `Life-Givers Flame` (id 371441) does not reattribute anything
- `Temporal Anomaly` (id 373862) only reattributes `Shifting Sands` currently

### The War Within

- `Enkindle` (id 444017) does not reattribute anything
- `Spiritbloom` (id 409895) does not reattribute anything (this is the Chronowarden hot)

## Demon Hunter

- `Soulscar` (id 390181) does not reattribute anything
- `Ragefire` (id 390197) does not reattribute anything
- `The Hunt` (id 370971) healing does not reattribute anything
- `Charred Warblades` (id 213011) healing does not reattribute anything

## Monk

- `Boneduest Brew` (id 325217) does not reattribute anything
- `Charred Passions` (id 386959) does not reattribute anything
- `Charred Dreams` (id 425299) does not reattribute anything
- melee hits as Mistweaver do not reattribute anything

### The War Within

- `Aspect of Harmony` (id 450763) does not reattribute anything
- `Purified Spirit` (id 450820) does not reattribute anything
- `Overwhelming Force` (id 452333) does not reattribute anything
- `Tiger's Ferocity` (id 454508) does not reattribute anything

### Special Cases

Note that these below may be reattributing `Shifting Sands` and it's based on a key log where naturally no `Shifting Sands` were on the Mistweaver.

- `Ancient Teachings` (ids 388024, 388025) does not reattribute anything
- `Chi Harmony` (id 423458) does not reattribute anything
- `Ancient Protection` (id 429271) does not reattribute anything
- `Soothing Mist` (id 115175) does not reattribute anything

## Death Knight

- `Coil of Devastation` (390271) does not reattribute `Ebon Might`

### The War Within

- `Infliction of Sorrow` (id 434144) does not reattribute `Ebon Might`
- `The Blood is Life` (id 434246) does not reattribute `Ebon Might`
- `Reaper's Mark` (id 439594) does not reattribute anything
- `Blood Fever` (id 440005) does not reattribute anything
- `Shattered Frost` (id 455996) does not reattribute anything

## Druid

- `Brambles` (id 203958) does not reattribute `Shifting Sands`
- `Tear` (id 391356) does not reattribute `Shifting Sands` or `Ebon Might`
  - it does reattribute `Prescience`
- `Tear Open Wounds` (id 391786) does not reattribute `Shifting Sands` or `Ebon Might`

## Hunter

### The War Within

- `Laceration` (id 459560) does not reattribute anything

### Special Cases

- `Kill Cleave` can stop reattributing `Ebon Might` for the remainder of a key (and presumably similarily in raid until zoning out) if the main pet dies and gets rezzed
  - note how [here](https://www.warcraftlogs.com/reports/pKrJvxTkYHabQcDf#fight=8&type=damage-done&source=15) Catwag has no reattribution on Kill Cleave from `EM`
  - [plenty of reattribution from Foxwag](https://www.warcraftlogs.com/reports/pKrJvxTkYHabQcDf#fight=8&type=damage-done&source=14) which [died sec 18](https://www.warcraftlogs.com/reports/pKrJvxTkYHabQcDf#fight=8&type=summary&pins=2%24Off%24%23244F4B%24expression%24type%20%3D%20"death"&view=events) and [got rezzed 4s later](https://www.warcraftlogs.com/reports/pKrJvxTkYHabQcDf#fight=8&type=casts&view=events&source=12&ability=982)
  - it [does work the next key again however](https://www.warcraftlogs.com/reports/pKrJvxTkYHabQcDf#fight=11&type=damage-done&source=12)
- bm hunters can underattribute regardless of above fixes when the main pet loses its internal reattribution status somehow

## Other

- `Timestrike` (id 419737) does not reattribute anything
- `Leech` is not reattributing anything but is arguably low priority
- `Entropic Embrace` (id 259756) does not reattribute anything
