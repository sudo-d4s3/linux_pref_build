#!/bin/env python3
import math

def calculator(expression): 
    return eval(expression, {'__builtins__': None}, {'sqrt': math.sqrt, 'sin': math.sin, 'cos': math.cos, 'tan': math.tan, 'lcm': math.lcm, 'gcd': math.gcd, 'ceil': math.ceil, 'floor': math.floor}); 

while True: 
    try: 
        expression = input('Enter an expression: '); 
        result = calculator(expression); 
        print(result); 
    except Exception as e: 
        print('Invalid expression: ', e);
