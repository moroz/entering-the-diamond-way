// Template for the Traditional Chinese edition of Entering the Diamond Way, read on an
// iPad (164 × 236 mm, the 11th gen screen's 1.44 aspect ratio at about its physical size).
// Two themes: dark (default) and light, picked with `--input theme=light` (see build.sh).
// Palettes and type follow the meditation booklets in ~/working/dharma (lib.typ): accent
// colour on headings only, everything else neutral.

#let theme = sys.inputs.at("theme", default: "dark")
#assert(theme in ("dark", "light"), message: "theme must be dark or light, got " + theme)
#let dark = theme == "dark"

// Diamond Way style guide: brand red (CMYK 15/100/85/0) and the sun's yellow (Pantone
// 122 C). Red is too dark to read on black, so dark headings take the yellow.
#let brand-red = cmyk(15%, 100%, 85%, 0%)
#let brand-yellow = cmyk(0%, 15%, 80%, 0%)

// Dark ground is never pure black (it smears on OLED as pixels switch off); text is a
// dimmed off-white to keep halation down.
#let c = if dark {
  (bg: rgb("#141416"), text: rgb("#D8D6D1"), strong: rgb("#EDEBE7"), muted: rgb("#8E8B86"),
    accent: brand-yellow, rule: rgb("#4A4850"))
} else {
  (bg: rgb("#FDFCFA"), text: rgb("#232220"), strong: rgb("#111110"), muted: rgb("#76726C"),
    accent: brand-red, rule: rgb("#C9C4BC"))
}

// Serif: Source Serif 4 for Latin and Noto Serif TC (Source Han Serif) for Chinese, the
// same Adobe family, both from fonts/ (build.sh passes --font-path). A Ming face's thin
// horizontals break up on OLED, so the dark theme sets the body a touch heavier.
#let fonts = ("Source Serif 4", "Noto Serif TC")
#let body-weight = if dark { 450 } else { 400 }

#let rule(width: 18mm) = line(length: width, stroke: 1.2pt + c.rule)

// ---------------------------------------------------------------- photographs

#let caption-text(body) = text(size: 9.5pt, fill: c.muted, body)

// Photos in the text float to the top of a page, never the bottom, so the text on a page
// stays in one block and no line gets caught between two photos. A photo is at most
// `photo-height` tall (narrower than the text if need be), leaving room for text below.
#let photo-height = 112mm

// An image at the text width, or narrower so it stays within `max-height`.
#let sized(path, max-height: photo-height) = context {
  let natural = measure(image(path))
  let ratio = natural.width / natural.height
  let width = calc.min(page.width - page.margin.left - page.margin.right, max-height * ratio)
  image(path, width: width)
}

#let photo(path, caption) = figure(
  placement: top,
  sized(path),
  caption: caption,
)

// Photos that follow each other in the text float together as one group, stacked, sharing
// the height of one photo.
#let photos(..items) = {
  let items = items.pos()
  let each = (photo-height + 20mm) / items.len() - 10mm
  figure(placement: top, stack(spacing: 5mm, ..items.map(((path, caption)) => stack(
    spacing: 2.5mm,
    sized(path, max-height: each),
    caption-text(caption),
  ))))
}

// Two photos side by side, each with its own caption.
#let photo-pair(path-a, caption-a, path-b, caption-b) = figure(
  placement: top,
  grid(
    columns: (1fr, 1fr),
    column-gutter: 4mm,
    row-gutter: 2.5mm,
    image(path-a, width: 100%), image(path-b, width: 100%),
    caption-text(caption-a), caption-text(caption-b),
  ),
)

// A photo with its caption directly below, the pair centred on a page of its own. The
// image keeps its proportions (at most the text width and 178 mm tall), so the caption
// sits right under it.
#let page-photo(path, caption) = align(center + horizon, stack(
  spacing: 3mm,
  sized(path, max-height: 178mm),
  caption-text(caption),
))

// A full-page photo inside a chapter, floated so the text before it runs on.
#let full-page-photo(path, caption) = place(top, float: true, scope: "parent",
  block(width: 100%, height: 196mm, breakable: false, page-photo(path, caption)))

