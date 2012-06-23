\name{prole-package}
\alias{prole-package}
\alias{prole}
\docType{package}
\title{
Bourgeois-Proletariat predator-prey simulation
}
\description{ A predator-prey simulation in which the payoff \cr
 to one population, called the Bourgeois, is a fixed fraction \cr
 of the income of the other population, called the Proletariat, \cr
 whose income is a population-independent constant. Two members  \cr
 of the total population are selected uniformly at random. If  \cr
 both are Proletariat, the Proletariat population is increased  \cr
 by a fixed constant amount. If one is Proletariat and the other  \cr
 is Bourgeois, a fixed fraction of the Proletariat becomes Bourgeois.  \cr
 Finally, if both are Bourgeois, one of them dies and the other 
 becomes Proletariat.
}
\details{
\tabular{ll}{
Package: \tab prole\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2012-06-22\cr
License: \tab GPL-2 
}
~~ An overview of how to use the package, including the most important ~~
~~ functions ~~
}
\author{
Florian Lengyel
Maintainer: Florian Lengyel <florian.lengyel@gmail.com>
~~ The author and/or maintainer of the package ~~
}
\keyword{ package }
\examples{
game(1000,2,100,45,0.1)
}
