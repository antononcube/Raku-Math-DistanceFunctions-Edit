# Math::DistanceFunctions::Edit

[![Actions Status](https://github.com/antononcube/Raku-Math-DistanceFunctions-Edit/actions/workflows/linux.yml/badge.svg)](https://github.com/antononcube/Raku-Math-DistanceFunctions-Edit/actions)
[![Actions Status](https://github.com/antononcube/Raku-Math-DistanceFunctions-Edit/actions/workflows/macos.yml/badge.svg)](https://github.com/antononcube/Raku-Math-DistanceFunctions-Edit/actions)
<!--- [![Actions Status](https://github.com/antononcube/Raku-Math-DistanceFunctions-Edit/actions/workflows/windows.yml/badge.svg)](https://github.com/antononcube/Raku-Math-DistanceFunctions-Edit/actions) -->

<!--- [![](https://raku.land/zef:antononcube/Math::DistanceFunctions::Edit/badges/version)](https://raku.land/zef:antononcube/Math::DistanceFunctions::Edit) -->
[![License: Artistic-2.0](https://img.shields.io/badge/License-Artistic%202.0-0298c3.svg)](https://opensource.org/licenses/Artistic-2.0)

Raku package of fast Damerau-Levenshtein distance functions based on C code via "NativeCall".

For a pure Raku implementation see ["Text::Levenshtein::Damerau"](https://raku.land/github:ugexe/Text::Levenshtein::Damerau), [NLp1].

-----

## Usage examples

The main function provided by this package is `edit-distance`. 
Here is comparison invocation with `dld` from "Text::Levenshtein::Damerau" 
over two string arguments:

```perl6
use Math::DistanceFunctions::Edit;
use Text::Levenshtein::Damerau;

my ($w1, $w2) = ('examples', 'samples');
say 'edit-distance : ', edit-distance($w1, $w2);
say 'dld           : ', dld($w1, $w2);
```

Vectors of integers, booleans, or strings can be also used:

```perl6
edit-distance(<bark alma area arc>, <Arc alma area>):ignore-case;
```

```perl6
edit-distance([True, False, False, True], [True, False, False]);
```

-----

## Motivation

The motivation for making this package was the slow performance of the DSL translation functions in the package
["DSL::Translators"](https://github.com/antononcube/Raku-DSL-Translators), [AAp1].
After profiling, it turned out about 50% of the time is spent in the function `dld` by "Text::Levenshtein::Demerau". 

That is the case because of the fuzzy marching which "DSL::Translators" does:

```perl6
use DSL::Translators;

dsl-translation('use @dfTitanic; group by sex; show couns;', to => 'Raku')<CODE>
```

The slowdown effect of the "expensive" to compute results by `dld` can be addressed by:

- Certain clever checks can be made before invoking `dld`.
- Create a new function called `edit-distance` in C and set up a "NativeCall" connection to it.

So, at this point, both approaches were taken: the first in "DSL::Translators", the second by "Math::DistanceFunctions::Edit".

-----

## Implementation

The design of "NativeCall" hook-up is taken from ["Algorithm::KdTree"](https://raku.land/github:titsuki/Algorithm::KdTree), [ITp1].

The actual C-implementation was made by several iterations of LLM code generation.

I considered re-programming to C the Raku code of `dld` in [NLp1], but since
[Damerau-Levenshtein distance](https://en.wikipedia.org/wiki/Damerau–Levenshtein_distance) is a 
[very well known, popular topic](https://rosettacode.org/wiki/Levenshtein_distance) 
LLM generations with simple prompts were used.

(And, yes, I read the code and tested it.)

-----

## References

[AAp1] Anton Antonov,
[DSL::Translators Raku package](https://github.com/antononcube/Raku-DSL-Translators),
(2020-2024),
[GitHub/antononcube](https://github.com/antononcube/)

[ITp1] Itsuki Toyota,
[Algorithm::KdTree Raku package](https://github.com/titsuki/p6-Algorithm-KdTree),
(2016-2024),
[GitHub/titsuki](https://github.com/titsuki).

[NLp1] Nick Logan,
[Text::Levenshtein::Damerau Raku package](https://github.com/ugexe/Raku-Text--Levenshtein--Damerau),
(2016-2022),
[GitHub/ugexe](https://github.com/ugexe/).
