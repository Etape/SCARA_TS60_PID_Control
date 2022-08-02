%%initialisation de l'interface
clc
clear all
 global q0 qf C1 C2 C3 C4 t q1 q2 q3 q1c q2c q3c
 q0=[0 0 0];
 qf=[pi/3 pi/2 0.3];
C1=0;C2=0;C3=0;C4=0;
global dt tmax
dt=0.0001;
tmax=2;