
# mlr3temporal

Temporal prediction / forecasting for mlr3

<!-- badges: start -->

[![tic](https://github.com/mlr-org/mlr3temporal/workflows/tic/badge.svg?branch=main)](https://github.com/mlr-org/mlr3temporal/actions)
[![CRAN Status
Badge](https://www.r-pkg.org/badges/version-ago/mlr3temporal)](https://cran.r-project.org/package=mlr3temporal)
[![codecov](https://codecov.io/gh/mlr-org/mlr3temporal/branch/master/graph/badge.svg)](https://codecov.io/gh/mlr-org/mlr3temporal)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![StackOverflow](https://img.shields.io/badge/stackoverflow-mlr3-orange.svg)](https://stackoverflow.com/questions/tagged/mlr3)
<!-- badges: end -->

Time series analysis accounts for the fact that data points taken over
time may have an internal structure (such as autocorrelation, trend or
seasonal variation) that should be accounted for. This package extends
the [mlr3](https://github.com/mlr-org/mlr3) package framework by
time-series prediction and resampling methods.

<img src="man/figures/multi_timeseries.png" width="1318" />

## Installation

Install the development version from GitHub:

``` r
remotes::install_github("mlr-org/mlr3temporal")
```

## Forecasting

Currently the following methods are implemented:

### Tasks

| Id                                                                                       | Code                   | Type                    |
|------------------------------------------------------------------------------------------|------------------------|-------------------------|
| [airpassengers](https://mlr3temporal.mlr-org.com/reference/mlr_tasks_airpassengers.html) | `tsk("airpassengers")` | Univariate Timeseries   |
| [petrol](https://mlr3temporal.mlr-org.com/reference/mlr_tasks_petrol.html)               | `tsk("petrol")`        | Multivariate Timeseries |

### Learners

| Id                                                                                            | Learner               | Package                                                 |
|-----------------------------------------------------------------------------------------------|-----------------------|---------------------------------------------------------|
| [auto.arima](https://mlr3temporal.mlr-org.com/reference/mlr_learners_regr.AutoArima.html)     | Auto Arima            | [forecast](https://cran.r-project.org/package=forecast) |
| [forecast.average](https://mlr3temporal.mlr-org.com/reference/mlr_learners_regr.Average.html) | Average               | base                                                    |
| [VAR](https://mlr3temporal.mlr-org.com/reference/mlr_learners_regr.VAR.html)                  | Vector Autoregression | [vars](https://cran.r-project.org/package=vars)         |

### Measures

| Id                                                                                        | Measure             | Package |
|-------------------------------------------------------------------------------------------|---------------------|---------|
| [forecast.mae](https://mlr3temporal.mlr-org.com/reference/mlr_measures_forecast.mae.html) | Mean Absolute Error | base    |

### Resampling Methods

| Id                                                                                                 | Resampling                     | Package |
|----------------------------------------------------------------------------------------------------|--------------------------------|---------|
| [forecastHoldout](https://mlr3temporal.mlr-org.com/reference/mlr_resamplings_forecastHoldout.html) | Holdout                        | base    |
| [cv](https://mlr3temporal.mlr-org.com/reference/mlr_resamplings_RollingWindowCV.html)              | Rolling Window CrossValidation | base    |

## Code Example

``` r
library(mlr3)
library(mlr3temporal)
library(tsbox)

# Univariate Timeseries

task = tsk("airpassengers")
learner = LearnerRegrForecastAverage$new()
learner$train(task,row_ids = 1:20)
learner$model
p = learner$predict(task,row_ids = 21:55)
p$score(msr("forecast.mae"))
autoplot(task)
```

## Resampling

#### Holdout

Split data into a training set and a test set. Parameter `ratio`
determines the ratio of observation going into the training set
(default: 2/3).

``` r
task = tsk("petrol")
learner = LearnerRegrForecastVAR$new()

rr = rsmp("forecastHoldout", ratio = 0.8)
rr$instantiate(task)
resample = resample(task, learner, rr, store_models = TRUE)
resample$predictions()
```

#### Rolling Window CV

Splits data using a `folds`-folds (default: 10 folds) rolling window
cross-validation.

``` r
task = tsk("petrol")
learner = LearnerRegrForecastVAR$new()

rr = rsmp("RollingWindowCV", folds = 5, fixed_window = F)
rr$instantiate(task)
resample = resample(task, learner, rr, store_models = TRUE)
resample$predictions()
```

## More resources

For detailed information on how to get started with `mlr3` please read
the [mlr3 book](https://mlr3book.mlr-org.com/) and consult the
[Vignette](https://mlr3temporal.mlr-org.com/articles/vignettes.html) for
more examples of mlr3temporal.

## Contributing to mlr3temporal

Please consult the [wiki](https://github.com/mlr-org/mlr3/wiki/) for a
[style guide](https://github.com/mlr-org/mlr3/wiki/Style-Guide), a
[roxygen guide](https://github.com/mlr-org/mlr3/wiki/Roxygen-Guide) and
a [pull request
guide](https://github.com/mlr-org/mlr3/wiki/PR-Guidelines).
