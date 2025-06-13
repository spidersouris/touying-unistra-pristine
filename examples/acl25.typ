#import "@preview/touying:0.6.1": *
#import "@preview/touying-unistra-pristine:1.4.1": *
#import "@preview/theorion:0.3.3": *
#import cosmos.clouds: *
#show: show-theorion

// Register the theme.
#show: unistra-theme.with(
  aspect-ratio: "16-9",
  config-info(
    // This is the title that will be shown on the first slide, as well as in the footer.
    // If we wanted a separate title for the footer, we could have used the "short-title" parameter instead.
    title: [GeNRe: Automatic Gender Neutralization in French Using Collective Nouns],
    // The authors are normally shown both on the first slide and in the footer, like the title.
    // However, here, because of the "footer-hide" parameter (l.34), they will only
    // be shown on the first slide.
    author: [Enzo Doyen & Amalia Todirascu],
    // Date. Shows both on the first slide and in the footer.
    // You can also use datetime().
    date: [June 2025],
    // Logo. Shows only in the footer.
    // You can also use an image, but it should be a low-height medium-width image logo
    // to preserve as much space as possible for the slide content.
    // Since ACL 2025 does not have such logo, we're simply adding some stylized text instead.
    logo: text("ACL 2025", size: 0.8em, font: "Lato", weight: "bold"),
  ),
  // We're using a special parameter, "footer-hide", to exceptionally hide
  // some information from the footer.
  // In v1.4.1, this parameter takes an array of strings.
  // Values can be "author" or "date".
  // Here, we're doing this because the title is very long and not very convenient to shorten.
  // If we could have shortened it, it'd probably have been a better idea
  // to use "short-title" instead in config-info().
  config-store(footer-hide: ("author",)),
)

// Increase text size for tables for better view
#show table: set text(size: 29pt)

// Reduce vertical spacing before table to avoid a page break
#show table: it => {
  v(-1em)
  it
}

// Slightly reduce the spacing between lists to show more content
#show enum: move.with(dy: -0.2em)

// Remove bookmarked when exporting to PDF
#set heading(bookmarked: false, outlined: false)

// Set the slide content to English
#set text(lang: "en")

// Change the formatting for citations to make them a bit more visible
#show cite: set text(size: 23pt, weight: "bold")

// Shorter function for bolding, with a color parameter
#let b(body, fill: black) = {
  text(weight: "bold", fill: fill)[#body]
}

// Shorter function for "labels" used on slide 7
#let lbl(body, fill: black, color: white) = {
  block(fill: fill, outset: 0.15em)[#text(
      fill: color,
      weight: "bold",
    )[#body]]
}

// Create the title slide (first slide)
#title-slide(
  // We normally wouldn't need to repeat the title here
  // since it's identical to what we set in config-info().
  // But the title is a bit too long, so to make it more pretty
  // and separate from the logos, we're adding a linebreak at the beginning.
  title: "\nGeNRe: A French Gender-Neutral Rewriting System Using Collective Nouns",
  // No need for a subtitle.
  subtitle: "",
  // Adding logos and moving them slightly with move().
  // Here, we have multiple logos, so we use the "logos" parameter.
  // There is also a singular "logo" parameter available when there is only one logo.
  // todo: change paths
  logos: (
    move(
      image("assets/acl_logo.png"),
      dx: 2em,
      dy: -0.5em,
    ),
    move(
      image("assets/lilpa.png", height: 60%),
      dx: 5em,
      dy: 0.8em,
    ),
  ),
)

// Creating our outline slide.
// The argument of the "title" parameter exhibits one of the features of
// touying-unistra-pristine: embedded icons with custom functions
// us-icon() and nv-icon(). See the README for more information.
#outline-slide(title: [#us-icon("summary") Outline])

// Creating a focus slide, that is a slide with a customizable gradient background.
// Several themes are available by default. See src/colors.typ for more information.
// Focus slides also support previously described icons with the "icon" parameter.
#focus-slide(
  theme: "berry",
  icon: us-icon("edit-done"),
)[Purpose and Objectives]

== French language and masculine generics

In French, grammatical gender matches the referent's for humans:

