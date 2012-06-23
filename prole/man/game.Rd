\name{game}
\alias{game}
\title{
Run Bourgeois-Proletariat predator-prey simulation
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
Run Bourgeois-Proletariat predator-prey simulation and display a
ggplot graph of the Bourgeois (red) and Proletariat (blue) populations
for each of the specified iterations.
}
\usage{
game(n, births, proles, bourgeois, r, nf = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{n}{
%%     ~~Describe \code{n} here~~
Number of iterations.
}
  \item{births}{
%%     ~~Describe \code{births} here~~
Number of Proletariat births.
}
  \item{proles}{
%%     ~~Describe \code{proles} here~~
Initial Proletariat population.
}
  \item{bourgeois}{
%%     ~~Describe \code{bourgeois} here~~
Initial Bourgeois population.
}
  \item{r}{
%%     ~~Describe \code{r} here~~
Percentage of Proletariate population converted to Bourgeois.
}
  \item{nf}{
%%     ~~Describe \code{nf} here~~
Disable floor calculation. False by default.
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
Predator-prey dynamical systems are idealized descriptions of 
behavior in the animal kingdom, an unforgiving domain from 
which humans imagine their superior evolutionary development 
and civilization afford them some protection.

In this simulation, there are two populations: the Proletariat and the 
Bourgeois. The initial number of each class is set at the beginning of 
the simulation. The simulation illustrates that the Bourgeois can 
repeatedly extract a fixed percentage of the total income of the 
Proletariat indefinitely, provided the Bourgeois is prevented from 
extracting too much.

Here we identify income with number of offspring. 
The simulation is defined so that each member of the Proletariat receives 
a fixed, population independent income, whereas the Bourgeois receives a 
proportion of the entire wealth of the Proletariat.

At each play of the simulation, two individuals from the total population 
of Proletariat and Bourgeois are chosen at random. Depending on the classes 
of the individuals chosen, the two populations will receive payoffs 
(which can be positive, negative or zero). There are three cases.

Case one: if two members of the Proletariat are selected, the population of 
the Proletariat is increased by a fixed amount, b. The quantity b is population independent. 

Case two: if a member of the Proletariat and a member of the Bourgeois are selected, the 
population of the Proletariat is reduced by floor(r*P), where P is the population of the 
Proletariat and r is a fixed proportion between 0 and 1. The population of the Bourgeois 
is increased by the same quantity floor(r*P). The cost to the Proletariat of 
an encounter with the Bourgeois is that a proportion of the Proletariat become Bourgeois (this 
is a kind of transfer of wealth in the form of offspring). One can think of the Bourgeois as 
tricking the Proletariat into raising its children. Other interpretations are possible, 
such as upward mobility.

Case three: if two members of the Bourgeois are selected, one of them dies, and the other 
is knocked into the Proletariat.  

}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
No values returned.
}
\author{
%%  ~~who you are~~
Florian Lengyel, Ph.D.
Research Associate, CUNY Environmental CrossRoads Initiative
The City College of New York
160 Convent Avenue
New York, NY 10031
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (n, births, proles, bourgeois, r, nf = FALSE) 
{
    XVec <- array(0, c(n - 1))
    YMat <- array(0, c(n - 1, 2))
    BENEFIT <- births
    Proletariat <- proles
    Prolemin <- Proletariat
    Prolemax <- Proletariat
    Bourgeois <- bourgeois
    Bourgeoismin <- Bourgeois
    Bourgeoismax <- Bourgeois
    weight <- 1
    XVec[0] <- 1
    YMat[0, ] <- c(Proletariat, Bourgeois)
    if (r <= 0 || r >= 1) {
        print("Transfer rate r must be between 0 and 1")
        return
    }
    for (k in 1:n - 1) {
        x <- sample(1:Proletariat + weight * Bourgeois, 2)
        if ((x[1] <= Proletariat) && (x[2] <= Proletariat)) {
            Proletariat <- Proletariat + BENEFIT
            taxrate <- 0
            tax <- floor(taxrate * BENEFIT)
            Proletariat <- Proletariat - tax
            Bourgeois <- Bourgeois + tax
        }
        else if ((Proletariat + 1 <= x[1]) && (Proletariat + 
            1 <= x[2])) {
            Bourgeois <- Bourgeois - 2
            Proletariat <- Proletariat + 1
        }
        else {
            if (nf == FALSE) {
                Bourgeois <- Bourgeois + floor((r/weight) * Proletariat)
                Proletariat <- Proletariat - floor(r * Proletariat)
            }
            else {
                Bourgeois <- Bourgeois + ((r/weight) * Proletariat)
                Proletariat <- Proletariat - (r * Proletariat)
            }
        }
        XVec[k] <- k
        YMat[k, ] <- c(Proletariat, Bourgeois)
        Prolemin <- min(Prolemin, Proletariat)
        Prolemax <- max(Prolemax, Proletariat)
        Bourgeoismin <- min(Bourgeoismin, Bourgeois)
        Bourgeoismax <- max(Bourgeoismax, Bourgeois)
    }
    print(sprintf("\%f <= s <= \%f, \%f <= d <= \%f", Prolemin, Prolemax, 
        Bourgeoismin, Bourgeoismax))
    df <- data.frame(Time = XVec, Prey = YMat[, 1], Predator = YMat[, 
        2])
    ggplot(df, aes(Time)) + geom_line(aes(y = Prey), colour = "blue") + 
        geom_line(aes(y = Predator), colour = "red") + ylab("Population")
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~Proletariat }
\keyword{ ~Bourgeois }% __ONLY ONE__ keyword per line
