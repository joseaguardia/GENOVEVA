# GENOVEVA

"Generador de nombres veloz y variado" ("Fast and varied name generator")

From a word list, it generates **17,335,754 combinations per word**, mixing lowercase, capitalized, uppercase, full and partial L33T (for each vowel and "s"), reverse, numbers from 1 to 4 digits, dates in mmddyyyy format from 1950 to 2030, date format mmddyy, symbols at the end, symbols between name and date...

Here you can check all the combinations for the example 'abecedarios':  
[example.txt](other_stuffs/ejemplo.txt) Here are some examples:

```
Abecedario+09052016
oiradecebA+30111954
4beced4rio%
ab3c3dario,051132
oiradecebA,2
Abecedari0_120842
Ab3c3dario%150346
abecedar1o+010931
abecedario+090676
abecedar1o-9810
4BECED4RIO+2117
4BECED4RIO+4145
oiradeceba*290147
AB3C3DARIO+050560
ABECEDARIO,110272
abecedar1o+020268
Abecedari0-25101959
4b3c3d4r10!060182
ABECEDAR1O!150390
AB3C3DARIO,11081999
```

Usage:
./genoveva.sh -i inputFile -o outputFile [-vs]
./genoveva.sh -p "one two three" -o outputFile [-vs]

-i: input file containing the base words
-p: quoted list of space-separated words
-o: output file for the dictionary
-s: Splits output into one file per input word
    (a full dictionary file for each name)
-m: minimal mode. Generates fewer combinations per word
-v: verbose mode. Displays created combinations




<p align="center">
 <img src="genoveva.png" />
</p>


### Changelog
v1.5

- Extended date range from 2020 to 2030

v1.4

- Added -m option to generate around 50% fewer combinations (removes all 'reverse' and some symbols). From 17,335,754 max per word to 8,070,102)

- Fixed bug where the script didn’t finish correctly

v1.3

- Added function to split output into a file per input name

v1.2

- Fixed character handling issue (only generated for the first one)

v1.1

- Now possible to pass words directly via the -p command option

- Parameter checks added to prevent errors

- Visual tweaks

v1.0

- Functional base version


## Extras
[Here you can find a list I compiled of Spanish proper names](othetr_stuffs/spanish_names.txt)

I’d think twice before running it fully through GENOVEVA, as the output file would be 355G (18,687,942,812 entries) :)