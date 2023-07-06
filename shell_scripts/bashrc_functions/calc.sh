#!/bin/bash

calc() { python3 -c "import ast; from math import *; print(eval(compile('$1', '<string>', 'eval')))" || echo "Invalid expression"; }
