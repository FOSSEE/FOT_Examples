//The problem consists of minimizing the weight of a tension/compression spring subject to constraints on
//minimum deflection, shear stress, surge frequency, limits on outside diameter and on design variables. The design
//variables are the mean coil diameter D, the wire diameter d and the number of active coils N. The problem can be
//expressed as follows: 
//Min f(x) = ( N + 2)*D*d^2 
//ST 
//g1(x) = 1-D^3*N/(71785*d^4) <= 0;
//g2(x) = 1-140.45*d/(D^2*N) <= 0;
//g3(x) = (4*D^2-d*D)/(12566*(d^3*D-d^4)) + 1/(5108*d^2)-1 <= 0;
//g4(x) = (D+d)/1.5 - 1 <=0;
//The following ranges for the variables were used
//0.05 <= d <= 2.0, 0.25<= D <=1.3, 2.0<=N<=15.0 
//
//Ref:Arora, J. S.. Introduction IO optimum design New York McGraw-Hill, 1989
//======================================================================                
// Copyright (C) 2018 - IIT Bombay - FOSSEE
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
// Author:Debasis Maharana
// Organization: FOSSEE, IIT Bombay
// Email: toolbox@scilab.in
//======================================================================
clc;

function y = spring(x)
    y = (x(3)+2)*x(1)^2*x(2);
endfunction

function [C,Ceq] = Nonlinconstraint(x)
    C(1) = 1-x(2)^3*x(3)/(71785*x(1)^4);
    C(2) = 1-140.45*x(1)/(x(2)^2*x(3));
    C(3) = (4*x(2)^2-x(1)*x(2))/(12566*(x(1)^3*x(2)-x(1)^4)) + 1/(5108*x(1)^2)-1;
    Ceq = [];C = C';
endfunction

function f = fGrad(x)
    f = [2*x(1)*x(2)*(x(3)+2) x(1)^2*(x(3)+2) x(1)^2*x(2)];
endfunction

mprintf('minimizing the weight of a tension/compression spring ');
mprintf('\n\n Design variables include mean coil diameter:D, the wire diameter:d and the number of active coils:N ');
disp('The objective is :( N + 2)*D*d^2');
mprintf('\nNon-linear constraints are on minimum deflection, shear stress, surge frequency,');
mprintf('\nlinear constraint is on outside diameter');


A = [1 1 0];
b = 1.5;
mprintf('Bounds on the variable are as follows');

lb = [0.05 0.25 2];
ub = [2 1.3 15];
table = [['bounds', 'lb','ub'];[['d';'D';'N'],string(lb'),string(ub')]];
disp(table);
x0 = lb + rand(1)*(ub-lb);
disp(x0,'Initial Guess is :');

input('press enter to continue');

mprintf('Scilab is solving your problem');
options=list("MaxIter", [1500], "CpuTime", [500], "GradObj", fGrad);

[xopt,fval,exitflag,output] =fmincon(spring, x0,A,b,[],[],lb,ub,Nonlinconstraint,options);

clc
select exitflag
case 0
    mprintf('Optimal Solution Found');
    mprintf('\n\nThe optimal design parameters are d =  %f ,D = %f and N = %f m',xopt(1),xopt(2),xopt(3));
    mprintf('\n\nThe optimal objective is %f ',fval);
    mprintf('\n\nIterations completed %d',output.Iterations);  
    mprintf('\nTotal CPU time %f',output.Cpu_Time);
    mprintf('\nTotal Functional Evaluations %d',output.Objective_Evaluation);
case 1
    mprintf('Maximum Number of Iterations Exceeded. Output may not be optimal');
    input('press enter to view results');
    mprintf('\nThe optimal design parameters are d =  %f ,D = %f and N = %f m',xopt(1),xopt(2),xopt(3));
    mprintf('\nThe optimal objective is %f ',fval);
    mprintf('\nIterations completed %d',output.Iterations);  
    mprintf('\nTotal CPU time %f',output.Cpu_Time);
    mprintf('\nTotal Functional Evaluations %d',output.Objective_Evaluation);
case 2
    mprintf('Maximum amount of CPU Time exceeded. Output may not be optimal.');
    input('press enter to view results');
    mprintf('\nThe optimal design parameters are d =  %f ,D = %f and N = %f m',xopt(1),xopt(2),xopt(3));
    mprintf('\nThe optimal objective is %f ',fval);
    mprintf('\nIterations completed %d',output.Iterations);  
    mprintf('\nTotal CPU time %f',output.Cpu_Time);
    mprintf('\nTotal Functional Evaluations %d',output.Objective_Evaluation);
case 3
    mprintf('Stop at Tiny Step');
    input('press enter to view results');
    mprintf('\nThe optimal design parameters are d =  %f ,D = %f and N = %f m',xopt(1),xopt(2),xopt(3));
    mprintf('\nThe optimal objective is %f ',fval);
    mprintf('\nIterations completed %d',output.Iterations);  
    mprintf('\nTotal CPU time %f',output.Cpu_Time);
    mprintf('\nTotal Functional Evaluations %d',output.Objective_Evaluation);
case 4
    mprintf('Solved To Acceptable Level');
    input('press enter to view results');
    mprintf('\nThe optimal design parameters are d =  %f ,D = %f and N = %f m',xopt(1),xopt(2),xopt(3));
    mprintf('\nThe optimal objective is %f ',fval);
    mprintf('\nIterations completed %d',output.Iterations);  
    mprintf('\nTotal CPU time %f',output.Cpu_Time);
    mprintf('\nTotal Functional Evaluations %d',output.Objective_Evaluation);
case 5
    mprintf('Converged to a point of local infeasibility.');
    input('press enter to view results');
    mprintf('\nThe optimal design parameters are d =  %f ,D = %f and N = %f m',xopt(1),xopt(2),xopt(3));
    mprintf('\nThe optimal objective is %f ',fval);
    mprintf('\nIterations completed %d',output.Iterations);  
    mprintf('\nTotal CPU time %f',output.Cpu_Time);
    mprintf('\nTotal Functional Evaluations %d',output.Objective_Evaluation);
end



