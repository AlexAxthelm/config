# tldraw offline canvas API — reference

Fuller detail behind `SKILL.md`. Read the section you need; you don't need all of it.

## Table of contents
- [Connection](#connection)
- [Endpoints](#endpoints)
- [The `api` object (search)](#the-api-object-search)
- [The `editor` and `helpers` (exec)](#the-editor-and-helpers-exec)
- [Shape types and required props](#shape-types-and-required-props)
- [Arrows and bindings](#arrows-and-bindings)
- [Screenshots](#screenshots)
- [Durable behavior: document scripts](#durable-behavior-document-scripts)
- [Gotchas](#gotchas)

## Connection

`server.json` holds `{ port (default 7236), token, pid, startedAt, ... }`.
Locations:
- macOS: `~/Library/Application Support/tldraw/server.json`
- Linux: `~/.config/tldraw/server.json` (respects `$XDG_CONFIG_HOME`)
- Windows: `%APPDATA%\tldraw\server.json`

Base URL `http://localhost:<port>` (127.0.0.1 works). Every request except
`GET /` needs `Authorization: Bearer <token>`. Re-read port + token on every
call — the token is per app launch and exported shell vars don't survive a fresh
subshell, so caching yields silent `401`s. The bundled `scripts/tldraw_api.py`
does this for you.

## Endpoints

| Method | Path | Purpose |
|---|---|---|
| GET  | `/` | API readme (no auth) — always current, read it if unsure |
| POST | `/api/search` | Run JS against the `api` object: docs, shapes, bindings, screenshots, the Editor API reference |
| POST | `/api/doc/:id/exec` | Run JS against the real `Editor` in one document (create/edit shapes) |
| POST | `/api/doc/:id/script-workspace` | Expose live document-script file paths for durable edits |
| GET  | `/api/doc/:id/script-status` | Document-script watcher state / digests / apply errors |

Request bodies are `{"code": "<js>"}`. Responses are `{"success": true, "result": ...}`
or `{"success": false, ...}`.

## The `api` object (search)

Runs against a structured reference + live document state. Highlights:

Live state (async):
- `api.getDocs(opts?)` — open documents, most-recently-focused first. Each has
  `id, filePath, name, unsavedChanges, windowId, shapeCount, pageCount, hasScript`.
  `opts.name` is a case-insensitive filename substring filter.
- `api.getFocusedDoc()` — the focused doc, or `null`.
- `api.getShapes(docId)` — `{ page, viewport, shapes }` for the current page;
  `shapes` are raw tldraw records.
- `api.getBindings(docId)` — binding records (arrow⇄shape connections).
- `api.getScreenshot(docId)` — see [Screenshots](#screenshots).

Editor API reference (static, for discovery):
- `api.members` — Editor methods/props: `{ name, kind, signature, description, params, examples, category }`.
- `api.categories` — category names (shapes, selection, camera, bindings, …).
- `api.helpers` — the editor-bound conveniences available as `helpers.*` in `exec`.
- `api.imports` — what you can `import` in exec / document scripts; the `tldraw`
  entry lists every importable symbol.
- `api.recipes` — worked end-to-end recipes: `{ id, title, whenToUse, body }`.
  Query these before building durable behavior instead of guessing.

Example — dump the current page's shapes with text:
```js
const d = await api.getFocusedDoc()
const { shapes } = await api.getShapes(d.id)
return shapes.map(s => ({ id: s.id, type: s.type, x: s.x, y: s.y,
  text: s.props?.richText ? helpers?.richTextToPlainText?.(s.props.richText) : undefined }))
```

## The `editor` and `helpers` (exec)

Inside `exec`, `editor` is the real tldraw `Editor` and `helpers` holds bound
conveniences. Import SDK primitives dynamically: `const { createShapeId,
toRichText } = await import('tldraw')` (static `import` works only in document
scripts). Common calls:

- `editor.createShape(partial)` / `editor.createShapes([...])`
- `editor.updateShape({ id, type, props })`
- `editor.deleteShapes([id, ...])`
- `editor.getCurrentPageShapes()` / `editor.getCurrentPageShapeIds()`
- `editor.select(...ids)` / `editor.selectNone()`
- `editor.zoomToFit({ animation: { duration: 0 } })`
- Wrap batches in `editor.run(() => { ... })`; keep script-driven writes out of
  undo with `editor.run(fn, { history: 'ignore' })`.

`helpers.*` (from `api.helpers`):
- `createArrowBetweenShapes(fromId, toId, opts?)` — arrow + both bindings in one call.
- `createShapeIfMissing(stablePartial)` / `createShapesIfMissing([...])` — idempotent seeding.
- `boxShapes(idsOrShapes, { text, color, fill, note })` — draw a labeled container around shapes.
- `translateShapes(...)`, `onShapeTranslate(...)`.
- `richTextToPlainText(richText)`.
- `getLints()` — runs the canvas linter over the page → `{ lints }`; handy to
  catch overlaps/unbound arrows before you call it done.

Return plain JSON from exec — ids, counts, booleans. Not shape records.

## Shape types and required props

`richText` must always be `toRichText('...')` — a bare string is rejected. Newlines
in the string become separate lines.

- **geo** (rectangle/ellipse/…): `geo, w, h, color, fill, richText` (+ `dash, size,
  align, verticalAlign` sensible defaults). `fill`: `none | solid | semi | pattern`.
- **text**: `richText, color, size, font, textAlign, w, scale, autoSize`.
- **note** (sticky): `richText, color, labelColor, size, font, align, verticalAlign,
  growY, fontSizeAdjustment, url, scale, textLastEditedBy`.

Prefer `geo` rectangles for architecture/flow diagrams (crisp, resizable) and
`note` for sticky-note brainstorms. If a `createShape` call is rejected, read the
returned validation error — it names the offending prop — or check
`api.members` / `api.recipes` for the exact current shape.

Colors: `black, grey, blue, light-blue, violet, light-violet, green, light-green,
yellow, orange, red, light-red, white`.

## Arrows and bindings

A "connected" arrow is one with real **binding** records tying each end to a
shape — not an arrow that merely looks close. Always create arrows with the
helper so bindings are real:

```js
helpers.createArrowBetweenShapes(fromId, toId, {
  arrowheadStart: 'none',        // arrow|none|dot|bar|diamond|inverted|pipe|square|triangle
  arrowheadEnd: 'arrow',
  richText: toRichText('label'), // optional edge label
  bend: 0,                       // >0 / <0 bows the arrow; use to route around boxes
})  // returns the new arrow's TLShapeId
```

Each call yields two binding records (start + end). Verify with
`api.getBindings(docId)` — expect `2 × (number of arrows)`.

## Screenshots

`api.getScreenshot(docId)` returns `{ filePath, width, height, pageName, viewport,
bounds, captureMode }` — a path to a JPG/PNG on disk, not image bytes. Copy/read
that file. `scripts/tldraw_api.py shot <docId> out.png` does the copy for you.
Screenshot after every layout change; judging placement blind leads to overlaps.

## Durable behavior: document scripts

`exec` edits the drawing once; installed listeners/timers/globals from `exec` die
when the document or app closes. For behavior that must survive reload —
run-on-open seeding, clickable UI, animation loops, reactive layout, custom shape
types — use a **document script** instead.

Flow: `POST /api/doc/:id/script-workspace` returns paths (`mainJsPath`,
`scriptDir`, `isDefaultScript`). Read `mainJsPath` first (don't clobber a
non-default script), edit it on the filesystem, then poll `GET
/api/doc/:id/script-status` until `state: "applied"` (`"pending"` = retry once;
`"error"` = read `lastApplyError` / `errorLogPath`). Contract:

```js
import { createShapeId, toRichText } from 'tldraw'   // static import OK in scripts
export default function ({ editor, helpers, signal }) {
  editor.run(() => {
    helpers.createShapeIfMissing({ id: createShapeId('node-1'), type: 'geo',
      x: 0, y: 0, props: { geo: 'rectangle', w: 200, h: 100, richText: toRichText('hi') } })
  }, { history: 'ignore' })
  const stop = editor.store.listen(() => { /* react */ })
  signal.addEventListener('abort', () => stop())     // REQUIRED: clean up on rerun/close
}
```

Scripts **rerun on every load**, so they must be idempotent — use
`createShapeIfMissing` with stable ids rather than deleting and redrawing
user-editable shapes. Query `api.recipes` (ids like
`add-durable-behavior-with-a-document-script`, `clickable-card-or-button-ui`,
`connection-dependent-behavior`, `animation-simulation-loop`,
`custom-shape-config-js`) for full worked patterns.

> Security note: a document script runs when the file is opened. Only build them
> for the user's own files, and don't run scripts embedded in `.tldraw` files
> from untrusted sources.

## Gotchas

- **No file open ⇒ empty results.** `api.getDocs()` returns `[]` when nothing is
  open (including right after the app rejected a bad file). Get a document open first.
- **The API can't open or save files.** It edits open documents; the user opens
  (File → New / Open, or macOS `open -a "tldraw offline" file.tldraw`) and saves
  (Cmd/Ctrl+S). `exec` changes show `unsavedChanges: true` until they save.
- **No external merge.** tldraw offline does not merge changes made to an open
  file by another program. Never edit the `.tldraw` on disk while it's open —
  close it first, or work through the API and let the user save.
- **Re-read the token every call** (see Connection).
- **`.tldr` ≠ `.tldraw`.** Legacy `.tldr` (single JSON) files import as a new
  unsaved document; `.tldraw` (zip + sqlite) is the native format.
