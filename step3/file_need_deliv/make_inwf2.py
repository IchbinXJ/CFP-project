import os

# Read values from step3.band_number file
file_path = './step3.band_number'
with open(file_path, 'r') as file:
    line = file.readline().strip()  # Read the first line and remove any extra whitespace
    aa, bb, cc, dd = line.split()  # Split the line into aa and bb

# Construct the command using the read values
#os.system('echo -e "{} {}\n{}:f\n{}:f\n" | write_inwf'.format(aa, bb))
cc = int(cc)
dd = int(dd)

# Construct the command using the read values and dynamic part
command_parts = []
for i in range(cc):
    command_parts.append('{}:f\n'.format(dd + i))

command = 'echo -e "{} {}\n{}" | write_inwf'.format(aa, bb, ''.join(command_parts))

# Print the command for debugging purposes
print("Command to execute:", command)

# Execute the command
os.system(command)
