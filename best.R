## @param state
##	Character vector containing the 2-character abbreviated name of a state.
##
## @param outcomeName
##	Character vector containing the name of an outcome/medical-condition.
##	Valid values are "heart attack", "heart failure", "pneumonia".
##
## @return
##	- If state is invalid, throw error message, "Invalid state!".
##	- If outcomeName is invalid, throw error message, "Invalid outcome!".
##	- Otherwise, if state and outcomeName are both valid, then a character
##	vector with the name of the hospital in the given state that has the
##	lowest 30-day death rate for the specified outcome.

best <- function(state, outcomeName) {
	source("auxiliaries.R")

	# Use the auxiliary methods to read the outcome data for the specified
	# state, filter the death rate and hospital name columns, and coerce
	# the death rate column to the "numeric" type.
	targetDeathRateColName <- getDeathRateColName(outcomeName)
	targetData <- read.outcomes(state, 
		columns = c(targetDeathRateColName, "Hospital.Name"),
		make.numeric = c(TRUE, FALSE))

	# Calculate the minimum death rate, and determine the name(s) of the
	# hospitals with that death rate.
	allDeathRates <- targetData[, targetDeathRateColName]
	minDeathRate <- min(allDeathRates)
	minDeathRateHospitalNames <- targetData[
		allDeathRates == minDeathRate, 
		"Hospital.Name"
	]

	# If there are multiple hospital names with the same death rate,
	# then pick the one that precedes all others alphabetically.
	min(minDeathRateHospitalNames)
}

## Unit Test
test_best <- function() {
	library(tools)	# Necessary to use assertError

	stopifnot(best("TX", "heart attack") == "CYPRESS FAIRBANKS MEDICAL CENTER")
	stopifnot(best("TX", "heart failure") == "FORT DUNCAN MEDICAL CENTER")
	stopifnot(best("MD", "heart attack") == "JOHNS HOPKINS HOSPITAL, THE")
	stopifnot(best("MD", "pneumonia") == "GREATER BALTIMORE MEDICAL CENTER")

	assertError(best("BB", "heart attack"))
	assertError(best("NY", "hert attack"))
}