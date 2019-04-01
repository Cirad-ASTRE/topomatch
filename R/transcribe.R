#' Transcribe toponyms according to a topomatch table
#'
#' Build a function for transcription.
#'
#' If there are any unmatched toponyms, they must be manually matched
#' in fixes for transcription. On the other hand, fixes can provide matches for incorrect
#' associations. See examples.
#'
#' @param obj A \code{topomatch} object.
#' @param fixes A Named character vector of manual fixes.
#'
#' @return A function that takes a character vector among the original
#' terms and returns a character vector with the corresponding matches.
#'
#' @export
#'
#' @examples
#'   (perfect <- topomatch("AFGHANISTAN", "Afghanistan"))
#'   transcribe(perfect)("Afghanistan")
#'
#'   terms <- c("foo", "bar", "foobar", "X")
#'   (mat <- topomatch(terms, c("Foo", "Bar")))
#'   setNames(transcribe(mat, fixes = c(X = "Bar"))(terms), terms)
#'
#'   ## You can still transcribe terms that do not need fixes
#'   # transcribe(mat)(terms)  # Error: X is not fixed
#'   transcribe(mat)(c("foo", "bar"))  # Works even if X remains unfixed.
#'
transcribe <- function(obj, fixes = NULL) {

  if (!all(idx <- names(fixes) %in% colnames(obj))) {
    stop("All name fixes must be elements of the original terms to match.\n",
         "Invalid fixes: ", names(fixes)[!idx])
  }

  if (!all(idx <- fixes %in% rownames(obj))) {
    stop("All fixes must be elements of the original candidates.\n",
         "If necessary, complete the list of candidates.\n",
         "Invalid fixes: ", unname(fixes)[!idx])
  }

  obj[, names(fixes)] <- 0
  obj[fixes, names(fixes)] <- diag(length(fixes))

  function(x) {

    unm.idx <- which(unmatched(obj))
    if (any(idx <- x %in% names(unm.idx))) {
      stop("Cannot transcribe ",
           paste(x[idx], collapse = ", "), ".\n",
           "Please fix these unmatched terms using fixes."
      )
    }

    ## Conversion table
    conv <- apply(obj, 2, function(i) rownames(obj)[which.max(i)])

    ## Additional elements not found in the table
    conv <- c(conv, setNames(nm = x[!x %in% names(conv)]))

    unname(conv[x])
  }

}
