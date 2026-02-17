// mds_test.m - Version simplifiée pour déboguer
// Test MDS property for weighted arc codes

load "utils/conic_utils.m";

function TestMDSProperty(q, d, n_trials)
    printf "========================================\n";
    printf "Testing MDS property\n";
    printf "q = %o, d = %o, n_trials = %o\n", q, d, n_trials;
    printf "========================================\n";
    
    // Construct conic and get points
    C := ConstructConic(q);
    pts := Points(C);
    n := #pts;
    printf "Conic has %o points\n", n;
    
    // Get monomials of degree d
    P2 := Ambient(C);
    mons := MonomialsOfDegree(P2, d);
    k := #mons;
    printf "Space of degree %o polynomials has dimension %o\n", d, k;
    
    if k gt n then
        printf "WARNING: Dimension (%o) exceeds length (%o) - MDS impossible\n", k, n;
        return 0.0;
    end if;
    
    mds_count := 0;
    
    for trial in [1..n_trials] do
        if trial mod 10 eq 0 then
            printf "Trial %o/%o\n", trial, n_trials;
        end if;
        
        // Pour l'instant, on simule juste
        mds_count +:= 1;
    end for;
    
    probability := mds_count / n_trials;
    printf "\nRESULTS: %o/%o trials simulated\n", mds_count, n_trials;
    printf "Probability: %o\n", probability;
    
    return probability;
end function;

// Test simple
TestMDSProperty(7, 2, 5);
