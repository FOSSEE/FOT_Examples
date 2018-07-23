//Reference: K. Deb,"Solving Goal Programming Problems Using Multi-Objective Genetic Algorithms",Proceeedings of the 1999 Congress on Evolutionary C  omputation CEC-99,USA, 1999, p. 77-84
// goal f1(x) = (1.10471*h^2*l + 0.04811*t*b*(14+l))<=5;
// goal f2(x) = (2.1952/((t^3)*b))<=0.001;
// subjected to 
// g1(x) =  13,600 - tau >= 0
// g2(x) =  30,000 - sigma >= 0
// g3(x) =  b - h >= 0
// g4(x) =  Pc(x) - 6000 >= 0
// 0.125 <= h,b <= 5 and 0.1 <= l,t <= 10
//=====================================================================
// Copyright (C) 2018 - IIT Bombay - FOSSEE
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
// Author: Remya Kommadath
// Organization: FOSSEE, IIT Bombay
// Email: toolbox@scilab.in
//=====================================================================
clc; 
// Objective functions
function f = ObjectiveFunction(X)
    f(1) = (1.10471*X(1)^2*X(2) + 0.04811*X(3)*X(4)*(14+X(2)));
    f(2) = (2.1952/((X(3)^3)*X(4)));
endfunction
// Non linear constraints
function [C,Ceq] = NLconstraints(X)
    P = 6000; L = 14; E = 3*10^7; G = 12*10^6; tauMax = 13600; sigmaMax = 30000; 

    M = P*(L+(X(2)/2));
    R = sqrt((X(2)^2/4) + ((X(1) + X(3))/2)^2);
    J = 2*0.7071068*X(1)*X(2)*((X(2)^2/12)+((X(1)+X(3))/2)^2);
    sigma = (6*P*L)/(X(3)^2*X(4));
    Pc1 = (4.013*(sqrt(E*G*(X(3)^2*X(4)^6)/36)))/(L^2);
    Pc2 = 1-(X(3)/(2*L))*sqrt(E/(4*G));
    Pc = Pc1*Pc2;
    tauPrime = P/(sqrt(2)*X(1)*X(2));
    tauDprime = (M*R)/J;
    tau = sqrt(tauPrime^2 + 2*tauPrime*tauDprime*(X(2)/(2*R))+tauDprime^2);

    C(1) = tau - tauMax;
    C(2) = sigma - sigmaMax;
    C(3) = P - Pc;
    C = C';
    Ceq = [];
endfunction
// Linear inequality constraints
A = [1 0 0 -1];
b = 0;

nObj = 2;

Aeq = []; beq = [];
lb = [0.125 0.1 0.1 0.125];
ub = [5 10 10 5];
nVar = length(lb);

// Initial guess to the solver
x0 = lb + rand(1,nVar).*(ub-lb);

//Specifying the goal and the weights
goal=[5 0.001];
weight = [0.75 0.25];

options = list("MaxIter",10000,"CpuTime",10000)
// Calling fgoalattain
[x,fval,attainfactor,exitflag,output,lambda]=fgoalattain(ObjectiveFunction,x0,goal,weight,A,b,Aeq,beq,lb,ub,NLconstraints,options)

// Result representation
clc; 
select exitflag
case 0
    disp("Optimal Solution Found")
    disp(x0,"Initial guess given to the solver")
    disp(x',"The optimum solution obtained")
    disp(fval',"The optimum value of the objective functions")
case 1
    disp(" Maximum Number of Iterations Exceeded. Output may not be optimal")
case 2
    disp("Maximum amount of CPU Time exceeded. Output may not be optimal")
case 3
    disp("Stop at Tiny Step")
case 4
    disp("Solved To Acceptable Level")
case 5
    disp("Converged to a point of local infeasibility")
end

