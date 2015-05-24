use v6;
use Test;
plan 1;

subtest {
    lives-ok { use Grammar::XQuery };
}, "Sanity tests";

done();
