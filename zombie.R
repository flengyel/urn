# Parasite/Host Zombie/Human population urn model in R
# (c) 2010-2012 Florian Lengyel. 
# This code is released under the GNU General Public License, version 2

library(reshape)
library(plyr)
library(ggplot2)
library(scales)
library(methods)

options(error=utils::recover)

setClass("zombie",
  representation(n="numeric",
                 births="numeric",
                 humans="numeric",
                 zombies="numeric",
                 r="numeric",
		 title="character",
                 palette="character",
                 df="data.frame"),
  prototype(n=numeric(1),
            births=numeric(1),
            humans=numeric(1),
            zombies=numeric(1),
            r=numeric(1),
	    title=character(1),
            palette=character(8),
            df=data.frame()))
                 
# .zombie.simulation(n,births,humans,zombies,r)
# n - number of iterations
# births - number of human population offspring
# humans - initial human population
# zombies - initial zombie population
# r - proportion of human population that becomes zombie when infected
# returns a data frame with the time t=1,...,n and the value
# of prole and zombies at time t
#
# evolutionary urn model of two populations of sizes humans and zombies
# in uniformly random paired encounters {x, y} in a total population of 
# size humans+zombies.
# Case 1: a human-human pairing increases humans by births
# Case 2: a human-zombie pairing converts 100*r% humans to zombies
# Case 3: a zombie-zombie kills both zombies and produces one human

.zombie.simulation<-function(n,births,humans,zombies,r)
{
    XVec <- array(0, c(n));
    YMat <- array(0, c(n,2));
    YMat[1,] <- c(humans,zombies);

    if ( r <= 0 || r >= 1)
    {
	   print("Transfer rate r must be between 0 and 1");
	   return(data.frame()); # return empty data frame
    }

    for ( k in 1:n )
    {  # sample 2 without replacement from total population
       x<-sample(1:humans+zombies,2); 

       if ((x[1] <= humans) && (x[2] <= humans))
       { # human/human encounter
	       humans <-  humans+births; 
       }
       else if ((humans+1 <= x[1]) && (humans+1 <= x[2]))
       { # zombie/zombie encounter
     	   zombies <- zombies-2;  # one dies and the other is declasse
           humans <- humans+1;
       } else
       { # zombie/human encounter
           zombies <- zombies+floor(r*humans);
           humans <- humans-floor(r*humans);
       }
    
       # update the new populations

       XVec[k]  <- k; 
       YMat[k,] <- c(humans,zombies); 
       
    } # for

    # Time is XVec
    Humans <-YMat[,1]
    Zombies <- YMat[,2]
    df <- data.frame(XVec,Humans,Zombies);
}

.zombie.title<-function(n,births,humans,zombies,r)
{
   return( paste("Zombie-Human Parasite-Host Simulation\n",
                 "n:",n,"b:",births,"h:", humans, "z:", zombies, "r:", r ) )
}

setMethod("initialize","zombie",
    function(.Object, n, births, humans, zombies, r) {
      .Object@n <- n
      .Object@births <- births
      .Object@humans <- humans
      .Object@zombies <- zombies
      .Object@r <- r
      .Object@title <- .zombie.title(n, births, humans, zombies, r)
      .Object@palette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", 
                           "#F0E442", "#0072B2", "#D55E00", "#CC79A7");
      .Object@df <- .zombie.simulation(n, births, humans, zombies, r)
      .Object})

# Display the data frame produced by zombie.simulation
setMethod("plot", signature=signature(x="zombie"),
   function(x) {
      zmin <- min(x@df$Zombies);
      xmean <- mean(x@df$XVec);
      XVec <- x@df$XVec

      ggplot(x@df,aes(XVec)) + xlab("time") + 
      opts(legend.background=theme_rect()) +
      geom_line(aes(y=Humans, colour="Humans")) + 
      geom_line(aes(y=Zombies, colour="Zombies")) +
      geom_hline(yintercept=zmin, colour="blue",alpha=0.5) +
 #     scale_y_continuous(limits=c(0,max(df$Proletariat,df$Bourgeois)), breaks=c(bmin)) +
      annotate("text",x=xmean,zmin-2, label=paste("min(Zombies) =",zmin),colour="blue",size=3) +
      opts(title=x@title) +
      scale_color_manual("Legend",
                          breaks=c("Humans", "Zombies"),
                          values=x@palette) +
		ylab("population");
})

setMethod("boxplot", signature=signature(x="zombie"),
function(x) {
  ggplot(data=melt(subset(x@df,select=-c(1))), 
         aes(variable,value,fill=variable)) +
  xlab("species") + ylab("population")  +
  guides(fill=FALSE) + 
  opts(title=x@title) +
  geom_boxplot(); 
})

setMethod("density", signature=signature(x="zombie"),
function(x) {
  mdf <- melt(subset(x@df,select=-c(1)),
              variable="Species",
              value.name="population");
  cdf <- ddply(mdf, .(Species), summarise, population.mean=mean(value));
  ggplot(data=mdf, aes(x=value,fill=Species)) +
  geom_vline(data=cdf, aes(xintercept=population.mean,color=Species),
           linetype="dashed",size=1) +
  xlab("population") +
  opts(title=x@title) +
  geom_density(alpha=.3); 
})



