//This is an infeasible model
//Ref:H.A. TAHA,"OPERATIONS RESEARCH AN INTRODUCTION",PEARSON-Prentice Hall New Jersey 2007,chapter 3.5
//Example:
//Toolco produces three types of tools, T1,T2 and T3. The tools use two rawmaterials, M1 and M2, according to the data in the following table:
//--------------------------------------------------------------------
//                            Number of units of raw materials per tool
//                            -----------------------------------------
//Raw material                 T1                 T2                T2
//---------------------------------------------------------------------
//M1                           3                  5                 6
//M2                           5                  3                 4
//---------------------------------------------------------------------
//The available daily quantites of raw materials M1 and M2 are 1000 units and 1200 units, respectively. The marketing department informed the production manager that according to their research , the daily demand for all three tools must be at least 500 units. will the manufacturing department be able to satisfy the demand?

// Copyright (C) 2015 - IIT Bombay - FOSSEE
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

Nraw = 2;
Nproduct = 3;
Product_mix = [3 5 6;5 3 4];
Raw_avail = [1000 1200];
Demand = [500 500 500];

mprintf('Data received')
mprintf('Number of product %d',Nproduct);
mprintf('Number of Raw materials %d',Nraw);
FirstR = ['Product 1','Product 2','Product 3','Available']
Raw_mat = ['M1','M2'];

table = [['Raw materisl' FirstR];[Raw_mat' string(Product_mix) string(Raw_avail') ]];
disp(table);
input('Enter to proceed '); 

for i = 1:Nraw
    A(i,:) = Product_mix(i,:);
    b(i) =  Raw_avail(i);
end
A = [A;-eye(Nproduct,Nproduct)];
b = [b;-500*ones(Nproduct,1)];

lb = zeros(1,Nproduct);//Redudant due to demand
ub = [];
C = ones(1,Nproduct);
[xopt,fopt,exitflag,output,lambda] = linprog(-C',A,b,[],[],lb,ub);

clc
select exitflag
    //Display result
case 0 then
    mprintf('Optimal Solution Found')
    input('Press enter to view results')
    disp('Paint produced')
    mprintf('\nExterior paint %d\t interior paint %d',xopt(1),xopt(2));
case 1 then
    mprintf('Primal Infeasible\n')
    y = A*xopt-b;
    if sum(y(1:Nraw))>0
        mprintf('\nInsufficient raw material');
    else
        mprintf('\nCan not meet market demand');
    end
case 2 then
    mprintf('Dual Infeasible')
case 3
    mprintf('Maximum Number of Iterations Exceeded. Output may not be optimal')
case 4
    mprintf('Solution Abandoned')
case 5
    mprintf('Primal objective limit reached')
else
    mprintf('Dual objective limit reached')
end

