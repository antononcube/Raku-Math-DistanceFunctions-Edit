#!/usr/bin/env raku
use v6.d;

use lib <. lib>;
use Math::DistanceFunctions::Edit;
use Text::Levenshtein::Damerau;

my ($w1, $w2) = ('examples', 'samples');
say 'edit-distance : ', edit-distance($w1, $w2);
say 'dld           : ', dld($w1, $w2);