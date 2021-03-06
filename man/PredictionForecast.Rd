% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PredictionForecast.R
\name{PredictionForecast}
\alias{PredictionForecast}
\title{Prediction Object for Forecasting}
\format{
\link[R6:R6Class]{R6::R6Class} object inheriting from \link{Prediction}.
}
\description{
This object wraps the predictions returned by a learner of class LearnerForecast, i.e.
the predicted response and standard error.
}
\section{Construction}{
\preformatted{p = PredictionForecast$new(task = NULL, row_ids = task$row_ids, truth = task$truth(), response = NULL, se = NULL)
}
\itemize{
\item \code{task} :: \link{TaskRegrForecast}\cr
Task, used to extract defaults for \code{row_ids} and \code{truth}.
\item \code{row_ids} :: \code{integer()}\cr
Row ids of the predicted observations, i.e. the row ids of the test set.
\item \code{truth} :: \code{numeric()}\cr
True (observed) outcome.
\item \code{response} :: \code{numeric()}\cr
Object of numeric response values that can be coerced to a data.table.
\item \code{se} :: \code{numeric()}\cr
Object of numeric standard errors that can be coerced to a data.table.
}
}

\section{Fields}{

All fields from \link{Prediction}, and additionally:
\itemize{
\item \code{response} :: \code{numeric()}\cr
Access to the stored predicted response.
\item \code{se} :: \code{numeric()}\cr
Access to the stored standard error.
}

The field \code{task_type} is set to \code{"forecast"}.
}

\section{Methods}{

All Methods from \link{Prediction}, and additionally:
\itemize{
\item \code{conf_int(level)}\cr
Access to the stored predicted response.
}
}

\examples{
task = mlr3::tsk("airpassengers")
learner = LearnerRegrForecastAutoArima$new()
learner$train(task, 1:30)
p = learner$predict(task, 31:50)
}
\concept{Prediction}
