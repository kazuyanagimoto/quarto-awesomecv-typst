# The quarto-extensions test container runs R in a non-UTF-8 (C) locale. There
# cat() escapes non-ASCII as "<U+00FC>", so the asis chunks emit
# "Z<U+00FC>rich" into the .typ file and Typst fails with "unclosed label".
# Pin LC_CTYPE to UTF-8 before anything else runs.
local({
  if (!grepl("utf-?8", Sys.getlocale("LC_CTYPE"), ignore.case = TRUE)) {
    for (loc in c("C.UTF-8", "C.utf8", "en_US.UTF-8")) {
      if (suppressWarnings(Sys.setlocale("LC_CTYPE", loc)) != "") break
    }
  }
})

source("renv/activate.R")
