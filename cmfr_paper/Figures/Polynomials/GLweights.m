function w = GLweights(np)
% Routine for querying Gauss-Legendre weights for a given polynomial order
% ---
% np - number of points
% xi - Gauss quadrature weights
% -------------------------------------------------------------------------

switch np
    case 1
        w = 2.0;
    case 2
        w = [1.0; 1.0];
    case 3
        w = [0.5555555555555556; 0.8888888888888888; 0.5555555555555556];
    case 4
        w = [0.3478548451374538; 0.6521451548625461; 0.6521451548625461; 0.3478548451374538];
    case 5
        w = [0.2369268850561891; 0.4786286704993665; 0.5688888888888889; 0.4786286704993665; 0.2369268850561891];
    case 6
        w = [0.1713244923791704; 0.3607615730481386; 0.4679139345726910; 0.4679139345726910; 0.3607615730481386; 0.1713244923791704];
    case 7
        w = [0.1294849661688697; 0.2797053914892766; 0.3818300505051189; 0.4179591836734694; 0.3818300505051189; 0.2797053914892766; 0.1294849661688697];
    otherwise
         error('GLweights:Plimit', 'Routine only provides for np<=7')
end
