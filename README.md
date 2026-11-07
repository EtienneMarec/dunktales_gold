# DunkTales in gold room (janky)

A [Noita](https://store.steampowered.com/app/881100/Noita/) mod that turns the gold room into an auto-pickup... with a catch: you have to listen to **DunkTales** and watch its clip at around 0.3 fps before you can move again.

Available on the [Steam Workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=3715218222).

## What it does

The first time you enter a gold biome during a run:

1. The DunkTales music starts playing.
2. All the gold around you is removed and its value (258,674 gold) is added straight to your wallet.
3. Your controls and inventory are locked for the whole song (3 min 12 s).
4. The clip plays fullscreen as a slideshow of 54 frames, timed to the lyrics so you can follow along karaoke-style.
5. When the song ends, you get your controls back and any leftover gold is cleaned up.

The slideshow keeps going while the game is paused, and the timer accounts for the time spent in the pause menu.

## Known jank

- Noita has no way to play video files, so the clip is only 54 still frames, and some of them are a bit blurry.
- The game does **not** pause during the song. You can still take damage, but the gold room is usually a safe place. If you hear yourself getting hurt, restart the mod: that stops the music.
- If the gold is shifted (e.g. by Fungal Shift), you still get the money.
- If a chunk isn't fully loaded, a bit of gold may be left behind.
- It triggers only once per run.

## Installation

**Steam Workshop:** subscribe on the [Workshop page](https://steamcommunity.com/sharedfiles/filedetails/?id=3715218222).

**Manual:**

1. Download or clone this repository.
2. Put the folder in `Noita/mods/` and make sure it is named `dunktales_gold`.
3. Enable the mod in the **Mods** menu of Noita.

## Project structure

```
dunktales_gold/
├── init.lua                  # Mod hooks: audio registration, player setup, frame rendering
├── files/
│   ├── music_checker.lua     # Detects the gold biome, gives the money, locks the player
│   └── image_utils.lua       # Picks and draws the right frame for the current time
├── data/
│   ├── audio/Desktop/        # FMOD bank containing the DunkTales event
│   └── imgs/                 # The 54 frames of the clip
├── GUIDs.txt                 # FMOD event/bank GUID mappings
├── mod.xml                   # Mod metadata
└── workshop.xml              # Steam Workshop metadata
```

To change when each frame appears, edit the `image_times_sec` table in `files/image_utils.lua` (times are in seconds).

## Credits

- Music: [DunkTales](https://youtu.be/xtlPywRdo6M) by **Shankmo**.
