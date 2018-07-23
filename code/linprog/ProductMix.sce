//Refernce: H.P. Williams,"Model building in mathematical programming",Fifth Edition,AJohn Wiley & Sons, Ltd., Publication,2013, chapter 1.2

//An engineering factory can produce five types of product (PROD 1, PROD 2,... , PROD 5) by using two production processes: grinding and drilling. After deducting raw material costs, each unit of each product yields the following contributions to profit:
// =====================================================
// PROD1       PROD2       PROD3       PROD4       PROD5
//  550         600         350         400         200
// =====================================================
//Each unit requires a certain time on each process. These are given below (in
//hours). A dash indicates when a process is not needed.
// =================================================================
//            PROD1       PROD2       PROD3       PROD4       PROD5
// -----------------------------------------------------------------
// Grinding    12          20           -           25          15
// Drilling    10           8          16            -           -
// =================================================================
//In addition, the final assembly of each unit of each product uses 20 hours of
//an employee’s time. The factory has three grinding machines and two drilling machines and works a six-day week with two shifts of 8 hours on each day. Eight workers are employed in assembly, each working one shift a day. The problem is tofind how much of each product is to be manufactured so as to maximize the totalprofit contribution. The minimum demand for each product is added to this problem and details are as follows
// =================================================================
//            PROD1       PROD2       PROD3       PROD4       PROD5
// -----------------------------------------------------------------
// Demand       5           5           2           7           2
// =================================================================

//=============================================================================
// Copyright (C) 2015 - IIT Bombay - FOSSEE
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
nProducts = 5;
nMachines = [3 2];
nWorkers = 8;
nDays = 6;
nHours = 8;
nMachineShift = 2;
nWorkerShift = 1;
prodProfit = [550 600 350 400 200]';
ProcessingTime = [12 20 0 25 15; 10 8 16 0 0; 20*ones(1,nProducts)];

// Linear inequalities
A1 = ProcessingTime;
b1 = (nDays*nHours)*[nMachines*nMachineShift nWorkers*nWorkerShift]';
// Demand constraints
A2 = [-1 0 0 0 0;0 -1 0 0 0;0 0 -1 0 0; 0 0 0 -1 0; 0 0 0 0 -1];
b2 = [-5 -5 -2 -7 -2]';

A = [A1;A2];
b = [b1;b2];
lb = zeros(1,nProducts); 
Cost = -prodProfit;
[xopt,fopt,exitflag,output,lambda]=linprog(Cost, A, b, [], [], lb,[]);

// Result representation
select exitflag
case 0
    disp(" Optimal Solution Found")
    P = [];
    for p = 1:nProducts
        P = [P strcat(["PROD",string(p)])];
    end

    disp([P;string(xopt')]);
    disp(["The optimal cost is ", string(fopt)])
case 1
    disp("Primal Infeasible")
    nViolatedConstraints = sum(A*xopt-b>0)
    if nViolatedConstraints
        disp(strcat(["No of constraints violated : ", string(nViolatedConstraints)]));
    end
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
