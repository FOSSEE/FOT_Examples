// Example problem for sensitivity analysis - using duality theorem to determine the reduced cost

//Reference : Bradley, Hax, and Magnanti,"Applied Mathematical Programming", Addison-Wesley, 1977, chapter 3 

//A custom molder has one injection-molding machine and two different dies to fit the machine. Due to differences in number of cavities and cycle times, withthe first die he can produce 100 cases of six-ounce juice glasses in six hours,while with the second die he can produce 100 cases of ten-ounce fancy cocktail glasses in five hours. The molder is approached by a new customer to produce a champagne glass. The production time for the champagne glass is 8 hours per hundred cases. He prefers to operate only on a schedule of 60 hours of production per week. He stores the week’s production in his own stockroom where he has an effective capacity of 15,000 cubic feet. A case of six-ounce juice glasses requires 10 cubic feet of storage space, while a case of ten-ounce cocktail glasses requires 20 cubic feet due to special packaging.The storage space required for the champagne glasses is 10 cubic feet per one case. The contribution of the six-ounce juice glasses is $5.00 per case; however, the only customer available will not accept more than 800 cases per week. The contribution of the ten-ounce cocktail glasses is $4.50 per case and there is no limit on the amount that can be sold where as the contribution of champagne glasses is $6.00 per case with no limit on the bound. How many cases of each type of glass should be produced each week in order to maximize the total contribution?
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
// -----------------------------Primal model-------------------------------
nProducts = 3;
TotalProcessingTime = 60;
RequiredTime = [6 5 8];
StokeRoomCapacity = 15000;
RequiredSpace = [10 20 10]*100;
Demand = 8; 
Revenue = [5 4.5 6];
nVar = 3 // Each variable indicates number of hundreds of units of each product

// Linear constraints
// Processing time constraint
A1 = RequiredTime;
b1 = TotalProcessingTime;
// Space constraint
A2 = RequiredSpace;
b2 = StokeRoomCapacity;
// Demand constraint
nDemand = length(Demand);
A3 = eye(nDemand,nVar);
b3 = Demand';

A = [A1;A2;A3]; b = [b1;b2;b3];

//Addition of slack variables
nInEqConstraints = length(b);
Aeq = eye(nInEqConstraints,nInEqConstraints);
Aeq = [A Aeq];
beq = b;

Cost = -[Revenue zeros(1,nInEqConstraints)]';

// -------------------------------Dual model------------------------------
dualA = -A';
dualb = Cost(1:nVar);

dual_nInEqConstraints = length(dualb);
dualAeq = eye(dual_nInEqConstraints,dual_nInEqConstraints);
dualAeq = [dualA dualAeq];
dualbeq = dualb;
dualCost = beq;
dualCost = [dualCost; zeros(dual_nInEqConstraints,1)];
dual_nVar = length(dualCost);
dual_lb = zeros(1,size(dualAeq,2));

[dual_xopt,dual_fopt,dual_exitflag,dual_output,dual_lambda] = linprog(dualCost,[],[], dualAeq, dualbeq, dual_lb,[]);
clc;
select dual_exitflag
case 0
    disp(dual_xopt(1:nInEqConstraints)',"Dual values of the primal constraints")
    disp(dual_xopt(nInEqConstraints+1:dual_nVar)',"Dual values of the primal variables")
    TopRow = ["Variable     "  "Rate of change in optima"];
    Table = string([(1:length(dual_xopt))' -dual_xopt]);
    disp("The change in optima due to one unit increase in each variables are given as below")
    disp([TopRow;Table])
    disp(["The optimal cost is ", string(dual_fopt)])
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
