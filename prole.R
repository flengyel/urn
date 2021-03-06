# Bourgesois/Proletariat population urn model in R
# (c) 2010-2012 Florian Lengyel. 
# This code is released under the GNU General Public License, version 2

library(reshape)
library(plyr)
library(ggplot2)
library(scales)
options(error=utils::recover)

# prole.sim(n,births,proles,bourgeois,r)
# n - number of iterations
# births - number of prole population offspring
# proles - initial proletariat population
# bourgeois - initial bourgeois population
# r - proportion of proletariat population that becomes bourgeois
# returns a data frame with the time t=1,...,n and the value
# of prole and bourgeois at time t
#
# evolutionary urn model of two populations of sizes proles and bourgeois
# in uniformly random paired encounters {x, y} in a total population of 
# size proles+bourgeois.
# Case 1: a prole-prole pairing increases proles by births
# Case 2: a prole-bourgeois pairing converts 100*r% proles to bourgeois
# Case 3: a bourgeois-bourgeois kills one of the bourgeois and converts 
# the other to a prole 

prole.cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", 
                   "#F0E442", "#0072B2", "#D55E00", "#CC79A7");

prole.cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", 
                   "#F0E442", "#0072B2", "#D55E00", "#CC79A7");

prole.sim<-function(n,births,proles,bourgeois,r)
{
    XVec <- array(0, c(n));
    YMat <- array(0, c(n,2));
    YMat[1,] <- c(proles,bourgeois);

    if ( r <= 0 || r >= 1)
    {
	   print("Transfer rate r must be between 0 and 1");
	   return(data.frame()); # return empty data frame
    }

    for ( k in 1:n )
    {  # sample 2 without replacement from total population
       x<-sample(1:proles+bourgeois,2); 

       if ((x[1] <= proles) && (x[2] <= proles))
       { # proles/proles encounter
	       proles <-  proles+births; 
       }
       else if ((proles+1 <= x[1]) && (proles+1 <= x[2]))
       { # Bourgeois/Bourgeois encounter
     	   bourgeois <- bourgeois-2;  # one dies and the other is declasse
           proles <- proles+1;
       } else
       { # Bourgeois/proles encounter
           bourgeois <- bourgeois+floor(r*proles);
           proles <- proles-floor(r*proles);
       }
    
       # update the new populations

       XVec[k]  <- k; 
       YMat[k,] <- c(proles,bourgeois); 
       
    } # for

    # Time is XVec
    Proletariat <-YMat[,1]
    Bourgeois <- YMat[,2]
    df <- data.frame(XVec,Proletariat,Bourgeois);
}

# Display the data frame produced by prole.sim
prole.plot<-function(df)
{
    bmin <- min(df$Bourgeois);
    xmean <- mean(df$XVec);
    XVec <- df$XVec

    ggplot(df,aes(XVec)) + xlab("time") + 
      opts(legend.background=theme_rect()) +
      geom_line(aes(y=Proletariat, colour="Proletariat")) + 
      geom_line(aes(y=Bourgeois, colour="Bourgeois")) +
      geom_hline(yintercept=bmin, colour="blue",alpha=0.5) +
 #     scale_y_continuous(limits=c(0,max(df$Proletariat,df$Bourgeois)), breaks=c(bmin)) +
      annotate("text",x=xmean,bmin-1, label=paste("min(Bourgeois) =",bmin),colour="blue",size=3) +
      opts(title="Bourgeois-Proletariat Predator-Prey Simulation") +
      scale_color_manual("Legend",
                          breaks=c("Proletariat", "Bourgeois"),
                          values=prole.cbbPalette) +
		ylab("population");
} # prole.plot

prole.boxplot<-function(df)
{
  ggplot(data=melt(subset(df,select=-c(1))), 
         aes(variable,value,fill=variable)) +
  xlab("class") + ylab("population")  +
  guides(fill=FALSE) + 
  geom_boxplot(); 
}


prole.density<-function(df)
{
  mdf <- melt(subset(df,select=-c(1)),
              variable="Class",
              value.name="population");
  cdf <- ddply(mdf, .(Class), summarise, population.mean=mean(value));
  ggplot(data=mdf, aes(x=value,fill=Class)) +
  geom_vline(data=cdf, aes(xintercept=population.mean,color=Class),
           linetype="dashed",size=1) +
  xlab("population") +
  geom_density(alpha=.3); 
}

# prolegomena to a class interface to the simulation
# The simulations should keep a record of the parameters used
# to define them. This can be used in the various display functions.
# Currently I'm only passing a data frame.

library(methods)
setClass("PROLE",
  representation(n="numeric",
                 births="numeric",
                 proles="numeric",
                 bourgeois="numeric",
                 r="numeric",
                 df="data.frame"),
  prototype(n=numeric(1),
            births=numeric(1),
            proles=numeric(1),
            bourgeois=numeric(1),
            r=numeric(1),
            df=data.frame()))
                 
#setValidity("PROLE",function(object){
#   retval <- NULL;
#   message("Checking validity")
#   if ( object@r <= 0 || object@r >= 1) 
#      retval <- c(retval,"r must be between 0 and 1");
#   if (is.null(retval)) return(TRUE) else return(retval)
#})

setMethod("initialize","PROLE",
    function(.Object, n, births, proles, bourgeois, r) {
      .Object@n <- n
      .Object@births <- births
      .Object@proles <- proles
      .Object@bourgeois <- bourgeois
      .Object@r <- r
      .Object@df <- prole.sim(n, births, proles, bourgeois, r)
      .Object})

setMethod("plot", signature=signature(x="PROLE"),
   function(x) {
       prole.plot(x@df) })

setMethod("boxplot", signature=signature(x="PROLE"),
   function(x) {
      prole.boxplot(x@df) })

setMethod("density", signature=signature(x="PROLE"),
   function(x) {
      prole.density(x@df) })
