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
#' @param x character vector of terms to matcih
#' @param candidates character vector of terms to compare against
#'
#' @return A matrix with x in rows and candidates in columns with matching
#'   scores.
#' @export
#'
#' @examples
#'   x <- c("aba", "Efé", "IJI", "kkk")
#'   cand <- c("aba", "efe", "iji", "opo", "Uvu")
#'   topomatch(x, cand)
topomatch <- function(x, candidates) {
  vf <- Vectorize(match_pwalign, "x", SIMPLIFY = TRUE, USE.NAMES = FALSE)

  structure(
    vf(tolower(x), tolower(candidates)),
    dimnames = list(candidates, x),
    class = c("topomatch", "matrix")
  )

}


print.topomatch <- function(x, ...) {

  is_exact <- function(x) sum(x > 0) == 1 && sum(x) == 1
  is_single_similar <- function(x) sum(x == max(x)) == 1

  exact_match.idx <- apply(x, 2, is_exact)
  single_similar_match.idx <- apply(x, 2, is_single_similar) & !exact_match.idx
  multiple_matches.idx <- !exact_match.idx & !single_similar_match.idx

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

  cat(sum(exact_match.idx), "names matched exactly:",
      terms_print(colnames(x)[exact_match.idx], print.length), "\n")
  cat("\n")
  cat(sum(single_similar_match.idx), "matches based on similarity:", "\n")

  for (i in seq_along(w <- which(single_similar_match.idx)))
    cat(paste0("  ", i, ". ", colnames(x)[w[i]], ": "),
        rownames(x)[which.max(x[, w[i]])], "\n")

  cat("\n")
  cat(sum(multiple_matches.idx), "unresolved matches:", "\n")

  for (i in seq_along(w <- which(multiple_matches.idx))) {
    matches <- which(x[, w[i]] == max(x[, w[i]]))
    cat(paste0("  ", i, ". ", colnames(x)[w[i]], ":"),
        terms_print(rownames(x)[matches], print.length), "\n")
  }
}
