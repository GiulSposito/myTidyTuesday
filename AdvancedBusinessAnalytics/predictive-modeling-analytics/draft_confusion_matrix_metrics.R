
cancel_prob <- function(lag, gender){
  ev <- exp(-1.6515 + .01699*lag - 0.3572 *gender)
  return(ev/(1+ev))
}

cancel_prob(10,1)

cancel_prob(10,0) - cancel_prob(10,1) / cancel_prob(10,1)

150 * .6

cost <- 200 * 1
benefit <- (150*.6) * 50
profit <- benefit - cost
profit

precision <- function(TP, FP){
  TP/(TP+FP)
}

precision(18, 34)

accuracy <- function(TN, TP, FN, FP){
  Total <- TN + TP + FN + FP
  (TN+TP)/Total
} 

accuracy(54,18,9,34)
