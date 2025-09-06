#import "@preview/touying:0.6.1": *
#import "@preview/touying-unistra-pristine:1.4.2": *

#show: unistra-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Title],
    author: [Author],
    date: datetime.today().display("[month repr:long] [day], [year repr:full]"),
    logo: image("../assets/unistrafooter.svg"),
  ),
  config-store(
    quotes: (
      left: "‘",
      right: "’",
    ),
    icon-links: (
      "image": (
        regex("\.(jpg|jpeg|png|bmp|svg|webp|tiff)$"),
        none,
      ),
    ),
  ),
)

#title-slide(logo: image("../assets/unistra.svg"))

= Example Section Title

== Example Slide

A slide with *important information*.

#pause

=== Highlight
This is #highlight(fill: blue.C)[highlighted in blue]. This is #highlight(fill: yellow.C)[highlighted in yellow]. This is #highlight(fill: green.C)[highlighted in green]. This is #highlight(fill: red.C)[highlighted in red].

#hero(
  image("../assets/unistra.svg"),
  title: "Hero",
  subtitle: "Subtitle",
  hide-footer: false,
)

#hero(
  image("../assets/cat1.jpg", width: 100%, height: 100%),
  txt: (
    text: "This is an "
      + highlight(
        fill: yellow.C,
      )[RTL#footnote[RTL = right to left. Oh, and here's a footnote!] hero with text and no title]
      + ".\n",
    enhanced: false,
  ),
  direction: "rtl",
  footnote: true,
)

#gallery(
  image("../assets/cat1.jpg", width: auto, height: 50%),
  image("../assets/cat2.jpg", width: auto, height: 50%),
  image("../assets/cat1.jpg", width: auto, height: 50%),
  image("../assets/cat2.jpg", width: auto, height: 50%),
  title: "Gallery",
  captions: (
    "Cat 1",
    "Cat 2",
    "Cat 1 again",
    "Cat 2 again",
  ),
  columns: 4,
)

#focus-slide(
  theme: "smoke",
  [
    This is a focus slide \ with theme "smoke"
  ],
)

#focus-slide(
  theme: "neon",
  icon: nv-icon("text-undo"),
  [
    This is a focus slide \ with theme "neon" and Nova icon "text-undo"
  ],
)

#focus-slide(
  theme: "yellow",
  icon: us-icon("book-open"),
  [
    This is a focus slide \ with theme "yellow" and Unistra icon "book-open"
  ],
)

#focus-slide(
  c1: black,
  c2: white,
  icon: us-icon("plant"),
  [
    This is a focus slide \ with custom colors \ and Unistra icon "plant"
    \ Next: Section 2
  ],
  text-color: yellow.D,
)

= Section 2

== Hey! New Section!

#lorem(30)

=== Heading 3

#lorem(10)

==== Heading 4

#lorem(80)

#quote(
  attribution: [from the Henry Cary literal translation of 1897 | *Noticed the custom quotes?*],
)[
  ... I seem, then, in just this little thing to be wiser than this man at
  any rate, that what I do not know I do not think I know either.
]

#slide[
  First column. #lorem(15)
][
  Second column. #lorem(15)
]

== Icon Links

https://i.edoyen.com/ShareX/2025/07/ky3Hdt.gif

#link("https://i.edoyen.com/ShareX/2025/07/ky3Hdt.gif")[with \#link]

https://i.edoyen.com/ShareX/2025/07/ky3Hdt.gif

https://i.edoyen.com/ShareX/2025/07/ky3Hdt.jpg
