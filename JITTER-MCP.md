# How the Jitter MCP works

The Jitter MCP is the connector that lets an AI agent (Claude Code, the Claude app, or another MCP client) read and edit Jitter (jitter.video) files directly. Edits land in the saved project, so the user sees them when they open the file in the Jitter editor.

## 1. Connecting

- Add the **Jitter** connector in your Claude app connectors (search for "Jitter"). Sign in with the Jitter account that owns or can edit the files.
- In Claude Code the tools appear with a prefix such as `mcp__<connector-id>__applyConf`.
- If a tool says it is not authorized, reconnect the connector and check that the account has access to the file.
- To check the connection, call `list_files`. It should list your files.

## 2. Ids you need

| Id | Where it comes from | Used for |
|---|---|---|
| `fileId` | The `id=` part of a Jitter link: `https://jitter.video/file/?id=<fileId>&nodeId=<nodeId>` | Every tool call |
| `nodeId` | The `nodeId=` part of the link, usually an artboard | Telling which artboard to work on |
| Layer and operation ids | Returned by `searchConf` | Targeting edits and animations |

## 3. The tools

### Discover and create
- **`list_files`**: lists the files the account can access. Use it when you don't have a link.
- **`create_file`**: creates a new draft file. It starts with one blank 640×360 artboard called "Scene 1". Remove that artboard if you build your own.

### Learn the API
- **`getEditorApiReference`** with `section`:
  - `workflow`: how to work, layout and animation guidance.
  - `tools`: the `conf` and `actions` API.
  - `schema`: every layer and operation type with its fields.

  Load `tools` before writing code, and `schema` before adding new layers or operations.

### Read
- **`searchConf`** with `fileId`, `label` and `code`: runs read-only JavaScript against the project and returns a small JSON result.
  ```js
  async (conf) => conf.artboards.map(a => ({ id: a.id, name: a.item.name, w: a.item.width, h: a.item.height, dur: a.item.duration }))
  ```
- **`searchConfBatch`** with `fileId`, `label` and `queries: [{ key, code }]`: several independent reads in one call.

### Edit
- **`applyConf`** with `fileId`, `label` and `code`: runs JavaScript that edits the project. It is all-or-nothing: if the code throws, nothing is applied.
  ```js
  async (conf, actions) => {
    const { newId } = actions.clone('ARTBOARD_ID', { x: 2240, y: 0 })
    actions.updateObj(newId, { name: 'My artboard - Logo build' })
  }
  ```

### See the result
- **`screenshotNode`** with `fileId`, `nodeId`, `timeMs`, `label` and optional `crop`: renders the artboard at a moment in the timeline.
  - Use it to check mid-animation frames.
  - It is a small image; use `crop` to zoom in on a detail.

### Media, brand and export
- **`create_media_upload`** then **`complete_media_upload`**: upload a local image, video or audio file.
  1. Create the upload with the MIME type and byte size.
  2. PUT the bytes to the returned `uploadUrl`, for example with `curl`.
  3. Complete the upload and use the returned `url` on a layer.
- **`listTeamLibraryTokens`** and **`manageTeamLibrary`**: Brand Kit colours, text styles and easing tokens.
- **`get_export_url`** with artboard ids: returns a link that starts the video, GIF or Lottie export when the user opens it.

## 4. The `conf` read API

| Call | Returns |
|---|---|
| `conf.artboards` | Array of artboard nodes (not a function) |
| `conf.get(id)` | One node `{ id, item, children? }` |
| `conf.layers(artboardOrId)` | All layers under an artboard, front to back |
| `conf.operations(artboardOrId)` | All operations (animations), including those inside `opGrp`s |
| `conf.walk(node)` | Depth-first walk |
| `conf.describeLifecycle(id)` | When a node enters and leaves |
| `conf.findOperationMotifs(id)` and `conf.findLayerMotifs(id)` | Repeated animation and layer patterns |
| `await conf.measureText(id, { timeMs, detail })` | The real rendered text box, lines, words and glyphs |

Each node's data is in `item`: `type`, `name`, `x`, `y`, `width`, `height`, `startTime`, `endTime`, `targetId` and so on.

## 5. The `actions` write API

| Call | What it does |
|---|---|
| `actions.createId()` | New unique id for every node you add |
| `actions.addObj({ id, item, children }, parentId, index?)` | Add a layer, group, operation or `opGrp`. Passing an artboard id as `parentId` routes it to the right tree. |
| `actions.updateObj(id, patch)` | Change fields of an existing node's `item` |
| `actions.removeObj(id)` | Delete a node and its children |
| `actions.moveObj(id, parentId, index?)` | Reparent or reorder. With no index it goes on top. |
| `actions.clone(id, { x, y })` | Deep copy with its animations. Returns `{ newId, idMap }`, where `idMap` maps old ids to new ids. |

## 6. How an animation is stored

- An **artboard** has a `layersTree` (layers) and an `operationsTree` (animations).
- An **operation** targets a layer with `targetId`, runs from `startTime` to `endTime` in ms, and has an `easing`. Example:
  ```js
  { type: 'slideIn', targetId: LAYER, startTime: 0, endTime: 500,
    easing: { schema: 'v1', name: 'slowdown:standard:v1', config: { intensity: 50 } },
    direction: 'up', distance: 40, noFade: false }
  ```
- Group operations in an **`opGrp`** (`{ type: 'opGrp', name: 'Intro' }`) with the operations as `children`.
- The artboard's `duration` (ms) clips everything. Animations past it are cut off.

Main operation types:
- **Presets:** `fadeIn/Out`, `slideIn/Out`, `growIn/Out`, `shrinkIn/Out`, `spinIn/Out`, `twistIn/Out`, `blurIn/Out`, `blurScaleIn/Out`, `blurSlideIn/Out`, `moveThenScaleIn/Out`, `maskCenterIn/Out`, `maskSizeIn/Out`, `maskResizeIn/Out`, `maskRevealIn/Out`, `maskSlideIn/Out`.
- **Text:** `textIn/Out`, `changeText`, `counter`.
- **Transforms:** `move`, `rotate`, `scale`, `resize`, `opacity`, `color`, `morph`, `cornerRadius`, `blurRadius`.
- **Visibility and playback:** `hide`, `show`, `playVideo`, `playAudio`, `playInstance`.
- **Effects:** `customShader` (Card Flip, 3D Orbit and the other editor Effects).

## 7. Typical session

1. `searchConf`: list artboards, then read the target artboard's layer tree.
2. `screenshotNode` at `timeMs: 0`: see the design.
3. `applyConf`: clone the artboard, then add `opGrp`s with operations.
4. `screenshotNode` at several times: check intro, hold, transitions and outro.
5. Fix with small `applyConf` edits (`updateObj` on operation timings or values).

## 8. Limits and gotchas

- **Effects:** the API cannot create a shader effect from nothing. Add the effect once in the Jitter editor (New Animation → Effects), then read it and copy its `item` to other layers. See the Card Flip notes in [WORKFLOW.md](WORKFLOW.md).
- **Not available:** background removal, stock media search and image-to-video.
- **Server busy or rate-limited:** wait 30 to 60 seconds and retry. After a timeout, read the file first, because the edit may already have applied.
- **Screenshots** are single frames. They don't prove smooth playback, so always say playback was not checked.
- **Stale reads:** the user can edit the file at any time. Re-read before acting on old ids or values.
