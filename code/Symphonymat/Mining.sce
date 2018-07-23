// This is an example of mixed integer linear programming problem. This problem dimension increases significantly with increase in years or mines.
//Example: A mining company is going to continue operating in a certain area for the next five years. There are four mines in this area, but it can operate at most three in any one year. Although a mine may not operate in a certain year, it is still necessary to keep it ‘open’, in the sense that royalties are payable, if it be operated in a future year. Clearly, if a mine is not going to be worked again, it can be permanently closed down and no moreroyalties need be paid. The yearly royalties payable on each mine kept ‘open’ are as follows:
//                            -----------------
//                            Mine 1 £5 million
//                            Mine 2 £4 million
//                            Mine 3 £4 million
//                            Mine 4 £5 million
//                            ------------------
//There is an upper limit to the amount of ore, which can be extracted from each mine in a year. These upper limits are as follows:
//                            ---------------------
//                            Mine 1 2 × 10^6 tons
//                            Mine 2 2.5 × 10^6 tons
//                            Mine 3 1.3 × 10^6 tons
//                            Mine 4 3 × 10^6 tons
//                            ---------------------
//The ore from the different mines is of varying quality. This quality is measured on a scale so that blending ores together results in a linear combination of the quality measurements, for example, if equal quantities of two ores were combined, the resultant ore would have a quality measurement half way between that of the ingredient ores. Measured in these units the qualities of the ores from the mines are given as follows:
//                            ---------------
//                            Mine 1      1.0
//                            Mine 2      0.7
//                            Mine 3      1.5
//                            Mine 4      0.5
//                            ---------------
//In each year, it is necessary to combine the total outputs from each mine to produce a blended ore of exactly some stipulated quality. For each year, these qualities are as follows:                            
//                            -------------------
//                            Year 1          0.9
//                            Year 2          0.8
//                            Year 3          1.2
//                            Year 4          0.6
//                            Year 5          1.0
//                            -------------------
//The final blended ore sells for £10 ton each year. Which mines should be operated each year and how much should they produce?                      

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

Nmines = 4;
//Royltes = [5e6 4e6 4e6 5e6];
Roylte = [5e6 4e6 4e6 5e6];

ubMines = [2e6 2.5e6 1.3e6 3e6];
Quality = [1 0.7 1.5 0.5];
Quality_blend = [0.9 0.8 1.2 0.6 1];
Nyears = length(Quality_blend);
Royltes = Roylte;
for i = 1:Nyears-1
    Roylte = Roylte*0.9;
    Royltes = [Royltes Roylte];
end



mprintf('Received Data')
mprintf('\nNumber of years to operate %d',Nyears)
mprintf('\nNumber of mines %d',Nmines);
disp(Royltes,'Royalities to be paid for each mine',);
disp(ubMines,'Upper limit of ore available from each mine');
disp(Quality,'Quality of ore from each mine');
input('Press enter to proceed')

//i - mine , t - year 
A = zeros(1,3*Nyears*Nmines+Nyears)
Aeq_quantity = zeros(Nyears,Nyears*(3*Nmines+1));
Aeq_quality = zeros(Nyears,Nyears*(3*Nmines+1));
A_operation = zeros(Nyears,Nyears*(3*Nmines+1));
Aoutput =[];Aopen=[];
boutput = zeros(Nyears*Nmines,1);
bopen = zeros(Nyears*Nmines,1);
beq_quantity = zeros(Nyears,1);
beq_quality = zeros(Nyears,1);

for i = 1:Nyears
    Aeq_quantity(i,(i-1)*Nmines+1:i*Nmines) = 1; 
    Aeq_quantity(i,Nyears*Nmines+i) = -1;
    beq_quantity(i) = 0;

    Aeq_quality(i,(i-1)*Nmines+1:i*Nmines) = Quality ;
    Aeq_quality(i,Nmines*Nyears+i) = -Quality_blend(i);
    beq_quality(i) = 0

    A_operation(i,Nyears*(Nmines+1)+((i-1)*Nmines+1:i*Nmines)) = 1;   
    B_operation(i) = 3;
    A_output = zeros(Nmines,Nyears*(3*Nmines+1));
    for j = 1:Nmines
        A_output(j,(i-1)*Nmines+j) = 1;
        A_output(j,Nyears*(Nmines+1)+(i-1)*Nmines+j) = - ubMines(j);
    end
    Aoutput = [Aoutput;A_output];
    A_open = zeros(Nmines,Nyears*(3*Nmines+1));
    for j = 1:Nmines
        A_open(j,(Nmines+1)*Nyears+(i-1)*Nmines+j) = 1;
        A_open(j,(2*Nmines+1)*Nyears+(i-1)*Nmines+j) = -1;
    end
    Aopen = [Aopen;A_open];
end
Aclose = [];bclose = zeros((Nyears-1)*Nmines,1);
for i = 1:Nyears-1
    A_close = zeros(Nmines,Nyears*(3*Nmines+1));
    for j = 1:Nmines
        A_close(j,Nyears*(2*Nmines+1)+(i-1)*Nmines+j) = -1;
        A_close(j,Nyears*(2*Nmines+1)+i*Nmines+j) = 1;
    end
    Aclose = [Aclose;A_close];
end

A = [Aoutput;A_operation;Aopen;Aclose]
Aeq = [Aeq_quantity;Aeq_quality];
b = [boutput;B_operation;bopen;bclose]
beq = [beq_quantity;beq_quality];

lb = zeros(1,Nyears*(3*Nmines+1));
ub = [repmat(ubMines,1,Nyears) sum(ubMines)*ones(1,Nyears) ones(1,2*Nmines*Nyears)];
//C = [zeros(1,Nmines*Nyears) [10 9 8 7 6].*ones(1,Nyears) zeros(1,Nyears*Nmines) -repmat(Royltes,1,Nyears)]';
C = [zeros(1,Nmines*Nyears) [10 10*0.9 10*0.9^2 10*0.9^3 10*0.9^4 ].*ones(1,Nyears) zeros(1,Nyears*Nmines) -Royltes]';

// All variables are not integers
intcon = [(Nmines+1)*Nyears+1:Nyears*(3*Nmines+1)];
options = list("time_limit", 2500);
[xopt,fopt,status,output] = symphonymat(-C,intcon,A,b,Aeq,beq,lb,ub,options);
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

for i = 1:Nyears
    xx(i,:) = xopt((i-1)*Nmines+1:i*Nmines)';
    Qt(i) = xopt(Nmines*Nyears+i);
end
years = string(1:Nyears);
Mines = [];
mprintf('Total profit %d',-fopt);
for i = 1:Nmines
    Mines = [Mines strcat(['Mine',string(i)])]    
end
table = [['years' Mines];[years' string(xx)]];
disp(table);
disp(string(Qt),'Each year produced blended ore')
