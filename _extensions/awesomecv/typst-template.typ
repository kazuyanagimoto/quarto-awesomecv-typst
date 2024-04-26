#import "@preview/fontawesome:0.1.0": *

// const color
#let color-darknight = rgb("#131A28")
#let color-darkgray = rgb("#333333")
#let color-middledarkgray = rgb("#414141")
#let color-gray = rgb("#5d5d5d")
#let color-lightgray = rgb("#999999")

// Default style
#let color-accent-default = rgb("#dc3522")
#let font-header-default = ("Roboto", "Arial", "Helvetica", "Dejavu Sans")
#let font-text-default = ("Source Sans Pro", "Arial", "Helvetica", "Dejavu Sans")

// User defined style
$if(style.color-accent)$
#let color-accent = rgb("$style.color-accent$")
$else$
#let color-accent = color-accent-default
$endif$
$if(style.font-header)$
#let font-header = "$style.font-header$"
$else$
#let font-header = font-header-default
$endif$
$if(style.font-text)$
#let font-text = "$style.font-text$"
$else$
#let font-text = font-text-default
$endif$

/// Helpers

// icon string parser

#let parse_icon_string(icon_string) = {
  if icon_string.starts-with("fa ") [
    #let parts = icon_string.split(" ")
    #if parts.len() == 2 {
      fa-icon(parts.at(1), fill: color-darknight)
    } else if parts.len() == 3 and parts.at(1) == "brands" {
      fa-icon(parts.at(2), fa-set: "Brands", fill: color-darknight)
    } else {
      assert(false, "Invalid fontawesome icon string")
    }
  ] else if icon_string.ends-with(".svg") [
    #box(image(icon_string))
  ] else {
    assert(false, "Invalid icon string")
  }
}

// contaxt text parser
#let unescape_text(text) = {
  // This is not a perfect solution
  text.replace("\\", "").replace(".~", ". ")
}

// layout utility
#let __justify_align(left_body, right_body) = {
  block[
    #box(width: 4fr)[#left_body]
    #box(width: 1fr)[
      #align(right)[
        #right_body
      ]
    ]
  ]
}

#let __justify_align_3(left_body, mid_body, right_body) = {
  block[
    #box(width: 1fr)[
      #align(left)[
        #left_body
      ]
    ]
    #box(width: 1fr)[
      #align(center)[
        #mid_body
      ]
    ]
    #box(width: 1fr)[
      #align(right)[
        #right_body
      ]
    ]
  ]
}

/// Right section for the justified headers
/// - body (content): The body of the right header
#let secondary-right-header(body) = {
  set text(
    size: 10pt,
    weight: "thin",
    style: "italic",
    fill: color-accent,
  )
  body
}

/// Right section of a tertiaty headers. 
/// - body (content): The body of the right header
#let tertiary-right-header(body) = {
  set text(
    weight: "light",
    size: 9pt,
    style: "italic",
    fill: color-gray,
  )
  body
}

/// Justified header that takes a primary section and a secondary section. The primary section is on the left and the secondary section is on the right.
/// - primary (content): The primary section of the header
/// - secondary (content): The secondary section of the header
#let justified-header(primary, secondary) = {
  set block(
    above: 0.7em,
    below: 0.7em,
  )
  pad[
    #__justify_align[
      #set text(
        size: 12pt,
        weight: "bold",
        fill: color-darkgray,
      )
      #primary
    ][
      #secondary-right-header[#secondary]
    ]
  ]
}

/// Justified header that takes a primary section and a secondary section. The primary section is on the left and the secondary section is on the right. This is a smaller header compared to the `justified-header`.
/// - primary (content): The primary section of the header
/// - secondary (content): The secondary section of the header
#let secondary-justified-header(primary, secondary) = {
  __justify_align[
     #set text(
      size: 10pt,
      weight: "regular",
      fill: color-gray,
    )
    #primary
  ][
    #tertiary-right-header[#secondary]
  ]
}
/// --- End of Helpers


