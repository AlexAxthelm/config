---
name: tldraw-offline
description: >-
  Create, edit, read, or diagram inside tldraw offline — the local desktop
  whiteboard app whose documents are `.tldraw` files. Use this whenever the user
  mentions a `.tldraw` file, the tldraw offline app, or asks you to draw, sketch,
  diagram, whiteboard, lay out boxes-and-arrows, or build/modify a canvas on
  their machine — even if they don't say "tldraw" by name. Critically, use it
  BEFORE touching any `.tldraw` file: hand-editing the archive corrupts it, and
  this skill explains the supported path (the app's local HTTP API) instead.
---

# Working with tldraw offline

tldraw offline is a local desktop whiteboard app. Its documents are `.tldraw`
files: a zip containing `db.sqlite`, `metadata.json`, `session.json`, and an
`assets/` folder. The app also exposes a **local HTTP API** so agents can read
and edit an open canvas.

## The one rule that saves you an hour

**Never hand-edit a `.tldraw` file** — do not unzip it, edit `db.sqlite`, and
re-zip. The container will look byte-perfect and still fail to open.

Here's why: on load, tldraw validates every record against its store schema
(exact prop sets, `richText` as structured objects, internal clock/session
bookkeeping). Records that weren't produced by tldraw's own `Editor` fail that
validation, and the app **silently refuses to open the file** — no error, just a
blank Home screen. You cannot reliably reproduce tldraw's record construction by
hand.

Instead, drive the running app through its API and let tldraw build valid
records for you. tldraw's own guidance is blunt: *"Do NOT hand-place shapes to
imitate a drawing — write the code that generates them,"* and *"Do not edit the
`.tldraw` archive with a filesystem CLI while it is open in the app."*

## Prerequisites: the app must be running with a document open

The API operates on **already-open documents** — it cannot open or create files
itself. Before doing anything, confirm a document is focused (see the helper
below). If none is open:

- Ask the user to open the file or create a new one (**File → New**), **or**
- On macOS, open a specific file into the running app:
  `open -a "tldraw offline" /path/to/file.tldraw`

If the app isn't running at all, ask the user to launch it — don't try to
generate a file offline to bootstrap it.

## Talk to the API (use the helper)

A bundled helper handles the fiddly parts (locating `server.json`, reading the
per-launch token, bearer auth, JSON). Prefer it over raw `curl`.

```bash
SKILL=~/.config/claude/skills/tldraw-offline   # adjust if installed elsewhere
python3 "$SKILL/scripts/tldraw_api.py" docs                 # print the live API readme
python3 "$SKILL/scripts/tldraw_api.py" doc                  # id of the focused document (or "none")
python3 "$SKILL/scripts/tldraw_api.py" search '<js>'        # run JS against the `api` object
python3 "$SKILL/scripts/tldraw_api.py" exec <docId> file.js # run JS against the real Editor
python3 "$SKILL/scripts/tldraw_api.py" shot <docId> out.png # screenshot to a file, prints the path
```

The helper re-reads the port and token on every call, which matters: the token
rotates per app launch, and a fresh shell won't inherit an exported value —
caching it produces silent `401`s.

Doing it by hand instead? Read `port` + `token` from `server.json`
(macOS: `~/Library/Application Support/tldraw/server.json`,
Linux: `~/.config/tldraw/server.json`,
Windows: `%APPDATA%\tldraw\server.json`), send
`Authorization: Bearer <token>` on every request except `GET /`, and re-read
both **inline on each call**.

## The core loop

You don't need to plan the final layout up front. Place a few shapes at rough
coordinates on a coarse grid (~260px pitch), screenshot, then nudge with
`editor.updateShape` / `helpers.translateShapes` and add the next batch. Reading
the page first (step 1) gives you the ids of existing shapes so you can extend or
edit them instead of starting over.

**1. Find the document and read what's there.**

```bash
python3 "$SKILL/scripts/tldraw_api.py" doc          # -> tldr:file:....  (the docId)
python3 "$SKILL/scripts/tldraw_api.py" search 'const d=await api.getFocusedDoc(); return (await api.getShapes(d.id)).shapes.map(s=>({id:s.id,type:s.type}))'
```

Useful read-only calls inside `search` (the object is `api`, not `spec`):
`api.getDocs()`, `api.getFocusedDoc()`, `api.getShapes(docId)`,
`api.getBindings(docId)`, `api.getScreenshot(docId)`. When you need a method you
don't know, search `api.members`; for worked patterns, read `api.recipes`.

**2. Make changes with `exec`.** Write the edit as a `.js` snippet and run it
against the Editor. Snippets run in an async context; import SDK helpers with
dynamic `import`:

```js
const { createShapeId, toRichText } = await import('tldraw')

// A box. richText MUST be toRichText('...') — a bare string is rejected.
editor.createShape({
  id: createShapeId('api'),
  type: 'geo',
  x: 100, y: 100,
  props: { geo: 'rectangle', w: 220, h: 100, color: 'violet', fill: 'solid',
           richText: toRichText('API\n(FastAPI)') },
})

// An arrow that is actually *bound* to both shapes (moves when they move).
// helpers.createArrowBetweenShapes handles the arrow + both bindings in one call.
helpers.createArrowBetweenShapes(createShapeId('api'), createShapeId('db'), {
  arrowheadEnd: 'arrow',
  richText: toRichText('SQL'),   // optional edge label
  bend: 0,                        // >0 / <0 bows the arrow to route around boxes
})

editor.zoomToFit({ animation: { duration: 0 } })
return { shapes: editor.getCurrentPageShapes().length }   // return plain JSON
```

Return plain JSON (ids, counts, booleans) — not shape objects.

**Grow the diagram; edit in place. Don't clear-and-rebuild to iterate.** Each
`exec` is additive, so build across several small snippets rather than composing
the whole thing at once. Give every shape a stable id (`createShapeId('api')`):
re-running then *updates in place* instead of duplicating, and you can change any
one shape later by id without touching the rest.

```js
// Edit an existing shape — no rebuild. Move / relabel / recolor / resize:
editor.updateShape({ id: createShapeId('api'), type: 'geo',
  x: 120, y: 260,                                                // move
  props: { color: 'green', richText: toRichText('API v2') } })  // recolor + relabel
```

For additive building, `helpers.createShapeIfMissing(partial)` /
`createShapesIfMissing([...])` seed shapes only if their stable id isn't already
present — safe to re-run as you grow the diagram.

Clear the page only when you truly want a blank slate — never just to make an
edit: `editor.deleteShapes(editor.getCurrentPageShapes().map(s => s.id))`.

**3. Verify visually.** Placement is hard to judge blind:

```bash
python3 "$SKILL/scripts/tldraw_api.py" shot <docId> /tmp/canvas.png
```

Then read the PNG. Adjust coordinates/`bend` values and re-run step 2 until it
reads cleanly (no arrow crossing a box, no overlapping labels).

**4. Tell the user to save.** `exec` edits are live but **unsaved** — the file on
disk is unchanged until the user presses **Cmd/Ctrl+S**. Say so explicitly. You
generally can't save for them (the API has no save endpoint).

## Layout tips that avoid ugly diagrams

- Give nodes a consistent size and space them on a grid; let arrows bind to
  shapes rather than placing loose endpoints.
- When an arrow would cut through a box, don't move the box — add a `bend` so it
  arcs around. Iterate against a screenshot; sign and magnitude are easy to eyeball.
- Color communicates grouping. Valid tldraw colors: `black, grey, blue,
  light-blue, violet, light-violet, green, light-green, yellow, orange, red,
  light-red, white`.

## Durable, reopen-safe behavior

`exec` is for one-off edits to the drawing. Anything expected to survive
reload — run-on-open logic, clickable UI, animation, reactive layout — belongs in
a **document script**, not `exec` (runtime listeners/timers from `exec` vanish
when the doc closes). That path uses `POST /api/doc/:id/script-workspace` plus
`script-status`. See `references/canvas-api.md` for the full API surface, the
document-script contract, and its idempotency/cleanup rules before going there.

## More detail

`references/canvas-api.md` — endpoints, the full `api.*` and `helpers.*` surface,
shape-type required props, document scripts, and gotchas. Read it when a call
fails or you need something beyond boxes and arrows.
