#!/bin/bash

COMPILER=./tiny_compiler

for TEST in teste_*.tiny; do
  echo "===== Testando $TEST ====="
  $COMPILER < "$TEST"
  echo
  echo "==========================="
  echo
done 