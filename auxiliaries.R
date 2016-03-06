## @param outcomeName
##	Character vector containing the name of a medical condition.
##	Should be "pnemumonia," "heart failure," or "heart attack."
##	If it is not one of these values, an error will be thrown.
##
## @return
##	- If outcomeName is valid, then a character vector containing 
##	the name of the 30-day death rate column in the outcomes data set 
##	that corresponds to outcomeName.
##	- If outcomeName is invalid, throw an error message.

getDeathRateColName <- function(outcomeName) {
	validOutcomes <- matrix(nrow = 3, ncol = 2)
	validOutcomes[,1] <- c("heart attack", "heart failure", "pneumonia")
	validOutcomes[,2] <- paste(
		"Hospital.30.Day.Death..Mortality..Rates.from.",
		c("Heart.Attack", "Heart.Failure", "Pneumonia"), 
		sep = ""
	)
	colnames(validOutcomes) <- c("names", "deathRateColNames")

	# If outcomeName is not valid, display error message.
	if (!(outcomeName %in% validOutcomes[,"names"])) {
		stop("Invalid outcome!")
	}
	
	# Otherwise, return the corresponding death rate column name from
	# validOutcomes.
	validOutcomes[validOutcomes[,"names"] == outcomeName, "deathRateColNames"]
}

## @param dataFrame
##	Source data frame, whose values in "colToNumerify" are being
##	coerced to "numeric."
##
## @param colToNumerify
##	Name of the column in "dataFrame," whose values are being coerced 
##	to "numeric."
##
## @return
##	Data frame with the same values as the source dataFrame but with
##	class(dataFrame[, colToNumerify]) = "numeric" and without any
##	rows where the value in colToNumerify is a missing value.

data.frame.numerifyCols <- function(dataFrame, colsToNumerify) {
	for (col in colsToNumerify) {
		dataFrame[, col] <- suppressWarnings(as.numeric(dataFrame[, col]))

		# Filter out all rows with a missing value in col.
		dataFrame <- dataFrame[complete.cases(dataFrame[, col]),]
	}

	dataFrame
}

## @param state
##	Optional character vector containing the 2-character abbreviated 
##	name of a state in "outcome-of-care-measures.csv."
##
## @param columns
##	Optional character vector containing the names of the columns that
##	we want to filter from the outcomes CSV file.
##
## @param make.numeric
##	Optional boolean vector whose length SHALL equal that of "columns."
##	For each element, TRUE indicates that the corresponding column in
##	"columns" shall be coerced to "numeric," and FALSE indicates that
##	the column shall be left as is.
##
## @return
##	A data frame with the data in "outcome-of-care-measures.csv."
##	- If columns is specified, filter those columns.
##	- If make.numeric is specified, and its length != that of columns,
##	then throw an error. Otherwise, coerce the specified cols to numeric.
##	- If state is invalid, throw an error.

read.outcomes <- function(state = NULL, columns = NULL, make.numeric = NULL) {
	outcomesData <- read.csv("outcome-of-care-measures.csv", 
		colClasses = "character")

	# Validate parameters.
	if (!is.null(state) && !(state %in% outcomesData$State)) {
		stop("Invalid state!")
	}
	if (!is.null(columns) && !is.null(make.numeric) && 
			length(columns) != length(make.numeric)) {
		stop("length(columns) does not equal length(make.numeric)!")
	}

	# Apply filters based on inputs.
	if (!is.null(state)) {
		outcomesData <- outcomesData[outcomesData$State == state,]
	}
	if (!is.null(columns)) {
		outcomesData <- outcomesData[, columns]
	}
	if (!is.null(make.numeric)) {
		outcomesData <- data.frame.numerifyCols(outcomesData, columns[make.numeric])
	}

	outcomesData
}