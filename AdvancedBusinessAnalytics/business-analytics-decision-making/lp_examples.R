# install.packages("lpSolve")

library(lpSolve)
library(tidyverse)
library(xlsx)

dtset <- read.xlsx("./AdvancedBusinessAnalytics/predictive-modeling-analytics/transportation_model.xlsx", 1)
dtset[4:10,2:7]


## lpSolve tutorial
## Set the coefficients of the decision variables
objective.in  <- c(25,  20)

## Create constraint martix
const.mat <- matrix(c(20,  12,  4,  4),  nrow=2, byrow=TRUE)

## define constraints
time_constraint <- (8*60)
resource_constraint <- 1800

## RHS for the constraints
const.rhs <- c(resource_constraint, time_constraint)

## Constraints direction
const.dir  <- c("<=",  "<=")

## Find the optimal solution
optimum <-  lp(direction="max",  objective.in, const.mat, const.dir,  const.rhs)
?lpSolve

#############


# Set up problem: maximize
# x1 + 9 x2 + x3 subject to
# x1 + 2 x2 + 3 x3 <= 9
# 3 x1 + 2 x2 + 2 x3 <= 15
#
f.obj <- c(1, 9, 1)
f.con <- matrix (c(1, 2, 3, 3, 2, 2), nrow=2, byrow=TRUE)
f.dir <- c("<=", "<=")
f.rhs <- c(9, 15)
#
# Now run.
#
lp ("max", f.obj, f.con, f.dir, f.rhs)
## Not run: Success: the objective function is 40.5
lp ("max", f.obj, f.con, f.dir, f.rhs)$solution
## Not run: [1] 0.0 4.5 0.0
#
# The same problem using the dense constraint approach:
#
f.con.d <- matrix (c(rep (1:2,each=3), rep (1:3, 2), t(f.con)), ncol=3)
lp ("max", f.obj, , f.dir, f.rhs, dense.const=f.con.d)
## Not run: Success: the objective function is 40.5

