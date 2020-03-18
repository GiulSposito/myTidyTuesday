library(lpSolve)


costs <- c(3,7,4,4,9,8,3,9,7,4,5,9,5,8,3,8,9,7,7,6)
# cost_matrix <- matrix(costs, byrow = T, nrow = 5)

constr <- c(
  1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # <= 60
  0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0, # <= 50
  0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0, # <= 70
  0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0, # <= 40
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1, # <= 20
  1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0, # >= 75
  0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0, # >= 25
  0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0, # >= 35
  0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1  # >= 65
)

constr.mtx <- matrix(constr, nrow = 9, byrow = T)
constr.dir <- c(rep("<=",5),rep(">=",4))
constr.rhs <- c(60,50,70,40,20,75,25,35,65)

#solving LP model
prod.trans <- lp ("min", costs, constr.mtx, constr.dir, constr.rhs, compute.sens = TRUE )

matrix(prod.trans$solution, nrow=5, byrow = T)

?lp


# obj.fun <- c(8 , 6 , 3 , 2 , 4 , 9)
m <- 2
n <- 3
constr <- matrix (0 , n +m , n*m )
for ( i in 1: m ) {
  for ( j in 1: n ) {
    constr [ i , n*(i-1)+j   ] <- 1
    constr [ m+j , n*(i-1)+j ] <- 1
  }
}
# constr.dir <- c(rep("<=", m ) , rep(">=", n ) )
# rhs <- c(70 , 40 , 40 , 35 , 25)
# 
# #solving LP model
# prod.trans <- lp ("min", obj.fun , constr, constr.dir, rhs, compute.sens = TRUE )
# 
# prod.trans$sens.coef.to
