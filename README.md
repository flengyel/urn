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

Here we identify income with number of offspring–a common simplification 
in applications of game theory to biology.  The simulation is defined
so that each member of the Proletariat receives a fixed, population 
independent income, whereas the Bourgeois receives a proportion of the 
entire wealth of the Proletariat.

At each play of the simulation, two individuals from the total population 
of Proletariat and Bourgeois are chosen at random. Depending on the classes 
of the individuals chosen, the two populations will receive payoffs 
(which can be positive, negative or zero). There are three cases.

* Case one: if two members of the Proletariat are selected, the population of 
the Proletariat is increased by a fixed amount, b. The quantity b is population independent. We also include–optionally–a tax rate. A proportion (25% in the examples below) of the income to the Proletariat is transferred to the Bourgeois, even though the Bourgeois are third parties to the interaction of the Proletariat. Taxing the Proletariate has two consequences: it damps the oscillations of the model, and it insures the Bourgeois against extinction.

* Case two: if a member of the Proletariat and a member of the Bourgeois are selected, the population of the Proletariat is reduced by [\gamma P], where P is the population of the Proletariat and \gamma is a fixed proportion between 0 and 1. The population of the Bourgeois is increased by the same quantity [\gamma P]. Effectively, the cost to the Proletariat of an encounter with the Bourgeois is that a proportion of the Proletariat become Bourgeois–this is a kind of transfer of wealth in the form of offspring. One can think of the Bourgeois as tricking the Proletariat into raising its children. Other interpretations are possible, such as upward mobility.

* Case three: if two members of the Bourgeois are selected, one of them dies, and the other is knocked into the Proletariat.  

This code is licenced under a [Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported (CC BY-NC-SA-3.0)  license](http://creativecommons.org/licenses/by-nc-sa/3.0/).
