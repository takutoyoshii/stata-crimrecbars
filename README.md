# crimrecbars (Stata Command)

**crimrecbars** is a custom Stata command that performs regression and margins analysis using audit study data, plotting the marginal effects of having a criminal record across different job contexts (city, customer service, manual skill, interaction). This Stata package creates a grouped bar chart showing outcomes by treatment group and covariates, motivated by audit study data.

## 📦 Installation

To install the command directly in Stata, run:

```stata
copy "https://raw.githubusercontent.com/takutoyoshii/stata-crimrecbars/main/crimrecbars.ado" "crimrecbars.ado", replace

copy "https://raw.githubusercontent.com/takutoyoshii/stata-crimrecbars/main/crimrecbars.sthlp" "crimrecbars.sthlp", replace

