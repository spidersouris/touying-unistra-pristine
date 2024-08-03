#import "@preview/touying:0.4.2": *
#import "../unistra.typ"
#import "../colors.typ": *
#import "../settings.typ" as settings

#let s = unistra.register(aspect-ratio: "16-9")
#let s = (s.methods.info)(
  self: s,
  title: [Title],
  subtitle: [_Subtitle_],
  author: [Author],
  date: datetime.today().display("[month repr:long] [day], [year repr:full]"),
)

#let PAGE_MARGINS = (
  "HEADER_FOOTER": (x: 2.8em, y: 2.5em),
  "HEADER_NO_FOOTER": (x: 2.8em, bottom: 0em),
  "NO_HEADER_FOOTER": (top: 1em, left: 2.8em),
  "NO_HEADER_NO_FOOTER": (x: 1em, y: 1em),
)

#let PAGE_MARGIN_KEY = (
  if settings.SHOW_HEADER and settings.SHOW_FOOTER {
    "HEADER_FOOTER"
  } else if settings.SHOW_HEADER {
    "HEADER_NO_FOOTER"
  } else if settings.SHOW_FOOTER {
    "NO_HEADER_FOOTER"
  } else {
    "NO_HEADER_NO_FOOTER"
  }
)

#(
  s.page-args += (
    margin: PAGE_MARGINS.at(PAGE_MARGIN_KEY),
    footer-descent: 0.2em,
  )
)

#let (init, slides, alert, task, definition) = utils.methods(s)
#show: init

#show strong: alert
#show heading.where(level: 1): set text(size: 1.5em, weight: "bold")

#set highlight(extent: 1pt)

#let (
  slide,
  empty-slide,
  title-slide,
  focus-slide,
  gallery,
  hero,
) = utils.slides(s)
#show: slides

#title-slide[]

= Example Section Title

== Example Slide

A slide with *important information*.

#lorem(50)

#pause

=== Highlight
This is #highlight(fill: blue)[highlighted in blue]. This is #highlight(fill: yellow)[highlighted in yellow]. This is #highlight(fill: green)[highlighted in green]. This is #highlight(fill: red)[highlighted in red].

#hero(
  title: "Hero",
  subtitle: "Subtitle",
  img: "assets/unistra.svg",
)

#gallery(
  title: "Gallery",
  images: (
    "assets/cat1.jpg",
    "assets/cat2.jpg",
    "assets/cat1.jpg",
    "assets/cat2.jpg",
  ),
  columns: 4,
)

#focus-slide(
  theme: "smoke",
  [
    This is a focus slide \ with theme "smoke"
  ],
)

#slide[
  This is a normal slide with *admonitions*:

  #task[
    This is a task.
  ]

  #definition[
    This is a definition.
  ]
]

#focus-slide(
  theme: "neon",
  [
    This is a focus slide \ with theme "neon"
  ],
)

#focus-slide(
  theme: "yellow",
  [
    This is a focus slide \ with theme "yellow"
  ],
)

#focus-slide(
  c1: black,
  c2: white,
  [
    This is a focus slide \ with custom colors
    \ Next: Section 2
  ],
  text_color: yellow-light,
)

= Section 2

== Hey! New Section!

#lorem(30)

=== Heading 3

#lorem(10)

==== Heading 4

#lorem(99)