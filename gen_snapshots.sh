#!/bin/bash

    ######## EDIT THESE ##########
    mainDir="MAIN_DIR"

    dates=(
	"Jan 1 2011" "Feb 1 2011" "March 1 2011" "April 1 2011" "May 1 2011" "June 1 2011" "July 1 2011" "Aug 1 2011" "Sept 1 2011" "Oct 1 2011" "Nov 1 2011" "Dec 1 2011"
	"Jan 1 2012" "Feb 1 2012" "March 1 2012" "April 1 2012" "May 1 2012" "June 1 2012" "July 1 2012" "Aug 1 2012" "Sept 1 2012" "Oct 1 2012" "Nov 1 2012" "Dec 1 2012"
	"Jan 1 2013" "Feb 1 2013" "March 1 2013" "April 1 2013" "May 1 2013" "June 1 2013" "July 1 2013" "Aug 1 2013" "Sept 1 2013" "Oct 1 2013" "Nov 1 2013" "Dec 1 2013"
	"Jan 1 2014" "Feb 1 2014" "March 1 2014" "April 1 2014" "May 1 2014" "June 1 2014" "July 1 2014" "Aug 1 2014" "Sept 1 2014" "Oct 1 2014" "Nov 1 2014" "Dec 1 2014"
	"Jan 1 2015" "Feb 1 2015" "March 1 2015" "April 1 2015" "May 1 2015" "June 1 2015" "July 1 2015" "Aug 1 2015" "Sept 1 2015" "Oct 1 2015" "Nov 1 2015" "Dec 1 2015"
	"Jan 1 2016" "Feb 1 2016" "March 1 2016" "April 1 2016" "May 1 2016" "June 1 2016" "July 1 2016" "Aug 1 2016" "Sept 1 2016" "Oct 1 2016" "Nov 1 2016" "Dec 1 2016"
	"Jan 1 2017"
    )

    #############################

    rm ${mainDir}/failed.txt > /dev/null 2>&1
    rm ${mainDir}/succeeded.txt > /dev/null 2>&1

    i=100

	## for each repository
	for repoName in `find ${mainDir} -maxdepth 1 -mindepth 1 -type d -printf '%f\n'` ; do

        cd $mainDir

        # cd into directory
        cd $repoName 

        origFolder="${repoName}_original"

        # if we already did this once

        if [ ! -d "$origFolder" ]; then
            # move everything into the newest dir
            mkdir $origFolder
            mv .[a-zA-Z0-9]* $origFolder > /dev/null 2>&1
            mv * $origFolder > /dev/null 2>&1
        fi

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
