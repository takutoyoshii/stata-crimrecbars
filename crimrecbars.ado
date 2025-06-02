* pager_analysis_bars.do
* Author: Takuto Yoshii
* Purpose: Regression + Margins + Bar Plots + Extensions

program define crimrecbars
    version 17.0


 use "/Users/takutoyoshii/Downloads/Causal inference /Essay CI/criminal_record.dta", clear

* Clean data
gen white = .
replace white = 1 if black == 0
replace white = 0 if black == 1
drop if missing(callback, crimrec, black, city, custserv, manualskill, interact)

*----------------------------------*
* 1. Criminal Record x City        *
*----------------------------------*
reg callback i.crimrec##i.city, robust
estimates store reg_city
margins city, dydx(crimrec)
marginsplot, recast(bar) ytitle("Marginal Effect of Criminal Record") ///
    title("Effect of Criminal Record by Location") xtitle("City (0=Suburb, 1=City Center)") ///
    plotopts(color(navy)) ciopts(color(gs12)) legend(off)
graph export "bar_crimrec_city.png", replace

*------------------------------------------*
* 2. Criminal Record x Customer Service    *
*------------------------------------------*
reg callback i.crimrec##i.custserv, robust
estimates store reg_custserv
margins custserv, dydx(crimrec)
marginsplot, recast(bar) ytitle("Marginal Effect of Criminal Record") ///
    title("Effect by Customer Service Role") xtitle("Customer Service (0=No, 1=Yes)") ///
    plotopts(color(maroon)) ciopts(color(gs12)) legend(off)
graph export "bar_crimrec_custserv.png", replace

*------------------------------------------*
* 3. Criminal Record x Manual Skill        *
*------------------------------------------*
reg callback i.crimrec##i.manualskill, robust
estimates store reg_manual
margins manualskill, dydx(crimrec)
marginsplot, recast(bar) ytitle("Marginal Effect of Criminal Record") ///
    title("Effect by Manual Skill Job") xtitle("Manual Skill (0=No, 1=Yes)") ///
    plotopts(color(forest_green)) ciopts(color(gs12)) legend(off)
graph export "bar_crimrec_manual.png", replace

*-------------------------------------------------*
* 4. Criminal Record x Face-to-Face Interaction   *
*-------------------------------------------------*
reg callback i.crimrec##i.interact, robust
estimates store reg_interact
margins interact, dydx(crimrec)
marginsplot, recast(bar) ytitle("Marginal Effect of Criminal Record") ///
    title("Effect by Employer Interaction") xtitle("Interaction (0=No, 1=Yes)") ///
    plotopts(color(orange)) ciopts(color(gs12)) legend(off)
graph export "bar_crimrec_interact.png", replace

*----------------------------------*
* 5. Criminal Record x Race        *
*----------------------------------*
reg callback i.black##i.crimrec, robust
estimates store reg_race
margins black, dydx(crimrec)
marginsplot, recast(bar) ytitle("Marginal Effect of Criminal Record") ///
    title("Effect by Race") xtitle("Race (0=White, 1=Black)") ///
    plotopts(color(midblue)) ciopts(color(gs12)) legend(off)
graph export "bar_crimrec_race.png", replace

*------------------------------------------------------*
* 6. Covariate Adjustment (Regression Adjustment)      *
*------------------------------------------------------*
reg callback i.crimrec##i.city distance i.manualskill i.custserv i.interact, robust
estimates store reg_controls

*------------------------------------------------------*
* 7. Randomization Inference Placeholder               *
*------------------------------------------------------*
* The 'ritest' package is not officially supported. Instead,
* if needed, permutation tests should be run using a custom loop
* or omitted in your analysis. This section is commented out.
*
* Example (not executable without package):
* ritest crimrec _b[crimrec], reps(1000): reg callback crimrec

*------------------------------------------------------*
* 8. Blocking: Stratified regressions (e.g., by city)  *
*------------------------------------------------------*
reg callback i.crimrec if city == 0, robust
estimates store reg_block_suburb
reg callback i.crimrec if city == 1, robust
estimates store reg_block_city

*----------------------------------------------*
* Main regressions + control model
esttab reg_city reg_custserv reg_manual reg_interact reg_race reg_controls using ///
    "pager_results.tex", replace se label compress title("Effects of Criminal Record across Contexts")

* Stratified regressions (blocking by city)
esttab reg_block_suburb reg_block_city using "pager_blocking.tex", ///
    replace se label compress title("Effect of Criminal Record by Location: Stratified Models")
	
end
