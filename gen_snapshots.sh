#!/bin/bash

	#beforeDate="Jan 1 2012"
	#afterDate="Jan 1 2013"

    mainDir="/home/a9palmer/iclones_test"
    dates=( "Jan 1 2012" "May 6 2012" )

    rm ${mainDir}/failed.txt > /dev/null 2>&1
    rm ${mainDir}/succeeded.txt > /dev/null 2>&1

    i=0
	## for each repository
	for repoName in `find ${mainDir} -maxdepth 1 -mindepth 1 -type d -printf '%f\n'` ; do

        #### Preparation

        cd $mainDir

        # cd into directory
        cd $repoName 

        origFolder="${repoName}_original"

        # move everything into the newest dir
        mkdir $origFolder
        mv .[a-zA-Z0-9]* $origFolder > /dev/null 2>&1
        mv * $origFolder > /dev/null 2>&1
        #todo: change to move ****

        ## end preparation

        for date in "${dates[@]}"
        do

            cd $mainDir

            # cd into directory
            cd $repoName 

            # create dir for the date and copy everything into it
            revDirName=rev_${i}_${date}
            mkdir "${revDirName}"

            cd $origFolder

            cp -rf .[a-zA-Z0-9]* ../"${revDirName}"
            cp -rf * "../${revDirName}/"

            # go to date dir and check for the snapshot
            cd "../${revDirName}"
            git rev-list -1 --before="${date}" master > rev_"${date}".txt

            ### TODO: Also need to account for initial commits

            # if repo doesn't go back that far in time, record project name, and exit
            if [ ! -s "rev_${date}.txt" ]; then
                echo "$(tput setaf 1)Repository [$repoName] doesn't go back to the date specified[$date]$(tput sgr0)"
                echo ${repoName}_${date} >> ${mainDir}/failed.txt 
            else
                echo ${repoName}_${date} >> ${mainDir}/succeeded.txt 
            fi

            # checkout the snapshot
            git checkout `cat rev_"${date}".txt` > /dev/null 2>&1
            rm rev_"${date}".txt

       #     if [ $? -eq 0 ]; then
       #        echo Checked out the before snapshot
       #     fi

            echo "$(tput setaf 2)Successfully checked out project [$repoName] for date [$date]$(tput sgr0)"

            i=$((i + 1))
        done
	done
