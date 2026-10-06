# 當藏傳佛教與西方相遇 (Entering the Diamond Way)

The Traditional Chinese edition of Lama Ole Nydahl's *Entering the Diamond Way*, typeset
in [Typst](https://typst.app/) for reading on an iPad (11th gen) or a phone, in a dark and
a light theme.

## Building

With [mise](https://mise.jdx.dev/):

```sh
mise run build    # → out/entering-dark.pdf and out/entering-light.pdf
```

Without mise, `./build.sh` (needs Typst 0.15 on `PATH` and `curl`); `./build.sh light`
builds one theme. The first build downloads the fonts into `fonts/` (`fetch-fonts.sh`):
Noto Serif TC and Source Serif 4, both under the SIL Open Font License (licences in
`fonts/`). They are not kept in git.

## Layout

- `entering.typ`: the book, including the chapters in order.
- `template.typ`: page, palettes, type, chapter openings, contents and the photo helpers
  (`photo`, `photos`, `photo-pair`, `full-page-photo`, `frontispiece`).
- `chapters/`: one file per chapter (`01.typ` … `19.typ`).
- `figures/`: the photographs.
- `entering.indd`: an earlier InDesign layout.

The LaTeX edition this was converted from (2022–2024, `main.tex` and `chapter_*.tex`) is
in git history up to commit 7a3c7cf0.
