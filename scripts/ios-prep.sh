#!/bin/sh
dir=iOS/Complex.playground/Sources
file=monoComplex.swift
scripts/makemono.pl
mkdir -p $dir
mv $file $dir
