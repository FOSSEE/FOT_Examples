//This example shows the use of duality  theorm to determine the reduced cost associated with the non-negative constraints 
//Ref:H.A. TAHA,"OPERATIONS RESEARCH AN INTRODUCTION",PEARSON-Prentice Hall New Jersey 2007,chapter 2.1
//Example: 
//TOYCO assembels three types of toys-trains,trucks and cars using three operations. the daily limits on the available times for the three operations are 430,460 and 420 minutes respectively. The revenues per unit of toy train, truck and car are $3.$2 and $5 respectively. The corrosponding times per train and per car are (2,0,4) and (1,2,0) minutes ( a zero time indicates that the operation is not used). determine the . Determine the shadow pricing and how optima changes with resource change.

//The primal model of the above problem is 
//maximize z = 3*x1 + 2*x2 + 5*x3
//Subject to
//x1 + 2*x2 + x3  <=430
//3*x1      +2*x3 <=460     
//x1 + 4*x2       <=420
//x1,x2,x3 >= 0

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
//primal model constraints
A = Assembly_time';
b = resource';

//dual constraints
dualA = -A';
[Ncons,Nvars] = size(A);
for i = 1:Nvars
    A1(i,i) = 1;
end
dualAeq = [dualA A1];
dualbeq = -revenue'; 
C = [b;zeros(Nvars,1)];
lb= zeros(1,2*Nvars);
ub = [];
[xopt,fopt,exitflag,output,lambda] = linprog(C,[],[],dualAeq,dualbeq,lb,[]);

clc;
select exitflag
    //Display result
case 0 then
    mprintf('Optimal Solution Found');
    input('Press enter to view results');clc;
    mprintf('Revenue Generated %d\n',fopt);
    disp(xopt(1:Ncons)','Dual values of the primal constraints');
    disp(xopt(Ncons+1:Ncons+Nvars)','Dual values of each primal variable');
    for i = 1:Ncons
        mprintf('\n A cost decrease of %d  will occur in the current objective cost value per unit decrease in resource %d ',xopt(i),i)
    end
    for i = 1:Nvars
        mprintf('\n A cost decrease of %d will occur in the current objective cost value per unit increase in variable x%d ',xopt(Ncons+i),i)
    end
    
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





