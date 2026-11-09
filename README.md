# NEON ECHO — The Story of James & Millie

> *"Count the stars with me. I'll always be one of them."* — Mara Vance

A **2D cyberpunk story game** told across **five continuous episodes**, built as a
**GameMaker Studio (2024.x / LTS)** project. You play **James Vance**, hunting the
drowned neon sprawl of **Verge City** for his sister **Millie** — and in the
**flashbacks** you play as Millie, where the truth of the story is quietly buried.

Every asset is **drawn procedurally as vector art** — there is not a single bitmap
sprite, sound file, or font file in the project. Characters, the city skyline,
rain, ash, paper cranes, vehicles and the whole UI are generated in GML at runtime.

---

## The story (from `STORY.md`)

Five strata frame the five episodes, each opening on the exact beat the last one
cut away from, and each ending on a knife-edge:

1. **The Sink** — *Breadcrumbs*. Rooftops, a street-kid courier, Books' junk-shop.
2. **The Loop** — *The Loop*. A high-speed neon ring-road run; a distorted voice on the comm.
3. **The Floodworks** — *Drowned Light* (the midpoint reversal). Millie is not a captive — she is the **Ghost**.
4. **The Foundry** — *The Factory* (all is lost). You were never the rescuer. *"You're the bait, James."*
5. **The Apex** — *Crown of Stars*. The only real sky in Verge City; the lullaby paid off.

Three motifs planted early and harvested late: **paper cranes**, the **star-counting
lullaby**, and the **scar on James's hand**.

### How the story is delivered *inside* the levels

| Delivery | Description |
| --- | --- |
| **Subtitles** | Ambient thoughts/callouts float at the lower third; never stop the action. |
| **Comm pop-ups** | Framed dialogue cards with the speaker's name + colour; advance with `E`/ACTION. |
| **Meetings** | Books, Millie, Cray and Saint step into the frame as rendered figures. |
| **Trigger zones** | Invisible zones pace dialogue by *movement*, not by menus. |
| **Flashbacks** | Short playable sections where you are **Millie** (warm magenta wash). |

### Mechanics

Running, parkour (vault + wall-run), climbing, shooting, driving (Ep 2),
riding (Ep 4) and swimming (Ep 3 & 5) — each episode combines several, and Millie
is only playable in the flashbacks.

---

## Project layout

```
neon-echo.yyp                  # GameMaker project file
options/main/options_main.yy   # project options (960x540, HTML5/Android ready)
rooms/rm_game/                 # the single continuous play room (engine rebuilds per scene)
objects/                       # controller, player, hostile, bullet, crane, vehicle, trigger
scripts/                       # all game logic + vector drawing
sprites/                       # empty placeholder sprites (art is procedural)
.github/workflows/build.yml    # CI: Android armv8 APK + Web build + Pages + Release
```

### Notable scripts

| Script | Role |
| --- | --- |
| `scr_palette.gml` | The full neon colour palette + speaker colours. |
| `scr_draw.gml` | Vector drawing primitives: rounded rects, glows, scanlines, stars. |
| `scr_story.gml` | Every line of dialogue for all 5 episodes + flashbacks, as structured beats. |
| `scr_world.gml` | Procedural skyline / motes (rain, sparks, ash, bubbles, stars) per stratum. |
| `scr_scene.gml` | Scene builder: sets mode, spawns hostiles/cranes/vehicles/goals. |
| `scr_input.gml` | Keyboard + on-screen touch controls (Android) behind one API. |
| `scr_menu.gml` | Title menu, pause, episode select — all vector art. |
| `scr_save.gml` | JSON save via the file sandbox / localStorage. |

---

## Opening & building locally

1. Open **GameMaker Studio 2024.x (or LTS)** and open `neon-echo.yyp`.
2. Press **F5** (or Run) — the game boots straight into the title menu.
3. Controls (desktop):
   - **Move** — `←`/`→` (and `W`/`S` for climb/swim/ladders)
   - **Jump** — `Spacebar`
   - **Shoot** — `F`
   - **Interact / advance dialogue** — `E`
   - **Pause** — `Esc`
4. On Android, the on-screen thumbstick and buttons are drawn automatically.

### Exports

- **Android**: target `Android`, arm64 (armv8) architecture — see
  `options/android/options_android.yy`. CI produces a debug-signed APK.
- **Web**: the game is pure vector art + the built-in font, so it needs no
  bundled assets.

---

## CI / CD (`.github/workflows/build.yml`)

The workflow uses the **official open-source GameMaker CLI — `@gamemaker/gm-cli`
(Apache-2.0, by YoYoGames/Opera)** directly on stock `ubuntu-latest` runners.
**No Docker image and no license secret are required** — `gm-cli` downloads Igor
+ the GameMaker runtime on demand and supplies a guest license automatically.
The Android SDK/NDK/JDK and the debug keystore are all provisioned **inside the
GitHub runner**, so nothing needs to be installed on any developer machine.

It runs on **push to `main`**, on **`v*` tags**, or on **manual dispatch**:

1. **Build Android** — `gm-cli package --target android --output NeonEcho-armv8-debug.apk`
   → a debug-signed **armv8 (arm64) APK** (a debug keystore generated on the runner,
   plus the SDK/NDK/JDK versions GameMaker requires: API 36, Build-Tools 37.0.0,
   NDK 30.0.15729638, JDK 17).
2. **Build Web** — `gm-cli package --target operagx --output neon-echo-web.zip`
   → the browser (HTML5/WebAssembly) build, zipped and unpacked for Pages.
3. **Deploy GitHub Pages** — the web build is deployed to the repo's Pages site.
4. **Release** — a GitHub Release is created (name from tag or computed date) and
   **both** the armv8 APK and the web ZIP are attached to the *same* release.

> **Note — web target:** the open-source CLI currently packages
> `mac, windows, linux, operagx, android`. The legacy `html5` target isn't wired
> into `gm-cli package` yet ("coming soon"), so the browser build uses
> `operagx` (GX.games), which is the HTML5/WebAssembly web export and is served
> from GitHub Pages. When `html5` lands in `gm-cli`, change `--target operagx`
> back to `--target html5`.

### Required setup

- **GitHub Pages** — enable it (Settings → Pages → source **"GitHub Actions"**).
- **Workflow permission** — ensure the repo's workflow permission is **Read & write**
  (the workflow also requests `contents: write` and `pages: write` itself).
- **`GAMEMAKER_PAT` secret (Android only)** — the **web** build works with the
  free guest license, but **Android export is a paid GameMaker target**. Add your
  access key from <https://gamemaker.io/en/account/access-keys> as a repository
  secret named **`GAMEMAKER_PAT`**, or the Android job fails with
  `Permission Error : Unable to obtain permission to execute`.

### What is pinned where

| Item | Pinned value |
| --- | --- |
| GameMaker CLI | `@gamemaker/gm-cli@2.4.1` (top of the workflow's `env`) |
| Android API | `36` (`ANDROID_API` in the workflow) |
| Android Build-Tools | `37.0.0` |
| Android NDK | `30.0.15729638` |
| JDK | Temurin 17 (`actions/setup-java`) |
| arm64 arch | `option_android_arch_arm64: true` in `options/android/options_android.yy` |

---

## Credits / craft notes

Built against the spine of *The Last of Us*, *Brothers: A Tale of Two Sons*,
*Taken*, *Blade Runner*, *Children of Men*, *Léon*, *Life is Strange*,
*Red Dead Redemption 2*, *God of War (2018)* and *Prisoners* — see `STORY.md`
for the full craft notes and the complete beat-by-beat script.