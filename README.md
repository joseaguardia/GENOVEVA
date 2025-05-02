# GENOVEVA

"Generador de nombres veloz y variado" ("Fast and varied name generator")

From a word list, it generates **17,335,754 combinations per word**, mixing lowercase, capitalized, uppercase, full and partial L33T (for each vowel and "s"), reverse, numbers from 1 to 4 digits, dates in mmddyyyy format from 1950 to 2030, date format mmddyy, symbols at the end, symbols between name and date...


Usage:
./genoveva.sh -i inputFile -o outputFile [-vsm] [-r 8-12]

-i: input file containing the base words
-p: quoted list of space-separated words
-o: output file for the dictionary
-s: Splits output into one file per input word
    (a full dictionary file for each name)
-r: range of characters to use. Format: 8-12 or 10-10
-m: minimal mode. Generates fewer combinations per word
-v: verbose mode. Displays created combinations

Example with the words "john" and "jane", using simple combinations and only 8 to 10 characters:
./genoveva.sh -p "john jane" -o john_jane.txt -m -r 8-10

![image](https://github.com/user-attachments/assets/bd1cf64b-bed1-4973-a021-2a054e80efd1)


Some of the word generated:
![image](https://github.com/user-attachments/assets/6a824c41-4ed2-42d6-b93d-2241adce3f7f)




### Changelog

v1.6

- Added option to generate only passwords within a character length range.

- Some texts are now traduced to english.

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
[Here you can find a list I compiled of Spanish proper names](other_stuffs/spanish_names.txt)

I’d think twice before running it fully through GENOVEVA, as the output file would be 355G (18,687,942,812 entries) :)
