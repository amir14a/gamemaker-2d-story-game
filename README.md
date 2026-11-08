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

- **Android**: set the target to `Android`, config `armv8 | debug` for a
  debug-signed APK (the workflow does exactly this).
- **HTML5**: set target to `HTML5`; the game uses only the built-in font and
  procedural art, so it needs no bundled assets.

---

## CI / CD (`.github/workflows/build.yml`)

The workflow, on **push to `main`**, on **`v*` tags**, or on **manual dispatch**:

1. **Build Android** — `igor --target="android" --config="armv8|debug"` → a
   debug-signed **armv8 (arm64) APK** (GameMaker signs debug builds with the
   bundled debug keystore automatically).
2. **Build Web** — `igor --target="HTML5"` → zips the `index.html` + `html5game/`
   output into `neon-echo-web.zip`.
3. **Deploy GitHub Pages** — the expanded web build is deployed to the repo's
   Pages site.
4. **Release** — a GitHub Release is created (name from tag or computed date) and
   **both** the armv8 APK and the web ZIP are attached to the *same* release.

### Required setup

The workflow runs `igor` (the GameMaker CLI) inside a container image. You must
either:

- point the two `container:` blocks at a **GameMaker CI image** that ships `igor`,
  the Android SDK/NDK, and (optionally) a license — e.g. swap
  `ghcr.io/your-org/gamemaker-ci:latest` for your own image; **or**
- run the jobs on a **self-hosted runner** that already has GameMaker + Android
  SDK installed (then delete the `container:` blocks).

Add a **repository secret** if your image needs license activation:

```
GMS_LICENSE = <your GameMaker entitlement / license>
```

Enable **GitHub Pages** (Settings → Pages → source "GitHub Actions") and make sure
the repo has the default **Read & write** workflow permission (the workflow also
requests `contents: write` and `pages: write`).

---

## Credits / craft notes

Built against the spine of *The Last of Us*, *Brothers: A Tale of Two Sons*,
*Taken*, *Blade Runner*, *Children of Men*, *Léon*, *Life is Strange*,
*Red Dead Redemption 2*, *God of War (2018)* and *Prisoners* — see `STORY.md`
for the full craft notes and the complete beat-by-beat script.