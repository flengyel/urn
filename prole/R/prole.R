# Bourgesois/Proletariat population urn model in R
# Written by Florian Lengyel. 

library(ggplot2);
#library(reshape);
options(error=utils::recover)

# prole(n,b,s,d,r)
# evolutionary urn model of two populations of sizes s and d
# in random paired encounters {x, y} in the total population of size s+d
# a subordinate-subordinate pairing gives birth to b subordinates 
# a subordinate-dominant pairing converts 100*r% subordinates to dominants
# a dominant-dominant kills both dominants and produces one subordinate 
#
# n - number of iterations
# b - number of subordinate population offspring
# s - initial subordinate population
# d - initial dominant population
# r - proportion of subordinate population that becomes dominant
# nf - no floors. Default is false. Set TRUE to remove floors.

prole<-function(n,births,proles,bourgeois,r,nf=FALSE)
{
    XVec <- array(0, c(n-1));
    YMat <- array(0, c(n-1,2));

    BENEFIT <- births;
    Proletariat <- proles;    
    Prolemin <- Proletariat;
    Prolemax <- Proletariat;
    Bourgeois <- bourgeois ;  
    Bourgeoismin <- Bourgeois;
    Bourgeoismax <- Bourgeois;

    XVec[0] <- 1;	
    YMat[0,] <- c(Proletariat,Bourgeois);

    if ( r <= 0 || r >= 1)
    {
	print("Transfer rate r must be between 0 and 1");
	return;
    }

    for ( k in 1:n-1 )
    {
       # sample 2 without replacement from total population
       x<-sample(1:Proletariat+Bourgeois,2); 

       if ((x[1] <= Proletariat) && (x[2] <= Proletariat))
       { # Proletariat/Proletariat encounter
	  Proletariat <-  Proletariat+BENEFIT; 
       	  #taxrate <- .25;
       	  taxrate <- 0;
       	  tax <- floor(taxrate*BENEFIT);
          Proletariat <- Proletariat-tax;
          Bourgeois <- Bourgeois+tax;
       }
       else if ((Proletariat+1 <= x[1]) && (Proletariat+1 <= x[2]))
       { # Bourgeois/Bourgeois encounter
     	   Bourgeois <- Bourgeois-2;  # one dies and the other is declasse
           Proletariat <- Proletariat+1;
       } else
       { # Bourgeois/Proletariat encounter
	  if (nf==FALSE) 
	  { 
            Bourgeois <- Bourgeois+floor(r*Proletariat);
	    Proletariat <- Proletariat-floor(r*Proletariat);
          } else
	  { Bourgeois <- Bourgeois+(r*Proletariat);
  	    Proletariat <- Proletariat-(r*Proletariat);
	  }
       }

       # update the new populations

       XVec[k]  <- k; 
       YMat[k,] <- c(Proletariat,Bourgeois); 
       Prolemin  <-  min(Prolemin,Proletariat);
       Prolemax  <-  max(Prolemax,Proletariat);
       Bourgeoismin  <-  min(Bourgeoismin,Bourgeois);
       Bourgeoismax  <-  max(Bourgeoismax,Bourgeois);
       
    } # for


    print(sprintf("%f <= s <= %f, %f <= d <= %f",
		 Prolemin,Prolemax,Bourgeoismin,Bourgeoismax));
    # Time is XVec
    Prey <-YMat[,1]
    Predator <- YMat[,2]
    df <- data.frame(XVec,Prey,Predator);

    ggplot(df,aes(XVec),stat="summary") + xlab("Time") + opts(legend.background=theme_rect()) +
    geom_line(aes(y=Prey, colour="Proletariat")) + 
    geom_line(aes(y=Predator, colour="Bourgeois")) +
    geom_hline(yintercept=Bourgeoismin, colour="blue",alpha=0.5) +
    annotate("text",x=mean(XVec),y=Bourgeoismin-5,label="Min Bourgeois",colour="blue",size=4) +
    opts(title="Bourgeois Proletariat Simulation") +
    scale_color_manual("Legend",
         breaks=c("Proletariat", "Bourgeois"),
         values=c("red", "black")) +
		ylab("Population");
} # game
