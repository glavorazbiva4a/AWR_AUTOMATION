import os

# Set ORACLE_SID and ORACLE_HOME here
os.environ['ORACLE_SID'] = 'TGCSDB'
os.environ['ORACLE_HOME'] = '/u01/app/oracle/product/19.3.0.1/db_EE_01'

# The rest of your script below
input_file_path = '/tmp/snap_id.txt'  # Replace with your file path
search_dates = ['23:30', '00:45']  # Dates to search for
snapshot_id1 = None  # Variable for the first snapshot ID
snapshot_id2 = None  # Variable for the second snapshot ID

try:
    # Open the input file for reading
    with open(input_file_path, 'r') as input_file:
        # Iterate through each line in the file
        for line in input_file:
            # Split the line into columns based on the '|' character
            columns = line.strip().split('|')
            if len(columns) == 2:
                # Extract the snapshot ID from the left side of the pipe character
                snapshot_id = columns[0]
                # Check if the date matches any of the search dates
                if columns[1] in search_dates:
                    if snapshot_id1 is None:
                        snapshot_id1 = snapshot_id  # Assign the first snapshot ID
                    else:
                        snapshot_id2 = snapshot_id  # Assign the second snapshot ID

    if snapshot_id1 is not None and snapshot_id2 is not None:
        print(snapshot_id1)
        print(snapshot_id2)
    else:
        print("Not enough snapshot IDs found for the specified dates.")

except IOError:
    print("File '{}' not found or cannot be opened.".format(input_file_path))
except Exception as e:
    print("An error occurred: {}".format(e))

# ... Your previous code ...

if snapshot_id1 is not None and snapshot_id2 is not None:
    print(snapshot_id1)  # Print snapshot_id1
    print(snapshot_id2)  # Print snapshot_id2
else:
    print("No snapshot IDs found for the specified dates.")
