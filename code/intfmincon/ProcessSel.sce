//This is an MINLP example.The solution to the problem is Y1=1,Y2=0;Y3=1;C1=1;B1=1.111;B2=0;B3=1.111;BP=0;A2=0;A3=1.52;
//Netprofit = 1.923 (10^3$/hr))
//Ref:Optimization of chemical processes, second edition. By Thomas F. Edgar, David M. Himmelblau, and Leon S. Lasdon, McGraw Hill, New York, 2001, Chapter 9
//The manufacture of a chemical C in process 1 that uses raw material B.B can either be purchased or
//manufactured via two processes, 2 or 3, both of which use chemical A as a raw mate-rial.Data and 
//specifications for this example problem, involving several nonlinear input4utput relations (mass balances),
//are shown in Table.We want to deter-mine which processes to use and their production levels in order to 
//maximize profit.The processes represent design alternatives that have not yet been built. Their fixed
//costs include amortized design and construction costs over their anticipated lifetime,which are incurred
//only if the process is used
//    
//    A2------Process2-------------B2
//    A1------Process3-------------B3
//    B2+B3+BP---------------------B1
//    B1------Process1-------------C1
//    
//Problem Data
//Conversions         Process         1       C = 0.9B
//                    Process         2       B = ln(1+A)
//                    Process         3       B = 1.2ln(1+A)   (A,B,C in tons)
//                    
//Maximum Capacity    Process         1       2 ton/h of C
//                    Process         1       4 ton/h of B
//                    Process         1       5 ton/h of B
//                    
//Price       A: $1800/ton
//            B: $7000/ton
//            C: $13000/ton
//            
//Demand of C: 1 ton/h maximum
//Costs:
//---------------------------------------------------------------------------------
//                    Fixed(10^3 $/hr)        variable (10^3 $/ton of product)
//Process 1           3.5                             2
//Process 1           1                               1
//Process 1           1.5                             1.2
//---------------------------------------------------------------------------------
////======================================================================                
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
//Objective function to calculate profit
function costval = ProcessSel(x)
    Y1 = x(1);Y2 = x(2);Y3 = x(3);
    C1 = x(4);B1 = x(5);B2 = x(6);
    B3 = x(7);BP = x(8);A2 = x(9);A3 = x(10);

    Income = 13*C1;
    Purchase = 7 * BP;
    Chemical = 1.8*A2 + 1.8*A3;
    Invest = 3.5*Y1 + 2*C1 + Y2 + B2 + 1.5*Y3 + 1.2*B3;

    costval = -(Income - (Purchase + Chemical + Invest));
endfunction

//Nonlinear constraint function
function [C,Ceq] = Nonlincon(x)
    Y1 = x(1);Y2 = x(2);Y3 = x(3);
    C1 = x(4);B1 = x(5);B2 = x(6);
    B3 = x(7);BP = x(8);A2 = x(9);A3 = x(10);
    //No Non-linear inequality constraint
    C = [];
    Ceq(1) = C1-0.9*B1;    
    Ceq(2) = B2-log(1+A2);
    Ceq(3) = B3 - 1.2*log(1+A3);

endfunction

// Decision vector structure
//  Y1 = x(1);Y2 = x(2);Y3 = x(3);C1 = x(4);B1 = x(5);B2 = x(6);B3 = x(7);BP = x(8);A2 = x(9);A3 = x(10);

//Inequality constraints
A = [0 -4 0 0 0 1 0 0 0 0
0 0 -5 0 0 0 1 0 0 0
-2 0  0 1 0 0 0 0 0 0];

b = zeros(3,1);

//Equality Constraint
Aeq = [0 0 0 0 1 -1 -1 -1 0 0;];
beq = 0;
//Number of variables
Var = 10;
//Capacity Constraints are used for deciding upper bounds of variables
C1max = 1;
B2max = 4;
B3max = 5;

A2max = exp(B2max)-1;
A3max = exp(B3max/1.2)-1;
B1max = C1max/0.9;
BPmax = B1max;

//Bounds on variables
lb = zeros(1,Var);
// Important to give proper UB as otherwise solution might become sub optimal
//users can try ub  = [1 1 1 1 %inf %inf %inf %inf %inf %inf];

ub  = [1 1 1 C1max B1max B2max B3max BPmax A2max A3max];
//Initial guess 
x0 = lb;
//Integer ariables
intcon = [1 2 3];
mprintf('The decision variables and their bounds are")

var = ['Y1','Y2','Y3','C1','B1','B2','B3','BP','A2','A3'];
Table = [['Variables','lower Bound','Upper Bound'];[var' string(lb') string(ub')]];
disp(Table)

input("Press enter to solve the problem");
clc
//Using intfmin for solving MINLP
mprintf("Scilab is solving the problem")
[xopt,fopt,exitflag,gradient,hessian]= intfmincon(ProcessSel,x0,intcon,A,b,Aeq,beq,lb,ub,Nonlincon)
clc;
Y1 = xopt(1);Y2 = xopt(2);Y3 = xopt(3);C1 = xopt(4);B1 = xopt(5);B2 = xopt(6);
B3 = xopt(7);BP = xopt(8);A2 = xopt(9);A3 = xopt(10);

select exitflag
case 0 
    mprintf("Optimal Solution Found");
    mprintf("\n Net profit is %f $ \n Net production is : %f ton/hr",-fopt*1000,C1)
    mprintf("\n The following production process should be followed \n")
    mprintf("\n Amount of raw material A2: %f ton/hr \n Amount of raw material A3: %f ton/hr \n amount of B1 purchased : %f ton/hr",A2,A3,B1)

case 1
    mprintf("InFeasible Solution.");
case 2
    mprintf("Objective Function is Continuous Unbounded.");
case 3
    mprintf("Limit Exceeded.");
case 4
    mprintf("User Interrupt");
case 5
    mprintf("MINLP Error")
end



