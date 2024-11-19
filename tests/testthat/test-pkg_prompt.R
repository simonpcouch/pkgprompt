test_that("pkg_prompt works for whole package", {
  res <- pkg_prompt("splines")

  expect_type(res, "character")
  expect_length(res, 1L)
  expect_match(res, "# Documentation for the splines package")
  expect_match(res, "### Returns")
})

test_that("pkg_prompt works with selected topics", {
  res <- pkg_prompt("splines", topic = "splines-package")

  expect_type(res, "character")
  expect_length(res, 1L)
  expect_no_match(res, "#### Returns")
  expect_match(res, "## Regression Spline Functions")

  expect_true(
    nchar(res) < nchar(pkg_prompt("splines"))
  )
})

test_that("pkg_prompt errors informatively with bad inputs", {
  expect_snapshot(pkg_prompt(NULL), error = TRUE)
  expect_snapshot(pkg_prompt("doesntexist"), error = TRUE)
  expect_snapshot(
    res <- pkg_prompt("splines", topics = c("doesntexist", "ns"))
  )
  expect_type(res, "character")
  expect_snapshot(
    error = TRUE,
    pkg_prompt("splines", topics = c("doesntexist", "this one either"))
  )
})
