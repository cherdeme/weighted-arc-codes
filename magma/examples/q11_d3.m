// q11_d3.m
// Example for q=11, d=3
// Author: Your Name

load "../utils/conic_utils.m";
load "../mds_test.m";

q := 11;
d := 3;

printf "\n";
printf "========================================\n";
printf "EXAMPLE: q = %o, d = %o\n", q, d;
printf "========================================\n";

// Quick test
prob := TestMDSProperty(q, d, 5);

printf "\nExample completed successfully!\n";
