**This list is continously updated whenever we confirm findings.**

**Log hooks are provided by Blizzard. WCL cannot fix it.**

Maintained by the WCL Team. If you have any question, additions or updates, please reach out on our [Discord](https://discord.gg/5ebPJSsy5y) or dm me (`xepher1s` discord & twitter).
Thanks to all the folks helping spotting these and reporting them.

**Last updated: June 19**. [Click for an overview of changes](https://gist.github.com/ljosberinn/a2f08a53cfe8632a18350eea44e9da3e/revisions).

Note this document was overhauled in June 2024 to allow a better overview. Older bugs and their context can be seen in the changelog linked above.

- [General Bugs](#general-bugs)
   * [Negative Reattribution](#negative-reattribution)
   * [Friendly Fire can reattribute](#friendly-fire-can-reattribute)
   * [Reattribution does not factor in throughput-increasing non-player originating auras](#reattribution-does-not-factor-in-throughput-increasing-non-player-originating-auras)
   * [Empty Support Events](#empty-support-events)
- [Per Class](#per-class)
   * [Warrior](#warrior)
   * [Mage](#mage)
   * [Warlock](#warlock)
      + [Special Cases](#special-cases)
   * [Priest](#priest)
      + [Special Cases](#special-cases-1)
   * [Shaman](#shaman)
   * [Rogue](#rogue)
   * [Paladin](#paladin)
   * [Evoker](#evoker)
   * [Demon Hunter](#demon-hunter)
   * [Monk](#monk)
      + [Special Cases](#special-cases-2)
   * [Death Knight](#death-knight)
   * [Druid](#druid)
   * [Hunter](#hunter)
      + [Special Cases](#special-cases-3)
   * [Other](#other)

# General Bugs

## Negative Reattribution

- [in large pulls, support events may write negative values](https://www.warcraftlogs.com/reports/23ncHaKrhQRzVvMW#fight=47&type=damage-done&pins=2%24Off%24%23244F4B%24expression%24effectiveDamage%20%3C%200&view=events), presumably until leaving combat
  - note that this seem in fact to be directly related to the pull size. we've only seen it on e.g. the first pull of Neltharion's Lair or pulls with many lashers in Brackenhide Hollow between 1st and 2nd boss
  - another good example here on [`Tindral Sageswift`](https://www.warcraftlogs.com/reports/Q4cz7XTKg9F1BZGM#fight=41&type=damage-done&pins=2%24Off%24%23244F4B%24expression%24effectiveDamage%20%3C%200&view=events)

## Friendly Fire can reattribute

- [trinket friendly fire on yourself reattributes](<https://www.warcraftlogs.com/reports/zCdypcK83xaLvfnh#fight=67&type=summary&view=events&start=11609328&end=11613883&pins=2%24Off%24%23244F4B%24expression%24(target.name%20%3D%20%22Gigadb%22%20or%20supportedActor.name%20%3D%20%22Gigadb%22)%20and%20ability.id%20in%20(401394,%20413984)%20and%20target.name%20!%3D%20%22Magmorax%22>), e.g. Echo of Neltharion trinkets or `Vessel of Searing Shadows`
- environmental damage may reattribute (needs reproduction example)

## Reattribution does not factor in throughput-increasing non-player originating auras

- player buffs and debuffs increasing throughput such as orbs on Smolderon, P2 of last boss Throne of the Tides, P2 of last boss Black Rook Hold are not factored into reattribution events of `Shifting Sands`, meaning too little throughput is subtracted from buffed targets

## Empty Support Events

https://www.warcraftlogs.com/reports/X2yBtArq6RbVkD1Z#fight=5&type=damage-done&start=1285631&end=1285631&view=events

Note how these:

![image](https://user-images.githubusercontent.com/29307652/278869773-8a64de12-f409-458a-b693-4cf0bc7891e3.png)

are not only empty but also, the hunter does not have Shifting Sands from these evokers at the time:

![image](https://user-images.githubusercontent.com/29307652/278869767-2e4e5e6b-9f30-4c5c-991a-073a8e12a1a5.png)

# Per Class

## Warrior

- `Finishing Wound` (id 426284) does not reattribute anything
- `Fatal Mark` (id 383706) does not reattribute `Ebon Might`
- `Fervid Bite` (id 425534) does not reattribute `Shifting Sands` or `Ebon Might`

## Mage

- `Glacial Blast` (id 424120) -- should NOT reattribute `Prescience` but `Ebon Might` and `Shifting Sands`

## Warlock

- `Dimensional Cinder` (id 427285) does not reattribute anything
- `Soul Cleave` (id 387502) via `Fel Guard` does not reattribute `Ebon Might`

### Special Cases

- `Prescience` does not seem to increase `Chaos Bolt` damage

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

- `Lightning Rod`
- `Ancestral Guidance` (id 114911) does not reattribute anything
- `Lava Slag` (id 427729) T31 4pc does not reattribute anything
- `Earthquake` (id 77478) does not reattribute `Ebon Might`
- `Flametongue Attack`(id 10444) does not reattribute `Ebon Might`

## Rogue

- `Soulreave` (id 409605) and `Soulrip` (id 409604) do not reattribute anything
  - both components of Aberrus T30 so not terribly important at this point
- `Poisoned Edges` (id 409483) does not reattribute anything
- `Sudden Demise` (id 343769) does not reattribute anything
- `Shadow Rupture` (id 424493) does not reattribute `Shifting Sands` or `Ebon Might`

## Paladin

- `Cleansing Flame` (ids 425261, 425262) T31 4pc does not reattribute anything
- `Blessed Hammer` (id 229976) healing doesn't reattribute anything
- `Bulwark of Order` (id 209388) does not reattribute anything
- `Hammer of Wrath` (id 24275) does not reattribute `Shifting Sands`

## Evoker

- `Enkindle` (id 444017) does not reattribute anything

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

### Special Cases

Note that these below may be reattributing `Shifting Sands` and it's based on a key log where naturally no `Shifting Sands` were on the Mistweaver.

- `Ancient Teachings` (ids 388024, 388025) does not reattribute anything
- `Chi Harmony` (id 423458) does not reattribute anything
- `Ancient Protection` (id 429271) does not reattribute anything
- `Soothing Mist` (id 115175) does not reattribute anything

## Death Knight

- `Blood Fever` (id 440005) does not reattribute anything
- `Reaper's Mark` (id 439594) does not reattribute anything
- `Death Coil` DoT does not reattribute `Ebon Might`

## Druid

- `Brambles` (id 203958) does not reattribute `Shifting Sands`
- `Tear` (id 391356) does not reattribute `Shifting Sands` or `Ebon Might`
  - it does reattribute `Prescience`
- `Tear Open Wounds` (id 391786) does not reattribute `Shifting Sands` or `Ebon Might`

## Hunter

- `Laceration (id 459560) does not reattribute anything

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
