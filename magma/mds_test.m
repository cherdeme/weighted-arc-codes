// mds_test.m
// Test MDS property for weighted arc codes
// Author: Your Name
// Version: 2.0 avec génération de logs

load "utils/conic_utils.m";

function WriteLog(message, logFile)
    // Écrit un message dans le fichier de log et à l'écran
    print message;
    if logFile cmpne "" then
        fprintf logFile, "%o\n", message;
    end if;
end function;

function TestMDSProperty(q, d, n_trials)
    // Test MDS property for random weights
    // Input:
    //   q - field size
    //   d - degree of polynomials
    //   n_trials - number of random weight vectors to test
    // Output:
    //   probability - fraction of trials yielding MDS codes
    
    // Créer un fichier de log avec timestamp
    logFileName := Sprintf("mds_test_q%o_d%o_%o.log", q, d, Cputime());
    logFile := Open(logFileName, "w");
    
    WriteLog("========================================", logFile);
    WriteLog(Sprintf("Testing MDS property - %o", CurrentDate()), logFile);
    WriteLog(Sprintf("q = %o, d = %o, n_trials = %o", q, d, n_trials), logFile);
    WriteLog("========================================", logFile);
    
    try
        // Construct conic and get points
        C := ConstructConic(q);
        pts := GetConicPoints(C);
        n := #pts;
        WriteLog(Sprintf("Conic has %o points", n), logFile);
        
        // Get monomials of degree d
        P2 := Ambient(C);
        mons := MonomialsOfDegree(P2, d);
        k := #mons;
        WriteLog(Sprintf("Space of degree %o polynomials has dimension %o", d, k), logFile);
        
        if k gt n then
            WriteLog(Sprintf("WARNING: Dimension (%o) exceeds length (%o) - MDS impossible", k, n), logFile);
            WriteLog("RESULTS: 0/0 (N/A)", logFile);
            Flush(logFile);
            delete logFile;
            return 0.0;
        end if;
        
        // Pre-compute evaluation matrix (without weights)
        WriteLog("Computing evaluation matrix...", logFile);
        E := EvaluateMonomialsOnPoints(mons, pts);
        
        mds_count := 0;
        failed_subsets := [];
        
        for trial in [1..n_trials] do
            if trial mod 10 eq 0 then
                WriteLog(Sprintf("Trial %o/%o", trial, n_trials), logFile);
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
                    if #failed_subsets lt 5 then  // Garder les 5 premiers échecs
                        Append(~failed_subsets, S);
                    end if;
                    break;
                end if;
            end for;
            
            if is_mds then
                mds_count +:= 1;
            end if;
        end for;
        
        probability := mds_count / n_trials;
        
        // Écrire les résultats détaillés
        WriteLog("", logFile);
        WriteLog("----------------------------------------", logFile);
        WriteLog("FINAL RESULTS", logFile);
        WriteLog("----------------------------------------", logFile);
        WriteLog(Sprintf("Trials: %o", n_trials), logFile);
        WriteLog(Sprintf("MDS count: %o", mds_count), logFile);
        WriteLog(Sprintf("Probability: %o", probability), logFile);
        WriteLog(Sprintf("Success rate: %o%%", Round(probability*100)), logFile);
        
        if #failed_subsets gt 0 then
            WriteLog("", logFile);
            WriteLog("Examples of failing subsets:", logFile);
            for i in [1..#failed_subsets] do
                WriteLog(Sprintf("  %o", failed_subsets[i]), logFile);
            end for;
        end if;
        
        WriteLog("", logFile);
        WriteLog(Sprintf("Log file saved as: %o", logFileName), logFile);
        WriteLog("Test completed successfully.", logFile);
        
        Flush(logFile);
        delete logFile;
        
        return probability;
        
    catch e
        // En cas d'erreur, l'écrire dans le log
        WriteLog("", logFile);
        WriteLog("ERROR: Exception caught!", logFile);
        WriteLog(Sprintf("Error message: %o", e), logFile);
        WriteLog("Test failed.", logFile);
        
        Flush(logFile);
        delete logFile;
        
        error e;  // Relancer l'erreur
    end try;
end function;

// Version avec test automatique si exécuté directement
if GetEnvironment("MAGMA_AUTO_TEST") eq "1" then
    print "\nRunning automatic tests...";
    print "----------------------------------------";
    
    // Tester différentes configurations
    tests := [
        [7, 2, 10],   // q=7, d=2, 10 essais
        [11, 3, 5],   // q=11, d=3, 5 essais
        [13, 3, 5],   // q=13, d=3, 5 essais
        [17, 3, 5]    // q=17, d=3, 5 essais
    ];
    
    for test in tests do
        q := test[1];
        d := test[2];
        trials := test[3];
        
        print Sprintf("\nTesting q=%o, d=%o, trials=%o", q, d, trials);
        print "----------------------------------------";
        
        prob := TestMDSProperty(q, d, trials);
        print Sprintf("Result: %o\n", prob);
    end for;
    
    print "\nAll tests completed.";
end if;
