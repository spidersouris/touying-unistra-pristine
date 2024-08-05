#import "@preview/touying:0.4.2": *
#import "colors.typ": *
#import "admonition.typ": *
#import "settings.typ" as settings

//todo (low prio): add material symbols

// ===================================
// ============ UTILITIES ============
// ===================================

#let cell(
  body,
  width: 100%,
  height: 100%,
  inset: 0mm,
  outset: 0mm,
  alignment: top + left,
  debug: settings.DEBUG,
) = rect(
  width: width,
  height: height,
  inset: inset,
  outset: outset,
  stroke: if debug {
    1mm + red
  } else {
    none
  },
  align(alignment, body),
)

/// Adds gradient to body (used for slide-focus)
#let gradientize(
  self,
  body,
  c1: blue-dark,
  c2: blue-dark,
  lighten_pct: 20%,
  angle: 45deg,
) = {
  rect(fill: gradient.linear(c1, c2.lighten(lighten_pct), angle: angle), body)
}

// ===================================
// ============= NAV BAR =============
// ===================================

//inspired from touying-buaa theme: https://github.com/Coekjan/touying-buaa/blob/a3fd8257328a80b7c7b74145a10a3984e26629a7/lib.typ
#let unistra-nav-bar(
  self: none,
) = states.touying-progress-with-sections(dict => {
  let (current-sections, final-sections) = dict
  current-sections = current-sections
    .filter(section => section.loc != none)
    .map(section => (
        section,
        section.children,
      ))
    .flatten()
    .filter(item => item.kind == "section")
  final-sections = final-sections
    .filter(section => section.loc != none)
    .map(section => (
        section,
        section.children,
      ))
    .flatten()
    .filter(item => item.kind == "section")
  let current-index = current-sections.len() - 1

  set text(size: 1.2em)
  for (i, section) in final-sections.enumerate() {
    set text(fill: if i != current-index {
      gray
    } else {
      black
    })

    if (i <= current-index) {
      box(inset: 0.3em, stroke: (bottom: 0.5pt + self.colors.black))[#link(
          section.loc,
          utils.section-short-title(section.title + (
            if (i < current-index) {
              "  |"
            }
          )),
        )<touying-link>]
    }
  }
})

// ================================
// ============ SLIDES ============
// ================================

// Creates a title slide
#let title-slide(
  self: none,
  title: "",
  subtitle: "",
  logo_path: "assets/unistra.svg",
  logo_width: 40%,
  logo_height: auto,
  ..args,
) = {
  self = utils.empty-page(self)

  let info = self.info + args.named()

  let body = {
    set text(fill: self.colors.white)
    set block(inset: 0mm, outset: 0mm, spacing: 0em)
    set align(top + left)
    gradientize(
      self,
      block(
        fill: none,
        width: 100%,
        height: 100%,
        inset: (left: 2em, top: 1em),
        grid(
          columns: (1fr),
          rows: (8em, 4em, 4em, 4em),
          cell([
            #align(
              left,
              image(logo_path, width: logo_width, height: logo_height),
            )
          ]),
          cell([
            #text(
              size: 2em,
              weight: "bold",
              if (title != "") {
                title
              } else {
                info.title
              },
            )
            #linebreak()
            #text(
              size: 2em,
              weight: "regular",
              if (subtitle != "") {
                subtitle
              } else {
                info.subtitle
              },
            )
          ]),
          cell([
            #set text(size: 1.5em, fill: self.colors.white)
            #text(weight: "bold", info.author)
          ]),
          cell([
            #set text(fill: self.colors.white.transparentize(25%))
            #utils.info-date(self)
          ]),
        ),
      ),
      c1: self.colors.blue-dark,
      c2: self.colors.cyan,
    )
  }

  (self.methods.touying-slide)(self: self, repeat: none, body)
}

// Creates a normal slide with a title and body
#let slide(self: none, title: none, ..args) = {
  if title != auto {
    self.slide-title = title
  }

  (self.methods.touying-slide)(
    self: self,
    title: title,
    setting: body => {
      if self.auto-heading == true and title != none {
        heading(level: 2, title)
      }
      set text(size: 30pt)
      body
    },
    ..args,
  )
}

