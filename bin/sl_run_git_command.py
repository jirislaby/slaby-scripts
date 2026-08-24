#!/usr/bin/python3
import subprocess
import sys
from termcolor import colored

def run_git_command(*args: str, exit_on_error=True, capture_output=True) -> subprocess.CompletedProcess:
    if not capture_output:
        sys.stderr.flush()
        sys.stdout.flush()

    try:
        return subprocess.run(('git', ) + args, check=True, capture_output=capture_output,
                              text=True)
    except subprocess.CalledProcessError as e:
        if not exit_on_error:
            raise e
        print(colored(f"Failed to run git: {e}", 'red'), file=sys.stderr)
        print(colored("stdout:", 'red'), file=sys.stderr)
        print(e.stdout, end='', file=sys.stderr)
        print(colored("stderr:", 'red'), file=sys.stderr)
        print(e.stderr, end='', file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    run_git_command(*sys.argv[1:], capture_output=False)
