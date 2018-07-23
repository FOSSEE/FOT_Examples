//This example shows the use of slack  or surplus variables  and their sigificance on the  model
//Ref:H.A. TAHA,"OPERATIONS RESEARCH AN INTRODUCTION",PEARSON-Prentice Hall New Jersey 2007,chapter 2.1
//Example: 
//TOYCO assembels three types of toys-trains,trucks and cars using three operations. the daily limits on the available times for the three operations are 430,460 and 420 minutes respectively. The revenues per unit of toy train, truck and car are $3.$2 and $5 respectively. The corrosponding times per train and per car are (2,0,4) and (1,2,0) minutes ( a zero time indicates that the operation is not used). determine the optimum production rate to maximize profit. Check any surplus resource availability.

// Copyright (C) 2018 - IIT Bombay - FOSSEE
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
// Author:Debasis Maharana
// Organization: FOSSEE, IIT Bombay
// Email: toolbox@scilab.in
//=================================================================================

clc;

Nproducts = 3;
Noperations = 3;
revenue = [3 2 5];
resource = [430 460 420];
Assembly_time = [1 3 1;2 0 4;1 2 0];
mprintf('Data Received')
prodNam = ['Trains','Trucks','cars']';
Operation = ['Operation 1','Operation 2','Operation 3'];
table = [['Products',Operation,'Revenue'];[prodNam,string(Assembly_time),string(revenue)'];['Resource',string(resource),'']];
disp(table)
input('Press enter to proceed ')

NequalCon = Noperations;
Aeq = zeros(NequalCon,Nproducts+Noperations);
for i = 1:Noperations
    Aeq(i,1:Nproducts) = Assembly_time(:,i)';
    beq(i) = resource(i);
    Aeq(i,i+Nproducts) = 1;
end

C = -[revenue zeros(1,Nproducts)];
lb= zeros(1,2*Noperations);
ub = [];

[xopt,fopt,exitflag,output,lambda] = linprog(C',[],[],Aeq,beq,lb,[]);
clc;
select exitflag
    //Display result
case 0 then
    mprintf('Optimal Solution Found');
    input('Press enter to view results');clc;
    mprintf('Revenue Generated %d\n',-fopt);
    disp(xopt(1:Nproducts)','Optimal Number of  Trains Trucks and Cars');
    disp(xopt(Nproducts+1:Nproducts+NequalCon)','Surplus resource available among 3 resources');
    beq = beq-xopt(Nproducts+1:Nproducts+NequalCon);
    disp(beq','Minimum Constraint boundry for Current optima');
case 1 then
    mprintf('Primal Infeasible')
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
