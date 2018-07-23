//Reference: K. M. Ragsdell and D. T. Phillips,"Optimal Design of a Class of Welded Structures Using Geometric Programming",ASME Journal of Engineering for Industry,Vol.98, pp 1021-1025, 1976
//A welded beam is designed for minimum cost subject to constraints on shear stress,bending stress in the beam,buckling load on the bar,end deflectionof the beam and the bound constraints. There are four design variables such as Weld thickness(inch), weld length (inch), bar thickness (inch), bar breadth(inch).
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
// Objective function
function f = ObjectiveFunction(X)
    f = 1.10471*X(1)^2*X(2) + 0.04811*X(3)*X(4)*(14+X(2));
endfunction
// Non linear equality and inequality constraints
function [C,Ceq] = NLconstraints(X)
    P = 6000; L = 14; E = 3*10^7; G = 12*10^6; tauMax = 13600;
    sigmaMax = 30000; deltaMax = 0.25;

    M = P*(L+(X(2)/2));
    R = sqrt((X(2)^2/4) + ((X(1) + X(3))/2)^2);
    J = 2*0.7071068*X(1)*X(2)*((X(2)^2/12)+((X(1)+X(3))/2)^2);
    sigma = (6*P*L)/(X(3)^2*X(4));
    delta = (4*P*L^3)/(E*X(3)^3*X(4));
    Pc1 = (4.013*(sqrt(E*G*(X(3)^2*X(4)^6)/36)))/(L^2);
    Pc2 = 1-(X(3)/(2*L))*sqrt(E/(4*G));
    Pc = Pc1*Pc2;
    tauPrime = P/(sqrt(2)*X(1)*X(2));
    tauDprime = (M*R)/J;
    tau = sqrt(tauPrime^2 + 2*tauPrime*tauDprime*(X(2)/(2*R))+tauDprime^2);

    C(1) = tau - tauMax;
    C(2) = sigma - sigmaMax;
    C(3) = 0.10471*X(1)^2 + 0.04811*X(3)*X(4)*(14+X(2)) - 5;
    C(4) = delta - deltaMax;
    C(5) = P - Pc;
    C = C';
    Ceq = [];
endfunction
// Linear inequality constraints
A = [1 0 0 -1;-1 0 0 0];
b = [0 -0.125]';
// Bounds of the problem
lb = [0.1 0.1 0.1 0.1];
ub = [2 10 10 2];
// Initial guess
x0 = rand(1,4).*(ub-lb);
// Design parameters of the problem
designParameters = {'Weld thickness(inch)','weld length (inch)','bar thickness (inch)','bar breadth(inch)'}
inGuess = [designParameters; string(x0)]
disp(inGuess,"Initial guess given to the solver")
input("Press enter to proceed: ")
// Calling the solver function
[xopt,fopt,exitflag,output,lambda] = fmincon(ObjectiveFunction,x0,A,b,[],[],lb,ub,NLconstraints)

// Result representation
clc; 
optSol = [designParameters; string(xopt')]
select exitflag
case 0
    disp(optSol,"The optimum solution obtained")
    disp(fopt,"The minimum cost for the weldment assembly is")
case 1
    disp(" Maximum Number of Iterations Exceeded. Output may not be optimal")
    disp(optSol,"The solution obtained")
    disp(fopt,"The minimum cost for the weldment assembly is")
case 2
    disp("Maximum amount of CPU Time exceeded. Output may not be optimal")
    disp(optSol,"The solution obtained")
    disp(fopt,"The minimum cost for the weldment assembly is")
case 3
    disp("Stop at Tiny Step")
    disp(optSol,"The solution obtained")
    disp(fopt,"The minimum cost for the weldment assembly is")
case 4
    disp("Solved To Acceptable Level")
    disp(optSol,"The solution obtained")
    disp(fopt,"The minimum cost for the weldment assembly is")
case 5
    disp("Converged to a point of local infeasibility")
end
disp(output)
