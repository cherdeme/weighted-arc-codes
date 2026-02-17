// conic_utils.m
// Utility functions for working with conics
// Author: Your Name
// Date: 2025

function ConstructConic(q)
    // Construct a non-degenerate conic over GF(q)
    // Returns the conic curve
    
    F := GF(q);
    P2<x,y,z> := ProjectiveSpace(F, 2);
    
    // Choose appropriate conic based on q mod 4
    if q mod 4 eq 3 then
        // x^2 + y^2 + z^2 works for q ≡ 3 mod 4
        C := Curve(P2, x^2 + y^2 + z^2);
    else
        // Otherwise use hyperbolic conic
        C := Curve(P2, x*y + z^2);
    end if;
    
    // Verify it's non-degenerate
    if not IsNonsingular(C) then
        error "Conic is singular!";
    end if;
    
    return C;
end function;

function GetConicPoints(C)
    // Get all points of a conic
    pts := Points(C);
    return [p : p in pts];
end function;

function EvaluateMonomialsOnPoints(mons, pts)
    // Evaluate all monomials on all points
    // Returns matrix M where M[i,j] = mons[i](pts[j])
    
    k := #mons;
    n := #pts;
    F := BaseRing(Universe(pts));
    
    M := ZeroMatrix(F, k, n);
    for i in [1..k] do
        for j in [1..n] do
            M[i][j] := Evaluate(mons[i], pts[j]);
        end for;
    end for;
    
    return M;
end function;

// Version corrigée de RandomNonZeroWeights dans conic_utils.m
function RandomNonZeroWeights(F, n)
    // Generate n random non-zero elements of F
    weights := [];
    for i in [1..n] do
        w := Random(F);
        while w eq 0 do
            w := Random(F);
        end while;
        Append(~weights, w);
    end for;
    return weights;
end function;

function PrintConicInfo(C)
    // Print information about a conic
    printf "Conic: %o\n", C;
    printf "Number of points: %o\n", #Points(C);
    printf "Is nonsingular: %o\n", IsNonsingular(C);
    printf "Genus: %o\n", Genus(C);
end function;
