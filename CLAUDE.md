# 當藏傳佛教與西方相遇 (Entering the Diamond Way, Traditional Chinese)

Typst book for reading on an iPad / OLED phone (see README.md).

- **Build with `mise run build`** (or `./build.sh`): both themes into `out/` (git-ignored),
  named `entering-<YYYYMMDD-HHMM>-<sha>[-dirty]-<theme>.pdf`. Release with
  `./build-release.sh` (clean working copy, master pushed); assets keep these names.
  Fonts are downloaded by `fetch-fonts.sh` into `fonts/`; never commit the `.ttf` files.
  Check a change by rendering the affected pages (`pdftoppm -png -f N -l N`), not just by
  compiling; after layout changes, look at every page with a photo.
- Page 164 × 236 mm (the iPad's 1.44 ratio at about real size). Colours only from the
  palettes in `template.typ`; the accent colours **headings only**. Dark theme: never pure
  black, body a touch heavier (Ming strokes break up on OLED).
- Type: Noto Serif TC with Source Serif 4 for Latin. Chinese conventions: two-character
  first-line indent, chapters labelled 第一章…, contents titled 目錄.
- Photos float to the **top** of a page only (no line caught between two photos) and are
  capped at `photo-height`; photos that follow each other go in one `#photos(...)` group.
  Full-page photos keep their caption directly below the image.
- Typst markup in the chapters escapes `#`, `*`, `_`, `$`, `@`, `<`, `\`, backtick, `[`
  and `]` in the text; keep the TODO comments from the translation.
- Commit with `jj commit`.
