
# How to make a package

There's not much to a package.  Here are the steps to making one:

1) Clone this repo.

2) Add R functions and their `roxygen2`-style doccumentation to the `R` subdirectory.
   The `man` subdirectory has a README.md with an example of `roxygen2` syntax
   that's adequate for most simple functions.

3) Update the `DESCRIPTION` file with the package name, descriptions, author(s), 
   today's date, and any needed `Depends/Suggests/Imports` or other comments

4) Go to the package root directory (the one with the `DESCRIPTION` file) and run
   Rscript `roxygen2::roxygenize(".")` or whatever the RStudio equivalent is.

5) When `roxygenize` runs, it should generate a `NAMESPACE` file in the root directory
   based on instructions in the R-file comments _and_ it should also generate 
   documentation in the `man` subdirectory based on the same comments.

6) Update `tests/testhat.R` with the name of the package so that `testthat` loads
   the package before trying to test it.  Writing and running tests is described
   in the [R packages book](http://r-pkgs.had.co.nz/tests.html), 
   
   If you scroll down there are some

   Each individual test should run a small function and check that it has the 
   correct output.  

7) Then you can go to the directory above the package root and run:
   `R CMD INSTALL <package-root>`


# Good policies to follow:

- Use the `checkmate` package for checking inputs, especially on user-facing
  functions.  This package has a lovely [vignette](https://cran.r-project.org/web/packages/checkmate/vignettes/checkmate.html) here: https://cran.r-project.org/web/packages/checkmate/vignettes/checkmate.html

- Write unit tests when they add value, it's more often than you would think.  They
  can add value when: 
    - a function might fail silently and produce a cascade of failures that will
      require time to trace back to the failure point to debug.
    - a function might involve formulas that could easily be modified down the line
      to produce slightly incorrect results.  Even checking function output for a 
      single value can save a lot of time.
    - you discovered a bug in a function and you'd like to not have to trace that
      same bug again.  This is called a "regression test".

- Don't add dependencies unless you need them.  Many packages have simple
  alternatives in base R so check with the group.

- Use the `styleR` package to format your code. It can be run via `usethis::use_tidy_style()`


