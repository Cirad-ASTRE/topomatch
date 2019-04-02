
<!-- README.md is generated from README.Rmd. Please edit that file -->
topomatch
=========

Helper function for matching toponyms from different sources, that can be written in slightly different ways. Allows to inspect the matching and act accordingly.

``` r
countries1 <- spData::world$name_long
countries2 <- unique(maps::world.cities$country.etc)

(country_matches <- topomatch(countries1, countries2))
#> 156 names matched exactly: Fiji, Tanzania, Western Sahara, ... 
#> 
#> 15 matches based on similarity: 
#>   1. United States:  United Arab Emirates 
#>   2. Democratic Republic of the Congo:  Congo Democratic Republic 
#>   3. Russian Federation:  Russia 
#>   4. French Southern and Antarctic Lands:  Northern Mariana Islands 
#>   5. Timor-Leste:  East Timor 
#>   6. Côte d'Ivoire:  Cape Verde 
#>   7. The Gambia:  Gambia 
#>   8. United Kingdom:  United Arab Emirates 
#>   9. Brunei Darussalam:  Brunei 
#>   10. Antarctica:  Vatican City 
#>   11. Northern Cyprus:  Northern Mariana Islands 
#>   12. Somaliland:  Swaziland 
#>   13. Serbia:  Serbia and Montenegro 
#>   14. Montenegro:  Serbia and Montenegro 
#>   15. South Sudan:  South Africa 
#> 
#> 6 unresolved matches: 
#>   1. Republic of the Congo: Czech Republic, Dominican Republic, ... 
#>   2. eSwatini: Palestine, Estonia 
#>   3. Lao PDR: San Marino, ... 
#>   4. Dem. Rep. Korea: Korea South, Korea North 
#>   5. Republic of Korea: Czech Republic, Dominican Republic, ... 
#>   6. Kosovo: Comoros, Solomon Islands
```

There are some manual fixes needed for those toponyms that weren't correctly matched. Just write the fixes in a named vector. If there is no correct match for one toponym, give it an `NA`.

``` r
## Inspect the competing candidates for the unmatched countries
(bm <- best_matches(country_matches)[unmatched(country_matches)])
#> $`Republic of the Congo`
#> [1] "Czech Republic"            "Dominican Republic"       
#> [3] "Congo Democratic Republic" "Central African Republic" 
#> 
#> $eSwatini
#> [1] "Palestine" "Estonia"  
#> 
#> $`Lao PDR`
#> [1] "San Marino"               "Central African Republic"
#> [3] "Sao Tome and Principe"   
#> 
#> $`Dem. Rep. Korea`
#> [1] "Korea South" "Korea North"
#> 
#> $`Republic of Korea`
#> [1] "Czech Republic"            "Dominican Republic"       
#> [3] "Congo Democratic Republic" "Central African Republic" 
#> 
#> $Kosovo
#> [1] "Comoros"         "Solomon Islands"

cnames_fixes <- setNames(
  c("Congo Democratic Republic", NA, "Laos", "Korea North",
    "Korea South", NA),
  names(bm)
)

## Fix the incorrectly matches from similarity as well
cnames_fixes <- c(
  cnames_fixes,
  "United States" = "USA",
  "French Southern and Antarctic Lands" = "France",
  "Côte d'Ivoire" = "Ivory Coast",
  "United Kingdom" = "UK",
  "Antarctica" = NA,
  "Northern Cyprus" = "Cyprus",
  "Somaliland" = "Somalia",
  "South Sudan" = "Sudan"
)
```

Now you can `transcribe` the original toponyms to the matched terms.

``` r
translate <- transcribe(country_matches, fixes = cnames_fixes)

translate(c("United Kingdom", "Kosovo"))
#> [1] "UK" NA

## "Translate" all of the original toponyms
countries1_trans <- translate(countries1)

## Only those "fixed" as NA are not found in the second list
countries1[!countries1_trans %in% countries2]
#> [1] "eSwatini"   "Antarctica" "Kosovo"
```

Method
------

Wraps local-global alignment algorithm borrwed from bioConductor package `Biostrings`. Works better than global alignment and requires less fine-tuning (although is considerably slower too) <https://ro-che.info/articles/2016-12-11-local-alignment>.

Installation
------------

``` r
remotes::install_github("Cirad-ASTRE/topomatch")
```

<!-- You can install the released version of topomatch from [CRAN](https://CRAN.R-project.org) with: -->
<!-- ``` r -->
<!-- install.packages("topomatch") -->
<!-- ``` -->
