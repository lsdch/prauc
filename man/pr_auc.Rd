% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prauc.R
\name{pr_auc}
\alias{pr_auc}
\title{Compute PR AUC estimates}
\usage{
pr_auc(df, scores, oracle, alpha = 0.05, pval = F)
}
\arguments{
\item{df}{a dataframe or tibble}

\item{scores}{scores column}

\item{oracle}{oracle column containing true labels}

\item{pval}{if true, transform scores as ( 1 - score )}
}
\value{
tibble containing PR AUC estimates, including average and confidence interval
}
\description{
Compute PR AUC estimates
}
\references{
Boyd, K., Eng, K. H., & Page, C. D. (2013).
Area under the precision-recall curve: point estimates and confidence intervals.
In Joint European conference on machine learning and knowledge discovery in databases (pp. 451-466).
Springer, Berlin, Heidelberg.
}
