#!/bin/bash

#Bankers Algorithm

#Variable  declaration
available=()
need_matrix=()
maximum_matrix=()
allocation_matrix=()
safe_sequence=()
processes=0
resources=0

#Function to validate integer input
validate_integer() {
	local input

	while true; do
    		read -p "$1" input
    		# Regex to match only positive integers
    		if [[ "$input" =~ ^[0-9]+$ ]]; then
      			echo "$input"
      			break
    		else
      			echo "Invalid input. Please enter an integer." >&2
    		fi
  	done
}

#Function to validate value for array
validate_value() {
	local i=$1
	local j=$2
	local value2=$3
	local value1

	while true; do
		value1=$(validate_integer "Enter value for P[$i], R[$j]: ")
        if (( value1 >= value2 )); then
            echo "$value1"
            break
        else
            echo "Value cannot be less than $value2" >&2
        fi
	done
}

#Function to initialize all values of a matrix and display it
matrix_init_and_display() {
	local -n matrix=$1
	local -n matrix2=$2
	local matrix_name=$3

	#Initialising the matrix
	for ((i=0; i < processes; i++)); do
		for ((j=0; j < resources; j++)); do
			index=$((i * resources + j))
			matrix[$index]=$(validate_value $i $j ${matrix2[$index]})
		done
	done

	#Displaying the matrix
	echo "$matrix_name:"
    	echo -n "Process"
    	for((r = 0; r < resources; r++));do
	    	echo -n " R[$r] "
    	done
		echo

    	for ((i = 0; i < processes; i++)); do
        	echo -n "  P[$i]  "
        	for ((j = 0; j < resources; j++)); do
            		echo -n "  ${matrix[$((i * resources + j))]}   "
        	done
        	echo
    	done
}

#Function to display available resources
display_available() {
	local -n matrix=$1

	echo "Resources available: "
    	for((r = 0; r < resources; r++));do
	    	echo -n "R[$r] "
    	done
	echo 

	for ((i=0; i < resources; i++)); do
		echo -n "  ${matrix[$i]}  "
	done
	echo
}

#Function to calculate needed resources and display the matrix
need_calculate_and_display() {
	local -n max_arr=$1
	local -n allocated_arr=$2
	local -n need_arr=$3

	echo -n "Process"
	for((r = 0; r < resources; r++));do
		echo -n " R[$r] "
	done
	echo
	
	for ((i=0; i < processes; i++)); do
		echo -n "  P[$i]  "
		for ((j=0; j < resources; j++)); do
			index=$((i * resources + j))
			need_arr[$index]=$((max_arr[$index] - allocated_arr[$index]))
			echo -n "  ${need_arr[$index]}   "
		done
		echo
	done
}

#Function to calculate if a process can run
calculate_resources() {
	local -n available_array=$1
	local -n need_arr=$2
	local pass=0

	#Check if needs can be met with available resources
	for ((i=0; i < resources; i++)); do
		if (( need_arr[$i] <= available_array[$i] )); then
			pass=$((pass + 1))
		fi
	done

	#Check if all needs are matched
	if (( pass == resources )); then
		return 0 #True condition
	else
		return 1 #False condition
	fi
}

#Function to allocate resources
allocate_resources() {
	local -n available_arr=$1
	local -n need_arr=$2
	local -n safe_arr=$3
	found=0
	pass=0
	process_arr=()

	#Iterate over all the processes
	for ((x=0; x < processes; x++)); do
		#Check if task is completed
		for ((item=0; item < ${#safe_arr[@]}; item++)); do
			local item_val=${safe_arr[$item]}
			if (( x == item_val)); then
				found=1
				break
			fi
		done
		if (( found == 1 )); then
			found=0
			continue
		else
			#Extracting the needed resources for the process
			for ((j=0; j < resources; j++)); do
				process_arr[$j]=${need_arr[$((x * resources + j))]}
			done

			calculate_resources available_arr process_arr
			pass=$?

			#If the process can run, allocate resources
			if (( pass == 0 )); then
				for ((j=0; j < resources; j++)); do
					available_arr[$j]=$((available_arr[$j] + allocation_matrix[$((x * resources + j))]))
				done
				safe_arr+=($x)
				x=-1
			fi
		fi
	done
}

add_task() {
	local -n no_of_processes=$1
	local -n maximum=$2
	local -n allocated=$3

	#increase the number of processes
	no_of_processes=$((no_of_processes + 1))

	#Take input of required resource matrices
	for ((i=$((no_of_processes - 1)); i < no_of_processes; i++)); do
		for ((j=0; j < resources; j++)); do
			index=$((i * resources + j))
			allocated[$index]=0
		done
		echo

		echo "Enter for maximum resources:"
		for((j=0; j < resources; j++)); do
			index=$((i * resources + j))
			maximum[$index]=$(validate_value $i $j ${allocated[$index]})
		done
		echo
	done
}

#STARTING THE PROGRAM

#Get user to input values
resources=$(validate_integer "Enter number of resources: ")
processes=$(validate_integer "Enter number of processes: ")

for((i=0; i < resources; i++)); do
	available[$i]=$(validate_integer "Enter available resources for r[$i]: ")
done

display_available available

echo "Enter resources already allocated:"
matrix_init_and_display allocation_matrix maximum_matrix "Allocated Resources Matrix"

echo "Enter maximum resources needed:"
matrix_init_and_display maximum_matrix allocation_matrix "Maximum Resources Matrix"

#Calculate need matrix on the basis of data given
need_calculate_and_display maximum_matrix allocation_matrix need_matrix
echo

available_dupli=("${available[@]}")

#Display all matrices
display_available available
echo

#Calculate if there is safe sequence
allocate_resources available need_matrix safe_sequence
unsafe=99
#Check if values in safe sequence array equals the number of processes
if [[ "${#safe_sequence[@]}" == "$processes" ]]; then
	echo "System is in a safe state."
	echo "Safe sequence: ${safe_sequence[@]}"
else
	echo "System is in an unsafe state"
	unsafe=1
fi

#Infinite loop to ask for extra task continuously
while true; do
	if [[ "$unsafe" -eq "1" ]]; then
		break
	fi
	extra_task=99
	while true; do
		echo
		extra_task=$(validate_integer "Press 0 to add an additional process and 1 to finish:")

		if [[ "$extra_task" == "0" || "$extra_task" == "1" ]]; then
			break
		else
			echo "Please enter one of the specified values">&2
		fi
	done 

	#Check if user wants to add extra tasks and break the loop if they dont want to
	if [[ "$extra_task" -eq "1" ]]; then
		break
	else	
		add_task processes maximum_matrix allocation_matrix

		#Reset required values
		available=("${available_dupli[@]}")
		safe_sequence=()

		need_calculate_and_display maximum_matrix allocation_matrix need_matrix
		allocate_resources available need_matrix safe_sequence

		echo
		if [[ "${#safe_sequence[@]}" == "$processes" ]]; then
			echo "System is in a safe state."
			echo "Safe sequence: ${safe_sequence[@]}"
		else
			echo "System is in an unsafe state"
			echo "Process denied. Not enough resources"
			unsafe=1
		fi
	fi
done
	


