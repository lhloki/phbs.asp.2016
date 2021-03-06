#-------------------implied volatility----------------

CalcBsmImpvol <- function(
  type = 'call', price, spot, forward = spot*exp((r-div)*t.exp),
  strike = forward, t.exp = 1, r = 0, div = 0
){
    #-------------------------------------------------
    #-------------------------------------------------
    #Inputs: type the same as in function optionprice
    #        price: the observed option price
    #Return: implied volatility
    #-------------------------------------------------
    #-------------------------------------------------

    price.forward = price * exp( r*t.exp)
    
    n.price = length(price.forward)
    n.strike = length(strike)
  
    vol <- rep(NA, n.price )

    if( length(strike) > 1L ) {
      stopifnot(n.price == n.strike )
      strike.vec <- strike
    } else {
      strike.vec <- rep( strike, n.price )
    }

    for(k in 1:n.price) {
      sub <- function(sigma){
        f <- CalcBsmPrice( 
          type = type, forward = forward, strike = strike.vec[k], t.exp = t.exp, sigma = sigma
        )[1] - price.forward[k]
        return(f)
      }
      vol[k] <- uniroot(f = sub,interval = c(0,10), tol = .Machine$double.eps * 1e4)$root
    }
    return(vol)
}