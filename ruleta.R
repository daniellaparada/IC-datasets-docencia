numeros <- c(0,0:36)
tiros <- 100
ruleta <- sample(numeros, tiros, replace = TRUE)

criterio <- function(ruleta){
  n <- length(ruleta)
  s <- c()
  for (i in 1:n-1)
  {
    s[i] <- ifelse(abs(ruleta[i]%%10 - ruleta[i+1]%%10)==1,1,0)
  }
  return(s)
}

unos.index <- which(criterio(ruleta) == 1)

ceros.racha <- c()
for(i in 1:(length(unos.index)-1)){
  ceros.racha[i] <- (unos.index[i+1]-1)-unos.index[i]
}
ceros.racha

hist(ceros.racha)
mean(ceros.racha)

