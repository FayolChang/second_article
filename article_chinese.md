---
title: "考虑DEA效率的上市公司财务困境预测"
author: "段永瑞"
date: "09/26/2014"
output: 
    pdf_document:
        keep_tex: true
        includes:
            in_header:mystyles.sty

---

## 引言

## 文献综述

### 数据包络分析
1978年Charnes, Cooper 和 Rhodes 提出了数据包络分析方法(DEA)。由于该方法具有很多优势，例如，评价结果与量纲无关;其研究对象可以是多投入多产出的过程;不要求明确的生产函数等，DEA在各领域得到了广泛的应用。最初提出的是CCR模型，该模型要求投入产出均为正数，但是在现实生活中，产出可能是负数，例如利润。本文介绍一种修改过的SBM来解决此问题（Tone 2004，Düzakin,E.,Düzakin,Hatice,2007）。
SBM是Tone 2001提出的一种基于松弛变量来量度效率的方法，模型如下：

$$

    \begin{align}
    \min & \rho=\frac{1-(1/m)\sum_{i=1}^{m}s_{i}^{-}/x_{io}}{1+(1/s)\sum_{r=1}^{s}s_{r}^{+}/y_{ro}}\\
    \textrm{s.t.} & \mathbf{x_{o}}=\mathbf{X\lambda}+\mathbf{s^{-}}\\
     & \mathbf{y_{o}}=\mathbf{Y\lambda}+\mathbf{s^{+}}\\
     & \mathbf{\lambda}\geq\mathbf{0},\mathbf{s^{-}}\geq\mathbf{0},\mathbf{s^{+}}\geq\mathbf{0}
    \end{align}
    
$$

### 随机森林

### 支持向量机

### 朴素贝叶斯

## 结果讨论

### 变量选择

#### DEA效率变量选择

#### 预测数据变量选择

### 