// Creates a focus slide with a gradient background
#let focus-slide(
  self: none,
  c1: none,
  c2: none,
  text_color: none,
  theme: none,
  text_alignment: center + horizon,
  body,
) = {
  assert(
    (c1 != none and c2 != none) or theme != none,
    message: "Please provide a color theme or two colors for the focus slide.",
  )

  if (theme != none) {
    assert(
      theme in self.colorthemes,
      message: "The theme " + theme + " is not defined.",
    )
    assert(
      self.colorthemes.at(theme).len() != 2 or self
        .colorthemes
        .at(theme)
        .len() != 3,
      message: "The theme " + theme + " is not a valid color theme.",
    )

    let theme_has_text_color = self.colorthemes.at(theme).len() == 3

    if (text_color == none and not theme_has_text_color) {
      text_color = self.colors.white
    } else {
      text_color = self.colorthemes.at(theme).at(2)
    }

    c1 = self.colorthemes.at(theme).at(0)
    c2 = self.colorthemes.at(theme).at(1)
  }

  let padding = auto
  if text_alignment == left + horizon {
    padding = 2em
  }

  self = utils.empty-page(self)
  let body = {
    set text(fill: text_color, size: 2em, weight: "bold", tracking: 0.8pt)

    gradientize(
      self,
      block(
        width: 100%,
        height: 100%,
        grid.cell(
          body,
          align: text_alignment,
          inset: padding,
        ),
      ),
      c1: c1,
      c2: c2,
    )
  }
  (self.methods.touying-slide)(self: self, repeat: none, body)
}

/// Creates a hero slide with a high width image, and optional title and subtitle
#let hero(
  self: none,
  title: none,
  subtitle: none,
  img: none,
  caption: none,
  text: none,
  img_height: auto,
  img_width: auto,
  text_alignment: top + center,
  direction: "ltr",
  gap: auto,
) = {
  let create_figure() = {
    figure(
      image(img, height: img_height, width: img_width),
      caption: caption,
    )
  }

  let create_image_cell() = {
    cell(
      create_figure(),
    )
  }

  let create_text_cell() = {
    cell(text, height: auto, width: 100%, alignment: text_alignment)
  }

  let create_grid(
    first_cell,
    second_cell,
    columns: (1fr, 1fr),
    rows: (1fr),
    column_gutter: auto,
    row_gutter: auto,
  ) = {
    grid(
      columns: columns,
      rows: rows,
      column-gutter: column_gutter,
      row-gutter: row_gutter,
      first_cell, second_cell,
    )
  }

  let create_body() = {
    if (text == none) {
      align(
        center,
        create_figure(),
      )
    } else {
      if direction == "ltr" {
        create_grid(
          create_text_cell(),
          create_image_cell(),
          column_gutter: gap,
        )
      } else if direction == "rtl" {
        create_grid(
          create_image_cell(),
          create_text_cell(),
          column_gutter: gap,
        )
      } else if direction == "utd" {
        create_grid(
          create_image_cell(),
          create_text_cell(),
          columns: (1fr),
          rows: (1fr, 1fr),
          row_gutter: gap,
        )
      } else if direction == "dtu" {
        create_grid(
          create_text_cell(),
          create_image_cell(),
          columns: (1fr),
          rows: (1fr, 1fr),
          row_gutter: if gap {
            gap
          } else {
            -2em
          },
        )
      }
    }
  }

  let add_title_and_subtitle(body) = {
    grid(
      cell(
        heading(level: 1, title),
        height: auto,
        width: auto,
      ),
      cell(
        heading(level: 2, subtitle),
        height: auto,
        width: auto,
      ),
      columns: 1fr,
      gutter: 0.6em,
      body
    )
  }

  let body = create_body()

  if (title, subtitle).all(x => x not in ("", none)) {
    body = add_title_and_subtitle(body)
  }
  (self.methods.touying-slide)(self: self, repeat: none, body)
}

// Creates a gallery slide with a title and images
#let gallery(
  self: none,
  title: none,
  images: array,
  columns: int,
  fit: "cover",
) = {
  let rows = (images.len() / columns)
  let body = {
    grid(
      ..images.map(img => image(
        img,
        width: 100%,
        height: 75%,
        fit: fit,
      )),
      columns: columns,
      rows: (1fr) * rows,
      gutter: 0.5em,
    )
  }

  if title != none {
    body = {
      heading(level: 1, title)
      body
    }
  }
  (self.methods.touying-slide)(self: self, repeat: none, body)
}

