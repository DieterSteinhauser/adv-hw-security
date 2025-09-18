# --------------------------------------------
# Dieter Steinhauser
# 9/4/25
# Adv HW Security
# --------------------------------------------

set relative_path "iscas85"  ; # Using the iscas85 directory is in the same directory as the script

# --------------------------------------------

# a. Echoes loop number in a for loop
puts "--- Part a: Loop Number Echo ---"
for {set i 0} {$i < 5} {incr i} {
    puts "Loop number: $i"
}

# --------------------------------------------

# b. Echoes number of files and filenames from a list of files (ISCAS85 benchmarks)
puts "\n--- Part b: File List and Count ---"

if {![file exists $relative_path]} {
    puts "Error: ISCAS85 directory '$relative_path' not found."
    exit 1
}

set files [glob -directory $relative_path -type f *.v] ; # Using Verilog files (.v)
set num_files [llength $files]
puts "Number of files: $num_files"

foreach file $files {
    puts "Filename: $file"
}

# # --------------------------------------------

# c. Echoes numbers only for each filename from previous task. Find the sum of all the numbers retrieved and echo the result
puts "\n--- Part c: Extract Numbers and Sum ---"
set total_sum 0

foreach file $files {

    # extracts the filename and extension only.
    set filename [file tail $file] 

    # Extract numbers from filename (assuming numbers are part of the filename)
    regexp {(\d+)} $filename numbers

    if {[llength $numbers] > 0} {
        set extracted_number [lindex $numbers 0]
        puts "Extracted number from $file: $extracted_number"
        incr total_sum $extracted_number

    } else {
        puts "No numbers found in $file"
    }
    
}
puts "Total sum of extracted numbers: $total_sum"

# # --------------------------------------------

# d. Creates a new folder RTL and copy all of files in ISCAS85 to it.
puts "\n--- Part d: Create RTL Folder and Copy Files ---"
set rtl_dir "RTL"
if {![file exists $rtl_dir]} {
    file mkdir $rtl_dir

    foreach file $files {
        file copy $file $rtl_dir/
    }
}

puts "Files copied to '$rtl_dir' directory."
# --------------------------------------------

# e. Concatenates directory and filenames (and extension if needed)

foreach file $files {

    # extracts the filename and extension only.
    set absolute_path [file normalize $relative_path]
    # puts "Absolute path: $absolute_path"
    puts "Concatenated filename: $absolute_path/$filename"

    }

# --------------------------------------------

# f. Open and appends filenames with directory in a text file in the for loop.
puts "\n--- Part f: Append Filenames to Text File ---"
set output_file "file_list.txt"
set txt_file [open $output_file "a"] ; # Open in append mode

# You can optionally add a message to confirm the operation
puts "Data appended to my_data.txt successfully."
foreach file $files {
    set full_path [file join $absolute_path $file]
    puts $txt_file $full_path
}

# close the file
close $txt_file
puts "Filenames with directory appended to '$output_file'."
