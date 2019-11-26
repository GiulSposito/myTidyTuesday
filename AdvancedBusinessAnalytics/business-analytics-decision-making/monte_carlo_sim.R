
# parameters
avg.demand         <- 150
tkt.show_up        <- .92
capacity           <- 134
ticket_price       <- 314
transfer_fee_price <- 60
cost_per_bumped    <- 400

# modelo
overbook_limit <- 13

actual_demand  <- 154
actual_demand  <- rpois(1000, avg.demand)

booking_capacity <- capacity + overbook_limit 
booked <- sapply(actual_demand, min, booking_capacity)

read_to_board  <- round(booked*tkt.show_up)
read_to_board  <- rbinom(1000, booked, tkt.show_up)

no_show <- booked-read_to_board

boarding_the_flight <- sapply(read_to_board, min, capacity)
bumped_to_a_later_flight <- read_to_board - boarding_the_flight

revenue_from_tickets <- booked * ticket_price
revenue_from_no_show <- no_show*transfer_fee_price
overbook_cost        <- bumped_to_a_later_flight*cost_per_bumped

net_revenue <- revenue_from_tickets+revenue_from_no_show-overbook_cost

hist(actual_demand, breaks=30, col = "red")
hist(booked, breaks = 30, col="red")
hist(net_revenue, breaks=30, col = "red")

