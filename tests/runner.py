import json
import subprocess
import numpy as np
from tensorflow.keras.datasets import mnist

def load_tests(json_file):
    with open(json_file, 'r') as file:
        return json.load(file)

def print_image(image):
    for row in image:
        line = "".join(["*" if pixel > 0.5 else " " for pixel in row])
        print(line)

def run_test(test):
    command = ['venus', test['test_file']] + test['args']  # Adjust this command as necessary
    print(command)
    try:
        # Run the command and capture the output
        result = subprocess.run(command, capture_output=True, text=True)

        # Check the exit code
        if result.returncode != test.get('exitcode', 0):
            return False, f"Expected exit code {test.get('exitcode', 0)}, got {result.returncode}"

        # Check stdout
        if 'stdout' in test and test['stdout'] != result.stdout.strip():
            return False, f"Expected stdout: '{test['stdout']}', got: '{result.stdout.strip()}'"
        
        return True, "PASSED"

    except Exception as e:
        return False, str(e)

def main():
    tests = load_tests('./test_cases/test.json')  # Load tests from the JSON file

    print("****************************************")
    for test in tests['tests']:
        print(f"[1] ({test['id']}) Running {test['name']}...")
        print("****************************************")

        passed, message = run_test(test)

        print("----------------------------------------")
        if passed:
            print("PASSED")
        else:
            print("FAILED")
            print(message)
        print("----------------------------------------")

if __name__ == "__main__":
    (x_train, y_train), (x_test, y_test) = mnist.load_data()
    
    x_train = x_train.astype('float32') / 255
    x_test = x_test.astype('float32') / 255
    main()