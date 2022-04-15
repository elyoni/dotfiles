#!/usr/bin/env python3
import subprocess  # To run ssh-keygen
import os  # For the join
import argparse

SSH_KEY_DIR="$HOME/.ssh"

class SshKey():
    def __init__(self, output_location=SSH_KEY_DIR, algorithm="ed25519"):
        self.output_location = output_location
        self.algorithm = algorithm

    def generate_pair(self, key_name, comment=""):
        file_path=os.path.join(self.output_location, key_name)
        subprocess.run(f"ssh-keygen -t {self.algorithm} -C \"{comment}\" -f \"{file_path}\" -P \"\"", shell=True, check=True)


def argparse_handler():
    parser = argparse.ArgumentParser(description=
                                     'The tool will help you to create pairs of RSA keys.' +
                                     f'The default path to save the kays are in {SSH_KEY_DIR}', formatter_class=argparse.RawTextHelpFormatter)

    parser.add_argument('-k', '--key_name', type=str, dest='KEY_NAME',
            required=True, help='Private key name')
    parser.add_argument('-c', '--comment', type=str, dest='COMMENT',
            help='Add comment to the key')
    return parser

def main():
    # Create the parser
    parser = argparse_handler()# Add an argument
    args = parser.parse_args()# Print "Hello" + the user input argument
    ssh_key = SshKey()
    ssh_key.generate_pair(args.KEY_NAME, args.COMMENT)

main()