// Creating a pretty box to highlight the examples.
#align(
  center,
  box(
    fill: luma(220),
    outset: 0.5em,
    width: 80%,
  )[un dans#underline(offset: 0.2em)[eur] (_a dancer_#super[male]); une dans#underline(offset: 0.2em)[euse] (_a dancer_#super[female])],
)
// #pause elements are used for transitions.
#pause
Masculine gender considered as default (*masculine generics*; MG) when referring to groups of both men and women:

#align(
  center,
  box(
    fill: luma(220),
    outset: 0.5em,
    width: 80%,
  )[« *Les étudiants*#super[MG] ont été invités à participer à l'atelier. » #linebreak() (_*Students*#super[MG] were invited to participate to the workshop._)],
)

// We slightly move the heading to the top with #v() to gain some space for the content.
== #v(-0.5em) Masculine generics and bias

// #mcite() is a custom touying-unistra-pristine function to cite multiple bibliography entries.
// See the "Citations" section in the README for more information.
Psycholinguistics studies in French and other languages with masculine generics show they bias towards male-centric mental representations #mcite(<stahlbergNameYourFavorite2001>, <gygaxGenericallyIntendedSpecifically2008>, <gygaxMasculineFormIts2012>, <harrisinteractiveLecritureInclusivePopulation2017>, <kornerGenderRepresentationsElicited2022>).

#pause

// Creating a horizontal line for content separation
#line(length: 100%)

// Once again, creating a prettier, centered box.
// The body also features nv-icon().
#align(
  center,
  box(
    fill: rgb("#a4ccd9"),
    outset: 0.5em,
    width: 80%,
    align(
      left,
      [#nv-icon("interface-question-mark") #place(
          dx: 6em,
          dy: -0.6em,
        )[#text(weight: "bold")[Why] is this important for NLP?]],
    ),
  ),
)

// unistra-touying pristine changes the default bold formatting to use a blue color.
- *in machine translation systems*, potential *gender bias* when translating from/to languages with different gender systems #mcite(<pratesAssessingGenderBias2020>, <savoldiGenderBiasMachine2021>, <vanmassenhoveGenderBiasMachine2024>)
- *in text generation models/LLMs*, increased male representation *at the expense of women and non-binary people* #pcite(<doyenManMadeLanguage2025>)


== Task of Gender Rewriting
#v(-1.2em)
// Using the "theorion" plugin here.
#definition(full-title: [#us-icon("lightbulb-o") Definition:])[
  generating one or more alternative sentences that either neutralize gender, adopt inclusive forms, or switch to a different gender
]

#pause
// When using the associated CSL file, @ labels are shown as prose.
- User-Centric (M → F / F → M) Rewriting (Arabic: @habashAutomaticGenderIdentification2019 @alhafniSharedTaskGender2022 @alhafniUserCentricGenderRewriting2022);
- Inclusive Rewriting (German: @pomerenkeINCLUSIFYBenchmarkModel2022; Portuguese: @velosoRewritingApproachGender2023; French: @lernerINCLUREDatasetToolkit2024);
- Neutral Rewriting (English: @sunTheyThemTheirs2021 @vanmassenhoveNeuTralRewriterRuleBased2021).

#pause

#align(
  center,
  block(
    width: 22em,
    outset: 0.5em,
    // nblue.A is a custom color included in the touying-unistra-pristine theme.
    // See src/colors.typ for all colors.
    fill: nblue.A.lighten(30%),
  )[#text(
      fill: white,
      weight: "bold",
    )[No French neutral rewriting system, and collective nouns unexploited for gender-neutralization in French]],
)

== Neutral Rewriting for French

Our work uses *human collective nouns* #pcite(<lecolleNomsCollectifsHumains2019>) for neutralizing \ gender, as their grammatical gender does not depend upon the referent's.

