// This example shows the use of equality constraint and corrosponding unrestricted dual variables
//Example:
//A refinery produces, on average, 1000 gallon/hour of virgin pitch in its crude distillation operation. This pitch may be blended with flux stock to make commercial fuel oil, or it can be sent in whole or in part to a visbreaker unit. The visbreaker produces an 80 percent yield of tar that can also be blended with flux stock to make commercial fuel oil. The visbreaking operation is economically break-even if the pitch and the tar are given no value, that is, the value of the overhead product equals the cost of the operation. The commercial fuel oil brings a realization of 5$/gal, but the flux stock has a cracking value of 8$/gal. This information together with the viscosity and gravity blending numbers and product specifications, appears in the following table. It is desired to operate for maximum profit. 
//
//--------------------------------------------------------------------
//                Quantity available     Value  Viscosity Gravity
//                    (gal/h)           ($/gal)   Bl.No.  Bl. No    
//Pitch               P = 1000-V            0       5       8
//Visbreaker feed     V                   0       -       -
//Tar                 T = 0.8V            0       11      7
//Flux                F = any             8       37      24
//Fuel oil            P + T + F           5       21 min  12 min    
//---------------------------------------------------------------------
//Suggest a operating condition for maximizing  profit.

// The primal model for this example is given as 
//Maximize 5*(P + T + F) - 8*F
//subject to
//            5*P + 11*T + 37*F >= 21*(P + T + F)
//            8*P + 7*T + 24*F >= 12*(P + T + F)
//            P - T/0.8 = 0 

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
//The problem can be execuated using slack variable too.
//Users are encouraged to explore the use of slack variables.

//Variables = [P T F]; Output = Fuel
Viscosity = [5 11 37 21];
Gravity = [8 7 24 12];
Value = [8 5];

A = [16 10 -16;4 5 -12];
b = [0 0]';
Aeq = [0.8 1 0];
beq = 800;
lb = [0 0 0];
ub = [];
C = -[5 5 -3]';
Ncons = 3;Nvar = 3;
//Dual problem
Adual = -[A;Aeq]'; 
bdual = C;
C = [b;beq];
// The varable corrosponding to equality constraint is unrestricted
lb = [0 0 -%inf];
ub = [];
[xopt,fopt,exitflag,output,lambda] = linprog(C,Adual,bdual,[],[],lb,ub);
clc

select exitflag
    //Display result
case 0 then
    mprintf('Optimal Solution Found');
    input('Press enter to view results');clc;
    mprintf('Revenue Generated %d\n',fopt);
    disp(xopt(1:Ncons)','Dual values of the primal constraints');
    
    for i = 1:Ncons
        mprintf('\n A cost decrease of %f  will occur in the current objective cost value per unit decrease in resource %d ',xopt(i),i)
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

