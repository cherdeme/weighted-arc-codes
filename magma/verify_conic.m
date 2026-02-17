// verify_conic.m
// Verify properties of conics over finite fields
// Author: Your Name

load "utils/conic_utils.m";

procedure VerifyConic(q)
    printf "\n";
    printf "========================================\n";
    printf "Verifying conic over GF(%o)\n", q;
    printf "========================================\n";
    
    C := ConstructConic(q);
    PrintConicInfo(C);
    
    pts := GetConicPoints(C);
    printf "\nFirst 5 points:\n";
    for i in [1..Min(5, #pts)] do
        printf "  %o\n", pts[i];
    end for;
    
    // Verify no three points are collinear (arc property)
    printf "\nVerifying arc property...\n";
    is_arc := true;
    triples := Subsets({1..#pts}, 3);
    for T in triples do
        p1 := pts[SetToSequence(T)[1]];
        p2 := pts[SetToSequence(T)[2]];
        p3 := pts[SetToSequence(T)[3]];
        if IsCollinear(p1, p2, p3) then
            printf "ERROR: Points %o, %o, %o are collinear!\n", p1, p2, p3;
            is_arc := false;
            break;
        end if;
    end for;
    
    if is_arc then
        printf "✓ Arc property verified: no three points are collinear\n";
    end if;
    
    printf "\nVerification complete.\n";
end procedure;

// Test for different q values
VerifyConic(7);
VerifyConic(11);
VerifyConic(13);
