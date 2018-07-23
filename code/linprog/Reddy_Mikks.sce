// This is an infeasible problem example. The original problem has been modified by including demand.
//Ref:H.A. TAHA,"OPERATIONS RESEARCH AN INTRODUCTION",PEARSON-Prentice Hall New Jersey 2007,chapter 2.1
//Reddy Mikks produces both interior and exterior paints from two raw materials, M1 and M2. The following table provides the basic data of the problem
//
//                    tons of raw material per tons of 
//                    --------------------------------
//Raw material        Exterior paint    Interior paint             Maximum daily vailability (tons)
//-------------------------------------------------------------------------------------------------
//M1                      6                   4                               24
//M2                      1                   2                               6
//-------------------------------------------------------------------------------------------------
//Profit per ton          5000                4000
//-------------------------------------------------------------------------------------------------
//A market survey indicates that the daily demand for interior paint cannot exceed that for exterior paint by more than 1 ton.
// Also, There should be minimum production of 6 tons combining both paints(this part is changed from the main problem). Reddy Mikks wants to determine the optimum product mix of interior and exterior paints that maximizes the total daily profit.

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

Nproducts = 2;
Nrawmaterial = 2;
profit_product  =[5000 4000];
product_Mix = [6 1;4 2];
Raw_avail = [24 6];
mprintf('Data received')
mprintf('Number of product %d',Nproducts);
mprintf('Number of Raw materials %d',Nrawmaterial);
FirstR = ['Product 1','Product 2','available'];
Raw_mat = ['M1','M2'];
table = [['Raw material' FirstR];[Raw_mat' string(product_Mix') string(Raw_avail') ]];
disp(table);
input('Enter to proceed ') ;

for i = 1:Nproducts
    A(i,:) = product_Mix(:,i)';
    b(i) = Raw_avail(i);
end

// market restriction
A = [A;[-1 1;-1 -1]];
b = [b(:);1;-6];
lb = zeros(1,Nproducts);
ub = [%inf %inf];
C = profit_product;

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
    mprintf('Primal Infeasible')
    y = A*xopt-b;
    if sum(y(1:Nrawmaterial))>0
        mprintf('\nInsufficient raw material');
    else
        mprintf('\nCan not meet market constraint');
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

