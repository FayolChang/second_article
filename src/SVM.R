SVM = function(formula_string)
{
    require(e1071)
    fit_mysvm = tune(svm,as.formula(formula_string),
                     data = training,
                     scale = T,
                     type = "C-classification",
                     kernel = "radial",
                     ranges = list(gamma = 2^(-10:1), cost = 2^(-2:4)),
                     tunecontrol = tune.control(sampling = "boot"))
    pred_mysvm = predict(fit_mysvm$best.model,newdata = testing)
    confusionMatrix(pred_mysvm,testing$ST)
}