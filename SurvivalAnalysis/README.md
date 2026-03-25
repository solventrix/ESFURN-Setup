# How to execute the Survival Analysis

## Prerequisites
1. The local installation for ESFURN is installed and running
2. The user has access to the ESFURN Harbor repository

## Execution steps
1. Open a terminal window
2. Download the 'Survival Analysis' run script:
    * Linux/MacOS:
      ```
      curl -L https://raw.githubusercontent.com/solventrix/ESFURN-Setup/master/SurvivalAnalysis/run-survival-analysis.sh --output run-survival-analysis.sh  && chmod +x run-survival-analysis.sh
      ```
    * Windows:
      ```
      curl -L https://raw.githubusercontent.com/solventrix/ESFURN-Setup/master/SurvivalAnalysis/run-survival-analysis.cmd --output run-survival-analysis.cmd
      ```
3. Execute the script (from the directory where the script is downloaded)
    * Linux/MacOS:
      ```
      ./run-survival-analysis.sh
      ```
    * Windows:
      ```
      run-survival-analysis.cmd
      ```
4. The script will run the Survival Analysis and show the output of the code
5. The result files will be available in a subfolder 'results'