// The photo opening a chapter, on the page before its title.
#let frontispiece(path, caption) = {
  pagebreak(weak: true)
  page-photo(path, caption)
  pagebreak()
}

// ---------------------------------------------------------------- book

#let chapter-label(n) = "第" + numbering("一", n) + "章"

#let book(body) = {
  set document(title: "當藏傳佛教與西方相遇", author: "喇嘛歐雷‧尼達爾")
  set page(
    width: 164mm,
    height: 236mm,
    margin: (top: 20mm, bottom: 20mm, x: 19mm),
    fill: c.bg,
    footer: context {
      let p = here().page()
      if p <= 2 { return }
      align(center, text(size: 8.5pt, fill: c.muted, tracking: 0.1em, str(p)))
    },
  )
  set text(font: fonts, weight: body-weight, size: 12pt, fill: c.text, lang: "zh", region: "tw")
  // Chinese book convention: two-character first-line indent; a little space between
  // paragraphs helps on screen.
  set par(justify: true, leading: 1em, spacing: 1em, first-line-indent: (amount: 2em, all: true))
  show strong: set text(weight: 700, fill: c.strong)

  set footnote.entry(separator: line(length: 24mm, stroke: 0.5pt + c.rule), gap: 0.6em)
  show footnote.entry: set text(size: 9.5pt, fill: c.muted)
  show footnote.entry: set par(first-line-indent: 0em, leading: 0.8em)

  set figure(gap: 2.5mm, numbering: none)
  show figure.caption: it => caption-text(it.body)
  show figure: set block(above: 1.6em, below: 1.6em)

  set list(indent: 0.5em)
  set enum(indent: 0.5em, numbering: n => text(fill: c.muted, "（" + numbering("一", n) + "）"))
  show enum: set par(first-line-indent: 0em)
  show quote.where(block: true): it => block(inset: (left: 2em, right: 1em), above: 1.4em,
    below: 1.4em, {
      set text(fill: c.muted)
      set par(first-line-indent: 0em)
      it.body
    })

  set heading(numbering: "一")
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(14mm)
    rule()
    v(5mm)
    text(size: 10.5pt, fill: c.muted, tracking: 0.2em, chapter-label(counter(heading).get().first()))
    v(2mm)
    block(below: 12mm, text(size: 26pt, weight: 500, fill: c.accent, it.body))
  }

  // ---------------------------------------------------------------- title page
  page(footer: none, margin: (x: 22mm, top: 0mm, bottom: 22mm), {
    set par(first-line-indent: 0em, leading: 0.5em)
    v(64mm)
    text(size: 36pt, weight: 400, fill: c.strong, tracking: 0.08em)[當藏傳佛教 \ 與西方相遇]
    v(6mm)
    place(left, dx: -22mm, line(length: 400mm, stroke: (thickness: 2pt,
      paint: gradient.linear(c.bg, brand-red, brand-red, brand-red))))
    v(8mm)
    text(size: 15pt, fill: c.text)[Entering the Diamond Way]
    v(1mm)
    text(size: 11pt, style: "italic", fill: c.muted)[Tibetan Buddhism Meets the West]
    v(1fr)
    text(size: 12pt, fill: c.text, tracking: 0.1em)[喇嘛歐雷‧尼達爾 著]
    v(1mm)
    text(size: 10pt, fill: c.muted, tracking: 0.12em, upper[Lama Ole Nydahl])
  })

  // ---------------------------------------------------------------- contents
  page(footer: none, {
    v(14mm)
    rule()
    v(5mm)
    text(size: 26pt, weight: 500, fill: c.accent)[目錄]
    v(10mm)
    set par(first-line-indent: 0em)
    show outline.entry: it => block(above: 0.9em, link(it.element.location(), grid(
      columns: (5em, 1fr, auto),
      text(fill: c.muted, size: 10.5pt, chapter-label(counter(heading).at(it.element.location()).first())),
      it.element.body,
      text(fill: c.muted, it.page()),
    )))
    outline(title: none, depth: 1)
  })

  body
}
