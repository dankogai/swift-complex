#!/bin/sh

swift build && swift -I.build/debug -L.build/debug -lComplex
