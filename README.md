# Advanced Mathematical Perspective iii
## Network Analysis and ERGM project
This repository is designed to contain R scripts that were used for data analysis within the report _Exponential Random Graph Models As a Method For Network Analysis_. All code and datasets are open-source and readily available in R or R studio. Please note that updates may have become available since the publication of this report and could effect the results. More importantly the Tobacco Control dataset is contained within UserNetR and the Star Wars dataset is contained within dplyr. These are the main version upgrades to be aware of.
### File directory
SessionInfo          -  Contains the version of R as well as all package versions used in the code.

moreno\_vis          -  This script will produce the visualisation of the moreno dataset with both the kamada-kawai and random algorithm.

moreno\_uni          -  This script simulates Erdos Renyi models of the moreno network and plots histograms of summary statistics.

TCnetwork\_analysis  -  This script performs complex ERGM analysis of the Tobacco Control dataset. This includes: network visualisation, model building, model selection, goodness-of-fit measures and simulation.

SWdataset\_analysis  -  This script contains the analysis for the starwars dataset. This includes: edgelist, network object, network visualisation, centrality measures, betweenness example plot, central network.
