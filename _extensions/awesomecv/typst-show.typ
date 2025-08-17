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
$if(style.font-header)$
  font-header: ("$style.font-header$",),
$elseif(brand.defaults.awesomecv-typst.font-header)$
  font-header: ("$brand.defaults.awesomecv-typst.font-header$", ),
$endif$
$if(style.font-text)$
  font-text: ("$style.font-text$",),
$elseif(brand.typography.base.family)$
  font-text: $brand.typography.base.family$,
$endif$
$if(style.color-accent)$
  color-accent: rgb("$style.color-accent$"),
$elseif(brand.color.primary)$
  color-accent: brand-color.primary,
$endif$
$if(style.color-link)$
  color-link: rgb("$style.color-link$"),
$elseif(brand.color.link)$
  color-link: brand-color.link,
$endif$
)