function opti = optimzr( worldpoints_real, imagepoints_real, camparam, u0, v0, imagesize)

x = optimvar('x', 13, 1 );
x.LowerBound = -500;
prob = optimproblem;

expr = fcn2optimexpr(@camfun, x, worldpoints_real, u0, v0, imagesize, 'OutputSize', [size(worldpoints_real,1), 2]);
expr2 = sum( (expr - imagepoints_real).^2, 2 );
expr3 = ( expr2 ).^(1/2);
prob.Objective = sum( expr3 );

x0.x(1) = camparam.A(1,1);
x0.x(2) = camparam.A(2,2);
x0.x(3:5) = camparam.R(1, :);
x0.x(6:8) = camparam.R(2, :);
x0.x(9:11) = camparam.tvecs;
x0.x(12:13) = [ camparam.k(1), camparam.k(2) ];
% x0.x(14:15) = [ .1, .1 ];
options = optimoptions('FMINCON', 'Display', 'none', 'FunctionTolerance', 1e-10, 'MaxFunctionEvaluations', 100000,...
    'MaxIterations', 100000);
[sol,~,exitflag,~] = solve(prob, x0, 'Options', options);

exitflag

xx = sol.x;
opti.imagepoints = camfun(xx, worldpoints_real, u0, v0, imagesize);

opti.A = [ xx(1) 0 u0; 0 xx(2) v0; 0 0 1 ];
opti.R(1, :) =  xx(3:5);
opti.R(2, :) =  xx(6:8);
opti.tvec = xx(9:11)';
opti.k = xx(12:13);

