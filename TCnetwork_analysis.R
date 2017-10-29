## File: TCnetwork_analysis.R
## Name: Fergus Willsmore
## Date: 1/10/17
## Course: AMPIII
## Desc: This script performs complex ERGM analysis of the Tobacco Control dataset. This includes: network visualisation, model building, model selection, goodness-of-fit measures and simulation.

#### Tobacco Control ####
# Complex ERGM anlaysis of Tobacco Control dataset

### setup ###

library(ergm)
library(UserNetR)
library(statnet)
degree<-sna::degree
components<-sna::components
centralization<-sna::centralization

## network setup ##

data(TCnetworks)
TCcnt<-TCnetworks$TCcnt
TCcoll<-TCnetworks$TCcoll
TCdiss<-TCnetworks$TCdiss
TCdist<-TCnetworks$TCdist
summary(TCdiss,print.adj=FALSE)
lgc <- component.largest(TCdiss,result="graph")
gd <- geodist(lgc)
TC.fns<-data.frame(Size=network.size(TCdiss),
                   Denstiy=gden(TCdiss),
                   Components=components(TCdiss),
                   Diameter=max(gd$gdist),
                   Clustering=gtrans(TCdiss,mode="graph"),
                   Betweenness=centralization(TCdiss,betweenness,mode='graph'))
lvl<-TCdiss %v% 'agency_lvl'
deg<-degree(TCdiss,gmode='graph')

# Network plot

set.seed(357)
plot(TCdiss,usearrows=FALSE,displaylabels=TRUE,
     vertex.cex=log(deg),vertex.col=lvl+1,label.pos=3,
     label.cex=.7,edge.lwd=0.5,edge.col="grey75")
      legend("bottomleft",legend=c("Local","State", "National"),
       col=2:4,pch=19,pt.cex = 1.5)

### Model Selection ###

# Null model

DSmod0<-ergm(TCdiss~edges,control=control.ergm(seed=40))
sum0<-summary(DSmod0)
plogis(coef(DSmod0)) #overall probability of observing a tie

# Scatter plot

scatter.smooth(TCdiss %v% 'tob_yrs',degree(TCdiss,gmode='graph'),
               xlab='Years of Tobacco Experience',
               ylab='Degree')

# Attribute predictor model

DSmod1 <- ergm(TCdiss~edges + nodefactor('lead_agency') +
                 nodecov('tob_yrs') ,
               control=control.ergm(seed=40))
summary(DSmod1)
p_edg <- coef(DSmod1)[1]
p_yrs <- coef(DSmod1)[3] 
plogis(p_edg + 5*p_yrs + 10*p_yrs)

## Dyadic predictors ## 

m<-mixingmatrix(TCdiss,'agency_lvl')
mixingmatrix(TCdiss,'agency_cat')

# Homophily

DSmod2a <- ergm(TCdiss~edges+nodecov('tob_yrs')+nodematch('agency_lvl'),control=control.ergm(seed=40))
summary(DSmod2a)

# Differential homophily

DSmod2b <- ergm(TCdiss~edges + nodecov('tob_yrs')+nodematch('agency_lvl',diff=TRUE),control=control.ergm(seed=40))
summary(DSmod2b)

# Detailed homophily

DSmod2c <- ergm(TCdiss~edges + nodecov('tob_yrs') +
                  nodemix('agency_lvl',base=1),
                control=control.ergm(seed=40))

# relational predictors

DSmod3 <- ergm(TCdiss~edges+nodecov('tob_yrs')+nodematch('agency_lvl',diff=TRUE)+edgecov(TCdist,attr='distance')+edgecov(TCcnt,attr='contact'), control=control.ergm(seed=40))
summary(DSmod3)

# structural predictors

DSmod4 <- ergm(TCdiss~edges+nodecov('tob_yrs')+
                 nodematch('agency_lvl',diff=TRUE)+
                 edgecov(TCcnt,attr="contact")+
                 gwesp(0.7, fixed=TRUE),
               control=control.ergm(seed=40))
summary(DSmod4)

## Goodness-of-fit measures ##

DSmod.fit<-gof(DSmod4,GOF=~distance+espartners+degree+triadcensus,burnin=1e+5,interval=1e+5)
summary(DSmod.fit)
op<-par(mfrow=c(2,2))
plot(DSmod.fit,cex.axis=1.6,cex.label=1.6)
par(op)

## Simulate a network ##

sim4<-simulate(DSmod4,nsim=1,seed=569)
lvlobs<-TCdiss %v% 'agency_lvl'
lvl4<-sim4 %v% 'agency_lvl'
plot(sim4,usearrows=FALSE,vertex.cex=log(deg),vertex.col=lvl4+1,edge.lwd=0.5,edge.col="grey75",main="Simulated Network")
legend("bottomleft",legend=c("Local","State", "National"),
       col=2:4,pch=19,pt.cex = 1.5)