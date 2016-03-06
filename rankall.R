## @param outcome
##	Character vector indicating the outcome/medical-condition for which
##	we are calculating the num-th-ranked hospital name in each state.
##	Must be one of "heart attack," "heart failure," or "pneumonia."
##
## @param num
##	Either an integer vector or a character vector equal to "best" or
##	"worst." Indicates the rank of the hospital name that we are fetching
##	for each state.
##
## @return
##	A data frame where one column is the 2-letter state abbreviation and
##	the other is the num-th-ranked hospital name for that state. Rankings
##	are done by the 30-day-mortality rate for the given "outcome."
##	- Display an error message if the outcome is invalid.
##	- Display NA for a given state if num exceeds the number of hospitals
##	in that state.

rankall <- function(outcome, num = "best") {
	source("auxiliaries.R")

	# Get the name of the death rate column corresponding to this outcome.
	# Then, retrieve this column, the states, and hospital names from the
	# outcomes data set.
	deathRateColName <- getDeathRateColName(outcome)
	targetData <- read.outcomes(
		columns = c(deathRateColName, "State", "Hospital.Name"),
		make.numeric = c(TRUE, FALSE, FALSE)
	)

	# Group the data by state.
	# Each group will list the hospitals within the state and their
	# corresponding death rates.
	dataGroupedByState <- split(targetData, targetData$State)

	# Function to group hospital names by death rates and then sort them
	# in alphabetical order within each group.
	sortHospitalsByDeathRates <- function(elem) {
		unlist(tapply(elem$Hospital.Name, elem[,deathRateColName], sort))
	}

	# sapply returns a flattened array. Convert this into a data frame,
	# so that we can see each state and its corresponding num-th-ranked 
	# hospital name.
	nthHospitalPerState <- data.frame(
		# For each state, sort the hospitals by death rates first and
		# hospital names in case of a tie between death rates.
		# Then, get the name of the nth ranking hospital for each state.
		sapply(dataGroupedByState, function(elem) {
			nthHospitalInState <- NA	# Default Value

			rankedHospitals <- sortHospitalsByDeathRates(elem)
			totalNumHospitals <- length(rankedHospitals)
			if (num == "best") {
				nthHospitalInState <- rankedHospitals[[1]]
			}
			else if (num == "worst") {
				nthHospitalInState <- 
					rankedHospitals[[totalNumHospitals]]
			}
			else if (num >= 1 && num <= totalNumHospitals) {
				nthHospitalInState <- rankedHospitals[[num]]
			}

			nthHospitalInState
		})
	)
	nthHospitalPerState <- cbind(nthHospitalPerState, rownames(nthHospitalPerState))
	colnames(nthHospitalPerState) <- c("hospital", "state")

	nthHospitalPerState
}