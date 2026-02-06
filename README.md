# Snake (Godot 4.6)

A clean, classic Snake implementation in Godot 4.6 using GDScript.

## Open and Run
1. Open Godot 4.6.
2. Import this folder (`snake-godot`) as a project.
3. Press `F5` (or click **Run Project**).

## Controls
- Move: `Arrow Keys` or `WASD`
- Touch: swipe to steer (iOS/mobile web)
- Restart: `R`
- Back to menu: `Esc`

## Gameplay Defaults
Tweak in `/Users/josh/Library/CloudStorage/Dropbox/Code/Godot/Tests/snake-godot/scripts/config.gd`:
- Grid: `20x20`
- Cell size: `24`
- Start length: `3`
- Tick: `0.15s`
- Speed ramp: every `5` food, tick `*= 0.92`
- Min tick: `0.06s`
- Walls kill by default (`WRAP_AROUND = false`)

Best score is saved to `user://save_data.json` (works on desktop and web).

## Export: macOS
1. In Godot: **Project > Export**.
2. Install export templates if prompted.
3. Add preset: **macOS**.
4. Set app name/identifier as needed.
5. Click **Export Project...** and choose output path.

## Export: Web (HTML5)
1. In Godot: **Project > Export**.
2. Add preset: **Web**.
3. Keep default compatibility unless your target needs custom settings.
4. Export to a folder (for example `dist/web`).
5. Serve over HTTP (do not run directly from `file://`).

Quick local host examples:
- Basic: `python3 -m http.server 8080` (run inside export folder)
- Node alternative: `npx http-server . -p 8080`

Web notes:
- Godot web export requires WebAssembly + WebGL2-capable browser.
- Some setups/features may require `COOP`/`COEP` headers (for `SharedArrayBuffer` contexts).
- For hosts like GitHub Pages/Netlify/Vercel, configure headers if your build/runtime requires cross-origin isolation.
