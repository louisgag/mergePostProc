# mergePostproc

The purpose of this script is to merge the different time folders created by the OpenFOAM postprocessing utilities when started or restarted at different times of the simulation. The original motivation to write it was to simplify the plotting of forces by not having to loop over different postProcessing subfolders and striping headers and unwanted output times.

The script takes the source/target filename root *fileRoot* as a single argument.
Example: `./mergePostProc.sh force`

The script will create a subfolder named mergedTimes for each folder present in the postProcessing folder.
It will create inside of it a file named *fileRoot*.dat and prepend to it starting from the last source *fileRoot*.dat.
The times listed in each source *fileRoot*.dat file will only be taken if not overwriten by the latest run.
For example, if *fileRoot*.dat in folder 0 has times going from 0 to 15 and the *fileRoot*.dat in folder 13 has times going from 13 to 20 the resulting *fileRoot*.dat in the mergedTimes folder will contain times 0 until 13 from folder 0 and 13 to 20 from folder 13.
