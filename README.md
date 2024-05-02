# Extracting Club Head Parameters

This research, led by MADS students at Carnegie Mellon University in partnership with golf startup company SquareFace, aims to carefully determine the best CHPs for producing the ideal trajectories and results for the nine standard shot shapes in golf. By exploring how each parameter affects different shot types, this study is set to offer essential insights that can significantly boost performance using existing clubs. Through this research, we are looking to bridge the gap between theoretical golf principles and the practical needs of golfers aiming to improve their game with standard equipment.

The data were collected from the CMU golf team using TrackMan, a radar that reports the CHPs of each shot given the ball’s trajectory. The data were collected in January and February of 2024. There were a total of 14,517 shots recorded however there are several limitations that should be noted.

### Data Cleaning

The `Input Data` directory contains the raw data we recieved. There two files that have uniform columns that are combined in the `Data Cleaning.R` file. Said file removes missing values and filters the data to only be rows that meet our "good shot" criteria. The `Output Data` directory contains cleaned data for standard clubs and cleaned data for all clubs not exclusive to standard clubs. The Data Cleaning directory is the first part of the pipeline but technically does not need to be run unless the data cleaning process is adjusted.

### Parameter Extraction

This directory contains 5 separte directories for 5 separate club types. Each of the 5 sub-directories contain RMarkdown files for both genders. Given that the data are cleaned, these files can be run as a pipeline to extract the wanted CHPs for each club type and gender. At the top of each file, the quadrant sizes can be adjusted.

The directory also contains a file that concatenates all of the data sets together called `ParameterExtractionDFOutput.R`. Given that all of the club files are run and datframes of parameters have been made, a data set is outputed as `Extracted_CHPs.csv`. This data set has a data dictionary located in the Parameter Extraction directory.

### Other directories

The Club Classification directory contains files on using ML tactics to classify unknown clubs to get more usable data. Initial Modeling Expirimentation just contains some early experimental files of building models and defining quadrants which are now finalized in the Parameter Extraction directory.

`Final Report.Rmd` and `Final-Report.pdf` conatin the final report for the project and `QuadrantsInContext` is just a .png file used in the final report.