#let resume(
  title: "CV",
  author: (:),
  date: datetime.today().display("[month repr:long] [day], [year]"),
  body,
) = {
  
  set document(
    author: author.firstname + " " + author.lastname,
    title: title,
  )
  
  set text(
    font: (font-text),
    size: 11pt,
    fill: color-darkgray,
    fallback: true,
  )
  
  set page(
    paper: "a4",
    margin: (left: 15mm, right: 15mm, top: 10mm, bottom: 10mm),
    footer: [
      #set text(
        fill: gray,
        size: 8pt,
      )
      #__justify_align_3[
        #smallcaps[#date]
      ][
        #smallcaps[
          #author.firstname
          #author.lastname
          #sym.dot.c
          CV
        ]
      ][
        #counter(page).display()
      ]
    ],
  )
  
  // set paragraph spacing

  
  set heading(
    numbering: none,
    outlined: false,
  )
  
  show heading.where(level: 1): it => [
    #set block(
      above: 1.5em,
      below: 1em,
    )
    #set text(
      size: 16pt,
      weight: "regular",
    )
    
    #align(left)[
      #text[#strong[#text(color-accent)[#it.body.text.slice(0, 3)]#text(color-darkgray)[#it.body.text.slice(3)]]]
      #box(width: 1fr, line(length: 100%))
    ]
  ]
  
  show heading.where(level: 2): it => {
    set text(
      color-middledarkgray,
      size: 12pt,
      weight: "thin"
    )
    it.body
  }
  
  show heading.where(level: 3): it => {
    set text(
      size: 10pt,
      weight: "regular",
      fill: color-gray,
    )
    smallcaps[#it.body]
  }
  
  let name = {
    align(center)[
      #pad(bottom: 5pt)[
        #block[
          #set text(
            size: 32pt,
            style: "normal",
            font: (font-header),
          )
          #text(fill: color-gray, weight: "thin")[#author.firstname]
          #text(weight: "bold")[#author.lastname]
        ]
      ]
    ]
  }
  
  let position = {
    set block(
      above: 0.75em,
      below: 0.75em,
    )
  
    set text(
      color-accent,
      size: 9pt,
      weight: "regular",
    )
    align(center)[
      #smallcaps[
        #author.position
      ]
    ]
  }
  
  let address = {
    set block(
      above: 0.75em,
      below: 0.75em,
    )
    set text(
      color-lightgray,
      size: 9pt,
      style: "italic",
    )
    align(center)[
      #author.address
    ]
  }
  
  let contacts = {
    set box(height: 9pt)
    
    let separator = box(width: 5pt, line(start: (0%, 0%), end: (0%, 100%), stroke: color-darkgray))
    let contact_last = author.contacts.pop()
    
    align(center)[
      #set text(
        size: 9pt,
        weight: "regular",
        style: "normal",
      )
      #block[
        #align(horizon)[
          #for contact in author.contacts [
            #box[#parse_icon_string(contact.icon)]
            #box[#link(contact.url)[#contact.text]]
            #separator
          ]
          #box[#parse_icon_string(contact_last.icon)]
          #box[#link(contact_last.url)[#contact_last.text]]
        ]
      ]
    ]
  }
  
  name
  position
  address
  contacts
  body
}

/// The base item for resume entries. 
/// This formats the item for the resume entries. Typically your body would be a bullet list of items. Could be your responsibilities at a company or your academic achievements in an educational background section.
/// - body (content): The body of the resume entry
#let resume-item(body) = {
  set text(
    size: 10pt,
    style: "normal",
    weight: "light",
    fill: color-darknight,
  )
  set par(leading: 0.65em)
  body
}

/// The base item for resume entries. This formats the item for the resume entries. Typically your body would be a bullet list of items. Could be your responsibilities at a company or your academic achievements in an educational background section.
/// - title (string): The title of the resume entry
/// - location (string): The location of the resume entry
/// - date (string): The date of the resume entry, this can be a range (e.g. "Jan 2020 - Dec 2020")
/// - description (content): The body of the resume entry
#let resume-entry(
  title: none,
  location: "",
  date: "",
  description: ""
) = {
  pad[
    #justified-header(title, location)
    #secondary-justified-header(description, date)
  ]
}

/// ---- End of Resume Template ----