#move(
  dx: -1.5em,
  block(width: 112%)[#corollary(full-title: "Examples:")[
      personnel (_staff_), jury, police, armée (_army_)…

      #grid(
        columns: (1fr, 1cm, 1.1fr),
        gutter: 0.9em,
        grid.header(
          [#text(weight: "bold")[Masculine generics]],
          [],
          [#text(weight: "bold")[Collective noun]],
        ),

        [#underline(offset: 0.2em)[Tous les anciens #b[employés]#super[MG] sont invités] au gala. #linebreak() #text(size: 0.9em)[(_#underline(offset: 0.2em)[All former #b[employees]#super[MG] are invited] #linebreak() to the gala_.)]],
        b[→],
        [#underline(offset: 0.2em)[L'ancien #b[personnel] est invité] au gala. #linebreak() #text(size: 0.9em)[(_#underline(offset: 0.2em)[Former #b[staff] is invited] to the gala_.)]],
      )]
  ],
)

== Neutral Rewriting for French

Our work uses *human collective nouns* #pcite(<lecolleNomsCollectifsHumains2019>) for neutralizing \ gender, as their grammatical gender does not depend upon the referent's.

#move(
  dx: -1.5em,
  block(width: 112%)[#corollary(full-title: "Examples:")[
      #box(
        fill: yellow.B,
        outset: 0.3em,
        radius: 1em,
      )[personnel (_staff_), jury, police, armée (_army_)…]

      #grid(
        columns: (1fr, 1cm, 1.1fr),
        gutter: 0.9em,
        grid.header(
          [#text(weight: "bold")[Masculine generics]],
          [],
          [#text(weight: "bold")[Collective noun]],
        ),

        [#underline(offset: 0.2em)[Tous les anciens #b[employés]#super[MG] sont invités] au gala. #linebreak() #text(size: 0.9em)[(_#underline(offset: 0.2em)[All former #b[employees]#super[MG] are invited] #linebreak() to the gala_.)]],
        b[→],
        [#underline(offset: 0.2em)[L'ancien #b[personnel] est invité] au gala. #linebreak() #text(size: 0.9em)[(_#underline(offset: 0.2em)[Former #b[staff] is invited] to the gala_.)]],
      )]
  ],
)

== Neutral Rewriting for French

Our work uses *human collective nouns* #pcite(<lecolleNomsCollectifsHumains2019>) for neutralizing \ gender, as their grammatical gender does not depend upon the referent's.

#move(
  dx: -1.5em,
  block(width: 112%)[#corollary(full-title: "Examples:")[
      personnel (_staff_), jury, police, armée (_army_)…

      #grid(
        columns: (1fr, 1cm, 1.1fr),
        gutter: 0.9em,
        grid.header(
          [#text(weight: "bold")[Masculine generics]],
          [],
          [#text(weight: "bold")[Collective noun]],
        ),

        // This is not the easiest to read, but basically, we're adding special
        // bold colored formatting (to match with label colors).
        [#underline(offset: 0.2em)[#b(fill: rgb("2a9d8f"))[Tous les ]#b(fill: rgb("ae2012"))[anciens] #b[employés]#super[MG ]#b(fill: rgb("5a189a"))[sont invités]] au gala. #linebreak() #text(size: 0.9em)[(_#underline(offset: 0.2em)[#b(fill: rgb("2a9d8f"))[All ]#b(fill: rgb("ae2012"))[former] #b[employees]#super[MG ]#b(fill: rgb("5a189a"))[are invited]] to the gala_.)]],
        b[→],
        [#par(
            spacing: 1.5em,
          )[#underline(offset: 0.2em)[#b(fill: rgb("2a9d8f"))[L']#b(fill: rgb("ae2012"))[ancien] #b[personnel] #b(fill: rgb("5a189a"))[est invité]] au gala.] #linebreak() #text(
            size: 0.9em,
          )[(_#underline(offset: 0.2em)[#b(fill: rgb("2a9d8f"))[Ø ]#b(fill: rgb("ae2012"))[Former] #b[staff] #b(fill: rgb("5a189a"))[is invited]] to the gala_.)]],
      )

      // Creating and placing labels relatively.
      #place(
        dx: 15em,
        dy: -2.8em,
      )[#lbl(fill: rgb("2a9d8f"))[DET]]
      #place(
        dx: 16.8em,
        dy: -2.8em,
      )[#lbl(fill: rgb("ae2012"))[ADJ]]
      #place(
        dx: 23em,
        dy: -2.8em,
      )[#lbl(fill: rgb("5a189a"))[VERB]]
    ]],
)

#focus-slide(
  theme: "lavender",
  icon: us-icon("flask-lg"),
)[Methodology and Models]

== #v(-0.5em) Methodology
#v(-0.8em)
+ Creating a dictionary with French collective nouns and their \ masculine generics member nouns counterparts, gathering *315 entries*.
#table(
  columns: (2fr, 2fr),
  table.header(
    text(weight: "bold")[Member noun (MG)],
    text(weight: "bold")[Collective noun],
  ),
  inset: 6pt,
  align: horizon + center,
  [employés (_employees_)], [personnel (_staff_)],
  [jurés (_jury members_)], [jury],
  [policiers (_police officers_)], [police],
  [soldats (_soldiers_)], [armée (_army_)],
  […], […],
)
#v(-0.6em) #pause
2. Extracting sentences containing member nouns from a French Wikipedia corpus #pcite(<graeloGraeloWikipedia2023>) and Europarl #pcite(<koehnEuroparlParallelCorpus2005>), got *398,954 sentences*. #pause
3. Developing *three different models for rewriting*: a rule-based system (RBS), fine-tuned models and an instruct-based model.

// Hero slides are used to show a larger version of images.
// The slides can also be divided into two to add some text on the other side.
#hero(
  place(image("assets/rbs_left.svg", width: 88%), dy: 0.2em, dx: -6.8em),
  direction: "ltr",
  columns: (1.5fr, 1fr),
  txt: (
    "text": place(
      [
        // Creating vertical colored lines to place on the figure.
        #place(dx: 16.8em, dy: 9.8em)[#rotate(90deg)[#line(
              length: 7em,
              stroke: 0.2cm + rgb("C5172E"),
            )]]
        #place(dx: 19em, dy: 3.2em)[#rotate(90deg)[#line(
              length: 2.6em,
              stroke: 0.2cm + rgb("1F509A"),
            )]]
        #v(-2em)
        // Creating a "fake" heading
        #align(
          center,
          heading(level: 2)[#text(size: 1.2em)[Rule-based system (RBS)]],
        )
        - Tokenizing input with _spaCy_ v.3.7.4 #pcite(<montaniSpaCyIndustrialstrengthNatural2024>), detecting member nouns using our member noun-collective noun dictionary
        - Using #b[two main components]:
          - #b(fill: rgb("1F509A"))[dependency detection component] to find member noun syntactic dependencies (determiners, adjectives, verbs…);
          - #b(fill: rgb("C5172E"))[generation component] to replace member nouns with their collective equivalents and reinflect using Python library _inflecteur_ #pcite(<chuttarsingInflecteur2021>): #b[73.42% acc.] on our data
            - additional changes by our RBS: #b[+2.34 acc.]

          // Creating vertical colored lines to place near the text.
          #place(dx: -1.3em, dy: -7.2em)[#rotate(90deg)[#line(
                length: 3em,
                stroke: 0.35cm + rgb("1F509A"),
              )]]

          #place(dx: -2.45em, dy: -2.5em)[#rotate(90deg)[#line(
                length: 5.3em,
                stroke: 0.35cm + rgb("C5172E"),
              )]]
      ],
      dx: -1em,
      dy: 1em,
    ),
    // By default, hero slides have enhanced (bold, bigger) text
    "enhanced": false,
  ),
  gap: -3.5em,
)

