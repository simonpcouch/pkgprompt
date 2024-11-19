# pkg_prompt errors informatively with bad inputs

    Code
      pkg_prompt(NULL)
    Condition
      Error in `check_pkg()`:
      ! `pkg` must be a single string, not `NULL`.

---

    Code
      pkg_prompt("doesntexist")
    Condition
      Error in `pkg_prompt()`:
      ! Package doesntexist must be installed to convert its documentation to plain text.

---

    Code
      res <- pkg_prompt("splines", topics = c("doesntexist", "ns"))
    Condition
      Warning in `pkg_prompt()`:
      Element doesntexist in `include` did not match any documentation topics and will be excluded from results.

---

    Code
      pkg_prompt("splines", topics = c("doesntexist", "this one either"))
    Condition
      Error in `pkg_prompt()`:
      ! `topics` did not match any entries in `pkg`'s documentation.

