facToStr <- function(var) {
    ifac = sapply(var, is.factor) # change only factor cols to string
    var[ifac] = lapply(var[ifac], as.character)
    return (var)
}

