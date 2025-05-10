# GENOVEVA

 ### Fast and versatile name generator for custom brute force attacks

From a word list, it generates up to **17,335,754 combinations per word**, mixing lowercase, capitalized, uppercase, full and partial L33T (for each vowel and the letter "s"), reverse forms, numbers from 1 to 4 digits, dates in mmddyyyy format from 1950 to 2030, date format mmddyy, symbols at the end, symbols between name and date...

## Usage
`./genoveva.sh -i inputFile -o outputFile [-vsm] [-r 8-12]`

Options

| Param. | Description |
| --- | --- |
| `-i` | **input file** containing the base words |
| `-p` | a **list of words** to generate dictionary (quoted and space-separated) |
| `-o` | **output file** for the dictionary |
| `-r` | character **length range** to use. (format: 8-12 or 10-10) |
| `-m` | **generates fewer combinations** per word (minimal mode) |
| `-s` | splits output into **separate files for each word** |
| `-v` | **verbose mode** (displays generated combinations) |



## Example 

With the words "john" and "jane", using simple combinations and only 8 to 10 characters, saved in the ./john_jane.txt file:

`./genoveva.sh -p "john jane" -o john_jane.txt -m -r 8-10`


![image](https://github.com/user-attachments/assets/bd1cf64b-bed1-4973-a021-2a054e80efd1)


Some of the word generated:
![image](https://github.com/user-attachments/assets/6a824c41-4ed2-42d6-b93d-2241adce3f7f)




## Extras
[Here you can find a list I compiled of Spanish proper names](other_stuffs/spanish_names.txt)

I’d think twice before running it fully through GENOVEVA, as the output file would be 355G (18,687,942,812 entries) :)
