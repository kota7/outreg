
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Build Status](https://travis-ci.org/kota7/outreg.svg?branch=master)](https://travis-ci.org/kota7/outreg)

outreg
======

Create Regression Tables for Publication

|     | .variable   | .stat    | Model 1      | Model 2      | Model 3      |
|-----|:------------|:---------|:-------------|:-------------|:-------------|
| 1   | (Intercept) | Estimate | 37.885\*\*\* | 38.752\*\*\* | 34.496\*\*\* |
| 2   |             | Std Err  | \[2.074\]    | \[1.787\]    | \[7.441\]    |
| 5   | cyl         | Estimate | -2.876\*\*\* | -0.942\*     | -0.762       |
| 6   |             | Std Err  | \[0.322\]    | \[0.551\]    | \[0.635\]    |
| 9   | wt          | Estimate |              | -3.167\*\*\* | -2.973\*\*\* |
| 10  |             | Std Err  |              | \[0.741\]    | \[0.818\]    |
| 13  | hp          | Estimate |              | -0.018       | -0.021       |
| 14  |             | Std Err  |              | \[0.012\]    | \[0.013\]    |
| 17  | drat        | Estimate |              |              | 0.818        |
| 18  |             | Std Err  |              |              | \[1.387\]    |
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
#> 2               Std Err   [2.074]   [1.787]   [7.441]
#> 5          cyl Estimate -2.876***   -0.942*    -0.762
#> 6               Std Err   [0.322]   [0.551]   [0.635]
#> 9           wt Estimate           -3.167*** -2.973***
#> 10              Std Err             [0.741]   [0.818]
#> 13          hp Estimate              -0.018    -0.021
#> 14              Std Err             [0.012]   [0.013]
#> 17        drat Estimate                         0.818
#> 18              Std Err                       [1.387]
#> 21                    N        32        32        32
#> 22                   R2     0.726     0.843     0.845
#> 23               adj R2     0.717     0.826     0.822
#> 24                  AIC   169.306   155.477   157.067
```

Installation
------------

Install from the CRAN repository.

``` r
install.packages('outreg')
```

Or the recent version from the github repository.

``` r
devtools::install_github('kota7/outreg')
```

Examples
--------

### Basic usage

``` r
library(outreg)
fitlist <- list(lm(mpg ~ cyl, data = mtcars),
                lm(mpg ~ cyl + wt + hp, data = mtcars),
                lm(mpg ~ cyl + wt + hp + drat, data = mtcars))
outreg(fitlist)
#>      .variable    .stat   Model 1   Model 2   Model 3
#> 1  (Intercept) Estimate 37.885*** 38.752*** 34.496***
#> 2               Std Err   [2.074]   [1.787]   [7.441]
#> 5          cyl Estimate -2.876***   -0.942*    -0.762
#> 6               Std Err   [0.322]   [0.551]   [0.635]
#> 9           wt Estimate           -3.167*** -2.973***
#> 10              Std Err             [0.741]   [0.818]
#> 13          hp Estimate              -0.018    -0.021
#> 14              Std Err             [0.012]   [0.013]
#> 17        drat Estimate                         0.818
#> 18              Std Err                       [1.387]
#> 21                    N        32        32        32
#> 22                   R2     0.726     0.843     0.845
#> 23               adj R2     0.717     0.826     0.822
#> 24                  AIC   169.306   155.477   157.067
```

### Custom regression names

If regression list is named, the names are used as column names.

``` r
outreg(setNames(fitlist, c('small', 'medium', 'large')))
#>      .variable    .stat     small    medium     large
#> 1  (Intercept) Estimate 37.885*** 38.752*** 34.496***
#> 2               Std Err   [2.074]   [1.787]   [7.441]
#> 5          cyl Estimate -2.876***   -0.942*    -0.762
#> 6               Std Err   [0.322]   [0.551]   [0.635]
#> 9           wt Estimate           -3.167*** -2.973***
#> 10              Std Err             [0.741]   [0.818]
#> 13          hp Estimate              -0.018    -0.021
#> 14              Std Err             [0.012]   [0.013]
#> 17        drat Estimate                         0.818
#> 18              Std Err                       [1.387]
#> 21                    N        32        32        32
#> 22                   R2     0.726     0.843     0.845
#> 23               adj R2     0.717     0.826     0.822
#> 24                  AIC   169.306   155.477   157.067
```

### Custom stats and stars

You may choose statistics to display and which stats to put "stars" on, and significance level.

``` r
outreg(fitlist, pv = TRUE, se = FALSE, 
       starred = 'pv', alpha = c(0.05, 0.01, 0.001))
#>      .variable    .stat  Model 1  Model 2  Model 3
#> 1  (Intercept) Estimate   37.885   38.752   34.496
#> 4               p Value 0.000*** 0.000*** 0.000***
#> 5          cyl Estimate   -2.876   -0.942   -0.762
#> 8               p Value 0.000***    0.098    0.240
#> 9           wt Estimate            -3.167   -2.973
#> 12              p Value          0.000***  0.001**
#> 13          hp Estimate            -0.018   -0.021
#> 16              p Value             0.140    0.118
#> 17        drat Estimate                      0.818
#> 20              p Value                      0.560
#> 21                    N       32       32       32
#> 22                   R2    0.726    0.843    0.845
#> 23               adj R2    0.717    0.826    0.822
#> 24                  AIC  169.306  155.477  157.067
```

### Constant term at the bottom

``` r
outreg(fitlist, constlast = TRUE)
#>      .variable    .stat   Model 1   Model 2   Model 3
#> 1          cyl Estimate -2.876***   -0.942*    -0.762
#> 2               Std Err   [0.322]   [0.551]   [0.635]
#> 5           wt Estimate           -3.167*** -2.973***
#> 6               Std Err             [0.741]   [0.818]
#> 9           hp Estimate              -0.018    -0.021
#> 10              Std Err             [0.012]   [0.013]
#> 13        drat Estimate                         0.818
#> 14              Std Err                       [1.387]
#> 17 (Intercept) Estimate 37.885*** 38.752*** 34.496***
#> 18              Std Err   [2.074]   [1.787]   [7.441]
#> 21                    N        32        32        32
#> 22                   R2     0.726     0.843     0.845
#> 23               adj R2     0.717     0.826     0.822
#> 24                  AIC   169.306   155.477   157.067
```

### Heteroskedacity robust standard errors

``` r
outreg(fitlist, robust = TRUE)
#>      .variable    .stat   Model 1   Model 2   Model 3
#> 1  (Intercept) Estimate 37.885*** 38.752*** 34.496***
#> 2               Std Err   [2.528]   [2.017]   [6.085]
#> 5          cyl Estimate -2.876***   -0.942*    -0.762
#> 6               Std Err   [0.359]   [0.481]   [0.527]
#> 9           wt Estimate           -3.167*** -2.973***
#> 10              Std Err             [0.664]   [0.756]
#> 13          hp Estimate            -0.018**  -0.021**
#> 14              Std Err             [0.008]   [0.009]
#> 17        drat Estimate                         0.818
#> 18              Std Err                       [1.014]
#> 21                    N        32        32        32
#> 22                   R2     0.726     0.843     0.845
#> 23               adj R2     0.717     0.826     0.822
#> 24                  AIC   169.306   155.477   157.067
```

### Poisson regression

``` r
counts <- c(18,17,15,20,10,20,25,13,12)
outcome <- gl(3,1,9)
treatment <- gl(3,3)
fitlist2 <- list(glm(counts ~ outcome, family = poisson()),
                 glm(counts ~ outcome + treatment, family = poisson()))
outreg(fitlist2)
#>      .variable    .stat  Model 1  Model 2
#> 1  (Intercept) Estimate 3.045*** 3.045***
#> 2               Std Err  [0.126]  [0.171]
#> 6     outcome2 Estimate -0.454** -0.454**
#> 7               Std Err  [0.202]  [0.202]
#> 11    outcome3 Estimate   -0.293   -0.293
#> 12              Std Err  [0.193]  [0.193]
#> 16  treatment2 Estimate             0.000
#> 17              Std Err           [0.200]
#> 21  treatment3 Estimate             0.000
#> 22              Std Err           [0.200]
#> 26                    N        9        9
#> 27                  AIC   52.761   56.761
```

### Logistic regression

``` r
fitlist3 <- list(glm(cbind(ncases, ncontrols) ~ agegp,
                     data = esoph, family = binomial()),
                 glm(cbind(ncases, ncontrols) ~ agegp + tobgp + alcgp,
                     data = esoph, family = binomial()),
                 glm(cbind(ncases, ncontrols) ~ agegp + tobgp * alcgp,
                     data = esoph, family = binomial()))
outreg(fitlist3)
#>           .variable    .stat   Model 1   Model 2   Model 3
#> 1       (Intercept) Estimate -2.139*** -1.780*** -1.760***
#> 2                    Std Err   [0.189]   [0.198]   [0.198]
#> 6           agegp.L Estimate  2.882***  3.005***  2.996***
#> 7                    Std Err   [0.644]   [0.652]   [0.654]
#> 11          agegp.Q Estimate -1.629***  -1.338**  -1.350**
#> 12                   Std Err   [0.583]   [0.591]   [0.592]
#> 16          agegp.C Estimate     0.151     0.153     0.134
#> 17                   Std Err   [0.443]   [0.449]   [0.451]
#> 21          agegp^4 Estimate     0.218     0.064     0.071
#> 22                   Std Err   [0.302]   [0.309]   [0.310]
#> 26          agegp^5 Estimate    -0.178    -0.194    -0.213
#> 27                   Std Err   [0.189]   [0.195]   [0.196]
#> 31          tobgp.L Estimate            0.594***  0.638***
#> 32                   Std Err             [0.194]   [0.197]
#> 36          tobgp.Q Estimate               0.065     0.029
#> 37                   Std Err             [0.188]   [0.196]
#> 41          tobgp.C Estimate               0.157     0.156
#> 42                   Std Err             [0.187]   [0.198]
#> 46          alcgp.L Estimate            1.492***  1.371***
#> 47                   Std Err             [0.199]   [0.211]
#> 51          alcgp.Q Estimate              -0.227    -0.149
#> 52                   Std Err             [0.180]   [0.196]
#> 56          alcgp.C Estimate               0.255     0.228
#> 57                   Std Err             [0.159]   [0.182]
#> 61  tobgp.L:alcgp.L Estimate                       -0.704*
#> 62                   Std Err                       [0.411]
#> 66  tobgp.Q:alcgp.L Estimate                         0.122
#> 67                   Std Err                       [0.420]
#> 71  tobgp.C:alcgp.L Estimate                        -0.292
#> 72                   Std Err                       [0.429]
#> 76  tobgp.L:alcgp.Q Estimate                         0.129
#> 77                   Std Err                       [0.389]
#> 81  tobgp.Q:alcgp.Q Estimate                        -0.445
#> 82                   Std Err                       [0.392]
#> 86  tobgp.C:alcgp.Q Estimate                        -0.052
#> 87                   Std Err                       [0.395]
#> 91  tobgp.L:alcgp.C Estimate                        -0.161
#> 92                   Std Err                       [0.367]
#> 96  tobgp.Q:alcgp.C Estimate                         0.048
#> 97                   Std Err                       [0.362]
#> 101 tobgp.C:alcgp.C Estimate                        -0.139
#> 102                  Std Err                       [0.358]
#> 106                        N        88        88        88
#> 107                      AIC   298.593   225.454   236.964
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
#> 2                    Std Err   [0.429]   [0.424]
#> 6           ph.ecog Estimate -0.326*** -0.324***
#> 7                    Std Err   [0.086]   [0.086]
#> 11              age Estimate    -0.008    -0.006
#> 12                   Std Err   [0.007]   [0.007]
#> 16       Log(scale) Estimate -0.304***          
#> 17                   Std Err   [0.062]          
#> 21 Log(scale) sex=1 Estimate           -0.244***
#> 22                   Std Err             [0.079]
#> 26 Log(scale) sex=2 Estimate           -0.423***
#> 27                   Std Err             [0.107]
#> 31                         N       227       227
#> 32                       AIC  2284.215  2284.504
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
#> 2               Std Err  [2.060] [16.079]
#> 6          age Estimate            -0.129
#> 7               Std Err           [0.219]
#> 11       quant Estimate            -0.046
#> 12              Std Err           [0.058]
#> 16  Log(scale) Estimate 1.783*** 1.718***
#> 17              Std Err  [0.309]  [0.310]
#> 21                    N       20       20
#> 22                  AIC   62.984   65.880
```

### Mix of OLS and instrument variable regression

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
#> 2                          Std Err   [1.023]   [1.059]   [1.210]
#> 5   log(rprice)           Estimate -1.407*** -1.277***  -0.892**
#> 6                          Std Err   [0.251]   [0.263]   [0.397]
#> 9  log(rincome)           Estimate     0.344     0.280    -0.489
#> 10                         Std Err   [0.235]   [0.239]   [0.608]
#> 13                               N        48        48        48
#> 14                              R2     0.433     0.429     0.274
#> 15                          adj R2     0.408     0.404     0.241
#> 16                             AIC   -19.680                    
#> 17                 Wu-Hasuman stat               3.068     3.553
#> 18                    WuHausman_pv               0.087     0.037
#> 19                     Sargan stat               0.333     0.076
#> 20                       Sargan_pv               0.564     0.783
#> 21  log(rprice)    Weak instr stat             244.734   195.613
#> 22              Weak instr p-value               0.000     0.000
#> 23 log(rincome)    Weak instr stat                         7.767
#> 24              Weak instr p-value                         0.000
```
