// Typst custom formats typically consist of a 'typst-template.typ' (which is
// the source code for a typst template) and a 'typst-show.typ' which calls the
// template's function (forwarding Pandoc metadata values as required)
//
// This is an example 'typst-show.typ' file (based on the default template  
// that ships with Quarto). It calls the typst function named 'article' which 
// is defined in the 'typst-template.typ' file. 
//
// If you are creating or packaging a custom typst template you will likely
// want to replace this file and 'typst-template.typ' entirely. You can find
// documentation on creating typst templates here and some examples here:
//   - https://typst.app/docs/tutorial/making-a-template/
//   - https://github.com/typst/templates

#show: resume.with(
$if(title)$
  title: [$title$],
$endif$
$if(date)$
  date: [$date$],
$endif$
$if(author)$
  author: (
    firstname: unescape_text("$author.firstname$"),
    lastname: unescape_text("$author.lastname$"),
    address: unescape_text("$author.address$"),
    position: unescape_text("$author.position$"),
    contacts: ($for(author.contacts)$(
      text: unescape_text("$it.text$"),
      url: unescape_text("$it.url$"),
      icon: unescape_text("$it.icon$"),
    )$sep$, $endfor$),
  ),
$endif$
$if(profile-photo)$
  profile-photo: unescape_text("$profile-photo$"),
$endif$
)