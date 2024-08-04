use v6.d;

use NativeCall;
use NativeHelpers::Array;

my constant $library = %?RESOURCES<libraries/EditDistance>.IO.Str;

sub say_hello() is native($library) { * }

sub EditDistance(Str, Str --> int32) is native($library) { * }

sub EditDistanceArray(CArray[int32], int32, CArray[int32], int32 --> int32) is native($library) { * }

unit module Math::DistanceFunctions::Edit;

our sub greet() {
    say_hello();
}

sub has-utf8(Str:D $s) { $s.chars != $s.encode.bytes }

our sub edit-distance(Str:D $s1, Str:D $s2 --> Int:D) is export {
    if has-utf8($s1) || has-utf8($s2) {
        my $carray1 = copy-to-carray($s1.comb».ord, int32);
        my $carray2 = copy-to-carray($s2.comb».ord, int32);
        return EditDistanceArray($carray1, $s1.chars, $carray2, $s2.chars);
    }
    return EditDistance($s1, $s2);
}