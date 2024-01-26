**This list is continously updated whenever we confirm findings.**

**Log hooks are provided by Blizzard. WCL cannot fix it.**

Maintained by the WCL Team. If you have any question, additions or updates, please reach out on our [Discord](https://discord.gg/5ebPJSsy5y) or dm me (`xepher1s`).
Thanks to all the folks helping spotting these and reporting them.

**Last updated: Jan 24**. [Click for an overview of changes](https://gist.github.com/ljosberinn/a2f08a53cfe8632a18350eea44e9da3e/revisions)

- [FAQ](#faq)
- [Reattribution problems](#reattribution-problems)
  * [General bugs](#general-bugs)
    + [Full Absorbs do not reattribute](#full-absorbs-do-not-reattribute)
    + [Negative Reattribution](#negative-reattribution)
    + [Friendly Fire can reattribute](#friendly-fire-can-reattribute)
    + [Healing Reattribution is often broken for any hot](#healing-reattribution-is-often-broken-for-any-hot)
    + [Reattribution does not factor in throughput-increasing non-player originating auras](#reattribution-does-not-factor-in-throughput-increasing-non-player-originating-auras)
    + [Empty Support Events](#empty-support-events)
    + [Other](#other)
  * [Abilities not reattributing anything](#abilities-not-reattributing-anything)
    + [Racials](#racials)
    + [Warrior](#warrior)
    + [Rogue](#rogue)
    + [Hunter](#hunter)
    + [Demon Hunter](#demon-hunter)
    + [Warlock](#warlock)
    + [Shaman](#shaman)
    + [Druid](#druid)
    + [Monk](#monk)
    + [Mage](#mage)
    + [Priest](#priest)
    + [Shaman](#shaman-1)
    + [Paladin](#paladin)
    + [Other](#other-1)
  * [Abilities not reattributing Ebon Might](#abilities-not-reattributing-ebon-might)
    + [Warrior](#warrior-1)
    + [Shaman](#shaman-2)
    + [Hunter](#hunter-1)
    + [Druid](#druid-1)
    + [Demon Hunter](#demon-hunter-1)
    + [Death Knight](#death-knight)
    + [Warlock](#warlock-1)
    + [Paladin](#paladin-1)
    + [Shaman](#shaman-3)
    + [Rogue](#rogue-1)
    + [Warrior](#warrior-2)
  * [Abilities not reattributing Shifting Sands](#abilities-not-reattributing-shifting-sands)
    + [Paladin](#paladin-2)
    + [Warrior](#warrior-3)
    + [Druid](#druid-2)
    + [Rogue](#rogue-2)
    + [Hunter](#hunter-2)
  * [Special cases](#special-cases)
    + [Priest](#priest-1)
    + [Warlock](#warlock-2)
    + [Hunter](#hunter-3)

# FAQ

<details>
  <summary>What does this mean for me as affected spec that gets buffed or as Augmentation Evoker?</summary>

  Basically, this inflates the buffed players throughput. Not all of what they owe to the buffing Evoker gets reassigned because the combat log simply doesn't tell us.
  
  As example, one week they may get buffed by 2 Evokers and will have a good parse as result. The next week, they perform at around the same level, but don't get buffed at all. Their resulting performance will be (possibly significantly) worse because they are competing with players that may have dedicated Evokers buffing them specifically or accidentally, and of course their past self.
  
  **Why is this problematic?** Depending on the degree of lack of reattribution, both parties have a significantly harder time to evaluate their performance:
  - the Evokers throughput is combined into other players throughput making it harder to tell who is a good target to buff & when & why
  - other players throughput is inflated making it harder for them to e.g. compare cooldown windows
 
  Depending on factors such as tuning, raid composition and individual player skill it may however be the better play to intentionally buff badly reattributing specs. After all, what matters is that you contribute to downing that boss.
</details>

<details>
  <summary>How to Spot a Lack of Reattribution</summary>
  
  - obviously the first step is to make sure the player received any buffs. theres multiple ways to do so but the easiest is to just hover a players throughput column and see whether it has a tooltip:

  ![image](https://user-images.githubusercontent.com/29307652/281195244-3c565dfd-9655-42bf-bfa2-fb2fbc70326d.png)
  
  - if not, then this player was not buffed at all.  
  - if so, click the buffed player and hover the DPS column. for a reattributing ability, it should look similar to this depending on how frequently they were buffed:
  
  ![image](https://user-images.githubusercontent.com/29307652/281191522-632af644-10ff-4935-9cbf-a229d21c3ba9.png)
  
  - an ability not reattributing simply wont have this tooltip
  
  ![image](https://user-images.githubusercontent.com/29307652/281191638-5bba54ab-d0ba-4289-b462-931a4dd6764e.png)
  
  - now this is a bit more tricky. each ability that reattributes should have a reattributing event basically _directly_ or very close after the initial event. there may be minor delay but usually they are share the same timestamp.
  
  - **do note that certain things are expected to not reattribute**:
    - embellishments and trinkets don't scale with main stat, so no `Ebon Might` reattribution
    - abilities that are guaranteed to crit e.g. during `Combustion` or `Lava Burst` should not reattribute `Prescience`
  
</details>

# Reattribution problems

<details>
  <summary>What is reattribution and how does it work?</summary>
  
  Reattribution is what we call the process of reassigning throughput from a buffed player to the implicit origin, the buffing Evoker.

  Blizzard themselves are providing the tools for this via the combat log file. Addons in game have also access to _a_ combat log, but it sees different things than what's in the file. Addons however have no access to the file, which is why addons cannot reattribute ingame.

  **How does it work?**

  The process is relatively simple, but this is technical so buckle up. The combat log is effectively just a text file, each line is an event and events come in different sizes and shapes, for example `SPELL_DAMAGE` or `ENCOUNTER_START`.

  Let's start with an unbuffed player and how a simplified combat log could look for them:

  ```sh
  1, SPELL_DAMAGE, Vollmer-Ragnaros, 120, 20, 1
  ```

  which translates to:

  ```sh
  timestamp: 1
  type: SPELL_DAMAGE
  player: Vollmer-Ragnaros
  damage done: 120
  mitigated: 20
  ability id: 1
  ```

  In above example, Vollmer used ability 1 (melee) to do 120 damage of which 20 were mitigated, so 100 effective damage.

  If Vollmer would've been buffed, it'd look like this:

  ```sh
  1, SPELL_DAMAGE, Vollmer-Ragnaros, 138, 23, 1
  1, SPELL_DAMAGE_SUPPORT, Xephyris-Blackrock, Vollmer-Ragnaros, 18, 3, 395152
  ```
  which translates to:

  ```sh
  timestamp: 1
  type: SPELL_DAMAGE_SUPPORT
  player: Xephyris-Blackrock
  buffed player: Vollmer-Ragnaros
  damage done: 18
  mitigated: 3
  ability id: 395152
  ```

  which states that Xephyris did 18 damage via the spell 395152 (`Ebon Might`), which in turn means, these 18 should be deducated from Vollmer (138 - 18 => 120 like before).

  The ongoing reattribution issues have multiple facettes:
  - events missing entirely: a specific spell scales with main stat but simply doesn't result in _SUPPORT events
    - there's subcases of spells that should conditionally reattribute but currently don't. e.g. shadow priest will do more damage via `Shadowy Apparitions` via a [talent](https://www.wowhead.com/spell=391284/tormented-spirits) because of procs from crit. some of these crits will be due to `Prescience`. Thus some `Shadowy Apparitions` damage should be reattributed. This is likely not as straight forward as just main stat scaling and also probably within the margin of error in the grand scope. 
  - events missing for a specific buff: a specific spells scales with main stat and should reattribute e.g. Ebon Might, but doesn't. the spell properly reattributes for Prescience however
  - events sometimes missing, e.g. under specific circumstances: a specific spell doesn't reattribute all the time but should, e.g. fully absorbed hits don't reattribute currently (see below)
  - events claiming too much: a specific spell claims _very obviously_ too much, e.g. 100% of the origin events value
  - events claiming too little: a specific spell claims _very obviously_ too little, e.g. negative values
  - events effectively empty: a specific spell (sometimes) simply has no value. not 0, just no value at all
  - events sent when they shouldn't: the player isn't buffed anymore and hasn't been for a considerable time so it can't be projectiles being fired when a buff was still present
  
</details>

## General bugs

### Full Absorbs do not reattribute
- [`Ebon Might`, `Shifting Sands` and `Prescience` do not reattribute anything if the origin damage is fully absorbed](https://www.warcraftlogs.com/reports/23ncHaKrhQRzVvMW#fight=41&type=damage-done&pull=9&source=2&target=433)
  - note how in that log the mentioned abilities do 0 damage despite [considerable uptime](https://www.warcraftlogs.com/reports/23ncHaKrhQRzVvMW#fight=41&type=auras&pull=9&pins=2%24Off%24%23244F4B%24expression%24ability.name%20in%20(%22Prescience%22,%20%22Ebon%20Might%22,%20%22Shifting%20Sands%22)&options=2)
  -  this was [fixed prior](https://www.warcraftlogs.com/reports/pT1jJ9bCA4fx6vg3#fight=49&type=damage-done&pull=9&source=1) but reintroduced on July 26
  -  `Inferno's Blessing` and `Fate Mirror` work
### Negative Reattribution
- [in large pulls, support events may write negative values](https://www.warcraftlogs.com/reports/23ncHaKrhQRzVvMW#fight=47&type=damage-done&pins=2%24Off%24%23244F4B%24expression%24effectiveDamage%20%3C%200&view=events), presumably until leaving combat
  - note that this seem in fact to be directly related to the pull size. we've only seen it on e.g. the first pull of Neltharion's Lair or pulls with many lashers in Brackenhide Hollow between 1st and 2nd boss
  - another good example here on [`Tindral Sageswift`](https://www.warcraftlogs.com/reports/Q4cz7XTKg9F1BZGM#fight=41&type=damage-done&pins=2%24Off%24%23244F4B%24expression%24effectiveDamage%20%3C%200&view=events)

### Friendly Fire can reattribute  
- [trinket friendly fire on yourself reattributes](https://www.warcraftlogs.com/reports/zCdypcK83xaLvfnh#fight=67&type=summary&view=events&start=11609328&end=11613883&pins=2%24Off%24%23244F4B%24expression%24(target.name%20%3D%20%22Gigadb%22%20or%20supportedActor.name%20%3D%20%22Gigadb%22)%20and%20ability.id%20in%20(401394,%20413984)%20and%20target.name%20!%3D%20%22Magmorax%22), e.g. Echo of Neltharion trinkets or `Vessel of Searing Shadows`
- environmental damage may reattribute (needs reproduction example)

### Healing Reattribution is often broken for any hot
- healing attribution is broken for any hot
  - it'll claim up to 100% of the healing done
    - e.g. note [`Ebon Might` taking 100% of this `Lifebloom`](https://www.warcraftlogs.com/reports/V6dqjXHTyWGR8QMZ#fight=3&type=healing&translate=true&pins=2%24Off%24%23244F4B%24expression%24((ability.name%20%3D%20%22Lifebloom%22%20and%20source.name%20%3D%20%22%E8%8E%AB%E5%84%8D%E5%84%8D%22)%20or%20supportedActor.name%20%3D%20%22%E8%8E%AB%E5%84%8D%E5%84%8D%22)%20and%20effectiveHealing%20%3E%200&view=events&start=219857&end=222827)
  - for examples, just check [the Aberrus Augmentation leaderboard for Healing](https://www.warcraftlogs.com/zone/rankings/33#class=Evoker&spec=Augmentation&partition=4&metric=hps), e.g. [this log](https://www.warcraftlogs.com/reports/V6dqjXHTyWGR8QMZ#fight=3&type=healing&translate=true)

### Reattribution does not factor in throughput-increasing non-player originating auras
- player buffs and debuffs increasing throughput such as orbs on Smolderon, P2 of last boss Throne of the Tides, P2 of last boss Black Rook Hold are not factored into reattribution events of `Shifting Sands`, meaning too little throughput is subtracted from buffed targets

### Empty Support Events

https://www.warcraftlogs.com/reports/X2yBtArq6RbVkD1Z#fight=5&type=damage-done&start=1285631&end=1285631&view=events

Note how these:

![image](https://user-images.githubusercontent.com/29307652/278869773-8a64de12-f409-458a-b693-4cf0bc7891e3.png)

are not only empty but also, the hunter does not have Shifting Sands from these evokers at the time:

![image](https://user-images.githubusercontent.com/29307652/278869767-2e4e5e6b-9f30-4c5c-991a-073a8e12a1a5.png)

### Other
- `Prescience` sometimes claims the _entire_ damage of the origin ability for a short period of time
- ~~`Breath of Eons` [sometimes doesn't extend `Ebon Might`](https://www.warcraftlogs.com/reports/Q4cz7XTKg9F1BZGM#fight=57&pull=14&type=summary&start=42619579&end=42626637&pins=0%24Separate%24%23244F4B%24casts%240%240.0.0.Any%24176244533.0.0.Evoker%24true%240.0.0.Any%24false%24403631%5E0%24Separate%24%23909049%24auras-gained%240%240.0.0.Any%240.0.0.Any%24true%240.0.0.Any%24false%24395152%5E2%24Off%24%23a04D8A%24expression%24ability.name%20in%20(%22Breath%20of%20Eons%22,%20%22Ebon%20Might%22)%20and%20type%20not%20in%20(%22heal%22,%20%22damage%22)&view=events)~~ fixed Nov 29
- ~~`Prescience` can claim damage even if the origin damage wasn't actually a crit. Discovered Dec 15, but present since July 25. [example](https://www.warcraftlogs.com/reports/Hd38L4fCYXjZ7yVR#fight=8&type=damage-done&pins=2%24Off%24%23244F4B%24expression%24ability.name%20%3D%20%22Prescience%22%20and%20isCritical%20%3D%20false&view=events)~~ false positive! this is intentional for special cases such as a crit triggering `Blade Flurry`/`Ignite`/`Caustic Splatter`/`Sanguine Blades`-like abilities that don't crit. `Prescience` will then tax appropriately, but as non-crit

## Abilities not reattributing anything

We'll try to provide examples for each but this list grew over a couple of months so bear with us while we don't have examples for all.

### Racials
- [`Entropic Embrace`](https://www.warcraftlogs.com/reports/GJAgTzhHRf6pVcbk#fight=22&type=damage-done&pins=0%24Separate%24%23909049%24auras-gained%240%240.0.0.Any%240.0.0.Any%24true%24682167.0.0.Rogue%24false%24395152%5E0%24Separate%24%23a04D8A%24auras-gained%240%240.0.0.Any%240.0.0.Any%24true%24682167.0.0.Rogue%24false%24410089%5E0%24Separate%24%23DF5353%24auras-gained%240%240.0.0.Any%240.0.0.Any%24true%24682167.0.0.Rogue%24false%24413984%5E0%24Separate%24rgb(78%25,%2061%25,%2043%25)%24damage%240%240.0.0.Any%24682167.0.0.Rogue%24true%240.0.0.Any%24false%24259756%5E2%24Off%24rgb(78%25,%2061%25,%2043%25)%24expression%24supportedActor.name%20%3D%20%22Zaese%22%20or%20source.name%20%3D%20%22Zaese%22&source=3&view=events&start=3149340&end=3152340) (id 259756)

### Warrior
- `Finishing Wound` (id 426284)

### Rogue
- ~~`Blade Flurry` (id 22482)~~ reattributes as of Dec 13
- ~~[`Shadow Blades`](https://www.warcraftlogs.com/reports/GJAgTzhHRf6pVcbk#fight=22&type=damage-done&source=3&pins=0%24Separate%24%23244F4B%24damage%240%240.0.0.Any%24682167.0.0.Rogue%24true%240.0.0.Any%24false%24279043%5E0%24Separate%24%23909049%24auras-gained%240%240.0.0.Any%240.0.0.Any%24true%24682167.0.0.Rogue%24false%24395152%5E0%24Separate%24%23a04D8A%24auras-gained%240%240.0.0.Any%240.0.0.Any%24true%24682167.0.0.Rogue%24false%24410089%5E0%24Separate%24%23DF5353%24auras-gained%240%240.0.0.Any%240.0.0.Any%24true%24682167.0.0.Rogue%24false%24413984%5E2%24Off%24rgb(78%25,%2061%25,%2043%25)%24expression%24supportedActor.name%20%3D%20%22Zaese%22%20or%20source.name%20%3D%20%22Zaese%22&start=3149318&end=3152319&view=events) (id 279043)~~ reattributes as of Dec 13
- `Soulreave` (id 409605) and `Soulrip` (id 409604) -- both components of Aberrus T30 so not terribly important at this point
- ~~`Sanguine Blades` (id 423193)~~ reattributes as of Dec 13
- `Poisoned Edges` (id 409483)
- ~~`Caustic Splatter` (id 421979)~~ reattributes as of Nov 29
- `Sudden Demise` (id 343769)
- ~~`Envenomous Explosion` (id 426581)~~ reattributes as of Nov 29
- ~~`Shadow Eviscerate` (id 424491)~~ reattributes as of Jan 23 (probably fixed with 10.2.5)

### Hunter
- ~~`Beast Cleave` (id 118459)~~ reattributes since Nov 22
- ~~`Kill Cleave`~~ reattributes since Nov 22

### Demon Hunter
- [`Soulscar`](https://www.warcraftlogs.com/reports/GJAgTzhHRf6pVcbk#fight=22&type=damage-done&source=3&pins=0%24Separate%24%23244F4B%24auras-gained%240%240.0.0.Any%240.0.0.Any%24true%24684609.0.0.DemonHunter%24false%24395152%5E0%24Separate%24%23909049%24damage%240%240.0.0.Any%24684609.0.0.DemonHunter%24true%240.0.0.Any%24false%24390181%5E2%24Off%24%23a04D8A%24expression%24supportedActor.name%20%3D%20%22Senkets%C3%BC%22%20or%20source.name%20%3D%20%22Senkets%C3%BC%22&view=events&start=3146230&end=3149231) (id 390181)
- [`Ragefire`](https://www.warcraftlogs.com/reports/GJAgTzhHRf6pVcbk#fight=22&type=damage-done&source=3&pins=0%24Separate%24%23244F4B%24auras-gained%240%240.0.0.Any%240.0.0.Any%24true%24684609.0.0.DemonHunter%24false%24395152%5E0%24Separate%24%23909049%24damage%240%240.0.0.Any%24684609.0.0.DemonHunter%24true%240.0.0.Any%24false%24390197%5E2%24Off%24%23a04D8A%24expression%24supportedActor.name%20%3D%20%22Senkets%C3%BC%22%20or%20source.name%20%3D%20%22Senkets%C3%BC%22&view=events&start=3158592&end=3161593) (id 390197)
- ~~[`Chaotic Disposition`](https://www.warcraftlogs.com/reports/GJAgTzhHRf6pVcbk#fight=15&type=damage-done&source=3&pins=0%24Separate%24%23909049%24auras-gained%240%240.0.0.Any%240.0.0.Any%24true%24693120.0.0.DemonHunter%24false%24395152%5E0%24Separate%24%23909049%24damage%240%240.0.0.Any%24693120.0.0.DemonHunter%24true%240.0.0.Any%24false%24428493%5E2%24Off%24%23a04D8A%24expression%24supportedActor.name%20%3D%20%22Neosferus%22%20or%20source.name%20%3D%20%22Neosferus%22&start=1901054&end=1907738&ability=395152&view=events) (id 428493)~~ has been reworked into a buff instead
- `The Hunt` (id 370971) - healing
- `Charred Warblades` (id 213011) - healing

### Warlock
- [`Dimensional Cinder`](https://www.warcraftlogs.com/reports/GJAgTzhHRf6pVcbk#fight=22&type=damage-done&source=3&pins=0%24Separate%24%23244F4B%24damage%240%240.0.0.Any%24694020.0.0.Warlock%24true%240.0.0.Any%24false%24427285%5E0%24Separate%24%23909049%24auras-gained%240%240.0.0.Any%240.0.0.Any%24true%24694020.0.0.Warlock%24false%24395152%5E0%24Separate%24%23a04D8A%24auras-gained%240%240.0.0.Any%240.0.0.Any%24true%24694020.0.0.Warlock%24false%24410089%5E2%24Off%24%23DF5353%24expression%24supportedActor.name%20%3D%20%22Romchutwo%22%20or%20source.name%20%3D%20%22Romchutwo%22&view=events&start=3149342&end=3152342) (id 427285)

### Shaman
- `Lightning Rod`
- `Ancestral Guidance` (id 114911)

### Druid
- [`Frenzied Assault`](https://www.warcraftlogs.com/reports/GJAgTzhHRf6pVcbk#fight=22&type=damage-done&source=3&pins=0%24Separate%24%23244F4B%24damage%240%240.0.0.Any%24614276.0.0.Druid%24true%240.0.0.Any%24false%24391140%5E0%24Off%24%23909049%24auras-gained%240%240.0.0.Any%240.0.0.Any%24true%24614276.0.0.Druid%24false%24395152%5E0%24Off%24%23a04D8A%24auras-gained%240%240.0.0.Any%240.0.0.Any%24true%24614276.0.0.Druid%24false%24413984%5E2%24Off%24%23DF5353%24expression%24supportedActor.name%20%3D%20%22Acessa%22%20%20or%20source.name%20%3D%20%22Acessa%22&view=events&start=3151735&end=3154735) (id 391140)
- [`Tear`](https://www.warcraftlogs.com/reports/GJAgTzhHRf6pVcbk#fight=22&type=damage-done&source=3&pins=0%24Separate%24%23244F4B%24damage%240%240.0.0.Any%24614276.0.0.Druid%24true%240.0.0.Any%24false%24391356%5E0%24Separate%24%23909049%24auras-gained%240%240.0.0.Any%240.0.0.Any%24true%24614276.0.0.Druid%24false%24395152%5E0%24Separate%24%23a04D8A%24auras-gained%240%240.0.0.Any%240.0.0.Any%24true%24614276.0.0.Druid%24false%24413984%5E2%24Off%24%23DF5353%24expression%24supportedActor.name%20%3D%20%22Acessa%22%20or%20source.name%20%3D%20%22Acessa%22&view=events&start=3167893&end=3170894&eventstart=3169134) (id 391356)
- [`Burning Frenzy`](https://www.warcraftlogs.com/reports/GJAgTzhHRf6pVcbk#fight=22&type=damage-done&source=3&pins=0%24Separate%24%23244F4B%24damage%240%240.0.0.Any%24614276.0.0.Druid%24true%240.0.0.Any%24false%24422779%5E0%24Off%24%23909049%24auras-gained%240%240.0.0.Any%240.0.0.Any%24true%24614276.0.0.Druid%24false%24395152%5E0%24Off%24%23a04D8A%24auras-gained%240%240.0.0.Any%240.0.0.Any%24true%24614276.0.0.Druid%24false%24413984%5E2%24Off%24%23DF5353%24expression%24supportedActor.name%20%3D%20%22Acessa%22%20or%20source.name%20%3D%20%22Acessa%22&view=events&start=3151804&end=3154805) (id 422779)

### Monk
- `Boneduest Brew` (id 325217)
- `Charred Passions` (id 386959)
- `Charred Dreams` (id 425299)
- melee hits as Mistweaver
- note that these below may be reattributing `Shifting Sands` and it's based on a key log where naturally no sands were on the mw
- `Ancient Teachings` (ids 388024, 388025)
- `Chi Harmony` (id 423458)
- `Ancient Protection` (id 429271)
- `Soothing Mist` (id 115175)

### Mage
- `Glacial Blast` (id 424120) -- should NOT reattribute `Prescience` but `Ebon Might` and `Shifting Sands`

### Priest
- melee as disc priest -- for completeness sake I suppose...
- `Vampiric Embrace` (id 15290) - healing
- `Devouring Plague` (id 335467) - healing
- `Vampiric Touch` (id 34914) - healing
- `Mindgames` (ids 375902, 375904) - healing
- `Halo` (id 390971) - healing
- `Binding Heal` (id 368276)
- `Sanctuary` (id 208771)

### Shaman
- `Lava Slag` (id 427729) T31 4pc
- melee for Elemental -- for completeness sake

### Paladin
- `Cleansing Flame` (ids 425261, 425262) T31 4pc
- `Shield of Vengeance` (id 184689) -- unsure if this should reattribtue `Ebon Might`, but it certainly scales with vers and should reattribute `Shifting Sands`
- `Blessed Hammer` (id 229976) doesn't reattribute healing
- `Bulwark of Order` (id 209388)

### Other
- `Timestrike` (id 419737) does not reattribute anything
- `Leech` is not reattributing anything but is arguably low priority

## Abilities not reattributing Ebon Might

### Warrior
- `Fatal Mark` (id 383706)

### Shaman
- [`Flametongue Attack`](https://www.warcraftlogs.com/reports/Q4cz7XTKg9F1BZGM#fight=41&type=damage-done&pins=0%24Separate%24%23244F4B%24auras-gained%240%240.0.0.Any%240.0.0.Any%24true%24175883852.0.0.Shaman%24false%24395152%5E2%24Off%24%23909049%24expression%24(source.name%20%3D%20%22Avesone%22%20and%20ability.name%20%3D%20%22Flametongue%20Attack%22)%20or%20supportedActor.name%20%3D%20%22Avesone%22&start=31890610&end=31923888&view=events) (id 10444)

### Hunter
- ~~[`Kill Command`](https://www.warcraftlogs.com/reports/GJAgTzhHRf6pVcbk#fight=10&type=damage-done&start=1190659&end=1193759&source=24&view=events&ability=83381&pins=0%24Off%24%23244F4B%24auras-gained%240%240.0.0.Any%240.0.0.Any%24true%240.0.0.Any%24false%24395152%5E0%24Off%24%23909049%24damage%240%240.0.0.Any%240.0.0.Any%24true%240.0.0.Any%24false%24395152%5E2%24Off%24%23a04D8A%24expression%24supportedActor.name%20%3D%20%22Jabl%22%20or%20source.name%20in%20(%22Jabl%22,%20%22Bloodgullet%22,%20%22Thickboy%22)&by=ability) (id 83381)~~
  - `Kill Command` sourced to BM / Survival hunter reattribute since Nov 21
  - `Kill Command` sourced to `Dire Beasts` reattributes since Nov 29
- ~~`Claw`~~ fixed on or before Nov 21
- `Kill Cleave` can stop reattributing `Ebon Might` for the remainder of a key (and presumably similarily in raid until zoning out) if the main pet dies and gets rezzed
  - note how [here](https://www.warcraftlogs.com/reports/pKrJvxTkYHabQcDf#fight=8&type=damage-done&source=15) Catwag has no reattribution on Kill Cleave from `EM`
  - [plenty of reattribution from Foxwag](https://www.warcraftlogs.com/reports/pKrJvxTkYHabQcDf#fight=8&type=damage-done&source=14) which [died sec 18](https://www.warcraftlogs.com/reports/pKrJvxTkYHabQcDf#fight=8&type=summary&pins=2%24Off%24%23244F4B%24expression%24type%20%3D%20"death"&view=events) and [got rezzed 4s later](https://www.warcraftlogs.com/reports/pKrJvxTkYHabQcDf#fight=8&type=casts&view=events&source=12&ability=982)
  - it [does work the next key again however](https://www.warcraftlogs.com/reports/pKrJvxTkYHabQcDf#fight=11&type=damage-done&source=12)
- bm hunters can underattribute regardless of above fixes when the main pet loses its internal reattribution status somehow
  - sounds obscure but the devs are aware

### Druid
- `Tear Open Wounds` (id 391786) -- also does not reattribute `Shifting Sands`, see below
- `Tear` (id 391356) -- also does not reattribute `Shifting Sands`, see below

### Demon Hunter
- ~~`Sigil of Flame` DoT~~ fixed on or before Nov 16

### Death Knight
- `Death Coil` DoT

### Warlock
- `Soul Cleave` (id 387502) via Fel Guard

### Paladin
- melee as holy paladin. note this is different to melee from mistweaver which indeed does not reattribute _anything_, while hpal reattributes `Shifting Sands` and `Prescience`

### Shaman
- `Earthquake` (id 77478)

### Rogue
- `Shadow Rupture` (id 424493) only reattributes `Prescience`

### Warrior
- `Fervid Bite` (id 425534) only reattributes `Prescience`, see below

## Abilities not reattributing Shifting Sands

### Paladin
- `Shield of Vengeance` (id 184689)
- [`Hammer of Wrath`](https://www.warcraftlogs.com/reports/Q4cz7XTKg9F1BZGM#fight=10&type=damage-done&source=295) (id 24275)

### Warrior
- `Fervid Bite` (id 425534) only reattributes `Prescience`, see above

### Druid
- ~~`Feral Frenzy` (id 274838) [is not reattributing its bleed. the initial hit works](https://www.warcraftlogs.com/reports/QgNV8PZ6KxMCFyvD#fight=50&type=damage-done&pins=0%24Separate%24%23244F4B%24auras-gained%240%240.0.0.Any%240.0.0.Any%24true%24174431619.0.0.Druid%24false%24395152%5E0%24Separate%24%23909049%24auras-gained%240%240.0.0.Any%240.0.0.Any%24true%24174431619.0.0.Druid%24false%24413984%5E0%24Separate%24%23a04D8A%24casts%240%240.0.0.Any%24174431619.0.0.Druid%24true%240.0.0.Any%24false%24274837%5E2%24Off%24%23DF5353%24expression%24(source.name%20%3D%20%22Guiltyas%22%20and%20ability.name%20%3D%20%22Feral%20Frenzy%22)%20or%20supportedActor.name%20%3D%20%22Guiltyas%22&view=events&start=5028349&end=5034926&eventstart=5029901). it's a bit harder to spot but note how after each non-tick event, an `Ebon Might` reattribution event is present for the same millisecond, but for the ticks, there's none. also note that it's not possible to limit reattribution to a specific ability, so its showing other damage reattribution in here too, meaning that the next `Ebon Might` event that is delayed by e.g. 50 milliseconds at `01:48.488` is from another damage source. the matching EM event should be at `01:48.434` like `Shifting Sands` and `Prescience` are.~~ reattributing presumably since 10.2.5
- [`Brambles`](https://www.warcraftlogs.com/reports/kwZ6XztvhKa4Gj81#fight=3&type=damage-done&pull=1&pins=0%24Separate%24%23244F4B%24auras-gained%240%240.0.0.Any%240.0.0.Any%24true%24207209715.0.0.Druid%24false%24395152%5E2%24Off%24%23909049%24expression%24(source.name%20%3D%20%22Mubz%22%20and%20ability.name%20%3D%20%22Brambles%22)%20or%20supportedActor.name%20%3D%20%22Mubz%22&view=events&start=532522&end=579620) (id 203958)
- `Tear Open Wounds` (id 391786) -- also does not reattribute `Ebon Might`, see above
- `Tear` (id 391356) -- also does not reattribute `Ebon Might`, see above

### Rogue
- `Shadow Rupture` (id 424493) only reattributes `Prescience`, see above

### Hunter
- there seem to be general reattribution problems for BM hunters with SS.
  - in [this log](https://www.warcraftlogs.com/reports/AnPVdrXc13DW4Rxa#fight=10&type=auras&translate=true&ability=413984), Havoc and BM have roughly the same uptime (9% difference)
  - yet Havoc - which at this time is still heavily underattributing due to `Ragefire` and `Soulscar` not reattributing anything - gains 22.98k dps from SS, while the Hunter gains only 14.23k (~38% difference)
  - both do gain roughly the same from `Ebon Might`: Hunter 14.91k <-> Havoc 15.66k
  - note that the culprit seem to be pet-sourced abilities. reattribution for damage sourced to the hunter has usually `Shifting Sands` dominating, but for pets its always behind `Ebon Might`

## Special cases

### Priest
- `Prescience` does not work with `Shadowy Apparitions` or `Tormented Spriits`

### Warlock
- `Prescience` does not seem to increase `Chaos Bolt` damage

### Hunter
- `Master Marksman`(id 269576) seems to be underattributing heavily; [example log](https://www.warcraftlogs.com/reports/PVnpY12WzgNr83RT#fight=last&type=damage-done&source=106), only 297/6282 (~4.7%) are reattributed
