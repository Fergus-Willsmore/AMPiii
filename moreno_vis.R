## File: moreno_vis.R
## Name: Fergus Willsmore
## Date: 1/9/17
## Course: AMPIII
## Desc: This script will produce the visualisation of the moreno dataset with both the kamada-kawai and random algorithm.

### Visualisation ###
# Moreno dataset

library(ggraph)
library(statnet)

data("Moreno")
gender <- Moreno %v% "gender"
Moreno<-asIgraph(Moreno)
graph<-Moreno
Gender<-c(rep("Male",17),rep("Female",16))

# KK

ggraph(graph, layout='kk')+
  geom_edge_link(width=1) + 
  geom_node_point(aes(col=Gender),size=6)+ 
  theme_graph()+
  theme(legend.position="bottom",
        legend.text = element_text(size=24),
        legend.title=element_blank())

# Random

ggraph(graph, layout='randomly')+
  geom_edge_link(width=1) + 
  geom_node_point(aes(col=Gender),size=6)+
  theme_graph()+
  theme(legend.position="bottom",
        legend.text = element_text(size=24),
        legend.title=element_blank())
