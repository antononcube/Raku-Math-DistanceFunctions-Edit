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

```perl6
use Math::DistanceFunctions::Edit;
use Text::Levenshtein::Damerau;

my ($w1, $w2) = ('examples', 'samples');
say 'edit-distance : ', edit-distance($w1, $w2);
say 'dld           : ', dld($w1, $w2);
```
```
# edit-distance : 2
# dld           : 2
```

-----

## References

[NLp1] Nick Logan,
[Text::Levenshtein::Damerau Raku package](https://github.com/ugexe/Raku-Text--Levenshtein--Damerau),
(2016-2022),
[GitHub/ugexe](https://github.com/ugexe/).
