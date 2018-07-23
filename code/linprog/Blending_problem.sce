// A practcal problem of blending of different products to acheive designed performance levels.
// This is an example from the class of allocation problems.
// Ref:H.A. Eiselt and C.-L.SAndblom,"Linear Programming and its Applications",Springer-Verlag Berlin Heidelberg 2007,chapter 2.7
//Example:
//A firm faces the problem of blending three raw materials into two final
//products. The required numerical information is provided in Table.
//
//-----------------------------------------------------------------------
//  Raw                 Products          Amount available     Unit Cost 
//Materials             1       2             (in tons)          ($)
//-----------------------------------------------------------------------
//     1             [0.4;0.6][0.5;0.6]        2000               1
//     2             [0.1;0.2][0.1;0.4]        1000               1.5
//     3             [0.2;0.5][0.2;0.3]        500                3
//-----------------------------------------------------------------------
//quantity required     600      700
//(in tons)
//-----------------------------------------------------------------------
//unit selling price    10        8
//($) 
//-----------------------------------------------------------------------
//we assume that raw materials blend linearly, meaning that taking,
//say, α units of raw material A and β units of raw material B, then
//the resulting blend C has features that are proportional to the
//quantities of A and B that C is made of. As an example, take 3 gallons
//of 80º water and 2 gallons of 100º water,then the result would be 5
//gallons of water, whose temperature is [3(80) + 2(100)]/5 = 88º.
//The parameters max and min indicate the smallest and largest proportion
//of rawmaterial that is allowed in the final product.Determine the
//optimal transportation plan to maximize profit.

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
Nprod = 2;
Nraw = 3;
demand = [600 700];
cost = [10 8];
con(1,:,:) = [0.4 0.6;0.1 0.2;0.2 0.5];
con(2,:,:) = [0.5 0.6;0.1 0.4;;0.2 0.3];
raw = [2000 1000 500];
RawC = [1 1.5 3];
mprintf('Received Data')
mprintf('Number of products %d',Nprod);
mprintf('number of raw materials %d',Nraw);
disp(demand,'Demand of products');
disp(cost,'Unit cost of products');

product = [];Min_Max = [];
for i = 1:Nprod
    product = [product,['Min-Max',string(i)]];
    for j = 1:Nraw
        MM(j,:) = con(i,j,:);
    end
    Min_Max = [Min_Max string(MM)];
end
Row1 = ['Raw Material',product,'Amount_avail','unit_Cost']
RawMaterial = string([1:Nraw]');
Amount_avail = string(raw(:));
unit_C = string(RawC(:));    
Table = [Row1;[RawMaterial Min_Max Amount_avail unit_C]];
disp(Table);
input('Press Enter to proceed ')
A1 = zeros(Nraw,Nraw*Nprod);
for i = 1:Nraw
    A1(i,i:Nraw:Nraw*Nprod)=1;
    b1(i) = raw(i);
end
A2 = zeros(Nprod*Nraw*2,Nprod*Nraw);b2 = zeros(Nprod*Nraw*2,1);
A3 = zeros(Nprod,Nprod*Nraw);
for i = 1:Nprod
    Areq = ones(2*Nraw,Nraw);
    Areq(Nraw+1:2*Nraw,:) = -1;
    for j =1:Nraw
        Areq(j,:) = con(i,j,1)* Areq(j,:);
        Areq(j,j) = Areq(j,j)-1;
        Areq(Nraw+j,:) = Areq(Nraw+j,:)*con(i,j,2);
        Areq(Nraw+j,j) = 1 + Areq(Nraw+j,j);
    end
    A2((i-1)*2*Nraw+1:i*2*Nraw,(i-1)*Nraw+1:i*Nraw) = Areq;
    A3(i,(i-1)*Nraw+1:i*Nraw)= ones(1,Nraw);
    b3(i) = demand(i);
end

A = [A1;A2];b = [b1;b2];
Aeq = A3;beq = b3;
C = [];
for i = 1:Nprod
    C1 =  -cost(i)*ones(1,Nraw) + RawC;   
    C = [C ;C1'];
end

lb = zeros(1,Nprod*Nraw);
intcon = 1:Nprod*Nraw;
[xopt,fopt,exitflag,output,lambda] = linprog(C,A,b,Aeq,beq,lb,[]);
clc
select exitflag
case 0 then
    mprintf('Optimal Solution Found')
    input('Press enter to view results')
    //Display results
    mprintf('Total profit is %d\n',-fopt);

    A1 = [];product = [];
    for i=1:Nprod
        Raw_M(:,i) = xopt((i-1)*Nraw+1:i*Nraw) ;
        product(i) = string(sum(Raw_M(:,i)));
        A1 = [A1 strcat(['Product' string(i)])];
    end

    table = [['RawMaterial', A1];[RawMaterial string(Raw_M)];['Total Product' product']];
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


