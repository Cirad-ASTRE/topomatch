#' Trim whitespaces
#'
#' Remove the whitespace before or after a string of character
#'
#'
#' @param x character vector, matrix or array.
#' @param internal logical. Whether to replace sequential internal by
#'   a single space
#'
#' @return A character object of the same type.
#' @export
#'
#' @author Robert J. Hijmans and Jacob van Etten. The code was borrowed
#' from function \code{\link[raster]{trim}} in package \code{raster}.
#'
#' @examples
#'   trim(c("    hi folks    !   ", "    hello   world    "))
trim <- function (x, internal = TRUE)
{
  if (internal) {
    gsub("^ *|(?<= ) | *$", "", x, perl = TRUE)
  }
  else {
    gsub("^\\s+|\\s+$", "", x)
  }
}
