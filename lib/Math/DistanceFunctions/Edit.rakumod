use v6.d;

use NativeCall;

my constant $library = %?RESOURCES<libraries/EditDistance>.IO.Str;

sub say_hello() is native($library) { * }

sub EditDistance(Str, Str --> int32) is native($library) { * }

unit module Math::DistanceFunctions::Edit;

our sub greet() {
    say_hello();
}

our sub edit-distance(Str:D $s1, Str:D $s2 --> Int:D) is export {
    return EditDistance($s1, $s2);
}
