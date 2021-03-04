# Go-NoGo-Analysis-Scripts
MATLAB code used by the Margolis Lab for decoding behavioral parameters relating to the Go/NoGo whisker-based decision-making paradigm with optogenetic manipulation

These two scripts are used in conjunction to perform analysis on Go/NoGo whisker-based decision-making data.

The first script "Multi_Behavior_Sort_AY" can be run on a maximum of 8 files.
It imports the Labview text file created following the session and organizes the data into each category (Hit, Miss, False Alarm, and Correct Rejection) for each session.
Ultimately, a nested structure is created with each session having its own structure. A matlab file is created that is taken up by the second script.

The second script "Multi_Behavioral_Analysis_AY" also can be run on a maximum of 8 files.
It allows the user to select how they would like to analyze each file (0, 1, or 2).
  Setting 0 means no analysis will be performed. The entire session will be analyzed as a whole.
  Setting 1 means that the first optogenetic paradigm was used (First 100 are baseline, last 100 are split into alternating ON/OFF blocks of 10 trials)
    e.g. ON --> OFF --> ON --> OFF --> ON --> OFF--> etc.
  Setting 2 means that the second optogenetic paradigm was used (First 100 are baseline, last 100 are somewhat staggered between ON/OFF blocks of 10 trials)
    e.g. OFF --> ON --> OFF --> ON --> OFF --> OFF --> ON --> OFF --> ON --> OFF
 All analytical data is saved inside the nested data structure.
  If analysis has been performed, the segregated (Off vs. On) results will be located in the "Final Data" array for each session
  If analysis has not been performed, the non-segregated data will be located in the "Base Data" array for each session
  
  *** NOTE: Use "Multi_Behavioral_Analysis_AY_v2" (modified and uploaded on 3/4/21)
  This version adds in the BasePercData when an LED Setting is inputted, which indicates how the mouse performed prior to LED ON vs. OFF blocks