// ====================================
// ============ REGISTER ==============
// == (incl. header, footer, colors) ==
// ====================================

#let register(
  self: themes.default.register(),
  aspect-ratio: "16-9",
  header: [],
  footer: [],
  footer-info-1: self => {
    [
      #self.info.title – #self.info.subtitle]
  },
  footer-info-2: self => {
    [
      #self.info.author | #utils.info-date(self)]
  },
  footer-number: self => {
    states.slide-counter.display() + " / " + states.last-slide-number
  },
  primary: aqua.darken(50%),
  ..args,
) = {
  let deco-format(it) = text(size: .6em, fill: gray, it)
  // color theme
  self = (self.methods.colors)(
    self: self,
    white: white,
    black: black,
    grey: grey,
    maroon: maroon,
    brown: brown,
    orange: orange,
    orange-bright: orange-bright,
    pink: pink,
    pink-bright: pink-bright,
    purple: purple,
    blue-dark: blue-dark,
    blue: blue,
    cyan: cyan,
    green: green,
    yellow: yellow,
    yellow-light: yellow-light,
    primary: primary,
  )
  // save the variables for later use
  self.unistra-nav = self => {
    grid(
      align: center + horizon,
      columns: (1fr, auto, auto),
      rows: 1.8em,
      components.cell(
        unistra-nav-bar(self: self),
      ),
    )
  }
  self.colorthemes = colorthemes
  self.slide-title = []
  self.simple-header = header
  self.simple-footer = footer
  self.auto-heading = true
  // set page
  let header(self) = {
    set align(top)
    grid(
      rows: (auto, auto),
      utils.call-or-display(self, self.unistra-nav),
    )
  }

  let footer(self) = {
    let cell(body) = rect(
      width: 100%,
      height: 100%,
      inset: 0mm,
      outset: 0mm,
      fill: none,
      stroke: none,
      align(horizon + center, text(size: 0.6em, fill: self.colors.black, body)),
    )

    set align(center + horizon)

    let has_title_and_subtitle = (
      self.info.title,
      self.info.subtitle,
    ).all(x => x not in ("", none))

    block(
      width: 150%,
      height: 1.9em,
      stroke: (top: 0.5pt + self.colors.black),
      {
        set text(size: 1.5em)
        grid(
          columns: (auto, auto, auto),
          rows: (1.4em, 1.4em),
          gutter: 3pt,
          cell(image("assets/unistra.svg", width: auto, height: 100%)),
          cell(text(
            self.info.title,
            weight: "bold",
          ) + if has_title_and_subtitle {
            settings.FOOTER_UPPER_SEP
          } else {
            ""
          } + self.info.subtitle + linebreak() + utils.call-or-display(
            self,
            footer-info-2,
          )),
          cell(utils.call-or-display(self, footer-number)),
        )
      },
    )
  }

  self.page-args += (
    paper: "presentation-" + aspect-ratio,
    fill: self.colors.white,
    header: if settings.SHOW_HEADER {
      header
    } else {
      none
    },
    footer: if settings.SHOW_FOOTER {
      footer
    } else {
      none
    },
    footer-descent: 0.6em,
    header-ascent: 1em,
  )

  self.full-header = false
  self.full-footer = false

  // slides methods
  self.methods.slide = slide
  self.methods.title-slide = title-slide
  self.methods.focus-slide = focus-slide
  self.methods.gallery = gallery
  self.methods.hero = hero

  // other methods
  self.methods.alert = (self: none, it) => {
    text(fill: blue-dark, it)
  }

  self.methods.task = (self: none, it) => {
    task(it)
  }

  self.methods.definition = (self: none, it) => {
    definition(it)
  }

  // init
  self.methods.init = (self: none, body) => {
    set heading(outlined: false)
    set text(fill: black, font: settings.FONT, size: 25pt)
    show footnote.entry: set text(size: .6em)
    show heading.where(level: 2): set block(below: 1.5em)
    set outline(target: heading.where(level: 1), title: none, fill: none)
    show outline.entry: it => it.body
    show outline: it => block(inset: (x: 1em), it)
    body
  }
  self
}