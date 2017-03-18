#/bin/bash

	beforeDate="Jan 1 2014"
	afterDate="Jan 1 2016"

    mainDir="/home/a9palmer/projects_test/"

    rm ${mainDir}/failed.txt 
    rm ${mainDir}/succeeded.txt 

	## for each repository
	for repoName in `find . -maxdepth 1 -mindepth 1 -type d -printf '%f\n'` ; do

        cd $mainDir

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
            echo "$(tput setaf 1)Repository [$repoName] doesn't go back to the date specified[$repoName]$(tput sgr0)"
            echo $repoName >> ${mainDir}/failed.txt 
        else
            echo $repoName >> ${mainDir}/succeeded.txt 
        fi

        # revert to the snapshot
        git checkout `cat rev_before.txt` > /dev/null 2>&1

   #     if [ $? -eq 0 ]; then
   #        echo Checked out the before snapshot
   #     fi

        # start on the after snapshot
        cd ../${repoName}_after
        git checkout `git rev-list -1 --before="${afterDate}" master` > /dev/null 2>&1

        echo "$(tput setaf 2)Successfully checked out project [$repoName]$(tput sgr0)"
	done
