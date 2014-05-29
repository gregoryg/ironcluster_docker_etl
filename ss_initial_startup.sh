#!/bin/bash

not_first_run_flag=~/.dmexpress_first_run

## Functions to print information
print_general_info()
{
	clear
	echo "Welcome to the Ironcluster ETL Docker container"
	echo ""
	echo "For more information about this image, please go to:"
	echo ""
	echo "www.syncsort.com/dockerETL"
	echo ""
}

print_first_time_info()
{
	echo ""
	echo "If you have not yet registered, please go to www.syncsort.com/dockerETL"
	echo ""
}

print_onselect_no()
{
	echo ""
    echo "Please see /usr/dmexpress/installationguide.pdf for information"
	echo "on how to apply your license key to Ironcluster ETL."
	echo ""
}       


export PATH=/usr/dmexpress/bin:$PATH
export LD_LIBRARY_PATH=/usr/dmexpress/lib:$LD_LIBRARY_PATH

## Always print out the general information
print_general_info

## If it isn't the first time running, do nothing
if [ -e $not_first_run_flag ]; then
	exit 0
## It is the first time running
else
	print_first_time_info
	
	echo "Would you like to apply your key? (Y/N)"
	while true; do
		read -s -n 1 response
		if [ "$response" == "Y" ] || [ "$response" == "y" ] ; then
			cd /usr/dmexpress
			echo ""
			echo "Press CTRL+C to exit from the key application prompt"
			echo ""
			sudo ./applykey
			rc=$?
			if [[ $rc == 0 ]]; then
				touch $not_first_run_flag
			fi
			sudo /usr/dmexpress/bin/start_dmxd
			rc=$?
			if [[ $rc != 0 ]];then
				echo "Unable to start dmxd."
				exit 1
			else
				echo "DMExpress Server started..."
				echo ""
			fi			
			exit 0
		elif [ "$response" == "N" ] || [ "$response" == "n" ] ; then
	
			print_onselect_no
			touch $not_first_run_flag
			exit 0
		else
			echo "Please enter Y or N"
		fi
	done
fi

done
