//Reference: J.K. Sharma,"OPerations Research Theory and Applications", Macmillan Publishers India Ltd., 5th edition, 2013, Chapter 4.

//An Air Force is experimenting with three types of bombs P,Q and R in which three kinds of explosives, viz., A, B and C will be used. Taking the various factors into account, it has been decided to use the maximum 600 kg of explosive A, at least 480 kg of B and exactly 540 kg of explosive C. Bomb P requires 3,2,2 kg, bomb Q requires 1,4,3 kg and bomb R requires 4,2,3 kg of explosives A,B and C respectively. Bomb P is estimated to give the equivalent of a 2 ton explosion, bomb Q, a 3 ton of explosion and bomb R, a 4 ton of explosion respectively. Under what production schedule can the Air Force make the biggest bang?
//=============================================================================
// Copyright (C) 2018 - IIT Bombay - FOSSEE
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
// Author: Remya Kommadath
// Organization: FOSSEE, IIT Bombay
// Email: toolbox@scilab.in
//============================================================================

clc; 
// =============================Primal Model===================================
nVar = 3;

// Linear inequalities
A = [3 1 4; -2 -4 -2];
b = [600 -480]';
nIneqCon = length(b);

// Linear equality
Aeq = [2 3 3];
beq = 540;
nEqCon = length(beq);

lb = zeros(1,nVar);
ub = [];

Cost = -[2 3 4 ]';

// =============================Dual Model===================================

// Inequality constraints
dual_A =  -[A;Aeq]';
dual_beq = Cost;
n_dualIneq = length(dual_beq);
Coeff_Slack = [eye(n_dualIneq,n_dualIneq);];
dual_Aeq = [dual_A Coeff_Slack];
dual_Cost = [b;beq; zeros(n_dualIneq,1)];

dual_nVar = length(dual_Cost);
lb = [zeros(1,nIneqCon) -%inf*ones(nEqCon) zeros(1,(dual_nVar-nIneqCon-nEqCon))];
ub = [];

[xopt,fopt,exitflag,output,lambda]=linprog(dual_Cost, [],[], dual_Aeq, dual_beq, lb,ub);
clc

select exitflag
case 0
    disp(xopt(1:nIneqCon+nEqCon)',"Dual values of the primal constraints")
    disp(xopt(nIneqCon+nEqCon+1:dual_nVar)',"Dual values of the primal variables")
    TopRow = ["Variable     "  "Rate of change in optima"];
    Table = string([(1:length(xopt))' -xopt]);
    disp("The change in optima due to one unit increase in each variables are given as below")
    disp([TopRow;Table])
    disp(["The optimal cost is ", string(fopt)])
case 1
    disp("Primal Infeasible")
case 2
    disp("Dual Infeasible")
case 3
    disp("Maximum Number of Iterations Exceeded. Output may not be optimal")
case 4
    disp("Solution Abandoned")
case 5
    disp("Primal objective limit reached")
case 6
    disp("Dual objective limit reached")
end
