#' Semantic versioning
#'
#' @param semver Character vector of package versions following semantic
#'     versioning see \url{http://semver.org/}
#'
#' @return A list of class "svlist" containing "semver" objects.
#' @export
#'
#' @examples
#' \dontrun{
#' verStr <- c("10.20.30", "1.2.3-beta",
#'             "10.2.3-DEV-SNAPSHOT", "1.2.3-SNAPSHOT-123")
#' vs <- sem_ver(verStr)
#' max(vs)
#' min(vs)
#' sort(vs)
#' range(vs)
#' as.character(vs)
#' }

sem_ver <- function(semver){
  "^
  (?'MAJOR'(?:
  0|(?:[1-9]\\d*)
  ))
  \\.
  (?'MINOR'(?:
  0|(?:[1-9]\\d*)
  ))
  \\.
  (?'PATCH'(?:
  0|(?:[1-9]\\d*)
  ))
  (?:-(?'prerelease'
  [0-9A-Za-z-]+(\\.[0-9A-Za-z-]+)*
  ))?
  (?:\\+(?'build'
  [0-9A-Za-z-]+(\\.[0-9A-Za-z-]+)*
  ))?
  $" -> svregex
  svregex <- gsub("\\n| ", "", svregex)
  mtch <- regmatches(semver, regexec(svregex, semver, perl = TRUE))
  mtch <- lapply(seq_along(mtch), function(sver){
    sv <- mtch[[sver]]
    if(length(sv) < 8){
      stop(semver[sver], " does not parse under semantic versioning rules")
    }
    sv <- as.list(sv)
    sv[2:4] <- lapply(sv[2:4], as.integer)
    class(sv) <- "semver"
    sv
  })
  class(mtch) <- "svlist"
  mtch
}

#' @export

print.semver <- function(x, ...){
  major <- x[[2]]
  minor <- x[[3]]
  patch <- x[[4]]
  prerelease <- x[[5]]
  build <- x[[7]]
  cat("Major:", major, "Minor:", minor, "Patch", patch)
  if(!identical(prerelease, "") || !identical(build, "")){
    cat("\nprerelease:", prerelease, "build:", build)
  }
  cat("\n")
}

#' @export

print.svlist <- function(x, ...){
  for(i in 1:length(x)){
    cat(paste0("[", i, "]"),  "\n")
    print(x[[i]])
    cat("\n")
  }
}

#' @export

Ops.semver <- function(e1, e2){
  if (nargs() == 1){
    stop(gettextf("unary %s not defined for \"semver\" objects",
                  .Generic), domain = NA)}
  boolean <- switch(.Generic, `<` = , `>` = , `==` = , `!=` = ,
                    `<=` = , `>=` = TRUE, FALSE)
  if (!boolean)
    stop(gettextf("%s not defined for \"semver\" objects",
                  .Generic), domain = NA)
  if(!inherits(e1, "semver")){
    e1 <- sem_ver(e1)[[1]]
  }
  if(!inherits(e2, "semver")){
    e2 <- sem_ver(e2)[[1]]
  }
  a1 <- integer(5L)
  a2 <- integer(5L)
  a1[4] <- identical(e1[[5]], "")*1L
  a2[4] <- identical(e2[[5]], "")*1L
  if(e1[[5]] != e2[[5]]){
    a1[5] <- as.integer(e1[[5]] > e2[[5]])
    a2[5] <- 1L - a1[5]
  }
  a1[1:3] <- unlist(e1[2:4])
  a2[1:3] <- unlist(e2[2:4])
  e1 <- sum(sign(a1-a2)*10^(4:0))
  e2 <- 0L
  NextMethod(.Generic)
}

#' @export

Ops.svlist <- function(e1, e2){
  if (nargs() == 1){
    stop(gettextf("unary %s not defined for \"svlist\" objects",
                  .Generic), domain = NA)}
  boolean <- switch(.Generic, `<` = , `>` = , `==` = , `!=` = ,
                    `<=` = , `>=` = TRUE, FALSE)
  if (!boolean)
    stop(gettextf("%s not defined for \"svlist\" objects",
                  .Generic), domain = NA)
  if(length(e1) != length(e2)){
    stop(
      gettextf("%s not defined for \"svlist\" objects of unequal length",
               .Generic),
      domain = NA
    )
  }
  FUN <- get(.Generic, envir = parent.frame(), mode = "function")
  unlist(Map(FUN, e1 = e1, e2 = e2))
}

#' @export

sort.svlist <- function(x, decreasing = FALSE, ...){
  if(length(x) <= 1){
    return(x)
  }
  elem <- x[1]
  remainder <- x[-1]
  elemlt <- vapply(remainder, `<`, logical(1), e2 = elem[[1]])
  vec1 <- remainder[elemlt]
  vec2 <- remainder[!elemlt]
  vec1 <- sort(vec1)
  vec2 <- sort(vec2)
  res <- `class<-`(c(vec1, elem, vec2), "svlist")
  if(decreasing){
    rev(res)
  }else{
    res
  }
}

#' @export

`[.svlist` <- function(x, i, ...){
  res <- .Primitive("[")(unclass(x), i)
  return(`class<-`(res, "svlist"))
}

#' @export

as.character.semver <- function(x, ...){
  x[[1]]
}

#' @export

as.character.svlist <- function(x, ...){
  vapply(x, as.character, character(1))
}

#' @export

Summary.svlist <- function(x, ..., na.rm = FALSE){
  ok <- switch(.Generic, max = , min = , range = TRUE, FALSE)
  if (!ok)
    stop(gettextf("%s not defined for \"svlist\" objects",
                  .Generic), domain = NA)
  sorted <- sort(x)
  switch(.Generic,
         max = sorted[[length(sorted)]],
         min = sorted[[1]],
         range = `class<-`(c(sorted[1], sorted[length(sorted)]), "svlist")
  )
}
