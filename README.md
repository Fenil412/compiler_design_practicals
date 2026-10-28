# Compiler Design Practicals — Lex/Flex and YACC/Bison

Contents:
1. `roman/` — validate standard Roman numerals from 1 to 3999 and translate to decimal.
2. `binary/` — validate binary numbers and convert to decimal.
3. `variable_tracker/` — track variable definitions and usages in assignment statements, reporting line numbers.
4. `java_analyzer/` — Lex/YACC syntax checker for the Java-like subset from the practical sheet (`class`, `main`, declarations, assignments, `if-else`, `for`, `+`, `*`).
5. `variable_tracker/examples/` — sample Java, C, Python, and generic assignment inputs. The variable tracker intentionally recognizes assignment-style statements; it is not a complete parser for those languages.

## Install tools on Ubuntu

```bash
sudo apt update
sudo apt install flex bison gcc make
```

## General note about command names

With `yacc -d file.y`, generated parser files are usually `y.tab.c` and `y.tab.h`.
With `bison -d file.y`, generated parser files are usually `file.tab.c` and `file.tab.h`.
The source files here use classic YACC naming so the commands shown in the practical work.

---

## 1. Roman numeral translator

```bash
cd roman
yacc -d roman.y
lex roman.l
gcc lex.yy.c y.tab.c -o roman -ll
./roman
```

Enter one Roman numeral and press Enter, e.g. `MCMXCIV`. End with Ctrl+D.
Valid range: 1–3999. Canonical form is enforced, so `IIII`, `IC`, `VX`, and `MMMM` are rejected.

If your Ubuntu system does not provide `yacc`/`lex` aliases, use:
```bash
bison -y -d roman.y
flex roman.l
gcc lex.yy.c y.tab.c -o roman -lfl
```

## 2. Binary to decimal

```bash
cd ../binary
yacc -d binary.y
lex binary.l
gcc lex.yy.c y.tab.c -o binary -ll
./binary
```

Enter a binary number, e.g. `101101`, then press Enter. End with Ctrl+D.

## 3. Variable definition and usage tracker

```bash
cd ../variable_tracker
yacc -d tracker.y
lex tracker.l
gcc lex.yy.c y.tab.c -o tracker -ll
./tracker < examples/assignments.txt
```

This reports each variable's definition line(s) and usage line(s). In this practical's definition rule, a variable is defined when it appears on the left side of an assignment. Right-hand-side variables count as uses. It is a simple assignment-language tracker, not a full Java/C/Python semantic analyzer.

Try the examples:
```bash
./tracker < examples/assignments.txt
./tracker < examples/sample.c
./tracker < examples/sample.java
./tracker < examples/sample.py
```

## 4. Java-like syntax analyzer

```bash
cd ../java_analyzer
yacc -d parser.y
lex lexer.l
gcc lex.yy.c y.tab.c -o java_analyzer -ll
./java_analyzer < input_correct.java
./java_analyzer < input_bad_missing_semicolon.java
./java_analyzer < input_bad_character.java
```

The grammar is deliberately a small subset for the assignment, not a complete implementation of Java. It accepts the class/main structure, integer declarations, assignments, `if-else`, `for`, comparisons, `+`, and `*`.

## Expected results

- Roman: `MCMXCIV` -> `Valid Roman numeral. Decimal value = 1994`
- Roman: `IC` -> invalid
- Binary: `101101` -> decimal 45
- Java analyzer: correct input -> `Valid syntax`
- Java analyzer: incorrect input -> syntax/lexical error and `Invalid program`