== Fine-tuned models

- Finetuned T5-small #pcite(<raffelExploringLimitsTransfer2020>) & M2M100 #pcite(<fanEnglishCentricMultilingualMachine2020>) on 60,000 RBS-converted sentences (Wikipedia/Europarl). Used 6,000 (10%) for eval. Hypothetical 0.27 WER improv. shown by @vanmassenhoveNeuTralRewriterRuleBased2021.
#pause
// Create a second fake heading
#text(size: 1.35em, weight: "bold")[Instruct-based model]
#v(-1.2em)
- Model type not used in other works for this specific task. Using Claude 3 Opus #pcite(<anthropicClaude3Model2024>) with few-shot prompting.
#v(0.2em)
// Reduce size for this table
#show table: set text(size: 22pt)
#table(
  columns: (8em, 1fr),
  table.header(
    text(weight: "bold")[Instruction Type],
    text(weight: "bold")[Description],
  ),
  inset: 6.1pt,
  align: horizon + center,
  [BASE], [Asking to replace member nouns with their collective noun equivalents, without specifying replacements],
  [DICT], [Asking to replace member nouns with their collective noun equivalents, specifying replacements using the dictionary],
  [CORR], [Asking to correct RBS-converted sentence],
)

#focus-slide(
  theme: "moss",
  icon: us-icon("search"),
)[Results]

