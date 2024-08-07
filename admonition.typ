#import "colors.typ": *
#import "settings.typ" as settings

// Credit: piepert
// https://github.com/piepert/grape-suite/blob/3be3e71a994bae82c9a9dedf41e918d7837ccc39/src/elements.typ

#let ADMONITION_TRANSLATIONS = (
  "task": (
    "en": "Task",
    "fr": "Tâche",
  ),
  "definition": (
    "en": "Definition",
    "fr": "Définition",
  ),
  "example": (
    "en": "Example",
    "fr": "Exemple",
  ),
  "brainstorming": (
    "en": "Brainstorming",
    "fr": "Remue-méninges",
  ),
)

#let admonition(
  body,
  title: none,
  time: none,
  primary-color: pink,
  secondary-color: pink.lighten(90%),
  tertiary-color: pink,
  dotted: false,
  figured: false,
  counter: none,
  show-numbering: true,
  numbering-format: (..n) => numbering("1.1", ..n),
  figure-supplement: none,
  figure-kind: none,
  text-color: black,
  emoji: none,
) = {

  if figured {
    if figure-supplement == none {
      figure-supplement = title
    }

    if figure-kind == none {
      panic("once paramter 'figured' is true, parameter 'figure-kind' must be set!")
    }
  }


  let body = {
    if show-numbering or figured {
      if counter == none {
        panic("parameter 'counter' must be set!")
      }

      counter.step()
    }

    set par(justify: true)
    show: align.with(left)

    block(
      width: 100%,
      height: auto,
      inset: 0.2em,
      outset: 0.2em,
      fill: secondary-color,

      stroke: (
        left: (
          thickness: 5pt,
          paint: primary-color,
          dash: if dotted {
            "dotted"
          } else {
            "solid"
          },
        ),
      ),

      pad(
        left: 0.3em,
        right: 0.3em,
        text(
          size: 1.1em,
          strong(
            text(
              fill: tertiary-color,
              emoji + " " + smallcaps(title) + if show-numbering or figured {
                [ ] + context numbering(
                  numbering-format,
                  ..counter.at(here()),
                ) + h(1fr) + time
              },
            ),
          ),
        ) + block(
          above: 0.8em,
          text(size: 1.2em, fill: text-color, body),
        ),
      ),
    )
  }

  if figured {
    figure(kind: figure-kind, supplement: figure-supplement, body)
  } else {
    body
  }
}

#let task = admonition.with(
  title: context state(
    "grape-suite-box-translations",
    ADMONITION_TRANSLATIONS,
  ).final().at("task").at(settings.LANGUAGE),
  primary-color: blue,
  secondary-color: blue.lighten(90%),
  tertiary-color: blue,
  figure-kind: "task",
  counter: counter("grape-suite-element-task"),
  emoji: emoji.hand.write,
)

#let definition = admonition.with(
  title: context state(
    "grape-suite-box-translations",
    ADMONITION_TRANSLATIONS,
  ).final().at("definition").at(settings.LANGUAGE),
  primary-color: green,
  secondary-color: green.lighten(90%),
  tertiary-color: green,
  figure-kind: "definition",
  counter: counter("grape-suite-element-definition"),
  emoji: emoji.brain,
)

#let brainstorming = admonition.with(
  title: context state(
    "grape-suite-box-translations",
    ADMONITION_TRANSLATIONS,
  ).final().at("brainstorming").at(settings.LANGUAGE),
  primary-color: orange,
  secondary-color: orange.lighten(90%),
  tertiary-color: orange,
  figure-kind: "brainstorming",
  counter: counter("grape-suite-element-brainstorming"),
  emoji: emoji.lightbulb,
)