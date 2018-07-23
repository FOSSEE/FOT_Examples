//Three carts interconnected by springs, are subjected to the loads P1, P2, and P3. The displacementas of the carts can be found by minimizing the potential energy of the system.
//
//f = 0.5X'[K]X - X'P
//
//where [K] = [k1+k4+k5  -k4           -   k5
//            -k4         k(2)+k(4)+k(6)  -k6
//            -k5        -k(6)             k3+k5+k6+k7+k8 ]
//The following data is given: k1 = 5000 N/m , k2 = 1500 N/m,
//k3 = 2000 N/m, k4 = 1000 N/m, k5 = 2500 N/m, k6 = 500 N/m, k7 = 3000 N/m, k8 = 3500 N/m
//P1 = 1000 N/m, P2 = 2000 N/m and P3 = 3000 N/m.
//The optimum displacement is x = [0.3241 0.8360 0.3677];
//Reference: Rao, S. S. (2009). Engineering Optimization: Theory and Practice: Fourth Edition. John Wiley and Sons.  Chapter 6.DOI: 10.1002/9780470549124.

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

clc
// Given data
k = [5000 1500 2000 1000 2500 500 3000 3500];
p = [1000 2000 3000];

Kval = [k(1)+k(4)+k(5)  -k(4)           -k(5)
       -k(4)           k(2)+k(4)+k(6)  -k(6)
       -k(5)          -k(6)             k(3)+k(5)+k(6)+k(7)+k(8) ]
            

//Initial Guess
x0 = [1 1 1];

//Unconstraint,unbounded and continuous problem. Hence the values of intcon,bounds and constraints are giben empty matrices
//Setting Iteration and cpu time in options
options = list("MaxIter", 100, "CpuTime", 100);

//calling the optimization solver
[xopt,fopt,exitflag,output] = intqpipopt(Kval,-p,[],[],[],[],[],[],[],x0,options)

clc
//Result display
select exitflag
case 0
disp("Optimal Solution Found")
printf('\n The displacement of the three springs are \n x1 = %f\n x2 = %f\n x3 = %f',xopt(1),xopt(2),xopt(3));
printf('\nThe potential energy of the system is %f',fopt)
printf('\nThe constraint violation is %f',output.ConstrViolation)
case 1
     disp("InFeasible Solution")
     printf('\nThe constraint violation is %f',output.ConstrViolation)
case 2 
     disp("Objective Function is Continuous Unbounded.")
     printf('\nThe constraint violation is %f',output.ConstrViolation)
case 3
    disp("Limit Exceeded.")
    printf('\nThe constraint violation is %f',output.ConstrViolation)
case 4
    disp("User Interrupt.")
case 5 
    disp("MINLP Error.")
end

