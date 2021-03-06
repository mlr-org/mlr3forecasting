```
Feature Name: `Cross Validation`
Start Date: 2019-12-20
Target Date:
```


## Summary

Creating a cross validation technique for time series data for machine learning algorithms


## Motivation

In temporal data there is correlation among data, then a sophisticated method is needed to produce training and test data set. One method is that the test data sets contain only one observation and training sets consist observations which occur prior to the observation in the train sets. Then the forecasting is based on the averaging over the test sets and this method called rolling.


## Guide-level explanation

In the rolling method through the dataset, the train and test data look like the following:

        fold 1 : training [1], test [2]
        fold 2 : training [1 2], test [3]
        fold 3 : training [1 2 3], test [4]
        fold 4 : training [1 2 3 4], test [5]
        fold 5 : training [1 2 3 4 5], test [6]

And so on.
 

 

## Reference-level explanation

 The function would look the following:


```r
ResamplingCV = R6Class("ResamplingRoling", inherit = Resampling,


  public = list(

    initialize = function() {

      ps = ParamSet$new(list(

        ParamInt$new("folds", lower = 1L, tags = "required")

      ))

      ps$values = list(folds = 10L)




      super$initialize(id = "cv", param_set = ps, man = "mlr3::mlr_resamplings_Roling")

    }

  ),


  private = list(

    .sample = function(ids) {

      data.table(

        row_id = ids,

        fold = shuffle(seq_along0(ids) %% as.integer(self$param_set$values$folds) + 1L),

        key = "fold"

      )

    },



    .get_train = function(i) {

      self$instance[!list(i), "row_id", on = "fold"][[1L]]

    },


    .get_test = function(i) {

      self$instance[list(i), "row_id", on = "fold"][[1L]]

    },



    .combine = function(instances) {

      list(train = do.call(c, map(instances, "train")), test = do.call(c, map(instances, "test"))) })) 

    },


    deep_clone = function(name, value) {

      if (name == "instance") copy(value) else value

    }

  )

)
```



## Rationale, drawbacks and alternatives

How to produced the training and test data set correctly based on the rolling concept in the codes.

## Prior art
    • Caret library https://rpubs.com/crossxwill/time-series-cv
    • Sktime 
    • https://www.sciencedirect.com/science/article/pii/S0167947317302384 (paper)
    • Forecast and fpp library https://robjhyndman.com/hyndsight/tscv/
