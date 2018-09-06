

#' Pick observations occurring at the first-recorded time.
#' 
#' @param time time vector
#' @return index
#' @export
pick_first = function(time) which(time == min(time))

#' Pick observations occurring at the last-recorded time.
#' 
#' @param time time vector
#' @return index
#' @export
pick_last = function(time) which(time == max(time))

#' Pick observationsn occurring prior to a pivot time point
#'
#' @param time time vector
#' @param pivot pivot time point
#' @return index
#' @export
pick_prior = function(time, pivot) {
  if (all(time > pivot))
    return(NULL)
  idx = which(time < pivot) 
  idx = idx[time[idx] == max(time[idx])]
  return(idx)
}

#' Pick observations occurring nearest the median time.
#'
#' @param time time vector
#' @param smaller if TRUE (default) return the smaller of two central 
#'        values, otherwise return larger
#' @return index
#' @export
pick_median = function(time, smaller = TRUE) {
  if (is_odd_length(time)) {
    idx = which(time == median(time))
  } else {
      distance = abs(time - median(time))
      idx = (1:length(time))[distance == min(distance)]
      if (smaller)
	idx = idx[time[idx] == min(time[idx])]
      else
        idx = idx[time[idx] == max(time[idx])]
  }
  return(idx)
}

#' Pick observations occurring at a time point
#'
#' @param time time vector
#' @param pivot pivot time point
#' @return index
#' @export
pick_time = function(time, t) which(time == t)

#' Pick observations occurring at time pivot.
#'
#' @param time time vector
#' @param pivot pivot time point
#' @return index
#' @export
pick_lag_heads = function(time, pivot) which(time != pivot)

#' Pick observations ocurring prior to head observations
#' and towards the pivot.  Ignore tails equal to pivot.
#'
#' @param time time vector
#' @param pivot pivot time point
#' @return index
#' @export
pick_lag_tails = function(time, pivot) {
  N = length(time)
  original_rank = seq_rank(time)
  shift_rank = original_rank
  pivot_idx = (time == pivot)
  pivot_rank = original_rank[pivot_idx][1]
  if (pivot_rank != 1) {
    pre_pivot = original_rank < pivot_rank
    shift_rank[pre_pivot] = original_rank[pre_pivot] + 1
  }
  if (pivot_rank != N) {
    post_pivot = original_rank > pivot_rank
    shift_rank[post_pivot] = original_rank[post_pivot] - 1
  }
  idx = match(shift_rank, original_rank)
  idx = idx[!pivot_idx]
  return(idx)
}

#' Pick observation order based on time (distance 
#' to pivot).
#'
#' @param time time vector
#' @param pivot pivot time point
#' @return index
#' @export
pick_pivot_distance = function(time, pivot) {
  N = length(time)
  pivot_idx = which(time == pivot)
  pivot_distance = abs(time - pivot)
  idx = order(pivot_distance)
  return(idx)
}

#' Run pick function by group
#' 
#' @param unit vector indicating group
#' @param time time vector
#' @param picker a single-unit pick-function
#' @param per_unit list of arguments passed to picker (like MoreArgs in mapply)
#' @param ... arguments passed to picker
#' @return ragged list of per-unit indexes
pick_ = function(unit, time, picker, ...) { 
  if (is_varying_length(unit, time))
    stop("'unit', and 'time' arguments must be the same length.")
  N <- length(unit) 
  idx = split(1:N, unit)
  ts = lapply(idx, function(i, x) x[i], x = time)
  extras = list(...)
  if ('per_unit' %in% names(extras)) {
    per_unit = extras[['per_unit']]
    extras[['per_unit']] <- NULL
  } else {
    per_unit = list()
  }
  extras[['index']] <- NULL
  picks = do.call(what = mapply, args = c(list(FUN = picker,
    time = ts), per_unit, list(MoreArgs = extras, SIMPLIFY = FALSE)))
  if (isTRUE(list(...)[['index']])) {
    rdx_picks = mapply(`[`, idx, picks, SIMPLIFY = FALSE)
    class(rdx_picks) <- c(class(rdx_picks), 'index')
  } else {
    rdx_picks = mapply(`[`, ts, picks, SIMPLIFY = FALSE)
    class(rdx_picks) <- c(class(rdx_picks), 'value')
  }
  return(rdx_picks)
}

#' Run pick function by group
#' 
#' @param unit vector indicating group
#' @param time time vector
#' @param picker a single-unit pick-function
#' @param per_unit list of arguments passed to picker (like MoreArgs in mapply)
#' @param ... arguments passed to picker
#' @return data frame 
pick = function(unit, time, picker, ...) {
  picks = pick_(unit, time, picker, ...) 
  if ('index' %in% class(picks)) {
    o = data.frame(unit = unit, time = time)[picks,]
  } else {
    o = data.frame(unit = unit, time = picks)
  }
  return(o)
}




