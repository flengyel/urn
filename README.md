## Introduction ##
Predator-prey dynamical systems are idealized descriptions of 
behavior in the animal kingdom, an unforgiving domain from 
which humans imagine their superior evolutionary development 
and civilization afford them some protection.

This simulation of a repeated game illustrates a mathematical notion 
of economic class dominance within a population.  Populations are 
partitioned into disjoint classes. One class dominates another if, 
at each repetition of the game, its payoff is an asymmetric zero-sum 
transfer of utility from the other class, such that the payoff is 
proportional to the population of the other class.  

The idea to define economic class dominance as a population-dependent 
income transfer (as opposed to a fixed working wage) 
from one class to another was inspired by a New York Times 
article of December 25, 2009, entitled "[At Tiny Rates, 
Saving Money Costs Investors](http://www.nytimes.com/2009/12/26/your-money/26rates.html)." 
The Times reported that "...risk-averse investors are 
effectively financing a second bailout of financial institutions, 
many of which have also raised fees and interest rates on credit cards."
William H. Gross of Pimco was quoted. "...a significant part 
of the government’s plan to repair the financial system and 
the economy is to pay savers nothing and allow damaged financial 
institutions to earn a nice, guaranteed spread," he said. 


In this simulation, a population is partitioned into two classes
called the Bourgeois and the Proletariat. The Bourgeois dominate 
the Proletariat in the above sense. The payoff to the Proletariat 
at each repetition of the game is a population-independent
constant fixed for the entire simulation.

Each play of the repeated game proceeds as follows.  Two members
of the total population are selected uniformly at random. If
both are Proletariat, the Proletariat population is increased
by a constant amount. If one is Proletariat and the other
is Bourgeois, a fixed fraction of the Proletariat becomes Bourgeois.
Finally, if both are Bourgeois, one of them dies and the other
becomes Proletariat.

## Examples ##
Load the source code `prole.R` with `source('prole.R')`.

### Creating a simulation ###
Create a `PROLE` object with `sim <- new("PROLE", 1000, 2, 30, 40, 0.031)`, for example.

### Simulation plot ###
Plot the simulation with `plot(sim)`. This will produce `ggplot2` output, such as the following.
[<img src="https://github.com/flengyel/urn/raw/master/sampleplot.png">](https://github.com/flengyel/urn/raw/master/sampleplot.png)

### Density plot ###
The method `density(sim)` will produce a density plot. The dashed lines indicate distribution
means. [<img src="https://github.com/flengyel/urn/raw/master/densityplot.png">](https://github.com/flengyel/urn/raw/master/densityplot.png)

## License ##

(c) 2010-2012, Florian Lengyel florian.lengyel@gmail.com
The text is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported (CC BY-NC-SA-3.0)  license](http://creativecommons.org/licenses/by-nc-sa/3.0/).
The code is licensed under the GNU General Public License, version 2.
