---
title: "Hybrid of DEA and Randomforest to predict shangshigongsi cai wu  kun jing"
author: "Yongrui Duan, Fayou Zhang"
date: "09/26/2014"
output:
  pdf_document:
    keep_tex: yes
    latex_engine: xelatex
    number_sections: yes
---


## Abstract

## introduction

Business failure prediction is crutial for investors, stock holders, managers, employees and government officials, and thus has been an hot topic in academic studies. 

Many technical methods have been applied to predict business failure. Amoung which are XX categories: XX, XX, XX, and XX.
XX(author) made an thorough review on XX. 

## Literature Review

### Data Envelopment Aanaysis(DEA)

DEA is a nonparametric method proposed by Charnes, Cooper and Rhodes in 1978. it has been applied to many fileds Because of its many advantages: it does not require any assumptions to be made about the distribution of inefficiency and it does not require a particular functional
form on the data in determining the froniter. it is capable of being used with any input-output measurement, and capable of handling multiple inputs and outputs. The CCR model requires inputs and outputs to be positive, which may be not applied in real life. for example, profits as an output may be negative. In this paper, we will introduce a modified SBM model (Tone 2004，Düzakin,E.,Düzakin,Hatice,2007) to tackle this problem. The SBM model is as follows:




$$
    \begin{aligned}
    \min & \rho=\frac{1-(1/m)\sum_{i=1}^{m}s_{i}^{-}/x_{io}}{1+(1/s)\sum_{r=1}^{s}s_{r}^{+}/y_{ro}}\\
    \textrm{s.t.} & \mathbf{x_{o}}=\mathbf{X\lambda}+\mathbf{s^{-}}\\
     & \mathbf{y_{o}}=\mathbf{Y\lambda}+\mathbf{s^{+}}\\
     & \mathbf{\lambda}\geq\mathbf{0},\mathbf{s^{-}}\geq\mathbf{0},\mathbf{s^{+}}\geq\mathbf{0}
    \end{aligned}
$$

However, this model can not handle negative output.（Tone 2004，Düzakin,E.,Düzakin,Hatice,2007）proposed an solution to this problem. Assuming $y_{ro}<0$, following transformations were applied:

$$
\begin{aligned}
\overline{y}_{r}^{+} & =\textrm{Max}_{j=1,2,...n.}\{y_{rj}|y_{rj}>0\}\\
\underline{y}_{r}^{-} & =\textrm{Min}_{j=1,2,...n.}\{y_{rj}|y_{rj}>0\}
\end{aligned}
$$

The term $s_r^+/y_{ro}$ in the objective function as replaced as follows：if $y_{ro}<0$ ,and $\overline{y}_{r}^{+}>\underline{y}_{r}^{+}$,then it will be replaced with

$$
s_r^{+}/\frac{\underline{y}_{r}^{+}(\overline{y}_{r}^{+}-\underline{y}_{r}^{+})}{\overline{y}_{r}^{+}-y_{ro}}
$$

Note that the term $y_{ro}$ are not replaced in the constraint. 

After transformation, all negaitve output were transformed to be positive and strictly less than $\underline{y}_{r}^{+}$ . and the more negative an output is,  the less its tranformation value.


### Random Forest

Random forest, developed by Leo Breiman(1) and Adele Cutler(2), is an ensemble learning method for classification and regression that operate by constructing a multitude of decision trees. For a given training dataset, $A = {(X_1,y_1),(X_2,y_2),\cdots,(X_n,y_n)}$,Where $X_i = 1,2,\cdots,n$, is a variable or vector and $y_i$ is its corresponding property or class label; the basic RF algorithm is presented as follows:

#### Bootstrap sample. 

Each training set is drawn with replacement from the original
dataset A. Bootstrapping allows replacement, so that some of the samples will be repeated
in the sample, while others will be “left out” of the sample. The “left out” samples
constitute the “Out-of bag (OOB)” which has, for example, one-third, of samples in A which are used later to get a running unbiased estimate of the classification error as trees
are added to the forest and variable imp ortance


#### Growing trees.

For each bootstrap sample, a tree is grown m variables $(m_{try})$ are
selected at random from all n variables $(m_{try} \leq n)$ and the best split of all $(m_{try})$ is used at
each node. Each tree is grown to the largest extent (until no further splitting is possible)
and no pruning of the trees occurs.

