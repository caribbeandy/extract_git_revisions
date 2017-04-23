### Synopsis

- Given a list of dates, extracts the corresponding snapshots from a git repository into nested folders.
- The original intent of this script was to preprocess a git repository for an incremental code clone detection and/or clone genealogy extraction (e.g. gCad [1] and iClones [2]).
- Also contains a cached set of URLs for all Google's GitHub Java projects.

### Usage

Edit these variables at the top of gen_snapshots.sh:

```shell
    mainDir="MAIN_DIR"
    dates=("Jan 1 2012" "May 6 2012")
```

[1]: http://ieeexplore.ieee.org/document/6676939/	"gCad: A Near-Miss Clone Genealogy Extractor to Support Clone Evolution Analysis"
[2]: http://www.softwareclones.org/iclones.php#prepare	"Preparing source code for iClones "
