//A practical problem of factory planning which determines the optimum product
// mix subject to production capacity and marketing limitation. 
//This example shows how to use spreadsheet data directly in scilab. 
//Ref: H. Paul Williams ,Model Building in Mathematical Programming ,
//A John Wiley & Sons, Ltd., Publication, Fifth Ed, Chapter 12.
//
//Example: An engineering factory makes seven products (PROD 1 to PROD 7) on the
//following machines: four grinders, two vertical drills, three horizontal drills, one
//borer and one planer. Each product yields a certain contribution to profit (defined
//as £/unit selling price minus cost of raw materials). These quantities (in £/unit)
//together with the unit production times (hours) required on each process are given
//below. A dash indicates that a product does not require a process.
//---------------------------------------------------------------------------------------
//                            Prod 1  Prod 2  Prod 3  Prod 4  Prod 5  Prod 6  Prod 7
//
//Contribution to profit       10       6       8       4       11      9       3
//Grinding                     0.5      0.7     -       -       0.3     0.2     0.5
//Vertical drilling            0.1      0.2     -       0.3     -       0.6     -
//Horizontal drilling          0.2      -       0.8     -       -       -       0.6
//Boring                       0.05     0.03    -       0.07    0.1     -       0.08
//Planing                       -       -       0.01    -       0.05    -       0.05
//--------------------------------------------------------------------------------------
//In the present month (January) and the five subsequent months, certain
//machines will be down for maintenance. These machines will be as follows:
//--------------------------------------------    
//January     1 Grinder
//February    2 Horizontal drills
//March       1 Borer
//April       1 Vertical drill
//May         1 Grinder and 1 Vertical drill
//June        1 Planer and 1 Horizontal drill
//--------------------------------------------
//
//There are marketing limitations on each product in each month. These are
//given in the following table:
//-------------------------------------------
//             1    2   3   4   5    6   7
//-------------------------------------------             
//January     500 1000 300 300 800  200 100
//February    600 500  200 0   400  300 150
//March       300 600  0   0   500  400 100
//April       200 300  400 500 200  0   100
//May         0   100  500 100 1000 300 0
//June        500 500  100 300 1100 500 60
//-------------------------------------------
//
//The factory works at six days a week with two shifts of 8 h each day.
//When and what should the factory make in order to maximise the total profit? 
//This problem considers single period only with no storage

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
clc

filepath = 'C:\Users\Iball\Desktop\scilab problems\Date 21-05-2018-Debasis\factory.xls';
[fd,SST,Sheetnames,Sheetpos] = xls_open(filepath);
S = readxls(filepath);
[Contributation,TextInd] = xls_read(fd,Sheetpos(Sheetnames == 'Contributation')); //Sheetpos gives the position of all the sheets
[Available,TextInd] = xls_read(fd,Sheetpos(Sheetnames == 'Available'));
[Failure,TextInd] = xls_read(fd,Sheetpos(Sheetnames == 'Machine Failure'));
[Limitation,TextInd] = xls_read(fd,Sheetpos(Sheetnames == 'Limitation'));
mclose(fd) //close the file

Sheetdata = readxls(filepath);
mprintf('Problem Data received\n')
for i = 1:4
    disp(Sheetnames(i))
    disp(Sheetdata(i))
end
input('press enter to continue')
clc
mprintf('Scilab is solving your problem')
Shift_T = 8;N_shift = 2;N_Workingdys = 24;//Data is fixed according to example. However it can be made as user defined parameter

Wrk_hrs = Shift_T*N_shift*N_Workingdys;

[Nmonth,Nprod] = size(Limitation);

Nprod = Nprod - 1; 
Nmonth = Nmonth - 1;
Ntype = size(Available,'r');

Available = Available(:,2);

Contributation = Contributation(2:Ntype+2,2:Nprod+1);// Extracting the data matrix only
Limitation = Limitation(2:Nmonth+1,2:Nprod+1); 
Failure = Failure(2:Nmonth+1,2:Ntype+1);
Failure(isnan(Failure))=0;

ub = [];
for i = 1:Ntype
    Amonth(i,:) =  Contributation(i+1,:);
    breq(i) = Available(i)*Wrk_hrs;  
end
b = [];A = zeros(Nmonth*Ntype,Nmonth*Nprod);C = [];lb = zeros(1,Nmonth*Nprod);

// Instead of seperate loops, we can use a single loop for determining all the possible variables
for  i = 1:Nmonth
    A((i-1)*Ntype+1:i*Ntype,(i-1)*Nprod+1:i*Nprod) = Amonth;
    B_month = breq - (Failure(i,:))'*Wrk_hrs;
    b = [b;B_month];   
    C = [C;-Contributation(1,:)'];
    ub = [ub Limitation(i,:)];
end

intcon = 1:Nmonth*Nprod; // all production units are integers
options = list("time_limit", 2500);
[xopt,fopt,status,output] = symphonymat(C,intcon,A,b,[],[],lb,ub,options);
clc
select status
case 227 then
    mprintf('Optimal Solution Found')
case 228 then
    mprintf('Maximum CPU Time exceeded')
case 229 then
    mprintf('Maximum Number of Node Limit Exceeded')
else
    mprintf('Maximum Number of Iterations Limit Exceeded')
end
input('Press enter to view results')
// Solution representation
A2 = ['January','Februry','March','April','May','June']';// users can modify it to accept from the excel sheet 
A1 = [" ", 'Prod1','Prod2','Prod3','Prod4','Prod5','Prod6','Prod7'];

for i = 1:Nmonth
    solution(i,:) = string(xopt((i-1)*Nprod+1:i*Nprod)'); 
end

mprintf('Production schedule for all the months')

table = [A1;[A2 solution]];
disp(table)
mprintf('The profit is %d',-fopt)


