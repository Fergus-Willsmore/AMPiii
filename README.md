# Advanced Mathematical Perspective iii
## Network Analysis and ERGM project
This repository is designed to contain R scripts that were used for data analysis within the report _Exponential Random Graph Models As a Method For Network Analysis_. All code and datasets are open-source and readily available in R or R studio. Please note that updates may have become available since the publication of this report and could effect the results. More importantly the Tobacco Control dataset is contained within UserNetR and the Star Wars dataset is contained within dplyr. These are the main version upgrades to be aware of.
### File directory
SessionInfo          -  The session info of R that contains all versions of packages loaded can be found here.

moreno\_vis          -  This script will produce the visualisation of the moreno dataset with both the kamada-kawai and random algorithm.

univariate\_moreno   -  This script simulates Erdos Renyi models of the moreno network and plots histograms of summary statistics.

TCnetwork\_analysis  -  This script performs complex ERGM analysis of the Tobacco Control dataset. This includes: network visualisation, model building, model selection, goodness-of-fit measures and simulation.

SWdataset\_analysis  -  This script contains the analysis for the starwars dataset. This includes: edgelist, network object, network visualisation, centrality measures, betweenness example plot, central network.


For this reason the Session Info can be found in the file named SessionInfo. More importantly the Tobacco Control dataset is contained within UserNetR and the Star Wars dataset is contained within dplyr. Updates to these datasets could effect the results.

Session Info
R version 3.3.3 (2017-03-06)
Platform: x86_64-apple-darwin13.4.0 (64-bit)
Running under: macOS  10.13

locale:
[1] en_AU.UTF-8/en_AU.UTF-8/en_AU.UTF-8/C/en_AU.UTF-8/en_AU.UTF-8

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
 [1] ggraph_1.0.0         UserNetR_2.10        igraph_1.1.2        
 [4] statnet_2016.9       sna_2.4              ergm.count_3.2.2    
 [7] tergm_3.4.1          networkDynamic_0.9.0 intergraph_2.0-2    
[10] dplyr_0.7.4          purrr_0.2.3          tidyr_0.7.1         
[13] tibble_1.3.4         ggplot2_2.2.1        tidyverse_1.1.1     
[16] broom_0.4.2          knitr_1.17           xtable_1.8-2        
[19] stringr_1.2.0        expm_0.999-2         Matrix_1.2-11       
[22] readr_1.1.1          forcats_0.2.0.9000   ergm_3.8.0          
[25] network_1.13.0       statnet.common_4.0.0 
