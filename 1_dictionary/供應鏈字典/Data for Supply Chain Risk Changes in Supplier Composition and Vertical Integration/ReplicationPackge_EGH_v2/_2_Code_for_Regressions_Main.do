

global out .\TablesAndFigures\


************************************************************************************************************************************************************
************************************************************************************************************************************************************
*Analysis starts here
************************************************************************************************************************************************************
************************************************************************************************************************************************************

use Output_clean,clear















************************************************************************************************************************************************************
************************************************************************************************************************************************************
*Table 1: Summary Statistics
************************************************************************************************************************************************************
************************************************************************************************************************************************************

*Drop missings
foreach i in SupplyChainUncertainty SupplyChainSentiment diff_cont_frac re_size mean_supplier_ind multinational major m_share_sic2_sale instown_perc fc_ww  ///
lag_ln_at lag_tobinq1 lag_cash lag_profit1 ///
num_supplier number_supplier_same_cont  number_supplier_us  number_supplier_diff_cont number_supplier_above_med3 ///
ma_input_d ma_output_d ma_nonrelated_d{
	drop if `i'==.
}

corr(SupplyChainUncertainty SupplyChainSentiment)

reghdfe SupplyChainUncertainty diff_cont_frac re_size ln_at mean_supplier_ind multinational major m_share_sic2_sale fc_ww instown_perc tobinq1, absorb(sic2#year) vce(cluster gvkey)
gen used=e(sample)
tab used


*Tabulate summary stats in Table 1
tabstat SupplyChainUncertainty SupplyChainSentiment diff_cont_frac re_size mean_supplier_ind multinational major m_share_sic2_sale fc_ww instown_perc ///
lag_ln_at lag_tobinq1 lag_cash lag_profit1 ///
num_supplier number_supplier_same_cont  number_supplier_us  number_supplier_diff_cont number_supplier_above_med3 ///
ma_input_d ma_output_d ma_nonrelated_d ,stat(n mean sd p25 p50 p75)  col(stat)







************************************************************************************************************************************************************
************************************************************************************************************************************************************
*Table 2:  Firm Characteristics and Supply Chain Risk.
************************************************************************************************************************************************************
************************************************************************************************************************************************************
 

reghdfe SupplyChainUncertainty diff_cont_frac  if used==1 , absorb( sic2#year) vce(cluster gvkey)
outreg2 using "$out\Table2.xls",replace adjr2 dec(4) label nocons addtext(Industry x year FE, Y)
reghdfe SupplyChainUncertainty diff_cont_frac re_size if used==1  , absorb( sic2#year) vce(cluster gvkey)
outreg2 using "$out\Table2.xls", adjr2 dec(4) label nocons addtext(Industry x year FE, Y)
reghdfe SupplyChainUncertainty diff_cont_frac re_size ln_at  if used==1 , absorb( sic2#year) vce(cluster gvkey)
outreg2 using "$out\Table2.xls", adjr2 dec(4) label nocons addtext(Industry x year FE, Y)
reghdfe SupplyChainUncertainty diff_cont_frac re_size ln_at mean_supplier_ind if used==1  , absorb( sic2#year) vce(cluster gvkey)
outreg2 using "$out\Table2.xls", adjr2 dec(4) label nocons addtext(Industry x year FE, Y)
reghdfe SupplyChainUncertainty diff_cont_frac re_size ln_at mean_supplier_ind multinational if used==1  , absorb( sic2#year) vce(cluster gvkey)
outreg2 using "$out\Table2.xls", adjr2 dec(4) label nocons addtext(Industry x year FE, Y)
reghdfe SupplyChainUncertainty diff_cont_frac re_size ln_at mean_supplier_ind multinational major if used==1  , absorb( sic2#year) vce(cluster gvkey)
outreg2 using "$out\Table2.xls", adjr2 dec(4) label nocons addtext(Industry x year FE, Y)
reghdfe SupplyChainUncertainty diff_cont_frac re_size ln_at mean_supplier_ind multinational major m_share_sic2_sale if used==1  , absorb( sic2#year) vce(cluster gvkey)
outreg2 using "$out\Table2.xls", adjr2 dec(4) label nocons addtext(Industry x year FE, Y)
reghdfe SupplyChainUncertainty diff_cont_frac re_size ln_at mean_supplier_ind multinational major m_share_sic2_sale fc_ww if used==1 , absorb( sic2#year) vce(cluster gvkey)
outreg2 using "$out\Table2.xls", adjr2 dec(4) label nocons addtext(Industry x year FE, Y)
reghdfe SupplyChainUncertainty diff_cont_frac re_size ln_at mean_supplier_ind multinational major m_share_sic2_sale fc_ww instown_perc if used==1 , absorb( sic2#year) vce(cluster gvkey)
outreg2 using "$out\Table2.xls", adjr2 dec(4) label nocons addtext(Industry x year FE, Y)
reghdfe SupplyChainUncertainty diff_cont_frac re_size ln_at mean_supplier_ind multinational major m_share_sic2_sale fc_ww instown_perc tobinq1 if used==1 , absorb( sic2#year) vce(cluster gvkey)
outreg2 using "$out\Table2.xls", adjr2 dec(4) label nocons addtext(Industry x year FE, Y)















 
************************************************************************************************************************************************************
************************************************************************************************************************************************************
*Table 3: Supply Chain Risk and the Composition of Supply Chains.
************************************************************************************************************************************************************
************************************************************************************************************************************************************


*Columns 1-5: OLS regressions
reghdfe num_supplier lag_SCUncertainty lag_SCSentiment lag_ln_at lag_tobinq1 lag_cash lag_profit1 if  lag_firm2_scriskIV2!=., absorb(gvkey sic2#year) vce(cluster gvkey)
outreg2 using "$out\Table3.xls",replace adjr2 dec(4) label nocons addtext(Firm FE, Y, Industry x year FE, Y)
reghdfe number_supplier_same_cont lag_SCUncertainty lag_SCSentiment lag_ln_at lag_tobinq1 lag_cash lag_profit1 if  lag_firm2_scriskIV2!=., absorb(gvkey sic2#year) vce(cluster gvkey)
outreg2 using "$out\Table3.xls",adjr2 dec(4) label nocons addtext(Firm FE, Y, Industry x year FE, Y)
reghdfe number_supplier_us lag_SCUncertainty lag_SCSentiment lag_ln_at lag_tobinq1 lag_cash lag_profit1  if  lag_firm2_scriskIV2!=., absorb(gvkey sic2#year) vce(cluster gvkey)
outreg2 using "$out\Table3.xls",adjr2 dec(4) label nocons addtext(Firm FE, Y, Industry x year FE, Y)
reghdfe number_supplier_diff_cont2 lag_SCUncertainty lag_SCSentiment lag_ln_at lag_tobinq1 lag_cash lag_profit1 if  lag_firm2_scriskIV2!=., absorb(gvkey sic2#year) vce(cluster gvkey)
outreg2 using "$out\Table3.xls",adjr2 dec(4) label nocons addtext(Firm FE, Y, Industry x year FE, Y)
reghdfe number_supplier_above_med3 lag_SCUncertainty lag_SCSentiment lag_ln_at lag_tobinq1 lag_cash lag_profit1  if  lag_firm2_scriskIV2!=., absorb(gvkey sic2#year) vce(cluster gvkey)
outreg2 using "$out\Table3.xls",adjr2 dec(4) label nocons addtext(Firm FE, Y, Industry x year FE, Y)


	********First Stage*************
	*columns 1-5
	reghdfe lag_SCUncertainty lag_firm2_scriskIV2 lag_ln_at lag_tobinq1 lag_cash lag_profit1, absorb(gvkey sic2#year) vce(cluster gvkey)
	outreg2 using "$out/firststage.xls",replace  adjr2 dec(4) label nocons addtext(Firm FE, Y, Industry x year FE, Y)
	*columns 6-10
	reghdfe lag_SCUncertainty lag_firm2_scriskIV2 lag_SCSentiment lag_ln_at lag_tobinq1 lag_cash lag_profit1, absorb(gvkey sic2#year) vce(cluster gvkey)
	outreg2 using "$out/firststage.xls", adjr2 dec(4) label nocons addtext(Firm FE, Y, Industry x year FE, Y)
	********************************

*Columns 6-10: IV regressions

ivreghdfe num_supplier lag_SCSentiment lag_ln_at lag_tobinq1 lag_cash lag_profit1 (lag_SCUncertainty  = lag_firm2_scriskIV2), absorb(gvkey sic2#year) cluster(gvkey) ro 
outreg2 using "$out\Table3.xls",adjr2 dec(4) label nocons addtext(Firm FE, Y, Industry x year FE, Y)
ivreghdfe number_supplier_same_cont lag_SCSentiment lag_ln_at lag_tobinq1 lag_cash lag_profit1 (lag_SCUncertainty  = lag_firm2_scriskIV2), absorb(gvkey sic2#year) cluster(gvkey) ro
outreg2 using "$out\Table3.xls",adjr2 dec(4) label nocons addtext(Firm FE, Y, Industry x year FE, Y)
ivreghdfe number_supplier_us lag_SCSentiment lag_ln_at lag_tobinq1 lag_cash lag_profit1 (lag_SCUncertainty  = lag_firm2_scriskIV2), absorb(gvkey sic2#year) cluster(gvkey) ro
outreg2 using "$out\Table3.xls",adjr2 dec(4) label nocons addtext(Firm FE, Y, Industry x year FE, Y)
ivreghdfe number_supplier_diff_cont lag_SCSentiment lag_ln_at lag_tobinq1 lag_cash lag_profit1 (lag_SCUncertainty  = lag_firm2_scriskIV2), absorb(gvkey sic2#year) cluster(gvkey) ro 
outreg2 using "$out\Table3.xls",adjr2 dec(4) label nocons addtext(Firm FE, Y, Industry x year FE, Y)
ivreghdfe number_supplier_above_med3 lag_SCSentiment lag_ln_at lag_tobinq1 lag_cash lag_profit1 (lag_SCUncertainty  = lag_firm2_scriskIV2), absorb(gvkey sic2#year) cluster(gvkey) ro
outreg2 using "$out\Table3.xls",adjr2 dec(4) label nocons addtext(Firm FE, Y, Industry x year FE, Y)








************************************************************************************************************************************************************
************************************************************************************************************************************************************
*Table 4: Supply Chain Risk and Vertical M&As. 
************************************************************************************************************************************************************
************************************************************************************************************************************************************



*Columns 1-3: OLS regressions
reghdfe ma_input_d lag_SCUncertainty lag_SCSentiment lag_ln_at lag_tobinq1 lag_cash lag_profit1  if  lag_firm2_scriskIV2!=., absorb(gvkey sic2#year) vce(cluster gvkey)
outreg2 using "$out\Table4.xls",replace adjr2 dec(4) label nocons addtext(Firm FE, Y, Industry x year FE, Y)
reghdfe ma_output_d lag_SCUncertainty lag_SCSentiment lag_ln_at lag_tobinq1 lag_cash lag_profit1  if  lag_firm2_scriskIV2!=., absorb(gvkey sic2#year) vce(cluster gvkey)
outreg2 using "$out\Table4.xls",adjr2 dec(4) label nocons addtext(Firm FE, Y, Industry x year FE, Y)
reghdfe ma_nonrelated_d lag_SCUncertainty lag_SCSentiment lag_ln_at lag_tobinq1 lag_cash lag_profit1  if  lag_firm2_scriskIV2!=., absorb(gvkey sic2#year) vce(cluster gvkey)
outreg2 using "$out\Table4.xls",adjr2 dec(4) label nocons addtext(Firm FE, Y, Industry x year FE, Y)


	********First Stage*************
	*columns 1-3
	reghdfe lag_SCUncertainty lag_firm2_scriskIV2 lag_ln_at lag_tobinq1 lag_cash lag_profit1, absorb(gvkey sic2#year) vce(cluster gvkey)
	outreg2 using "$out/firststage.xls",replace  adjr2 dec(4) label nocons addtext(Firm FE, Y, Industry x year FE, Y)
	*columns 4-6
	reghdfe lag_SCUncertainty lag_firm2_scriskIV2 lag_SCSentiment lag_ln_at lag_tobinq1 lag_cash lag_profit1, absorb(gvkey sic2#year) vce(cluster gvkey)
	outreg2 using "$out/firststage.xls", adjr2 dec(4) label nocons addtext(Firm FE, Y, Industry x year FE, Y)
	********************************

*Columns 4-6: IV regressions

ivreghdfe ma_input_d lag_SCSentiment lag_ln_at lag_tobinq1 lag_cash lag_profit1 (lag_SCUncertainty = lag_firm2_scriskIV2), absorb(gvkey sic2#year) cluster(gvkey) ro
outreg2 using "$out\Table4.xls",adjr2 dec(4) label nocons addtext(Firm FE, Y, Industry x year FE, Y)
ivreghdfe ma_output_d lag_SCSentiment lag_ln_at lag_tobinq1 lag_cash lag_profit1 (lag_SCUncertainty = lag_firm2_scriskIV2), absorb(gvkey sic2#year) cluster(gvkey) ro
outreg2 using "$out\Table4.xls",adjr2 dec(4) label nocons addtext(Firm FE, Y, Industry x year FE, Y)
ivreghdfe ma_nonrelated_d lag_SCSentiment lag_ln_at lag_tobinq1 lag_cash lag_profit1 (lag_SCUncertainty = lag_firm2_scriskIV2), absorb(gvkey sic2#year) cluster(gvkey) ro
outreg2 using "$out\Table4.xls",adjr2 dec(4) label nocons addtext(Firm FE, Y, Industry x year FE, Y)


	