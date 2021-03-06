#' @title Forecast Task
#'
#' @import data.table
#' @import mlr3
#' @import tsbox
#'
#' @usage NULL
#' @format [R6::R6Class] object inheriting from [Task]/[TaskSupervised].
#'
#' @description
#' This task specializes [Task] and [TaskSupervised] for forecasting problems.
#' The target column is assumed to be numeric.
#' The `task_type` is set to `"forecast"` `.

#'
#' @section Construction:
#' ```
#' t = TaskRegrForecast$new(id, backend, target, date_col)
#' ```
#'
#' * `id` :: `character(1)`\cr
#'   Identifier for the task.
#'
#' * `backend` :: [DataBackend]\cr
#'   Either a [DataBackendLong], a object of class `ts` or a `data.frame` with specified date column
#'   or any object which is convertible to a DataBackend with `as_data_backend()`.
#'   E.g., a object of class  `dts` will be converted to a [DataBackendLong].
#'
#' * `target` :: `character(n)`\cr
#'   Name of the target column(s).
#'
#' @section Fields:
#' All methods from [TaskSupervised], and additionally:
#' * `date_col` :: `character(1)`\cr
#'   Name of the date column.
#
#' @section Methods:
#' See [TaskSupervised], additionally:
#' * `date(row_ids = NULL)`  :: `data.table`\cr
#'   (`integer()` | `character()`) -> named `list()`\cr
#'   Returns the `date` column.
#'
#' @family Task
#' @seealso seealso_task
#' @export
TaskForecast = R6::R6Class("TaskForecast",
  inherit = TaskSupervised,
  public = list(
    initialize = function(id, backend, target, time_col = NULL) {
      assert_character(target)
      if (inherits(backend, "data.frame")) {
        assert_subset(time_col, colnames(backend))
        backend = df_to_backend(backend, target, time_col)
      }
      if (!inherits(backend, "DataBackend")) {
        backend = as_data_backend(ts_dts(backend), target)
      }
      super$initialize(id = id, task_type = "forecast", backend = backend, target = target)
      private$.col_roles$feature = setdiff(private$.col_roles$feature, self$date_col)
    },

    truth = function(row_ids = NULL) {
      if (c("multivariate") %in% self$properties) {
        self$data(row_ids, cols = self$target_names)
      } else {
        super$truth(row_ids)[[1L]]
      }
    },

    data = function(rows = NULL, cols = NULL, data_format = "data.table") {
      data = super$data(rows, cols, data_format)
      # Order data by date: FIXME: Should this happen here or in the backend.
      date = self$date(rows)
      assert_true(nrow(data) == nrow(data))
      data[order(date), ]
    },

    date = function(row_ids = NULL) {
      rows = row_ids %??% self$row_roles$use
      self$backend$data(rows, self$date_col)
    }
  ),

  active = list(
    date_col = function() {
      self$backend$date_col
    }
  )
)
