## METHOD 2: use local-global alignment algorithm from Biostrings
## Works better than global alignment and requires less fine-tuning
## (although is considerably slower too)
## If only "local" alignment is used, then Saïda gets misclassified
## because the maximum score is attained by several candidates and this
## takes the first one.
## https://ro-che.info/articles/2016-12-11-local-alignment
#' @import Biostrings
match_pwalign <- function(x, candidates) {
  ## in the sake of speed: check for perfect matches first
  if (x %in% candidates) {
    scores <- vector("double", length(candidates))
    idx <- which(x == candidates)
    scores[idx] <- 1/length(idx)
  } else {
    scores <- Biostrings::pairwiseAlignment(candidates, x, type = "local-global", scoreOnly = TRUE)
  }

  return(scores)
}

#' Toponomy matching
#'
#' Match a list of toponyms agains a list of candidates.
#'
#' For comparison, strings are trimmed off whitespaces, converted to
#' upper-case and special characters transliterated to ASCII.
#'
#' @param x character vector of terms to matcih
#' @param candidates character vector of terms to compare against
#'
#' @return A matrix with x in rows and candidates in columns with matching
#'   scores.
#' @export
#'
#' @examples
#'   x <- c("abá", "Efé", "IJI", "kkk")
#'   cand <- c("aba", "ef", "iji", "opo", "Uvu")
#'   topomatch(x, cand)
topomatch <- function(x, candidates) {
  vf <- Vectorize(match_pwalign, "x", SIMPLIFY = TRUE, USE.NAMES = FALSE)

  clean_str <- function(x) {
    trim(toupper(iconv(as.character(x), from = "utf-8", to="ASCII//TRANSLIT")))
  }

  structure(
    matrix(
      vf(clean_str(x), clean_str(candidates)),
      nrow = length(candidates),
      ncol = length(x)
    ),
    dimnames = list(candidates, x),
    class = c("topomatch", "matrix")
  )

}


#' @export
print.topomatch <- function(x, ...) {

  ## TODO: use colors for printing (package crayon)

  exact_match.idx <- exact_matches(x)
  multiple_matches.idx <- unmatched(x)
  single_similar_match.idx <- !exact_match.idx & !multiple_matches.idx

  terms_print <- function(x, lim) {
    lens <- vapply(seq_along(x), function(n) nchar(paste(head(x, n), collapse = ", ")), 1)
    n <- tail(which(lens < lim - 4), 1)

    if (length(n) == 0) {
      ans <- "..."
    } else {
      ans <- paste(x[seq.int(n)], collapse = ", ")
      if (n < length(x)) ans <- paste(ans, "...", sep = ", ")
    }

    return(ans)
  }

  print.length <- 40
  bmx <- best_matches(x)

  cat(sum(exact_match.idx), "names matched exactly:",
      terms_print(colnames(x)[exact_match.idx], print.length), "\n")
  cat("\n")
  cat(sum(single_similar_match.idx), "matches based on similarity:", "\n")

  for (i in seq_along(w <- bmx[single_similar_match.idx])) {
    cat(paste0("  ", i, ". ", names(w)[i], ": "), w[[i]], "\n")
  }

  cat("\n")
  cat(sum(multiple_matches.idx), "unresolved matches:", "\n")

  for (i in seq_along(w <- bmx[multiple_matches.idx])) {
    cat(paste0("  ", i, ". ", names(w)[i], ":"),
        terms_print(w[[i]], print.length), "\n")
  }
}


#' Best matches
#'
#' @param x \code{topomatch} object
#'
#' @return The original list of toponyms with their best-ranked
#'   candidates.
#'
#' @export
#'
#' @examples
#'   best_matches(topomatch(c("a", "b"), c("A", "X")))
best_matches <- function(x) UseMethod("best_matches", x)

#' @export
best_matches.topomatch <- function(x) {
  bm <- lapply(seq.int(ncol(x)), function(.) rownames(x)[which(x[, .] == max(x[, .]))])
  return(setNames(bm, colnames(x)))
}

#' Exact toponym matches
#'
#' @param x \code{topomatch} object
#'
#' @return named logical vector
#' @export
#'
#' @examples
#'   exact_matches(topomatch(c("a", "b"), "A"))
exact_matches <- function(x) UseMethod("exact_matches", x)

#' @export
exact_matches.topomatch <- function(x) {
  apply(x, 2, function(j) sum(j > 0) == 1 && sum(j) == 1)
}


#' Similar toponym matches
#'
#' @param x \code{topomatch} object
#'
#' @return named logical vector
#' @export
#'
#' @examples
#'   similar_matches(topomatch(c("a", "b"), "A"))
similar_matches <- function(x) UseMethod("similar_matches", x)

#' @export
similar_matches.topomatch <- function(x) {
  !exact_matches(x) & !unmatched(x)
}

#' Unmatched toponyms
#'
#' Vector of toponyms with more than one plausible candidate with
#' the same score.
#'
#' @param x \code{topomatch} object
#'
#' @return named logical vector
#' @export
#'
#' @examples
#'   unmatched(topomatch(c("a", "b"), c("A", "X")))
unmatched <- function(x) UseMethod("unmatched", x)

#' @export
unmatched.topomatch <- function(x) {
  apply(x, 2, function(j) sum(j == max(j)) > 1)
}


