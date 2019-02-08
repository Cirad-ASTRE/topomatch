
<!-- README.md is generated from README.Rmd. Please edit that file -->
topomatch
=========

Helper function for matching toponyms from different sources, that can be written in slightly different ways. Allows to inspect the matching and act accordingly.

``` r
countries1 <- raster::ccodes()$NAME
countries2 <- unique(maps::world.cities$country.etc)

(country_matches <- topomatch(countries1, countries2))
#> 218 names matched exactly: Afghanistan, Albania, Algeria, American Samoa, Andorra, Angola, Anguilla, Antigua and Barbuda, Argentina, Armenia, Aruba, Australia, Austria, Azerbaijan, Bahamas, Bahrain, Bangladesh, Barbados, Belarus, Belgium, Belize, Benin, Bermuda, Bhutan, Bolivia, Bosnia and Herzegovina, Botswana, Brazil, British Virgin Islands, Brunei, Bulgaria, Burkina Faso, Burundi, Cambodia, Cameroon, Canada, Cape Verde, Cayman Islands, Central African Republic, Chad, Chile, China, Colombia, Comoros, Cook Islands, Costa Rica, Croatia, Cuba, Cyprus, Czech Republic, Denmark, Djibouti, Dominican Republic, Dominica, Ecuador, Egypt, El Salvador, Equatorial Guinea, Eritrea, Estonia, Ethiopia, Falkland Islands, Faroe Islands, Fiji, Finland, France, French Guiana, French Polynesia, Gabon, Gambia, Georgia, Germany, Ghana, Gibraltar, Greece, Greenland, Grenada, Guadeloupe, Guam, Guatemala, Guinea-Bissau, Guinea, Guyana, Haiti, Honduras, Hungary, Iceland, India, Indonesia, Iran, Iraq, Ireland, Isle of Man, Israel, Italy, Jamaica, Japan, Jersey, Jordan, Kazakhstan, Kenya, Kiribati, Kuwait, Kyrgyzstan, Laos, Latvia, Lebanon, Lesotho, Liberia, Libya, Liechtenstein, Lithuania, Luxembourg, Macedonia, Madagascar, Malawi, Malaysia, Maldives, Mali, Malta, Marshall Islands, Martinique, Mauritania, Mauritius, Mayotte, Mexico, Micronesia, Moldova, Monaco, Mongolia, Montserrat, Morocco, Mozambique, Myanmar, Namibia, Nauru, Nepal, Netherlands, New Caledonia, New Zealand, Nicaragua, Niger, Nigeria, Niue, Norfolk Island, Northern Mariana Islands, Norway, Oman, Pakistan, Palau, Panama, Papua New Guinea, Paraguay, Peru, Philippines, Poland, Portugal, Puerto Rico, Qatar, Reunion, Romania, Russia, Rwanda, Saint-Martin, Saint Helena, Saint Kitts and Nevis, Saint Lucia, Saint Pierre and Miquelon, Saint Vincent and the Grenadines, Samoa, San Marino, Sao Tome and Principe, Saudi Arabia, Senegal, Seychelles, Sierra Leone, Singapore, Slovakia, Slovenia, Solomon Islands, Somalia, South Africa, Spain, Sri Lanka, Sudan, Suriname, Svalbard and Jan Mayen, Swaziland, Sweden, Switzerland, Syria, Taiwan, Tajikistan, Tanzania, Thailand, East Timor, Togo, Tokelau, Tonga, Trinidad and Tobago, Tunisia, Turkey, Turkmenistan, Tuvalu, Uganda, Ukraine, United Arab Emirates, Uruguay, Uzbekistan, Vanuatu, Vatican City, Venezuela, Vietnam, Wallis and Futuna, Western Sahara, Yemen, Zambia, Zimbabwe 
#> 
#> 32 matches based on similarity: 
#>   1. Akrotiri and Dhekelia:  Saint Pierre and Miquelon 
#>   2. Antarctica:  Vatican City 
#>   3. Bonaire, Saint Eustatius and Saba:  Saint Kitts and Nevis 
#>   4. Bouvet Island:  Easter Island 
#>   5. British Indian Ocean Territory:  British Virgin Islands 
#>   6. Caspian Sea:  American Samoa 
#>   7. Christmas Island:  Cayman Islands 
#>   8. Clipperton Island:  Solomon Islands 
#>   9. Cocos Islands:  Cook Islands 
#>   10. Côte d'Ivoire:  Ireland 
#>   11. Curaçao:  Nicaragua 
#>   12. Democratic Republic of the Congo:  Congo Democratic Republic 
#>   13. French Southern Territories:  French Polynesia 
#>   14. Guernsey:  Guernsey and Alderney 
#>   15. Heard Island and McDonald Islands:  Falkland Islands 
#>   16. Hong Kong:  Serbia and Montenegro 
#>   17. Montenegro:  Serbia and Montenegro 
#>   18. North Korea:  Northern Mariana Islands 
#>   19. Northern Cyprus:  Northern Mariana Islands 
#>   20. Palestina:  Palestine 
#>   21. Paracel Islands:  Northern Mariana Islands 
#>   22. Saint-Barthélemy:  Saint-Barthelemy 
#>   23. Serbia:  Serbia and Montenegro 
#>   24. Sint Maarten:  Saint-Martin 
#>   25. South Georgia and the South Sandwich Islands:  British Virgin Islands 
#>   26. South Korea:  South Africa 
#>   27. South Sudan:  South Africa 
#>   28. Spratly Islands:  Canary Islands 
#>   29. Turks and Caicos Islands:  Turks and Caicos 
#>   30. United Kingdom:  United Arab Emirates 
#>   31. United States Minor Outlying Islands:  US Virgin Islands 
#>   32. United States:  United Arab Emirates 
#> 
#> 6 unresolved matches: 
#>   1. Åland: Netherlands, Switzerland, Finland, Greenland, Ireland, Canary Islands, Marshall Islands, New Zealand, Iceland, Faroe Islands, Poland, Thailand, Cook Islands, US Virgin Islands, Netherlands Antilles, Solomon Islands, Swaziland, Cayman Islands, Northern Mariana Islands, Falkland Islands, Easter Island, Norfolk Island, British Virgin Islands 
#>   2. Kosovo: Comoros, Solomon Islands 
#>   3. Macao: Malaysia, Madagascar, Macedonia, Malawi, Micronesia 
#>   4. Pitcairn Islands: US Virgin Islands, British Virgin Islands 
#>   5. Republic of Congo: Czech Republic, Dominican Republic, Congo Democratic Republic, Central African Republic 
#>   6. Virgin Islands, U.S.: US Virgin Islands, British Virgin Islands

str(country_matches)
#>  'topomatch' num [1:239, 1:256] 0 0 0 0 0 0 0 0 0 0 ...
#>  - attr(*, "dimnames")=List of 2
#>   ..$ : chr [1:239] "Palestine" "Pakistan" "Kuwait" "Somalia" ...
#>   ..$ : chr [1:256] "Afghanistan" "Akrotiri and Dhekelia" "Åland" "Albania" ...
```

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