== Dependency Detection Results (RBS)

- Manually annotated dependencies from 500 sentences (250 Wikipedia; 250 Europarl)
- *Objective*: evaluate correct detection of syntactic dependencies of the member noun to be modified
- *Baseline*: default spaCy-detected member noun's dependencies (excluding punctuation)

#figure(image("assets/uYvVmd.png", width: 125%))

== Generation Results (RBS/fine-tuned/instruct-based)

- Manually gender-neutralized 500 sentences (250 Wikipedia; 250 Europarl) using collective nouns
- *Objective*: evaluate correct conversion of sentences
- *Baseline*: original, unconverted sentence (as per previous works) #pause
#v(-0.5em)
#line(length: 100%)
#v(-0.5em)
#b[Metrics:]
- #b(fill: ngreen.B)[WER] (word difference between reference and converted sentence)
- #b(fill: ngreen.B)[BLEU] (n-gram overlap between reference and converted sentence, $n=4$)
- #b(fill: ngreen.B)[cosine similarity] (sentence-level embeddings comparison with SBERT #pcite(<reimers-2019-sentence-bert>) and model #raw("Sentence-CamemBERT-Large"))

== #v(-0.8em) Generation Results
#v(-1.5em)
#figure(
  image("assets/LpieWb.png", width: 60%),
  gap: 0em,
)
#v(-1.6em)
#figure(image("assets/E85bUs.png", width: 117%))
#v(-1.3em)
#align(
  center,
  text(
    size: 0.89em,
  )[RBS/Baseline difference comparison with other gender-neutralization systems (#b[Table 1]) and Global results (#b[Table 2])],
)

== #v(-0.8em) Error Counts and Types
#v(-1.4em)
#figure(image("assets/genre_errors_c24_en.svg", width: 98%))

== Conclusion
#v(-0.5em)
#text(weight: "bold", fill: green.B)[Contributions]
#v(-0.5em)
// Creating a block to add left strokes near the text
#block(stroke: (left: 5pt + green.C), outset: (x: 0.5em))[
  - Dictionary of French collective nouns and their member noun equivalents
  - Dataset of gender-neutralized and non-gender-neutralized sentences
  - First automatic gender-neutralization system for French
  - Highlighted potentiality of instruct-based models combined with pre-created resources for this task
]
#text(weight: "bold", fill: red.B.transparentize(20%))[Limits]
#v(-0.5em)
#block(
  width: 108%,
  stroke: (left: 5pt + red.B.transparentize(40%)),
  outset: (x: 0.5em),
)[
  - Specific semantics of collective nouns (making them unusable in some contexts)
  - Coreference partly supported only for RBS/fine-tuned models
  - Limits of LLM-as-a-judge approach for instruct-based model error analysis #pcite(<gu2025surveyllmasajudge>)
]

#focus-slide(
  theme: "wine",
  // Hiding counter for this slide as it's the last one
  show-counter: false,
  // Hiding this slide from the outline
  outlined: false,
  text-size: 1.7em,
)[Our work will be presented in-person in Vienna. \ Looking forward to having a chat there! #grid(
    columns: (1fr, 1fr),
    image("assets/acl_logo.png", width: 45%),
    image("assets/qr_arxiv.svg", width: 45%),
  )]

// Show the appendix.
// With the touying-unistra-pristine, appendix slide numbers have an "A-" label by default.
// The label can be changed using the "footer-appendix-label" option in config-store().
#show: appendix

== Bibliography

// For correct formatting of #pcite(), #mcite() and @ labels,
// make sure to define the associated style.
#bibliography(
  "assets/genre_bib.bib",
  style: "assets/apa_en.csl",
  title: none,
)
