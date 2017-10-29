## File: moreno_uni.R
## Name: Fergus Willsmore
## Date: 15/9/17
## Course: AMPIII
## Desc: This script simulates Erdos Renyi models of the moreno network and plots histograms of summary statistics.

### Univariate statistics ###
# Erdos Renyi models of moreno network

library(ggraph)
library(statnet)
library(UserNetR)
library(intergraph)
library(igraph)
set.seed(37)
components<-sna::components

# five number summary function

five_no_sum<-function(x){
  if (is(x,"network")==FALSE){
    x<-asNetwork(x)
  }
  size<-network.size(x)
  dens<-gden(x)
  comp<-components(x)
  lgc <- component.largest(x,result="graph")
  gd <- geodist(lgc)
  diam<-max(gd$gdist)
  clust<-gtrans(x,mode="graph")
  return(c(size,dens,comp,diam,clust))
}

# Erdos Renyi simulation

data("Moreno")
p<-46/(33*(32)/2) # estimate p: number of edges / total possible no. of edges
t<-100
sum<-matrix(ncol=5,nrow=t)
summary_Moreno<-five_no_sum(Moreno) 
for (i in 1:100){
  net1<-sample_gnp(33,p,directed=FALSE,loop=FALSE)
  sum[i,]=five_no_sum(net1)
}
sum<-as.data.frame(sum)
colnames(sum)<-c("Size","Density","Components","Diameter","Clustering")

# Specific plots

ggplot(data=sum, aes(sum$Size)) +
  geom_histogram(bins=20,col="red",fill="green",alpha = .2)+
  labs(x="Size", y="Frequency")+
  geom_vline(xintercept=summary_Moreno[1],col="blue",alpha=.5,size=2)+
  theme(axis.text=element_text(size=20),axis.title=element_text(size=20))
ggsave("moreno_size.pdf", width = 8, height = 8)

ggplot(data=sum, aes(sum$Density)) +
  geom_histogram(bins=20,col="red",fill="green",alpha = .2)+
  labs(x="Density", y="Frequency")+
  geom_vline(xintercept=summary_Moreno[2],col="blue",alpha=.5,size=2)+
  theme(axis.text=element_text(size=20),axis.title=element_text(size=20))
ggsave("moreno_dens.pdf", width = 8, height = 8)

ggplot(data=sum, aes(sum$Components)) +
  geom_histogram(bins=20,col="red",fill="green",alpha = .2)+
  labs(x="Components", y="Frequency")+
  geom_vline(xintercept=summary_Moreno[3],col="blue",alpha=.5,size=2)+
  theme(axis.text=element_text(size=20),axis.title=element_text(size=20))
ggsave("moreno_comp.pdf", width = 8, height = 8)

ggplot(data=sum, aes(sum$Diameter)) +
  geom_histogram(bins=20,col="red",fill="green",alpha = .2)+
  labs(x="Diameter", y="Frequency")+
  geom_vline(xintercept=summary_Moreno[4],col="blue",alpha=.5,size=2)+
  theme(axis.text=element_text(size=20),axis.title=element_text(size=20))
ggsave("moreno_diam.pdf", width = 8, height = 8)

ggplot(data=sum, aes(sum$Clustering))+
  geom_histogram(bins=20,col="red",fill="green",alpha = .2)+
  labs(x="Clustering", y="Frequency")+
  geom_vline(xintercept=summary_Moreno[5],col="blue",alpha=.5,size=2)+
  theme(axis.text=element_text(size=20),axis.title=element_text(size=20))
ggsave("moreno_clust.pdf", width = 8, height = 8)

