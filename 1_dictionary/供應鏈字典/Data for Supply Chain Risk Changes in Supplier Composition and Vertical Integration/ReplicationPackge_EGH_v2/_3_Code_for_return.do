


global out .\TablesAndFigures\


************************************************************************************************************************************************************
************************************************************************************************************************************************************
*Prepare CAR
************************************************************************************************************************************************************
************************************************************************************************************************************************************
use CAR,clear

gen gvkey_acquiror=gvkey


*Identify vertical mergers
merge 1:1 gvkey_acquiror year using sdc.dta
drop if _merge==2
drop _merge

gen vertical=0
replace vertical=1 if pct_input!=. | pct_output != . 
tab vertical

*Merge on control variables
merge m:1 gvkey year using Output_clean, keepusing(lag_ln_at lag_tobinq1 lag_cash lag_profit1 sic2 lag_SCUncertainty)
keep if _merge==3
drop _merge


gen interaction=vertical*lag_SCUncertainty
tab vertical


drop if lag_ln_at==.
drop if lag_tobinq1==.
drop if lag_cash==.
drop if lag_profit1==.
drop if lag_SCUncertainty==.

la var vertical "Vertical merger"
la var interaction "SCRisk * Vertical merger"



************************************************************************************************************************************************************
************************************************************************************************************************************************************
*Table 5: Stock Market Reaction to Vertical M&A Announcements.
************************************************************************************************************************************************************
************************************************************************************************************************************************************

reg car11 lag_SCUncertainty vertical interaction, ro
outreg2 using "$out\Table5.xls",replace adjr2 dec(4) label nocons addtext(Year FE, N, Industry FE, N)
reg car11 lag_SCUncertainty vertical interaction  lag_ln_at lag_tobinq1 lag_cash lag_profit1, ro
outreg2 using "$out\Table5.xls", adjr2 dec(4) label nocons addtext(Year FE, N, Industry FE, N)
reghdfe car11 lag_SCUncertainty vertical interaction lag_ln_at lag_tobinq1 lag_cash lag_profit1, absorb(sic2 year) vce(robust)
outreg2 using "$out\Table5.xls", adjr2 dec(4) label nocons addtext(Year FE, Y, Industry FE, Y)




