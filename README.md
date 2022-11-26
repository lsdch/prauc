# PR AUC
Estimation of precision-recall AUC with confidence interval, following Boyd et al (2013).
Mirror of OCaml implementation at https://github.com/pveber/prc/

## Installation

```R
devtools::install_github("https://github.com/lsdch/prauc")
```

## Usage 

```R
prauc_estimates = preds_df %>% prauc::prauc(score_col, oracle_col, alpha=0.05)
```

Boyd, K., Eng, K. H., & Page, C. D. (2013).
Area under the precision-recall curve: point estimates and confidence intervals.
In Joint European conference on machine learning and knowledge discovery in databases (pp. 451-466).
Springer, Berlin, Heidelberg.
