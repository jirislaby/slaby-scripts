import os
import subprocess
import sys

from termcolor import colored


class Git:
    tree: os.PathLike

    def __init__(self, tree: os.PathLike | None = None):
        self.tree = tree if tree else os.getcwd()

    def call(self, *args: str, **kwargs) -> subprocess.CompletedProcess:
        cmd = ['git', '-C', str(self.tree), *args]
        return subprocess.run(cmd, check=True, text=True, **kwargs)

    def oneline(self, *args: str) -> str:
        res = self.call(*args, capture_output=True)
        return res.stdout.rstrip()

    def multiline(self, *args: str) -> list[str]:
        res = self.call(*args, capture_output=True)
        return res.stdout.splitlines()

def run_git_command(*args: str, exit_on_error=True, capture_output=True) -> subprocess.CompletedProcess:
    if not capture_output:
        sys.stderr.flush()
        sys.stdout.flush()

    try:
        return Git().call(*args, capture_output=capture_output)
    except subprocess.CalledProcessError as e:
        if not exit_on_error:
            raise
        print(colored(f"Failed to run git: {e}", 'red'), file=sys.stderr)
        if e.stdout:
            print(colored("stdout:", 'red'), file=sys.stderr)
            print(e.stdout, end='', file=sys.stderr)
        if e.stderr:
            print(colored("stderr:", 'red'), file=sys.stderr)
            print(e.stderr, end='', file=sys.stderr)
        sys.exit(1)
