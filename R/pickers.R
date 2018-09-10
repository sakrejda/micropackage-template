

#' Pick observations occurring at the first-recorded time.
#' 
#' @param time time vector
#' @return index
#' @export
pick_first = function(time) which(time == min(time))

