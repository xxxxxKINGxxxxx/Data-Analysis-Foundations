# 01 — Data Cleaning and Exploration in Python and R

> Part of [Data Analysis Foundations](../README.md).

## Dataset

**Adult Income dataset** (UCI Machine Learning Repository, 1994 US Census): https://archive.ics.uci.edu/ml/datasets/adult
48,842 rows, 15 columns. The target is `income` (`<=50K` or `>50K`). Missing values are encoded as `?` in the raw file (`workclass`, `occupation`, `native_country`).

## What was done

| Step | Python (`data_cleaning.ipynb`) | R (`data_cleaning.R`) |
|---|---|---|
| Setup | Print library versions | Print library versions |
| Load and inspect | Shape, dtypes, missing values, duplicates | Same checks |
| Clean | Mode imputation for the three categorical columns, strip whitespace, convert to categories, derive `age_group` | Same, using `dplyr` |
| Explore | Filtered subset (over 40 h/week) and three grouped summary tables | Same tables |
| Custom function | `column_summary()` returns count, min, max, mean, median, range | Equivalent function |

Mode imputation was used because the missing columns are categorical, so a mean is meaningless and dropping rows would lose data.

## How to run

```bash
pip install pandas numpy matplotlib seaborn
jupyter notebook data_cleaning.ipynb      # Run All
```

```r
install.packages(c("dplyr", "ggplot2", "readr", "tidyr"))
```
```bash
Rscript data_cleaning.R
```

Both read `data/adult.csv`; run them from this folder. The Python notebook also writes `clean_data.csv` (git-ignored).

## Limitations

A well-known public dataset with simple structure, so the value is in the method: the same workflow reproduced in both languages, with a documented reason for every cleaning decision.
