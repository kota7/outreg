
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Build Status](https://travis-ci.org/kota7/outreg.svg?branch=master)](https://travis-ci.org/kota7/outreg)

outreg
======

Create Regression Tables for Publication

|     | .variable   | .stat    | Model 1      | Model 2      | Model 3      |
|-----|:------------|:---------|:-------------|:-------------|:-------------|
| 1   | (Intercept) | Estimate | 37.885\*\*\* | 38.752\*\*\* | 34.496\*\*\* |
| 2   | (Intercept) | Std Err  | \[2.074\]    | \[1.787\]    | \[7.441\]    |
| 5   | cyl         | Estimate | -2.876\*\*\* | -0.942\*     | -0.762       |
| 6   | cyl         | Std Err  | \[0.322\]    | \[0.551\]    | \[0.635\]    |
| 9   | wt          | Estimate |              | -3.167\*\*\* | -2.973\*\*\* |
| 10  | wt          | Std Err  |              | \[0.741\]    | \[0.818\]    |
| 13  | hp          | Estimate |              | -0.018       | -0.021       |
| 14  | hp          | Std Err  |              | \[0.012\]    | \[0.013\]    |
| 17  | drat        | Estimate |              |              | 0.818        |
| 18  | drat        | Std Err  |              |              | \[1.387\]    |
| 21  |             | N        | 32           | 32           | 32           |
| 22  |             | R2       | 0.726        | 0.843        | 0.845        |
| 23  |             | adj R2   | 0.717        | 0.826        | 0.822        |
| 24  |             | AIC      | 169.306      | 155.477      | 157.067      |

Overview
--------

`outreg` summarizes regression outcomes into a coefficient table in `data.frame` format. Currently, `outreg` supports the following model fit objects:

-   `lm` : linear regression
-   `glm` : logistic regression, poisson regression, etc
-   `survreg` : survival regression, tobit regression, etc
-   `ivreg` : instrument variable regression

Usage
-----

`outreg` takes a list of model fit objects as the main input, and returns a `data.frame` object where a model is represented in a column.

``` r
library(outreg)
fitlist <- list(lm(mpg ~ cyl, data = mtcars),
                lm(mpg ~ cyl + wt + hp, data = mtcars),
                lm(mpg ~ cyl + wt + hp + drat, data = mtcars))
outreg(fitlist)
#>      .variable    .stat   Model 1   Model 2   Model 3
#> 1  (Intercept) Estimate 37.885*** 38.752*** 34.496***
#> 2  (Intercept)  Std Err   [2.074]   [1.787]   [7.441]
#> 5          cyl Estimate -2.876***   -0.942*    -0.762
#> 6          cyl  Std Err   [0.322]   [0.551]   [0.635]
#> 9           wt Estimate           -3.167*** -2.973***
#> 10          wt  Std Err             [0.741]   [0.818]
#> 13          hp Estimate              -0.018    -0.021
#> 14          hp  Std Err             [0.012]   [0.013]
#> 17        drat Estimate                         0.818
#> 18        drat  Std Err                       [1.387]
#> 21                    N        32        32        32
#> 22                   R2     0.726     0.843     0.845
#> 23               adj R2     0.717     0.826     0.822
#> 24                  AIC   169.306   155.477   157.067
```

Installation
------------

This package is not on CRAN (yet). Please install by from the github repository.

``` r
devtools::install_github('kota7/outreg')
```

Examples
--------

### Basic usage.

``` r
library(outreg)
fitlist <- list(lm(mpg ~ cyl, data = mtcars),
                lm(mpg ~ cyl + wt + hp, data = mtcars),
                lm(mpg ~ cyl + wt + hp + drat, data = mtcars))
outreg(fitlist)
#>      .variable    .stat   Model 1   Model 2   Model 3
#> 1  (Intercept) Estimate 37.885*** 38.752*** 34.496***
#> 2  (Intercept)  Std Err   [2.074]   [1.787]   [7.441]
#> 5          cyl Estimate -2.876***   -0.942*    -0.762
#> 6          cyl  Std Err   [0.322]   [0.551]   [0.635]
#> 9           wt Estimate           -3.167*** -2.973***
#> 10          wt  Std Err             [0.741]   [0.818]
#> 13          hp Estimate              -0.018    -0.021
#> 14          hp  Std Err             [0.012]   [0.013]
#> 17        drat Estimate                         0.818
#> 18        drat  Std Err                       [1.387]
#> 21                    N        32        32        32
#> 22                   R2     0.726     0.843     0.845
#> 23               adj R2     0.717     0.826     0.822
#> 24                  AIC   169.306   155.477   157.067
```

### If regression list is named, the names are used as column names.

``` r
outreg(setNames(fitlist, c('small', 'medium', 'large')))
#>      .variable    .stat     small    medium     large
#> 1  (Intercept) Estimate 37.885*** 38.752*** 34.496***
#> 2  (Intercept)  Std Err   [2.074]   [1.787]   [7.441]
#> 5          cyl Estimate -2.876***   -0.942*    -0.762
#> 6          cyl  Std Err   [0.322]   [0.551]   [0.635]
#> 9           wt Estimate           -3.167*** -2.973***
#> 10          wt  Std Err             [0.741]   [0.818]
#> 13          hp Estimate              -0.018    -0.021
#> 14          hp  Std Err             [0.012]   [0.013]
#> 17        drat Estimate                         0.818
#> 18        drat  Std Err                       [1.387]
#> 21                    N        32        32        32
#> 22                   R2     0.726     0.843     0.845
#> 23               adj R2     0.717     0.826     0.822
#> 24                  AIC   169.306   155.477   157.067
```

### May choose statistics to display and which stats to put "stars" on.

``` r
outreg(fitlist, pv = TRUE, se = FALSE, starred = 'pv')
#>      .variable    .stat  Model 1  Model 2  Model 3
#> 1  (Intercept) Estimate   37.885   38.752   34.496
#> 4  (Intercept)  p Value 0.000*** 0.000*** 0.000***
#> 5          cyl Estimate   -2.876   -0.942   -0.762
#> 8          cyl  p Value 0.000***   0.098*    0.240
#> 9           wt Estimate            -3.167   -2.973
#> 12          wt  p Value          0.000*** 0.001***
#> 13          hp Estimate            -0.018   -0.021
#> 16          hp  p Value             0.140    0.118
#> 17        drat Estimate                      0.818
#> 20        drat  p Value                      0.560
#> 21                    N       32       32       32
#> 22                   R2    0.726    0.843    0.845
#> 23               adj R2    0.717    0.826    0.822
#> 24                  AIC  169.306  155.477  157.067
```

### Poisson regression.

``` r
counts <- c(18,17,15,20,10,20,25,13,12)
outcome <- gl(3,1,9)
treatment <- gl(3,3)
fitlist2 <- list(glm(counts ~ outcome, family = poisson()),
                 glm(counts ~ outcome + treatment, family = poisson()))
outreg(fitlist2)
#>      .variable    .stat  Model 1  Model 2
#> 1  (Intercept) Estimate 3.045*** 3.045***
#> 2  (Intercept)  Std Err  [0.126]  [0.171]
#> 5     outcome2 Estimate -0.454** -0.454**
#> 6     outcome2  Std Err  [0.202]  [0.202]
#> 9     outcome3 Estimate   -0.293   -0.293
#> 10    outcome3  Std Err  [0.193]  [0.193]
#> 13  treatment2 Estimate             0.000
#> 14  treatment2  Std Err           [0.200]
#> 17  treatment3 Estimate            -0.000
#> 18  treatment3  Std Err           [0.200]
#> 21                    N        9        9
#> 22                  AIC   52.761   56.761
```

### Logistic regression.

``` r
fitlist3 <- list(glm(cbind(ncases, ncontrols) ~ agegp,
                     data = esoph, family = binomial()),
                 glm(cbind(ncases, ncontrols) ~ agegp + tobgp + alcgp,
                     data = esoph, family = binomial()),
                 glm(cbind(ncases, ncontrols) ~ agegp + tobgp * alcgp,
                     data = esoph, family = binomial()))
outreg(fitlist3)
#>          .variable    .stat   Model 1   Model 2   Model 3
#> 1      (Intercept) Estimate -2.139*** -1.780*** -1.760***
#> 2      (Intercept)  Std Err   [0.189]   [0.198]   [0.198]
#> 5          agegp.L Estimate  2.882***  3.005***  2.996***
#> 6          agegp.L  Std Err   [0.644]   [0.652]   [0.654]
#> 9          agegp.Q Estimate -1.629***  -1.338**  -1.350**
#> 10         agegp.Q  Std Err   [0.583]   [0.591]   [0.592]
#> 13         agegp.C Estimate     0.151     0.153     0.134
#> 14         agegp.C  Std Err   [0.443]   [0.449]   [0.451]
#> 17         agegp^4 Estimate     0.218     0.064     0.071
#> 18         agegp^4  Std Err   [0.302]   [0.309]   [0.310]
#> 21         agegp^5 Estimate    -0.178    -0.194    -0.213
#> 22         agegp^5  Std Err   [0.189]   [0.195]   [0.196]
#> 25         tobgp.L Estimate            0.594***  0.638***
#> 26         tobgp.L  Std Err             [0.194]   [0.197]
#> 29         tobgp.Q Estimate               0.065     0.029
#> 30         tobgp.Q  Std Err             [0.188]   [0.196]
#> 33         tobgp.C Estimate               0.157     0.156
#> 34         tobgp.C  Std Err             [0.187]   [0.198]
#> 37         alcgp.L Estimate            1.492***  1.371***
#> 38         alcgp.L  Std Err             [0.199]   [0.211]
#> 41         alcgp.Q Estimate              -0.227    -0.149
#> 42         alcgp.Q  Std Err             [0.180]   [0.196]
#> 45         alcgp.C Estimate               0.255     0.228
#> 46         alcgp.C  Std Err             [0.159]   [0.182]
#> 49 tobgp.L:alcgp.L Estimate                       -0.704*
#> 50 tobgp.L:alcgp.L  Std Err                       [0.411]
#> 53 tobgp.Q:alcgp.L Estimate                         0.122
#> 54 tobgp.Q:alcgp.L  Std Err                       [0.420]
#> 57 tobgp.C:alcgp.L Estimate                        -0.292
#> 58 tobgp.C:alcgp.L  Std Err                       [0.429]
#> 61 tobgp.L:alcgp.Q Estimate                         0.129
#> 62 tobgp.L:alcgp.Q  Std Err                       [0.389]
#> 65 tobgp.Q:alcgp.Q Estimate                        -0.445
#> 66 tobgp.Q:alcgp.Q  Std Err                       [0.392]
#> 69 tobgp.C:alcgp.Q Estimate                        -0.052
#> 70 tobgp.C:alcgp.Q  Std Err                       [0.395]
#> 73 tobgp.L:alcgp.C Estimate                        -0.161
#> 74 tobgp.L:alcgp.C  Std Err                       [0.367]
#> 77 tobgp.Q:alcgp.C Estimate                         0.048
#> 78 tobgp.Q:alcgp.C  Std Err                       [0.362]
#> 81 tobgp.C:alcgp.C Estimate                        -0.139
#> 82 tobgp.C:alcgp.C  Std Err                       [0.358]
#> 85                        N        88        88        88
#> 86                      AIC   298.593   225.454   236.964
```

### Survival regression

``` r
library(survival)
fitlist4 <- list(survreg(Surv(time, status) ~ ph.ecog + age,
                         data = lung),
                 survreg(Surv(time, status) ~ ph.ecog + age + strata(sex),
                         data = lung))
outreg(fitlist4)
#>           .variable    .stat   Model 1   Model 2
#> 1       (Intercept) Estimate  6.831***  6.732***
#> 2       (Intercept)  Std Err   [0.429]   [0.424]
#> 5           ph.ecog Estimate -0.326*** -0.324***
#> 6           ph.ecog  Std Err   [0.086]   [0.086]
#> 9               age Estimate    -0.008    -0.006
#> 10              age  Std Err   [0.007]   [0.007]
#> 13       Log(scale) Estimate -0.304***          
#> 14       Log(scale)  Std Err   [0.062]          
#> 17 Log(scale) sex=1 Estimate           -0.244***
#> 18 Log(scale) sex=1  Std Err             [0.079]
#> 21 Log(scale) sex=2 Estimate           -0.423***
#> 22 Log(scale) sex=2  Std Err             [0.107]
#> 25                         N       227       227
#> 26                       AIC  2284.215  2284.504
```

### Tobit regression

``` r
fitlist5 <- list(survreg(Surv(durable, durable>0, type='left') ~ 1,
                 data=tobin, dist='gaussian'),
                 survreg(Surv(durable, durable>0, type='left') ~ age + quant,
                 data=tobin, dist='gaussian'))
outreg(fitlist5)
#>      .variable    .stat  Model 1  Model 2
#> 1  (Intercept) Estimate   -2.227   15.145
#> 2  (Intercept)  Std Err  [2.060] [16.079]
#> 5          age Estimate            -0.129
#> 6          age  Std Err           [0.219]
#> 9        quant Estimate            -0.046
#> 10       quant  Std Err           [0.058]
#> 13  Log(scale) Estimate 1.783*** 1.718***
#> 14  Log(scale)  Std Err  [0.309]  [0.310]
#> 17                    N       20       20
#> 18                  AIC   62.984   65.880
```

### Combine instrument variable regression and linear regression.

``` r
library(AER)
data("CigarettesSW", package = "AER")
CigarettesSW$rprice <- with(CigarettesSW, price/cpi)
CigarettesSW$rincome <- with(CigarettesSW, income/population/cpi)
CigarettesSW$tdiff <- with(CigarettesSW, (taxs - tax)/cpi)

fitlist6 <- list(OLS = lm(log(packs) ~ log(rprice) + log(rincome),
                          data = CigarettesSW, subset = year == "1995"),
                 IV1 = ivreg(log(packs) ~ log(rprice) + log(rincome) |
                             log(rincome) + tdiff + I(tax/cpi),
                             data = CigarettesSW, subset = year == "1995"),
                 IV2 = ivreg(log(packs) ~ log(rprice) + log(rincome) |
                             log(population) + tdiff + I(tax/cpi),
                             data = CigarettesSW, subset = year == "1995"))
outreg(fitlist6)
#>       .variable              .stat       OLS       IV1       IV2
#> 1   (Intercept)           Estimate 10.342***  9.895*** 10.116***
#> 2   (Intercept)            Std Err   [1.023]   [1.059]   [1.210]
#> 5   log(rprice)           Estimate -1.407*** -1.277***  -0.892**
#> 6   log(rprice)            Std Err   [0.251]   [0.263]   [0.397]
#> 9  log(rincome)           Estimate     0.344     0.280    -0.489
#> 10 log(rincome)            Std Err   [0.235]   [0.239]   [0.608]
#> 13                               N        48        48        48
#> 14                              R2     0.433     0.429     0.274
#> 15                          adj R2     0.408     0.404     0.241
#> 16                             AIC   -19.680        NA        NA
#> 17                 Wu-Hausman stat        NA     3.068     3.553
#> 18              Wu-Hausman p-value        NA     0.087     0.037
#> 19                     Sargan stat        NA     0.333     0.076
#> 20                  Sargan p-value        NA     0.564     0.783
#> 21  log(rprice)    Weak instr stat             244.734   195.613
#> 22  log(rprice) Weak instr p-value               0.000     0.000
#> 23 log(rincome)    Weak instr stat                         7.767
#> 24 log(rincome) Weak instr p-value                         0.000
```
