## @param state
##	Character vector containing the 2-letter abbreviation of a state name.
##
## @param outcome
##	Character vector containing the name of an outcome/medical-condition.
##	Must be "pneumonia," "heart failure," or "heart attack."
##
## @param num
##	Integer vector specifying the 30-day-mortality-rate rank of the target
##	hospital. E.g., if num = 5, return the name of the hospital with the
##	5th lowest 30-day-mortality-rate for the given (state, outcome).
##	- Can be character vector with values "best" or "worst".
##
## @return
##	Character vector with the name of the hospital that has the "num" lowest 
##	30-day mortality rate due to the specified outcome in the given state.
##	- Throw error if state or outcome is invalid.
##	- NA if num is greater than the number of hospitals in the state treating
##	the given outcome.

rankhospital <- function(state, outcome, num) {
	source("auxiliaries.R")

	deathRateColName <- getDeathRateColName(outcome)
	targetData <- read.outcomes(state,
		columns = c(deathRateColName, "Hospital.Name"),
		make.numeric = c(TRUE, FALSE))

	# Use tapply to group hospital names by death rates and sort them in
	# alphabetical order w/in each group. Then, flatten the array returned
	# by tapply, so that each index corresponds to exactly 1 hospital name.
	hospitalsPerDR <- unlist(tapply(targetData$Hospital.Name, 
		targetData[,deathRateColName], sort))
	totalNumHospitals <- length(hospitalsPerDR)

	targetHospitalName <- NA	# Default
	if (num == "best") {
		targetHospitalName <- hospitalsPerDR[[1]]
	}
	else if (num == "worst") {
		targetHospitalName <- hospitalsPerDR[[totalNumHospitals]]
	}
	else if (num >= 1 && num <= totalNumHospitals) {
		# Can access by num since elements in hospitalsPerDR are organized
		# in order of increasing mortality rate and hospital name.
		targetHospitalName <- hospitalsPerDR[[num]]
	}
	
	targetHospitalName
}

## Unit Tests
test_rankhospital <- function() {
	library(tools)

	stopifnot(rankhospital("TX", "heart failure", 4) == 
		"DETAR HOSPITAL NAVARRO")
	stopifnot(rankhospital("MD", "heart attack", "worst")== 
		"HARFORD MEMORIAL HOSPITAL")
	stopifnot(is.na(rankhospital("MN", "heart attack", 5000)))
}