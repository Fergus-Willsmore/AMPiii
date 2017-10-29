## File: SWdataset_analysis.R
## Name: Fergus Willsmore
## Date: 10/10/17
## Course: AMPIII
## Desc:  This script contains the analysis for the starwars dataset. This includes: edgelist, network object, network visualisation, centrality measures, betweenness example plot, central network. 

#### Star Wars Dataset ####
# exploration of starwars dataset

## Setup ##

library(tidyverse)
library(igraph)
library(ggraph)
degree<-igraph::degree
data(starwars)
set.seed(104)
starwars<-as.data.frame(starwars)

## Create edgelist of network ##
# find all pairwise combinations of number of movies shared

char<-starwars$name
count.i<-1
count.k<-1
el<-matrix(data=NA,ncol=2,nrow=0,byrow = TRUE)
films<-matrix(data=NA,ncol=1,nrow=0,byrow=TRUE)
for (i in char[1:(length(char)-1)]){
  i.ind<-which(starwars$name==i)
  for (j in char[(count.i+1):length(char)]){
    j.ind<-which(starwars$name==j)
    test<-intersect(starwars$films[[i.ind]],starwars$films[[j.ind]])
    if (length(test)==0){
    }else{
      el<-rbind(el,c(i,j)) 
      films<-rbind(films,length(test))
    }
    count.k<-count.k+1
  }
  count.i<-count.i+1
}
el<-cbind(el,films)
colnames(el)[3]<-"Films"

## Create Network Object ##

graph<-graph.data.frame(el,directed = FALSE)

# Find the characters trilogy

preq<-starwars$films[[87]]
orig<-starwars$films[[4]]
orig<-orig[2:4]
awak<-starwars$films[[86]]

a<-sapply(starwars$films,function(x){sum(preq %in% x)})
b<-sapply(starwars$films,function(x){sum(orig %in% x)})
c<-sapply(starwars$films,function(x){sum(awak %in% x)})
Tril<-data.frame(Preq=a,Orig=b,Awak=c)

Tril<-apply(Tril,1,function(x){ifelse(sum(x>0)==1,which(x>0),0)})
Tril<-sapply(Tril,function(x){ifelse(x==1,"Prequel",ifelse(x==2,"Original",ifelse(x==3,"Awakens","Both")))})
order<-sapply(V(graph)$name,function(x){which(starwars$name==x)})

# Add trilogy to network

V(graph)$Trilogy=Tril[order]

## Network Visualisation ##

# define colour palette to be colour blind friendly 
cbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

# define legend titles
Films<-factor(E(graph)$Films)
Degree<-degree(graph)
Trilogy<-factor(V(graph)$Trilogy)

# Plot
g<-ggraph(graph, layout = 'kk') +
  geom_edge_link(aes(colour=Films,alpha=Films)) +
  geom_node_point(aes(size=Degree,shape=Trilogy))+
  theme_graph()+
  theme(plot.title = element_text(hjust = 0.5),legend.text = element_text(size=16),
        legend.title = element_text(size=20))+
  scale_edge_color_manual(values=cbPalette)
plot(g)

# Save coordinates
coord<-ggplot_build(g)$data[[2]]

## Centrality of main network ##

df.cent <- data.frame(
  Degree = degree(graph), 
  Closeness = closeness(graph), 
  Betweenness = betweenness(graph,weights=Films),
  Eigen=evcent(graph)$vector)
rownames(df.cent)<-V(graph)$name
df.centsort <- df.cent[order(-df.cent$Eigen),]

## Betweenness and number of films plot ##
# This plots the weighted version. The unweighted can be produced if weights=Films is omitted from the betweenness calculation.

ind<-1
f<-rep(0,87)
for (i in starwars$films){
  f[ind]<-length(i)
  ind<-ind+1
}
op <- par(mar = c(4,5,4,2) + 0.1)
plot(f,df.cent$Betweenness,xlab = "Number of Films",ylab = "Betweenness",
     cex.lab=1.8, cex.axis=1.5,cex=1.3)
par(op)

### Betweenness example plot for Anakin and Han ###

# Get all shortest paths
news.path <- get.all.shortest.paths(graph, 11, 82,mode="all")
list<-unlist(news.path$res)

# Create variable node size
node.size<-rep(3,87)
node.size[list]<-8

## Generate edge color variable:

ecol <- rep(adjustcolor("gray40", alpha.f = .05), ecount(graph))

# find shorest path edges
name<-V(graph)$name[list]
a<-rep(0,length(name))
counter<-1
for (i in name[1:(length(name)-1)]){
  n<-which(el[,1]==name[counter])
  m<-which(el[,2]==name[counter+1])
  val<-intersect(n,m)
  n<-which(el[,2]==name[counter])
  m<-which(el[,1]==name[counter+1])
  val1<-intersect(n,m)
  counter<-counter+1
  a[counter]<-max(val,val1)
}
a<-a[which(a>0)]
ecol[a] <- "orange"

# Generate edge width variable:
ew <- rep(2, ecount(graph))
ew[list] <- 4

# Generate node color variable:
vcol <- rep("gray40", vcount(graph))
vcol[list] <- "gold"
vcol[5]<-"red"

# Generate selective label
label<-rep('',87)
label[list]<-word(V(graph)$name[list])

# Match star wars network layout
l<-layout.norm(cbind(coord$x,coord$y))

# Create plot of betweenness example 
set.seed(649)
plot(graph, layout=l,vertex.color=vcol, edge.color=ecol, 
     edge.width=ew, edge.arrow.mode=0, vertex.size=node.size,
     vertex.label.dist=2,vertex.label.degree=0,vertex.label=label,
     vertex.label.color="black", vertex.label.family="Helvetica",
     vertex.label.cex=1.1,vertex.label.font=2)

### Smaller central network ###

sw.copy <- delete_edges(graph, which(E(graph)$Films<4))
iso <- V(sw.copy)[degree(sw.copy)==0]
sw.copy <- delete_vertices(sw.copy, iso)
Films<-factor(E(sw.copy)$Films)
Degree<-degree(sw.copy)
g<-ggraph(sw.copy, layout = 'kk') +
  geom_edge_link(aes(colour=Films)) +
  geom_node_point(aes(size=Degree))+
  theme_graph()+
  theme(plot.title = element_text(hjust = 0.5),legend.text = element_text(size=16),
        legend.title = element_text(size=20))+
  scale_edge_color_manual(values=cbPalette)
coord<-ggplot_build(g)$data[[2]]
g<-g+geom_text(aes(label=ifelse(Degree>0,word(V(sw.copy)$name),''),x=coord$x,y=coord$y+0.13),colour="black",hjust="inward",vjust="inward",size=5)
plot(g)

# centrality of smaller central network

df.cent2 <- data.frame(
  Degree = degree(sw.copy), 
  Closeness = closeness(sw.copy), 
  Betweenness = betweenness(sw.copy,weights=Films),
  Eigen=evcent(sw.copy)$vector)
rownames(df.cent2)<-V(sw.copy)$name
df.centsort2 <- df.cent2[order(-df.cent2$Eigen),]
