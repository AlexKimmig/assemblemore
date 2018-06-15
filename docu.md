# Conways game of life – auf dem 8051





**Ein Projekt von:**

Thomas Pötzsch

Alexander Kimmig

Jennifer Hauß







(screenshot glider)







**Karlsruhe, den 14.06.2018**

Inhaltsverzeichnis

Einleitung        3

Motivation        3

Aufgabenstellung        3

Grundlagen        3

Assembler        3

Der 8051 Mikrocomputer        3

Entwicklungsumgebung MCU-8051 DIE        3

Konzept        3

Analyse        3

Programmentwurf        3

Implementation        3

Zusammenfassung        3



# Einleitung

## Motivation

Die Motivation dieses Projektes war es die systemnahe Programmierung mit Assembler kennenzulernen und uns mit den wichtigsten Befehlen vertraut zu machen. Ein grundlegendes Verständnis von Assembler kann auch sehr hilfreich sein, um die Funktionsweise abstrakter, höherer Programmiersprachen zu verstehen und Fehler nachvollziehen zu können.

Weiterhin können Compiler-Schritte durch die Programmierung in Assembler gespart werden und Overhead vermieden werden, was besonders bei Embedded Systems sehr wichtig ist.

## Aufgabenstellung

Die Aufgabenstellung war ein kleines, simples Programm in Assembler zu programmieren. Dabei durfte man sich selbst aussuchen, was für ein Programm man implementiert.  Unsere Idee war es „Conway&#39;s Game  of life&quot; so nach zu programmieren, dass der sogenannte „Glider&quot; auf einer 8x8 LED Matrix erscheint und sich nach den Regeln des Spiels bewegt.

# Grundlagen

## Assembler

Eine Assemblersprache ist eine Programmiersprache, die zur systemnahen Programmierung eines bestimmten Computers ausgerichtet ist. Die Assemblerbefehle werden direkt in Maschinensprache (also Bytecode) umgewandelt. Damit ist es die erste Stufe ab der Maschinensprache, die für Menschen lesbar ist.

Der Quellcode eines Assemblerprogramms wird mit Hilfe einer Übersetzungssoftware (einem Assembler) in Maschinensprache übersetzt.

Der Befehlssatz der Assemblersprache ist abhängig vom Zielcomputer und somit nicht einheitlich.

https://de.wikipedia.org/wiki/Assemblersprache

## Der 8051 Mikrocomputer

Der 8051 hat 2 getrennte Adressbereiche für den Programmspeicher und für den Arbeitsspeicher, welche zusätzlich noch in internen und externen Bereich unterteilt sind.

Hier evt. Füllen

## Entwicklungsumgebung MCU-8051 DIE

Die IDE MCU-8051 ist kostenlos im Internet verfügbar und bietet Simulation des Programmablaufs inklusive der verschiedenen Speicherzustände während des Ablaufs. Dazu kann an Hardware simuliert werden:

- LED Panel
- LED Display
- LED Matrix
- Multiplexed LED Matrix
- Simple Keypad
- Matrix Keypad
- LCD Display
- Temperatursensor
- Etc.

# Konzept

## Analyse

Zunächst haben wir die vier Regeln des „Game of life&quot; analysiert und überlegt, wie die

## Programmentwurf

# Implementation

# Zusammenfassung
