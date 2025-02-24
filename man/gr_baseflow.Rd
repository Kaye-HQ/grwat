% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/separate.R
\name{gr_baseflow}
\alias{gr_baseflow}
\title{Extract baseflow}
\usage{
gr_baseflow(
  Q,
  a = 0.925,
  k = 0.975,
  C = 0.05,
  aq = -0.5,
  passes = 3,
  padding = 30,
  method = "lynehollick"
)
}
\arguments{
\item{Q}{Numeric runoff vector.}

\item{a}{Numeric value of a filtering parameter used in \code{'chapman'}, \code{'jakeman'} and \code{'lynehollick'} methods. Defaults to \code{0.925}.}

\item{k}{Numeric value of a filtering parameter used in \code{'boughton'} and \code{'maxwell'} methods. Defaults to \code{0.975}.}

\item{C}{Numeric value of a separation shape parameter used in \code{'boughton'}, \code{'jakeman'} and \code{'maxwell'} methods}

\item{aq}{Numeric value of a filtering parameter used in \code{'jakeman'} method. Defaults to \code{-0.5}.}

\item{passes}{Integer number of filtering iterations. The first iteration is forward, second is backward, third is forward and so on. Defaults to \code{3}.}

\item{padding}{Integer number of elements padded at the beginning and ending of runoff vector to reduce boundary effects. Defaults to \code{30}.}

\item{method}{Character string to set baseflow filtering method. Available methods are \code{'boughton'}, \code{'chapman'}, \code{'furey'}, \code{'jakeman'}, \code{'lynehollick'} and \code{'maxwell'}. Default is \code{'lynehollick'}, which corresponds to Lyne-Hollick (1979) hydrograph separation method.}
}
\value{
Numeric baseflow vector with length equal to \code{Q}
}
\description{
Extract baseflow from hydrological series using the filtering approach
}
\examples{\donttest{
library(grwat)
library(ggplot2)
library(dplyr)
library(tidyr)
library(lubridate)

data(spas) # example Spas-Zagorye data is included with grwat package

# Calculate baseflow using Line-Hollick approach
hdata = spas \%>\% 
  mutate(Qbase = gr_baseflow(Q, method = 'lynehollick', 
                             a = 0.925, passes = 3))

# Visualize for 1980 year
ggplot(hdata) +
  geom_area(aes(Date, Q), fill = 'steelblue', color = 'black') +
  geom_area(aes(Date, Qbase), fill = 'orangered', color = 'black') +
  scale_x_date(limits = c(ymd(19800101), ymd(19801231)))

# Compare various approaches
hdata = spas \%>\%
  mutate(lynehollick = gr_baseflow(Q, method = 'lynehollick', a = 0.9),
         boughton = gr_baseflow(Q, method = 'boughton', k = 0.9),
         jakeman = gr_baseflow(Q, method = 'jakeman', k = 0.9),
         maxwell = gr_baseflow(Q, method = 'maxwell', k = 0.9)) \%>\% 
  pivot_longer(lynehollick:maxwell, names_to = 'Method', values_to = 'Qbase')

# Visualize for 1980 year
ggplot(hdata) +
  geom_area(aes(Date, Q), fill = 'steelblue', color = 'black') +
  geom_area(aes(Date, Qbase), fill = 'orangered', color = 'black') +
  scale_x_date(limits = c(ymd(19810101), ymd(19811231))) +
  facet_wrap(~Method)

# Compare Lyne to Kudelin
p = gr_get_params('center')
p$filter = 'kudelin'

hdata = spas \%>\% 
  mutate(lynehollick = gr_baseflow(Q, method = 'lynehollick', 
                                   a = 0.925, passes = 3),
         kudelin = gr_separate(spas, p)$Qbase) \%>\% 
  pivot_longer(lynehollick:kudelin, names_to = 'Method', values_to = 'Qbase')

# Visualize for 1980 year
ggplot(hdata) +
  geom_area(aes(Date, Q), fill = 'steelblue', color = 'black') +
  geom_area(aes(Date, Qbase), fill = 'orangered', color = 'black') +
  scale_x_date(limits = c(ymd(19800101), ymd(19801231))) +
  facet_wrap(~Method)
}}
