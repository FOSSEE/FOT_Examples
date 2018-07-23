//Reference : Dantzig G. B., Linear Programming and Extensions, Princeton University Press, Princeton, New Jersey, 1963, Chapter 3-3.

//The objective of the problem is to minimize the transportation cost of goods from the canneries to the warehouses,by satisfying the supply and demand constraints. Inorder to simplify the problem, it is assumed that there are two canneries and three warehouses. The supply data of canneries are as follows
// =============================
//              Supply
// Cannery I     350
// Cannery II    650
// =============================
//The demands at the warehouses are as given
// =============================
//               Demand
// Warehouse A    300
// Warehouse B    300
// Warehouse C    300
// =============================
//ShippingCost between the canneries and warehouses are
// =========================================================
//             Warehouse A     Warehouse B     Warehouse C
// =========================================================
// Cannery I       2.5             1.7             1.8
// Cannery II      2.5             1.8             1.4
// =========================================================
// It should be noted that, this case is solved without considering the inventory.
//
//===========================================================================
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

nCanneries = 2;
nWarehouses = 3;
ShippingCost = [2.5 1.7 1.8; 2.5 1.8 1.4];
demand = [300 300 300]'; 
supply = [350 650]';

nVar = nCanneries*nWarehouses;
lb = zeros(1,nVar); // lower bounds of the amount of commodity to be shipped from each canneries to warehouses;

// Linear inequality constraints
// Total supply to the warehouses from a cannery should not exceed the corresponding supply limit of the same cannery
for i = 1:nCanneries
    indeX = (i-1)*nWarehouses+1:i*nWarehouses;
    As(i,indeX) = ones(1,nWarehouses);
end
Bs = supply;
As
// Total supply to a warehouses from the canneries should satisfy the corresponding demand of the same warehouses
//Ad = zeros()
for i = 1:nWarehouses
    indeX = i:nWarehouses:nVar;
    Ad(i,indeX) = -1;
end
Bd = -demand;

A = cat(1,As,Ad);
b = cat(1,Bs,Bd);

// Minimize the total transportation cost between all plants and markets
Cost = zeros(nVar,1);
for i = 1:nCanneries
    indeX = (i-1)*nWarehouses+1:i*nWarehouses;
    Cost(indeX) = (ShippingCost(i,:)');
end

[xopt,fopt,exitflag,output,lambda] = linprog(Cost,A,b,[],[],lb,[]);

// Display of results
select exitflag
case 0
    disp(" Optimal Solution Found")
    // xopt is transformed into a nCanneries X nWarehouses sized string matrix 
    for i = 1:nCanneries
        indeX = (i-1)*nWarehouses+1:i*nWarehouses;
        X(i,1:nWarehouses) = xopt(indeX,1)';
    end
    Values = string(X);

    // Labelling each markets as M_1,M_2,...,M_nWarehouses
    Markets(1,1) = [" "];
    for j = 2:nWarehouses+1
        Markets(1,j) = strcat(["M_",string(j-1)]);
    end

    // Labelling each plants as P_1,P_2,...,P_nCanneries
    for i = 1:nCanneries
        Plants(i) = strcat(["P_",string(i)]);
    end

    table = [Markets; [Plants Values]];
    f = gcf();
    clf
    as = f.axes_size; // [width height]
    ut = uicontrol("style","table",..
    "string",table,..
    "position",[150 as(2)-220 300 87]) // => @top left corner of figure


    // Modify by hand some values in the table. Then get them back from the ui:
    matrix(ut.string,size(table))
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
