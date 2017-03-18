#/bin/bash


	## for each repository
	repoName=caliper

	beforeDate="Jan 17 2014"

	# move into directory
	cd $repoName 

	# move everything into the after dir
	mkdir ${repoName}_after
    mv .[a-zA-Z0-9]* ${repoName}_after
	mv * ${repoName}_after

	# create before dir and copy everything into it
	mkdir ${repoName}_before
	cd ${repoName}_after
    cp -rf .[a-zA-Z0-9]* ${repoName}_before
	cp -rf . ../${repoName}_before/

    exit 0

	# go to before dir and check for the snapshot
	cd ../${repoName}_before
	git rev-list -1 --before=$beforeDate master > rev_before.txt

    # if repo doesn't go back that far in time, record project name, and exit
	if [ ! -s rev_before.txt ]; then
	    echo "File not found, or it is empty"
        echo "Repository doesn't go back to the date specified"
        echo "Exiting"
        # if rev_before empty, write name to dir, exit
        exit 1 
	fi

	#git rev-list -1 --before="Jan 17 2014" master > rev_after

