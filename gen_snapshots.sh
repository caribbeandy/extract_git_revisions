#/bin/bash

	beforeDate="Jan 17 2016"
	afterDate="May 17 2016"

	## for each repository
	for repoName in * ; do

        if [ -f "$repoName" ]; then
            continue
        fi

        #repoName=caliper

        # move into directory
        cd $repoName 

        # move everything into the after dir
        mkdir ${repoName}_after
        mv .[a-zA-Z0-9]* ${repoName}_after > /dev/null 2>&1
        mv * ${repoName}_after > /dev/null 2>&1

        # create before dir and copy everything into it
        mkdir ${repoName}_before
        cd ${repoName}_after

        cp -rf .[a-zA-Z0-9]* ../${repoName}_before
        cp -rf * ../${repoName}_before/

        # go to before dir and check for the snapshot
        cd ../${repoName}_before
        git rev-list -1 --before="${beforeDate}" master > rev_before.txt

        ### Also need to account for initial commits

        # if repo doesn't go back that far in time, record project name, and exit
        if [ ! -s rev_before.txt ]; then
            echo "File not found, or it is empty"
            echo "Repository doesn't go back to the date specified"
            echo "Exiting"
            # if rev_before empty, write name to dir, exit

            exit 1 
        fi

        # revert to the snapshot
        git checkout `cat rev_before.txt` > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo Checked out the before snapshot
        fi

        # start on the after snapshot
        cd ../${repoName}_after
        #git rev-list -1 --before="Jan 17 2014" master > rev_after
        git checkout `git rev-list -1 --before="${afterDate}" master` > /dev/null 2>&1

        if [ $? -eq 0 ]; then
            echo Checked out the after snapshot
        fi

        echo Successfully checked out project $repoName
	done
