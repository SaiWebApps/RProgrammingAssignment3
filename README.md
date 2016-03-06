# Coursera R Programming Assignment #3

## Setup

* [Data for Assignment](https://eventing.coursera.org/api/redirectStrict/KHGIS1q2j_1qAeJK21txgmSnPbWdNsujpX4uZd3Y8-ZG8Cj9EAIpi_Fr1ZOjeS4g9BB6La0apt-khKCbEFi1Tw.u3-8o03h_ivY8AS5AhJNJA.2FAEmrflgw3l0E7c9yul5coVKRF6NbB5X758c3jpGBVD31HuB79vvhuYrb7tmw_-PYOTm7tttUN-sHgiPviQRCLdCtR9mfVCvxRzLsEEFM3q-nqRsfYJA54bhyczO1-zf4ucPt3OKWw3jpL9b2s6TgsJedvjbMuaz_GPBXLQoVEwvg6fMUBSdpc9a-NvARNsNJXBSrLX1zQsVP3u2gkgmVI79mSM4S1T2HfvYmfG7rUCvjuuN5C-eZFD2cUKL3DbikteVn729lBp6B5pYTK4NNJEDQsDORFja6gqzXOYMEITQ5_t379VB1hcjyq9U7BjsYOzu1LH49F3SMPbs5UAcBjOeLxXUeYQhm8W1nwnw7RmJLEXhjrM73DZZujWeAzDp3AnpYULO0NUXVwdeYbzdju1gwyMEKyDqNsG4ILbJhE)
* [Instructions](https://d18ky98rnyall9.cloudfront.net/_775189147d7b89d66333adf6d920b52d_ProgAssignment3v2.pdf?Expires=1457395200&Signature=jvZY2cpDrVphY98MuV9tMRoqBr7O0pBisYG7kQeyRgCuloSr33-SRtjJRAoRJd-plztYYzRBDF0NvQNlrAEe85wUVATVipVbJ3d4Eq9pVCupaWgTd6yhbfgcMi28k-d2uX7eSeT2FcJVwsrDS5-O1Wec5JcHMs-T4W5PJW1Vbxw_&Key-Pair-Id=APKAJLTNE6QMUY6HBC5A)

Be sure to copy the outcomes CSV file into the same directory as these R scripts. To change the name/path expected for the CSV file, look at the read.outcomes function auxiliaries.R.

## Code Breakdown

* <u>auxiliaries.R</u> : Helper functions used by the 3 functions described below.
* <u>best.R</u> : Return the name of the best hospital in the state (a.k.a, the hospital with the lowest 30-day-mortality rate) for a particular outcome.
* <u>rankhospital.R</u> : Return the name of the Nth-ranked hospital (ranking by 30-day-mortality rate for a particular outcome) in a given state.
* <u>rankall.R</u> : For each state, return the name of the Nth-ranked hospital (ranking by 30-day-mortality rate for a particular outcome).

## General Notes
* The only possible outcomes are {"pneumonia", "heart failure", "heart attack"}. Any outcomes outside this set are not supported and will cause the functions above to throw an error, "Invalid outcome!".
* There are unit tests for the <i>best</i> and <i>rankhospital</i> functions but not the <i>rankall</i> function.

## Examples

### best.R
```R
>> best("TX", "heart attack")
```
will return the best hospital in Texas for resolving heart attacks (a.k.a, the hospital with the lowest 30-day-mortality rate for heart-attacks in Texas).

### rankhospital.R
```R
>> rankhospital("TX", "heart failure", 5)
```
will return the 5th-best hospital in Texas for resolving heart attacks.

### rankall.R
```R
>> rankall("pneumonia", 5)
```
will return the 5th-best hospital for addressing pneumonia in all states in the outcomes data set. If a state does not have a 5th-best hospital for resolving pneumonia, then the corresponding hospital value will be NA.

Please check the instructions link under the <u>Setup</u> section for more details.