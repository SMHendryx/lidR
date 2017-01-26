# ===============================================================================
#
# PROGRAMMERS:
#
# jean-romain.roussel.1@ulaval.ca  -  https://github.com/Jean-Romain/lidR
#
# COPYRIGHT:
#
# Copyright 2016 Jean-Romain Roussel
#
# This file is part of lidR R package.
#
# lidR is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>
#
# ===============================================================================

#' Individual tree segmentation
#'
#' Individual tree segmentation with several possible algorithms (see details). The function
#' attributes to each point of the point cloud a number to identify from which detected tree
#' the point comes from. By default the classification is done at the point level. However, with some algorithms it is
#' possible to return a raster image of the classification. There is currently 1 algorithm
#' implemented. See relevant sections.
#'
#' @section Dalponte 2012:
#'
#' \code{algorithm = "dalponte2012"}
#'
#' This is the algorithm developpd by M. Dalponte (see references). This algorithm exists
#' in the package \pkg{itcSegment}. This version is identical to the original but with superfluous code
#' removed and rewritten in pure C++. Consequently it is 6 times faster. The names of the parameters are the same as those
#' in Dalponte's \pkg{itcSegment} package. Dalponte's algorithm is a canopy
#' surface model-based method. An image of the canopy is expected.
#' \describe{
#' \item{\code{searchWinSize}}{Size (in pixels) of the moving window used to the detect the local maxima. It should be an odd number larger than 3. Default 3}
#' \item{\code{TRESHSeed}}{Growing threshold 1. It should be between 0 and 1. Default 0.45}
#' \item{\code{TRESHCrown}}{Growing threshold 2. It should be between 0 and 1. Default 0.55}
#' \item{\code{DIST}}{Maximum value of the crown diameter of a detected tree (in meters). Default 10}
#' \item{\code{th}}{Digital number value below which a pixel cannot be a local maxima. Default 2}
#' }
#'
#' @section Li 2012:
#'
#' Not yet implemented
#'
#' @param .las An object of the class \code{LAS}
#' @param algorithm character. The name of an algorithm. Can be \code{"dalponte2012"}, \code{"li2012"}.
#' (see sections relevant to each algorithm)
#' @param image RasterLayer. Image of the canopy if the algorithm works on canopy surface model.
#' But some algorithms work on the raw point cloud. You can compute it with grid_canopy or read it from external file.
#' @param ... parameter for the algorithms. Depends on the algorithm used (see details about the algoritms)
#' @param extra logical. By defaut the function works at the point cloud level and return nothing.
#' If \code{extra = TRUE} the function return a list of 2 \link[raster:raster]{RasterLayer} with the position
#' of the local maxima and the map of the crowns.
#' @examples
#' LASfile <- system.file("extdata", "Megaplot.laz", package="lidR")
#' las = readLAS(LASfile, XYZonly = TRUE, filter = "-keep_xy 684850 5017850 684900 5017900")
#'
#' # compute a canopy image
#' chm = grid_canopy(las, res = 0.5, na.fill = "knnidw", k = 4)
#' chm = as.raster(chm)
#'
#' # smoothing post-process
#' kernel = matrix(1,3,3)
#' chm = raster::focal(chm, w = kernel, fun = mean)
#'
#' # check the image
#' raster::plot(chm, col = height.colors(50))
#'
#' r = lastrees(las, "dalponte2012", chm, extra = TRUE,
#'              searchWinSize = 3, TRESHSeed = 0.45,
#'              TRESHCrown = 0.55, DIST = 10, th = 0)
#'
#' raster::plot(r[[1]], col = random.colors(38))
#' raster::plot(r[[2]], col = random.colors(38))
#' plot(las, color = "treeID", colorPalette = random.colors(38))
#' @references
#' M. Dalponte, F. Reyes, K. Kandare, and D. Gianelle, "Delineation of Individual Tree Crowns from ALS and Hyperspectral data: a comparison among four methods," European Journal of Remote Sensing, Vol. 48, pp. 365-382, 2015.
#' @export
lastrees <-function(.las, algorithm, image = NULL, extra = FALSE, ...)
{
  if(algorithm == "dalponte2012" )
    return(dalponte2012(.las, image, extra, ...))
  else
    stop("This algorithm does not exist.", call. = FALSE)
}

dalponte2012 = function(.las, image, extra, searchWinSize = 3, TRESHSeed = 0.45, TRESHCrown = 0.55, DIST = 10, th = 2)
{
  if (searchWinSize < 3 | searchWinSize %% 2 == 0)
    stop("searchWinSize not correct", call. = FALSE)

  l = dim(image)[1]
  w = dim(image)[2]

  Canopy <- matrix(w, l, data = image, byrow = FALSE)
  Canopy <- Canopy[1:w, l:1]
  Canopy[is.na(Canopy) | Canopy < th] <- 0

  Maxima = itc_treetops(Canopy, searchWinSize)
  Crowns = itc_expandcrowns(Canopy, Maxima, TRESHSeed, TRESHCrown, DIST)

  Crowns = raster::raster(apply(Crowns,1,rev))
  raster::extent(Crowns) = raster::extent(image)

  lasclassify(.las, Crowns, "treeID")

  if(extra == FALSE)
    return(invisible(NULL))
  else
  {
    Maxima = raster::raster(apply(Maxima,1,rev))
    raster::extent(Maxima) = raster::extent(image)

    return(list(Crowns, Maxima))
  }
}