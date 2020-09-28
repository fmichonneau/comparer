test_that("output is correct when files are identical", {
  res <- compare_folders(
    system.file("test_identical", "folder_one", package = "fiderent"),
    system.file("test_identical", "folder_two", package = "fiderent")
  )

  expect_true(all(res$identical))

})

test_that("output is correct when files are different", {
  res <- compare_folders(
    system.file("test_difference", "folder_one", package = "fiderent"),
    system.file("test_difference", "folder_two", package = "fiderent")
  )
  expect_false(all(res$identical))
})
