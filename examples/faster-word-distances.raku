#!/usr/bin/env raku
use v6.d;
use Data::Reshapers;
use Data::Summarizers;
use Text::Levenshtein::Damerau;
use Text::Diff::Sift4;
use Math::DistanceFunctions::Edit;

#============================================================
# See https://github.com/MasterDuke17/Text-Diff-Sift4
#use Text::Diff::Sift4;

#============================================================
# See https://rosettacode.org/wiki/Levenshtein_distance#Raku
sub levenshtein-distance ( Str $s, Str $t --> Int ) {
    my @s = *, |$s.comb;
    my @t = *, |$t.comb;

    my @d;
    @d[$_;  0] = $_ for ^@s.end;
    @d[ 0; $_] = $_ for ^@t.end;

    for 1..@s.end X 1..@t.end -> ($i, $j) {
        @d[$i; $j] = @s[$i] eq @t[$j]
                ??   @d[$i-1; $j-1]    # No operation required when eq
                !! ( @d[$i-1; $j  ],   # Deletion
                     @d[$i  ; $j-1],   # Insertion
                     @d[$i-1; $j-1],   # Substitution
                ).min + 1;
    }

    @d[*-1][*-1];
}

#============================================================

sub StrDistanceFunc( Str $w1, Str $w2) {
    +StrDistance.new(before => $w1, after => $w2)
}

#============================================================

my @testPairs =[ <kitten sitting>, <saturday sunday>, <rosettacode raisethysword>,
                 <string1 string2>, <classify clasify>, <correlation corellation>,
                 <recommend recomende>, <non-negative nonenegative>, <hour our>];

my UInt $n = 10_000;
my @res;
for @testPairs -> ($s, $t) {
    for [('dld', &dld),
         ('rosetta', &levenshtein-distance),
         ('sift', &sift4),
         ('StrDistance', &StrDistanceFunc),
         ('edit-distance', &edit-distance)] -> ($distName, &distFinder) {
        my $tstart = now;
        my $d = &distFinder($s, $t);
        for ^$n {
            &distFinder($s, $t)
        }
        my $tend = now;
        @res.push( {func => $distName, first => $s, second => $t, dist => $d, time => ($tend - $tstart).Num / $n} )
    }
}

say to-pretty-table(@res, align => 'l', field-names => <func first second dist time>);

records-summary(@res);

my %res2 = group-by(@res, <func>)>>.List;

records-summary(%res2, field-names => <first second dist time>);

say Data::TypeSystem::deduce-type(%res2);

say '=' x 120;

my %res3 = %res2.map({ $_.key => $_.value.map(*<time>).sum });
.say for %res3;

say '-' x 120;

.say for %res3.deepmap({ $_ / %res3<StrDistance> });