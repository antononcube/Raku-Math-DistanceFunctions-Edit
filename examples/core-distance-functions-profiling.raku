#!/usr/bin/env raku
use v6.d;

# The speed up using the C implementations is:
# Cosine distance ≈ 2.2 times
# Euclidean distance ≈ 1.5 times

#use Math::DistanceFunctions;
use Math::DistanceFunctions::Edit;

my $iterations = 1_000;

my @small-vec1 = (1, 0, 0)».Num;
my @small-vec2 = (0, 1, 0)».Num;
my @large-vec1 = (^1000).map({1.rand});
my @large-vec2 = (^1000).map({1.rand});

my $start = now;
for ^$iterations {
    cosine-distance(@small-vec1, @small-vec2);
}
my $small-cosine-time = now - $start;

$start = now;
for ^$iterations {
    cosine-distance(@large-vec1, @large-vec2);
}
my $large-cosine-time = now - $start;

$start = now;
for ^$iterations {
    euclidean-distance(@small-vec1, @small-vec2);
}
my $small-euclidean-time = now - $start;

$start = now;
for ^$iterations {
    euclidean-distance(@large-vec1, @large-vec2);
}
my $large-euclidean-time = now - $start;

say "Total Small Cosine Distance Time      : {$small-cosine-time}s";
say "Average Small Cosine Distance Time    : {$small-cosine-time / $iterations}s";
say "Total Large Cosine Distance Time      : {$large-cosine-time}s";
say "Average Large Cosine Distance Time    : {$large-cosine-time / $iterations}s";
say "Total Small Euclidean Distance Time   : {$small-euclidean-time}s";
say "Average Small Euclidean Distance Time : {$small-euclidean-time / $iterations}s";
say "Total Large Euclidean Distance Time   : {$large-euclidean-time}s";
say "Average Large Euclidean Distance Time : {$large-euclidean-time / $iterations}s";