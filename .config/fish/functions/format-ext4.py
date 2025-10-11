import subprocess
import sys
# import getpass  # For secure password input


def main():
    """Usage: `python format-ext4.py /dev/disk10`"""
    # Check if device argument is provided
    if len(sys.argv) != 2:
        print("Usage: python format-ext4.py <device>")
        print("Example: python format-ext4.py /dev/disk10")
        sys.exit(1)

    device = sys.argv[1]

    # Validate device path format (basic check)
    if not device.startswith('/dev/'):
        print("Error: Device must start with '/dev/'")
        sys.exit(1)

    e2fsprogs_path = subprocess.run(['brew', '--prefix', 'e2fsprogs'],
                                    capture_output=True,
                                    text=True).stdout.strip()
    # password = getpass.getpass("Enter your sudo password: ")
    # command = ['sudo', '-S', 'apt', 'update']  # -S reads password from stdin
    command = ['sudo', f"$(brew --prefix e2fsprogs)/sbin/mkfs", device]

    print(f"Formatting device: {device}")
    print(f"Command: {' '.join(command)}")

    # Ask for confirmation
    confirm = input(f"Are you sure you want to format {device}? This will erase all data! (yes/no): ")
    if confirm.lower() != 'yes':
        print("Operation cancelled.")
        sys.exit(0)

    # process = subprocess.Popen(command, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    # stdout, stderr = process.communicate(input=password + '\n')
    process = subprocess.run(command, capture_output=True, text=True)

    if process.returncode == 0:
        print("Success:", process.stdout)
    else:
        print("Error:", process.stderr)

if __name__ == "__main__":
    main()
