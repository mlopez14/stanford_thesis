syms k x y z omega t c g mu lambda Pr R
%%% Specify constants
c = 0;

dims = 2;


%%% Manufactured solution
if dims == 2
    U = [sin(k*(x + y) - omega * t) + c;...
        sin(k*(x + y) - omega * t) + c;...
        sin(k*(x + y) - omega * t) + c;...
        0;...
        (sin(k*(x + y) - omega * t) + c)^2];
    
elseif dims == 3
    U = [sin(k*(x + y + z) - omega * t) + c;...
        sin(k*(x + y + z) - omega * t) + c;...
        sin(k*(x + y + z) - omega * t) + c;...
        sin(k*(x + y + z) - omega * t) + c;...
        (sin(k*(x + y + z) - omega * t) + c)^2];
end

%%% Fluxes
rho = U(1);
u = U(2)/rho;
v = U(3)/rho;
w = U(4)/rho;
E = U(5);

p = (g - 1)* ( E - 1/2*rho*(u^2 + v^2 + w^2));
T = p/(rho*R);
cp = g*R/(g-1);


% Derivatives
ux = diff(u,x);
uy = diff(u,y);
uz = diff(u,z);

vx = diff(v,x);
vy = diff(v,y);
vz = diff(v,z);

wx = diff(w,x);
wy = diff(w,y);
wz = diff(w,z);

Tx = diff(T,x);
Ty = diff(T,y);
Tz = diff(T,z);

if dims == 2
    uz = 0;
    vz = 0;
    wz = 0;
    Tz = 0;
end

% x direction
f_inv = [rho*u;...
    rho*u^2 + p;...
    rho*u*v;...
    rho*u*w;...
    u*(E + p)];

f_visc = mu*[0;...
    2*ux + lambda* (ux + vy + wz);...
    vx + uy;...
    wx + uz;...
    u*(2*ux + lambda*(ux + vy + wz)) + v*(vx + uy) + w*(wx + uz) + cp/Pr*Tx];

% y direction
g_inv = [rho*v;...
    rho*u*v;...
    rho*v^2 + p;...
    rho*v*w;...
    v*(E + p)];

g_visc = mu*[0;...
    vx + uy;...
    2*vy + lambda*(ux + vy + wz);...
    wy + vz;...
    v*(2*vy + lambda*(ux + vy + wz)) + u*(vx + uy) + w*(wy + vz) + cp/Pr*Ty];

% z direction
h_inv = [rho*w;...
    rho*u*w;...
    rho*v*w;...
    rho*w^2 + p;...
    w*(E + p)];

h_visc = mu*[0;...
    wx + uz;...
    wy + vz;...
    2*wz + lambda*(ux + vy + wz);...
    w*(2*wz + lambda*(ux + vy + wz)) + u*(wx + uz) + v*(wy + vz) + cp/Pr*Tz];

% Collecting the fluxes
F = f_inv - f_visc;
G = g_inv - g_visc;
H = h_inv - h_visc;

%% Finding the sources
if dims == 2
    S = (diff(U,t) + diff(F,x) + diff(G,y))
elseif dims == 3
    S = simplify(diff(U,t) + diff(F,x) + diff(G,y) + diff(H,z))
end

%% Compare with code

if dims == 3
    Scode = [(3*k - omega)*cos(omega*t - k*(x + y + z));...
        (cos(omega*t - k*(x + y + z))*((9 + 4*c*(-1 + g) - 3*g)*k - 2*omega - 4*(-1 + g)*k*sin(omega*t - k*(x + y + z))))/2;...
        (cos(omega*t - k*(x + y + z))*((9 + 4*c*(-1 + g) - 3*g)*k - 2*omega - 4*(-1 + g)*k*sin(omega*t - k*(x + y + z))))/2;...
        (cos(omega*t - k*(x + y + z))*((9 + 4*c*(-1 + g) - 3*g)*k - 2*omega - 4*(-1 + g)*k*sin(omega*t - k*(x + y + z))))/2;...
        (-6*g*k^2*mu*sin(omega*t - k*(x + y + z)) + Pr*cos(omega*t - k*(x + y + z))*(3*(3 - 3*g + 4*c*g)*k - 4*c*omega + 4*(-3*g*k + omega)*sin(omega*t - k*(x + y + z))))/(2.*Pr)];
elseif dims == 2
    Scode = [(2*k - omega)*cos(omega*t - k*(x + y));...
        cos(omega*t - k*(x + y))*((3 + 2*c*(-1 + g) - g)*k - omega - 2*(-1 + g)*k*sin(omega*t - k*(x + y)));...
        cos(omega*t - k*(x + y))*((3 + 2*c*(-1 + g) - g)*k - omega - 2*(-1 + g)*k*sin(omega*t - k*(x + y)));...
        0;...
        (-2*g*k^2*mu*sin(omega*t - k*(x + y)) + 2*Pr*cos(omega*t - k*(x + y))*(k - g*k + 2*c*g*k - c*omega + (-2*g*k + omega)*sin(omega*t - k*(x + y))))/Pr];
end

simplify(S - Scode)
    
    




