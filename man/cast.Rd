% Generated by roxygen2 (4.0.2): do not edit by hand
\name{cast}
\alias{acast}
\alias{cast}
\alias{dcast}
\title{Cast functions
Cast a molten data frame into an array or data frame.}
\usage{
dcast(data, formula, fun.aggregate = NULL, ..., margins = NULL,
  subset = NULL, fill = NULL, drop = TRUE,
  value.var = guess_value(data))

acast(data, formula, fun.aggregate = NULL, ..., margins = NULL,
  subset = NULL, fill = NULL, drop = TRUE,
  value.var = guess_value(data))
}
\arguments{
\item{data}{molten data frame, see \code{\link{melt}}.}

\item{formula}{casting formula, see details for specifics.}

\item{fun.aggregate}{aggregation function needed if variables do not
identify a single observation for each output cell.  Defaults to length
(with a message) if needed but not specified.}

\item{...}{further arguments are passed to aggregating function}

\item{margins}{vector of variable names (can include "grand\_col" and
"grand\_row") to compute margins for, or TRUE to compute all margins .
Any variables that can not be margined over will be silently dropped.}

\item{subset}{quoted expression used to subset data prior to reshaping,
e.g. \code{subset = .(variable=="length")}.}

\item{fill}{value with which to fill in structural missings, defaults to
value from applying \code{fun.aggregate} to 0 length vector}

\item{drop}{should missing combinations dropped or kept?}

\item{value.var}{name of column which stores values, see
\code{\link{guess_value}} for default strategies to figure this out.}
}
\description{
Use \code{acast} or \code{dcast} depending on whether you want
vector/matrix/array output or data frame output.  Data frames can have at
most two dimensions.
}
\details{
The cast formula has the following format:
\code{x_variable + x_2 ~ y_variable + y_2 ~ z_variable ~  ... }
The order of the variables makes a difference.  The first varies slowest,
and the last fastest.  There are a couple of special variables: "..."
represents all other variables not used in the formula and "." represents
no variable, so you can do \code{formula = var1 ~ .}.

Alternatively, you can supply a list of quoted expressions, in the form
\code{list(.(x_variable, x_2), .(y_variable, y_2), .(z))}.  The advantage
of this form is that you can cast based on transformations of the
variables: \code{list(.(a + b), (c = round(c)))}.  See the documentation
for \code{\link[plyr]{.}} for more details and alternative formats.

If the combination of variables you supply does not uniquely identify one
row in the original data set, you will need to supply an aggregating
function, \code{fun.aggregate}. This function should take a vector of
numbers and return a single summary statistic.
}
\examples{
#Air quality example
names(airquality) <- tolower(names(airquality))
aqm <- melt(airquality, id=c("month", "day"), na.rm=TRUE)

acast(aqm, day ~ month ~ variable)
acast(aqm, month ~ variable, mean)
acast(aqm, month ~ variable, mean, margins = TRUE)
dcast(aqm, month ~ variable, mean, margins = c("month", "variable"))

library(plyr) # needed to access . function
acast(aqm, variable ~ month, mean, subset = .(variable == "ozone"))
acast(aqm, variable ~ month, mean, subset = .(month == 5))

#Chick weight example
names(ChickWeight) <- tolower(names(ChickWeight))
chick_m <- melt(ChickWeight, id=2:4, na.rm=TRUE)

dcast(chick_m, time ~ variable, mean) # average effect of time
dcast(chick_m, diet ~ variable, mean) # average effect of diet
acast(chick_m, diet ~ time, mean) # average effect of diet & time

# How many chicks at each time? - checking for balance
acast(chick_m, time ~ diet, length)
acast(chick_m, chick ~ time, mean)
acast(chick_m, chick ~ time, mean, subset = .(time < 10 & chick < 20))

acast(chick_m, time ~ diet, length)

dcast(chick_m, diet + chick ~ time)
acast(chick_m, diet + chick ~ time)
acast(chick_m, chick ~ time ~ diet)
acast(chick_m, diet + chick ~ time, length, margins="diet")
acast(chick_m, diet + chick ~ time, length, drop = FALSE)

#Tips example
dcast(melt(tips), sex ~ smoker, mean, subset = .(variable == "total_bill"))

ff_d <- melt(french_fries, id=1:4, na.rm=TRUE)
acast(ff_d, subject ~ time, length)
acast(ff_d, subject ~ time, length, fill=0)
dcast(ff_d, treatment ~ variable, mean, margins = TRUE)
dcast(ff_d, treatment + subject ~ variable, mean, margins="treatment")
if (require("lattice")) {
 lattice::xyplot(`1` ~ `2` | variable, dcast(ff_d, ... ~ rep), aspect="iso")
}
}
\seealso{
\code{\link{melt}},  \url{http://had.co.nz/reshape/}
}
\keyword{manip}

