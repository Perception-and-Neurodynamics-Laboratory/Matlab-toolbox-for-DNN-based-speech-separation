function [acc, hit, fa] = getHITFA(gnd, predlb)

gnd(gnd==0) = -1; predlb(predlb == 0) = -1;

acc = mean(gnd == predlb);

hit = sum(predlb==1 & gnd==1) / sum(gnd == 1);
fa = sum(predlb==1 & gnd==-1) / sum(gnd == -1);
