use v6.d;

use NativeCall;
use NativeHelpers::Array;

my constant $library = %?RESOURCES<libraries/EditDistance>.IO.Str;

sub say_hello() is native($library) { * }

#sub EditDistance(Str, Str --> int32) is native($library) { * }

sub EditDistance(CArray[int32], int32, CArray[int32], int32 --> int32) is native($library) { * }

unit module Math::DistanceFunctions::Edit;

our sub greet() {
    say_hello();
}

our sub edit-distance(Str:D $s1, Str:D $s2 --> Int:D) is export {
    my $carray1 = copy-to-carray($s1.comb».ord, int32);
    my $carray2 = copy-to-carray($s2.comb».ord, int32);
    return EditDistance($carray1, $s1.chars, $carray2, $s2.chars);
}
