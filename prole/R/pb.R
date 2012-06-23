# Bourgesois/Proletariat population urn model in R
# Written by Florian Lengyel. 

library(ggplot2);
options(error=utils::recover)

# game(n,b,s,d,r)
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

game<-function(n,births,proles,bourgeois,r,nf=FALSE)
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

    weight <- 1; # the Bourgeois have weight times more influence
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
       x<-sample(1:Proletariat+weight*Bourgeois,2); 

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
	  { # It takes weight Proles to make one Bourgeois * predation rate
            Bourgeois <- Bourgeois+floor((r/weight)*Proletariat);
	    Proletariat <- Proletariat-floor(r*Proletariat);
          } else
	  { Bourgeois <- Bourgeois+((r/weight)*Proletariat);
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
    Time <- XVec
    Prey <-YMat[,1]
    Predator <- YMat[,2]
    df <- data.frame(Time,Prey,Predator);

    ggplot(df,aes(Time)) + 
    geom_line(aes(y=Prey),colour="blue") + 
    geom_line(aes(y=Predator),colour="red") +
		ylab("Population");
 
} # game
