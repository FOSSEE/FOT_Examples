//Employee Scheduling
//Macrosoft has a 24-hour-a-day, 7-days-a-week toll free hotline that is being set up to answer questions regarding a new product.  The following table summarizes the number of full-time equivalent employees (FTEs) that mustbe on duty in each time block.
//
//Interval    Time    FTEs
//   1        0-4      15
//   2        4-8      10
//   3        8-12     40
//   4        12-16    70
//   5        16-20    40
//   6        20-0     35
//Macrosoft may hire both full-time and part-time employees. The former work 8-hour shifts and the latter work 4-hour shifts; their respective hourly wages are $15.20 and $12.95. Employees may start work only at the beginning of 1 of the 6 intervals.Part-time employees can only answer 5 calls in the time a full-time employee can answer 6 calls.  (i.e., a part-time employee is only 5/6 of a full-time employee.) At least two-thirds of theemployees working at any one time must be full-time employees.Formulate an LP to determine how to staff the hotline at minimum cost. 

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

Interval = 1:6;
Time = 0:4:20;
FTEs = [15 10 40 70 40 35];
intr = [];
Ninterval = length(Interval);
for i = 1:Ninterval-1
    intr = [intr;strcat([string(Time(i)),'-',string(Time(i+1))])];
end

intr = [intr;strcat([string(Time(i)),'-',string(Time(1))])];

table = [['Interval','Time','Full-time Emp Req'];[string(Interval'),intr,string(FTEs')]];
mprintf('Data received');
disp(table);
input('press enter to proceed');

A1 = zeros(Ninterval,2*Ninterval);b1 = zeros(Ninterval,1);
A2 = zeros(Ninterval,2*Ninterval);b2 = zeros(Ninterval,1);
A1(1,[1 Ninterval Ninterval+1]) = [-1 -1 -5/6]; b1(1) = -15;
A2(1,[1 Ninterval Ninterval+1]) = [-1/3 -1/3 2/3];        
for i = 2:Ninterval
    A1(i,i-1:i) = -1;
    A1(i,Ninterval+i) = -5/6;
    b1(i) = -FTEs(i);

    A2(i,i-1:i)=-1/3;
    A2(+i,Ninterval+i)=2/3;
end
A= [A1;A2];b = [b1;b2];
Cost = [15.20*8*ones(1,Ninterval) 12.95*4*ones(1,Ninterval)]';
lb = zeros(1,2*Ninterval);ub = [];
[xopt,fopt,exitflag,output,lambda] = linprog(Cost,A,b,[],[],lb,ub)

clc
select exitflag
case 0 then
    mprintf('Optimal Solution Found')
    input('Press enter to view results')
    //Display results
    mprintf('Total Cost is %d\n',-fopt);
    table(:,4:5) = [['Full time Emp', 'Part-Time Emp'];[string(xopt(1:6)) string(xopt(7:12))]];
    disp(table);
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