#### OOB error estimate. 

Each tree is constructed on the bootstrap sample. The OOB
samples are not used and therefore regarded as a test set to provide an unbiased estimate
of the prediction accuracy. Each OOB sample is put down the constructed trees to get
a classification. A test set classification is formed. At the end of the run, take k to be
the class which got most of the “votes” every time sample n was OOB. The proportion of
times that k is not the true class of n averaged over all samples is the OOB error estimate.

### SVM

Support vector machines(SVM) is the theory based on statistical learning theory. It realizes the theory of VC dimension and principle of structural risk minimum(SRM). The idea of SVM is to search an optimal hyper-plane :TODO:

Suppose we are given a set of training data $xi \in R^n(i=1,2,…,n)$ with the desired output $yi∈{+1,-1}$ corresponding to the two classes. And suppose the dataset is linear seperable. So there exists a separating hyper plane with the target functions w·xi+b=0 (w represents the weight vector and b represents the bias). To ensure that all training data can be classified, we must make the margin of separation $(2/‖w‖)$ maximum. Then, in the case of linear separation, the linear SVM for optimal separating hyper plane has the following optimization problem.

$$

$$


## Results and Discussion


### The data

Our aim is to predict whether a company would experience financial failure in two years after based on the financial statement data of current year. The data are from XXXX. We collected data from 2008 to 2013 but only use  2008-2010 for prediction.  for example, we obtain data of a company in its 2010 financial statement and this company was classifed as special treatment(ST*) in 2013 for the first time. we pair the data in 2010 and the label ST in 2013 together to build our model. Once the model was built, we can predict wether a specific company will be classified as special treatment two years after.

### procedure
First, we calculate DEA efficiency of the corperations in each year,an d use the efficiency as a feature.  Second, we caluclate viarable importance through random forests. third, we build our models using the 3,5,10 most important variables. When building our models, we randmonly select 200 nonST corperatons and resample ST corperations to 200 to make two class balance. forth, we randomly divide the 400 sample into training set and testing set.
fifth, we use the training set to train different models. sixth, we compared these models.

### results

The results shows that efficiency is an relatively important factor in predicting ST










```
## 
## Recursive feature selection
## 
## Outer resampling method: Bootstrapped (25 reps) 
## 
## Resampling performance over subset size:
## 
##  Variables Accuracy Kappa AccuracySD KappaSD Selected
##          2    0.962 0.924    0.01074  0.0214         
##          3    0.965 0.930    0.00761  0.0152         
##          4    0.960 0.920    0.01056  0.0210         
##          5    0.963 0.925    0.01088  0.0217         
##          6    0.964 0.928    0.01168  0.0233         
##          7    0.966 0.932    0.00996  0.0199         
##          8    0.968 0.937    0.01052  0.0210         
##          9    0.967 0.935    0.01022  0.0204         
##         10    0.969 0.939    0.00964  0.0193         
##         11    0.970 0.939    0.01008  0.0201         
##         12    0.970 0.941    0.00960  0.0192         
##         13    0.970 0.940    0.00955  0.0191         
##         14    0.970 0.941    0.01049  0.0209         
##         15    0.971 0.942    0.00974  0.0194         
##         16    0.970 0.941    0.00951  0.0190         
##         17    0.971 0.943    0.00905  0.0181         
##         18    0.971 0.941    0.01007  0.0201         
##         19    0.972 0.943    0.00937  0.0187         
##         20    0.972 0.944    0.00944  0.0188         
##         21    0.972 0.945    0.00988  0.0197         
##         22    0.974 0.947    0.00957  0.0191         
##         23    0.974 0.948    0.00975  0.0195         
##         24    0.975 0.951    0.00839  0.0167         
##         25    0.975 0.951    0.00747  0.0149         
##         26    0.975 0.951    0.00767  0.0153         
##         27    0.976 0.952    0.00754  0.0151        *
## 
## The top 5 variables (out of 27):
##    T60800, T70600, T40402, T10300, T80403
```


It is shown that every variable do contribute to the predition accuracy, and DEA efficiency rank the 6th. for simplicity, we choose the first 3, 5, 10 most important variables, explore the difference of accuracy using a variaty of machine learning methods. 

















