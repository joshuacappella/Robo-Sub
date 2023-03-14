%% Matlab Project 2 Joshua Cappella March 1, 2023
clear all; close all; clc;

% Problem 1: Decoding a matrix into a patern
M = load('scramble.dat');
disp(decoder(M))
% function for this problem is at the bottom of the file


% Problem 2: Calculating the number of months left on a simple interest
% loan
prompt = "Enter the annual percent interest of your loan as a" + ...
    " number. For example, if your loan has a 7% interest rate, enter 7: ";
apr = input(prompt);
prompt = "Enter the total amount of your loan in dollars: ";
balance = input(prompt);
prompt = "Enter your your required monthly payment in dollars: ";
payment = input(prompt);
calculator(apr, balance, payment);
% function for this problem is at the bottom of the file

% Problem 3
%% Engineering Analysis Robotic Submarine Simulation Project
close all
clear
clc

% time span
tspan = 0:0.002:6;

% inital conditions
x0 = 3;
y0 = 2;
z0 = 5;
Vx0 = 6.2;
Vy0 = 0.3;
Vz0 = 0.4;

[tlist,Slist] = ode45(@(t,S)Dynamics(t,S),tspan,[x0; y0; z0; Vx0; Vy0; ...
    Vz0]);

figure(1)
subplot(3,1,1)
plot(tlist,Slist(:,1),'linewidth',2)
legend('Position x')
grid on;
xlabel('Time t (s)')

subplot(3,1,2)
plot(tlist,Slist(:,2),'linewidth',2)
legend('Position y')
grid on;
xlabel('Time t (s)')

subplot(3,1,3)
plot(tlist,Slist(:,3),'linewidth',2)
legend('Position z')
grid on;
xlabel('Time t (s)')

figure(2)
subplot(1,1,1)
plot3(Slist(:,1),Slist(:,2),Slist(:,3))
grid on;

function Sdot = Dynamics(t,S)
    % Downward Force Due to Gravity
    m = 3000;
    g = 9.81;
    
    % Thrust
    Tx = 1000;
    Ty = 10;
    Tz = 0;
    
    % Drag
    Dx = 0.04;
    Dy = 0.60;
    Dz = 0.60;
    
    % Force Buoyancy
    fB = 11;

    x = S(1);
    y = S(2);
    z = S(3);
    Vx = S(4);
    Vy = S(5);
    Vz = S(6);

    xDot = sin(z.*3.6.*t);
    yDot = -y.*cos(5.8.*t);
    zDot = x.*sin(1.7.*t.^2);
    VxDot = -Dx .* Vx + Tx;
    VyDot = -Dy .* Vy + Ty;
    VzDot = -Dz .* Vz + (m.*g) - fB + Tz;

    Sdot = [xDot; yDot; zDot; VxDot; VyDot; VzDot];
end

% function for problem 1
function[d] = decoder(M)
    r = mod(M,3);
    r(r == 0) = ' ';
    r(r == 1) = '*';
    r(r == 2) = '=';
    d = char(r);
end

% function for problem 2
function calculator(apr, balance, payment)
    sumMonths = 0;
    sumInterest = 0;
    initialApr = apr;
    apr = apr.*(0.01./12);
    initialBalance = balance;
    % Most the months
    while balance > payment
        interest = (balance .* apr);
        balance = balance + interest;
        balance = balance - payment;
        sumMonths = sumMonths + 1;
        sumInterest = sumInterest + interest;
    end
    % Final month
    interest = (balance .* apr);
    balance = 0;
    sumMonths = sumMonths + 1;
    sumYears = round(sumMonths ./ 12);
    sumInterest = round(sumInterest + interest);
    String = "The payoff time of your $%d loan at %0d%c is %d months" + ...
        " (%d years) and will cost $%0d.";
    outputString = sprintf(String, initialBalance, initialApr, '%', ...
        sumMonths, sumYears, sumInterest);
    disp(outputString)
end