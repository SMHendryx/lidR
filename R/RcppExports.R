# Generated by using Rcpp::compileAttributes() -> do not edit by hand
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

itc_treetops <- function(Canopy, searchWinSize) {
    .Call(lidR_itc_treetops, Canopy, searchWinSize)
}

itc_expandcrowns <- function(Canopy, Maxima, TRESHSeed, TRESHCrown, DIST) {
    .Call(lidR_itc_expandcrowns, Canopy, Maxima, TRESHSeed, TRESHCrown, DIST)
}

algo_li2012 <- function(X, Y, Z, dt1, dt2, R, displaybar = FALSE) {
    .Call(lidR_algo_li2012, X, Y, Z, dt1, dt2, R, displaybar)
}

fast_table <- function(x, size = 5L) {
    .Call(lidR_fast_table, x, size)
}

fast_countequal <- function(x, t) {
    .Call(lidR_fast_countequal, x, t)
}

fast_countbelow <- function(x, t) {
    .Call(lidR_fast_countbelow, x, t)
}

fast_countover <- function(x, t) {
    .Call(lidR_fast_countover, x, t)
}

MorphologicalOpening <- function(X, Y, Z, resolution, displaybar = FALSE) {
    .Call(lidR_MorphologicalOpening, X, Y, Z, resolution, displaybar)
}

point_in_polygon <- function(vertx, verty, pointx, pointy) {
    .Call(lidR_point_in_polygon, vertx, verty, pointx, pointy)
}

points_in_polygon <- function(vertx, verty, pointx, pointy) {
    .Call(lidR_points_in_polygon, vertx, verty, pointx, pointy)
}

points_in_polygons <- function(vertx, verty, pointx, pointy, displaybar = FALSE) {
    .Call(lidR_points_in_polygons, vertx, verty, pointx, pointy, displaybar)
}

tinfo <- function(M, X) {
    .Call(lidR_tinfo, M, X)
}

tsearch <- function(x, y, elem, xi, yi, diplaybar = FALSE) {
    .Call(lidR_tsearch, x, y, elem, xi, yi, diplaybar)
}

