use v6;
use Test;
plan 1;

subtest {
    lives_ok { use Grammar::XQuery };
}, "Sanity tests";

done();