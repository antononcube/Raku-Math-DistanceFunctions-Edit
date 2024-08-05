use v6.d;

use NativeCall;
use NativeHelpers::Array;

my constant $library = %?RESOURCES<libraries/EditDistance>.IO.Str;

# This is three ≈3 times faster than the has-utf8 subs defined below.
sub is_utf8(Str --> int32) is native($library) {*}

sub EditDistance(Str, Str --> int32) is native($library) {*}

sub EditDistanceArray(CArray[int32], int32, CArray[int32], int32 --> int32) is native($library) {*}

unit module Math::DistanceFunctions::Edit;

# Using this definition slows down the computations ≈3 times.
#sub has-utf8(Str $str --> Bool) { so $str ~~ /<-[\x00..\x7F]>/; }

# Using this definition slows down the computations ≈3 times.
#sub has-utf8(Str:D $s) { $s.chars != $s.encode.bytes }

our sub edit-distance-fast(Str:D $s1, Str:D $s2 --> Int:D) is export {
    if is_utf8($s1) || is_utf8($s2) {
        my $carray1 = copy-to-carray($s1.comb».ord, int32);
        my $carray2 = copy-to-carray($s2.comb».ord, int32);
        return EditDistanceArray($carray1, $s1.chars, $carray2, $s2.chars);
    }
    return EditDistance($s1, $s2);
}

our proto sub edit-distance($s1, $s2, Bool:D :i(:$ignore-case) = False --> Int:D) is export {*}

multi sub edit-distance(Str:D $s1, Str:D $s2, Bool:D :i(:$ignore-case) = False --> Int:D) {
    return do if $ignore-case {
        edit-distance-fast($s1, $s2)
    } else {
        edit-distance-fast($s1.lc, $s2.lc)
    }
}

multi sub edit-distance(@s1, @s2, Bool:D :i(:$ignore-case) = False --> Int:D) {
    return do if (@s1.all ~~ Bool:D) && (@s2.all ~~ Bool:D) {
        return edit-distance(@s1».Int, @s2».Int, :$ignore-case);
    } elsif (@s1.all ~~ Str:D) && (@s2.all ~~ Str:D) {
        my @words = [|@s1, |@s2].unique;
        if $ignore-case { @words = @words».lc.unique }
        my %reMap = @words Z=> (^@words.elems);
        return edit-distance(@s1.map({ %reMap{$_} }), @s2.map({ %reMap{$_} }), :!ignore-case);
    } elsif (@s1.all ~~ Int:D) && (@s2.all ~~ Int:D) {
        my $carray1 = copy-to-carray(@s1, int32);
        my $carray2 = copy-to-carray(@s2, int32);
        return EditDistanceArray($carray1, @s1.elems, $carray2, @s2.elems);
    } else {
        return edit-distance(@s1».raku, @s2».raku, :$ignore-case);
    }
}