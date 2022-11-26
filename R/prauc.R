#' @import dplyr

decreasing_ties = function(scores, oracle) {
  tibble(scores, oracle) %>%
    group_by(scores) %>%
    summarise(
      n_pos = sum(oracle),
      n_neg = sum(!oracle)
    ) %>%
    arrange(desc(scores))
}

sigmoid = function(x) {
  exp(x) / (1 + exp(x))
}

logit = function(p) {
  log(p / (1 - p))
}

#' Compute average PR AUC
#'
#' @param scores vector of scores
#' @param oracle vector of labels T/F
#' @param pval if ture, transform scores as ( 1 - score )
#'
#' @return numeric value of average PR AUC
#' @export
prauc_avg = function(scores, oracle, pval = T) {
  if (pval) {
    scores = 1 - scores
  }
  ties = decreasing_ties(replace_na(scores, 0), oracle) %>%
    mutate(
      cum_pos = Reduce("+", n_pos, accumulate = T),
      cum_neg = Reduce("+", n_neg, accumulate = T),
      precision = cum_pos / (cum_pos + cum_neg),
      s = n_pos * precision
    )
  sum(ties$s) / sum(ties$n_pos)
}

#' Compute logit confidence interval
#'
#' @param avg_auc average PR AUC estimate
#' @param alpha risk for type 1 error
#' @param n_pos number of true positive labels
#'
#' @return a named 2-vector of confidence interval bounds
#' @export
prauc_logit_ci = function(avg_auc, alpha, n_pos) {
  eta_hat = logit(avg_auc)
  tau_hat = (n_pos * avg_auc * (1 - avg_auc))**(-0.5)
  delta = tau_hat * qnorm(p = 1 - alpha / 2, sd = 1, mean = 0)
  c(
    lower = sigmoid(eta_hat - delta),
    upper = sigmoid(eta_hat + delta)
  )
}

#' Compute PR AUC estimates
#'
#' @param df a dataframe or tibble
#' @param scores scores column
#' @param oracle oracle column containing true labels
#' @param pval if true, transform scores as ( 1 - score )
#' @return tibble containing PR AUC estimates, including average and confidence interval
#' @references Boyd, K., Eng, K. H., & Page, C. D. (2013).
#' Area under the precision-recall curve: point estimates and confidence intervals.
#' In Joint European conference on machine learning and knowledge discovery in databases (pp. 451-466).
#' Springer, Berlin, Heidelberg.
#' @export
prauc = function(df, scores, oracle, alpha = 0.05, pval = F) {
  scores = pull(df, {{ scores }})
  oracle = pull(df, {{ oracle }})
  n_pos = sum(oracle)
  avg = auc_average_precision(scores, oracle, pval)
  ci = auc_logit_ci(avg, alpha, n_pos)
  as_tibble_row(c(prauc = avg, ci))
}
