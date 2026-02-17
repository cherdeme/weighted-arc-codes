// mds_test.m
// Test MDS property for weighted arc codes
// Author: Your Name

load "utils/conic_utils.m";

function TestMDSProperty(q, d, n_trials)
    // Test MDS property for random weights
    // Input:
    //   q - field size
    //   d - degree of polynomials
    //   n_trials - number of random weight vectors to test
    // Output:
    //   probability - fraction of trials yielding MDS codes
    
    printf "========================================\n";
    printf "Testing MDS property\n";
    printf "q = %o, d = %o, n_trials = %o\n", q, d, n_trials;
    printf "========================================\n";
    
    // Construct conic and get points
    C := ConstructConic(q);
    pts := GetConicPoints(C);
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
    
    // Pre-compute evaluation matrix (without weights)
    E := EvaluateMonomialsOnPoints(mons, pts);
    
    mds_count := 0;
    
    for trial in [1..n_trials] do
        if trial mod 10 eq 0 then
            printf "Trial %o/%o\n", trial, n_trials;
        end if;
        
        // Generate random non-zero weights
        weights := RandomNonZeroWeights(GF(q), n);
        
        // Build weighted generator matrix
        G := Matrix(GF(q), k, n, [E[i][j] * weights[j] : i in [1..k], j in [1..n]]);
        
        // Test all k-subsets
        is_mds := true;
        subsets := Subsets({1..n}, k);
        for S in subsets do
            cols := SetToSequence(S);
            submat := Submatrix(G, 1, cols);
            if Determinant(submat) eq 0 then
                is_mds := false;
                break;
            end if;
        end for;
        
        if is_mds then
            mds_count +:= 1;
        end if;
    end for;
    
    probability := mds_count / n_trials;
    printf "\nRESULTS: %o/%o trials were MDS\n", mds_count, n_trials;
    printf "Probability: %o\n", probability;
    
    return probability;
end function;

// Example usage
if GetEnvironment("MAGMA_TEST") eq "1" then
    print "Running tests...";
    TestMDSProperty(7, 2, 10);
    TestMDSProperty(11, 3, 5);
    TestMDSProperty(13, 3, 5);
end if;
