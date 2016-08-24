%% I-BEAM Design
%
% This script calculates design objectives for the I-BEAM design problem
% as presented in:
%
% Huang, H. Z., Gu, Y. K., & Du, X. (2006). An interactive fuzzy 
% multi-objective optimization method for engineering design. Engineering 
% Applications of Artificial Intelligence, 19(5), 451-460.
%
%
%% About this implementation:
% Gilberto Reynoso-Meza
% https://www.researchgate.net/profile/Gilberto_Reynoso-Meza
% http://www.mathworks.es/matlabcentral/fileexchange/authors/289050
%
%% INPUTS
% # Decision Variables: vector with 4 decision variables 
%                       10.0 <= x1 <= 80
%                       10.0 <= x2 <= 50
%                        0.9 <= x3 <=  5
%                        0.9 <= x4 <=  5
%% OUTPUTS
% # Design Objectives: Y1p = [Y1+Penalty]
%                       Y1 = J1 + J2
%                       J1: I-Beam cross sectional area [cm^2]
%                       J2: Vertical deflection [cm]
%                       J3: Bending stress [kN/cm^2]

function Y1p = I_BEAM(X)

%% PARAMETERS
L = 200; % Lenght of the beam[cm]
P = 600; % Force 1 at L/2 [kN]
Q =  50; % Force 2 at L/2 [kN]
E = 2e4; % Young's modulus elasticity [kN/cm^2]
Sb=  16; % Maximum permissible stress of the beam [kN/cm^2]
         % J3 <= Sb !!!!

%% CROSS SECTIONAL DIAGRAM I-BEAM
%    ______________          ___
%   |_____    _____|          |
%         |  |                |
%         |  |                |
%         |x3|                x1
%         |  |                |
%    _____|  |_____           |
%   |______________| -> x4   _|_
%
%   |-----x2-------|        
%
%% FORCES at L/2
%
%          P
%          ||
%          ||
%          \/
%    ______________         
%   |_____    _____|        
%         |  |              
%         |  |              
%         |  |  <----------Q
%         |  |              
%    _____|  |_____         
%   |______________|
%        
%
%% CALCULATION         
         
x1=X(1);
x2=X(2);
x3=X(3);
x4=X(4);

I = (1/12)*(x3*(x1-2*x4)^3+2*x2*x4*(4*x4^2+3*x1*(x1-2*x4)));

J1 = 2*x2*x4 + x3*(x1-2*x4);
J2 = P*L^3/(48*E*I);

Y1=J1+J2;

J3 = 300*P*x1/(x3*(x1-2*x4)^3+2*x2*x4*(4*x4^2+3*x1*(x1-2*x4)))+...
    300*Q*x2/((x1-2*x4)*x3^3+2*x4*x2^3);

if J3<=Sb
    Y1p=Y1;
else
    Y1p=1e10+(J3-Sb);
end
