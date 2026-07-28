

************************************************************************************************************************************************************
************************************************************************************************************************************************************
*Prepare M&A
************************************************************************************************************************************************************
************************************************************************************************************************************************************
use sdc,clear

*calculate number of M&A deals at the firm-year level

bys gvkey_acquiror year: egen num_input_ma_any=count(gvkey_target) if pct_input>0 & pct_input!=.

bys gvkey_acquiror year: egen num_output_ma_any=count(gvkey_target) if pct_output>0 & pct_output!=.

bys gvkey_acquiror year: egen num_unrelated_ma=count(gvkey_target) if pct_output==. & pct_input==. & acquiror_sic!=target_sic

duplicates drop gvkey_acquiror year,force
rename gvkey_acquiror gvkey
drop gvkey_target pct_input pct_output acquiror_sic target_sic


la var num_input_ma_any "Number of M&As with supplier"
la var num_output_ma_any "Number of M&As with customer"
la var num_unrelated_ma "Number of Unrelated M&As" 

save _temp_sdc_cleaned,replace

************************************************************************************************************************************************************
************************************************************************************************************************************************************
*Prepare Revere
************************************************************************************************************************************************************
************************************************************************************************************************************************************

use customer_supplier_year_revere,clear


*Number of suppliers
egen num_supplier=sum(1), by(gvkey_customer year)


*Number of suppliers in the same continent
egen number_supplier_same_cont=sum(continent_customer==continent_supplier), by(gvkey_customer year)


*Number of U.S. suppliers
*All customer countries are coded as 1 since we are focusing on U.S. firms
egen number_supplier_us=sum(country_customer==country_supplier), by(gvkey_customer year)


*Number of suppliers in different continents
egen number_supplier_diff_cont2=sum(continent_customer~=continent_supplier), by(gvkey_customer year)


*Fraction of a firm’s suppliers located in a continent different from that of the firm over the total number of suppliers
gen diff_cont_frac=number_supplier_diff_cont2/num_supplier


*Relative size: Focal firm’s total assets scaled by its suppliers’ average total assets
egen at_supplier_mean=mean(at_supplier), by(gvkey_customer year)
gen re_size=ln(at_customer)/ln(at_supplier_mean)


*The average of a firm’s number of suppliers by input industry
egen nn=sum(1), by(gvkey_customer year ind_supplier)
egen mean_supplier_ind=mean(nn), by(gvkey_customer year)
cap drop nn


*Number of industry leader suppliers
egen number_supplier_above_med3=sum(supplier_above_med3), by(gvkey_customer year)


*IV: max of supplier's scrisk
egen firm2_scriskIV2=max(scrisk_supplier), by(gvkey_customer year)
bys gvkey_customer (year): gen lag_firm2_scriskIV2=firm2_scriskIV2[_n-1]


rename gvkey_customer gvkey
keep gvkey year num_supplier number_supplier_same_cont number_supplier_us number_supplier_diff_cont2 ///
number_supplier_above_med3 diff_cont_frac re_size mean_supplier_ind  firm2_scriskIV2 lag_firm2_scriskIV2
duplicates drop gvkey year,force


la var num_supplier "Number of suppliers" 
la var number_supplier_same_cont "Number of suppliers in the same continent" 
la var number_supplier_us "Number of U.S. suppliers" 
la var number_supplier_diff_cont2 "Number of suppliers in different continents" 
la var number_supplier_above_med3 "Number of industry leader suppliers" 
la var diff_cont_frac "Different continents" 
la var re_size "Relative size" 
la var mean_supplier_ind "Average number of suppliers in an input industry" 
la var firm2_scriskIV2 "SCRisk - supplier (IV)" 
la var lag_firm2_scriskIV2 "lag SCRisk - supplier (IV)" 

         

save _temp_gvkey_year_revere,replace



************************************************************************************************************************************************************
************************************************************************************************************************************************************
*Prepare Compustat
************************************************************************************************************************************************************
************************************************************************************************************************************************************

use Compu,clear


*Market share
egen m_sum_sic2_sale=sum(sale), by(sic2 year)
gen m_share_sic2_sale=sale/m_sum_sic2_sale


*Size
gen ln_at=ln(1+at)


*Tobin's Q
gen tobinq1=(at-ceq+(csho*prcc_f))/at


*Cash flow
gen profit1=ib/at


*Cash holdings
gen cash=che/at

bys gvkey (year): gen lag_ln_at=ln_at[_n-1]
bys gvkey (year): gen lag_tobinq1=tobinq1[_n-1]
bys gvkey (year): gen lag_profit1=profit1[_n-1]
bys gvkey (year): gen lag_cash=cash[_n-1]


keep year gvkey sic2 multinational major m_share_sic2_sale fc_ww fc_hp instown_perc  ln_at tobinq1 profit cash lag_ln_at lag_tobinq1 lag_profit1 lag_cash
        

la var m_share_sic2_sale "Market share" 
la var ln_at "Size" 
la var tobinq1 "Tobin's Q" 
la var profit1 "Cash flow" 
la var lag_cash "Lag(cash holdings)" 
la var lag_ln_at "Lag(size)" 
la var lag_tobinq1 "Lag(Tobin's Q)" 
la var lag_profit1 "Lag(cash flow)" 
la var cash "Cash holdings" 


save _temp_compu,replace


************************************************************************************************************************************************************
************************************************************************************************************************************************************
*Put everything together
************************************************************************************************************************************************************
************************************************************************************************************************************************************

**************Start from SCRisk dataset*********************
use scrisk.dta,clear


*************Merge on M&A dataset***************************
merge 1:1 gvkey year using _temp_sdc_cleaned
drop if _merge==2
drop _merge


*Create dummies for different types of M&As
gen ma_input_d=1 if num_input_ma_any>=1 & num_input_ma_any!=.
replace ma_input_d=0 if ma_input_d==.
tab ma_input_d

gen ma_output_d=1 if num_output_ma_any>=1 & num_output_ma_any!=.
replace ma_output_d=0 if ma_output_d==.
tab ma_output_d

gen ma_nonrelated_d=1 if num_unrelated_ma>=1 & num_unrelated_ma!=.
replace ma_nonrelated_d=0 if ma_nonrelated_d==.
tab ma_nonrelated_d

la var ma_input_d "M&A with supplier"
la var ma_output_d "M&A with customer"
la var ma_nonrelated_d "Unrelated M&As" 



**************Merge on Revere*******************************
merge 1:1 gvkey year using _temp_gvkey_year_revere
drop if _merge==2
drop _merge



replace num_supplier=0 if num_supplier==.
replace number_supplier_same_cont=0 if number_supplier_same_cont==.
replace number_supplier_above_med3=0 if number_supplier_above_med3==.
replace number_supplier_us=0 if number_supplier_us==.
replace number_supplier_diff_cont=0 if number_supplier_diff_cont==.



**************Merge on Compustat****************************
merge 1:1 gvkey year using _temp_compu
drop if _merge==2
drop _merge

*Apply Compustat filters

drop if sic2>=60&sic2<=69
drop if sic2==49


*Winsorize
foreach i in SupplyChainUncertainty SupplyChainSentiment lag_ln_at lag_tobinq1 ln_at ///
lag_cash lag_profit1 lag_firm2_scriskIV2 num_supplier number_supplier_same_cont ///
number_supplier_above_med3 number_supplier_us number_supplier_diff_cont2 mean_supplier_ind ///
diff_cont_frac m_share_sic2_sale tobinq1 instown_perc tobinq1{
	winsor `i',gen(`i'W) p(.01)
	drop `i'
	rename `i'W `i'
}


*Take lags
bys gvkey (year): gen lag_SupplyChainUncertainty=SupplyChainUncertainty[_n-1]
bys gvkey (year): gen lag_SupplyChainSentiment=SupplyChainSentiment[_n-1]

la var lag_SupplyChainUncertainty "SCRisk"
la var lag_SupplyChainSentiment "SCSentiment"

rename lag_SupplyChainUncertainty lag_SCUncertainty
rename lag_SupplyChainSentiment lag_SCSentiment


*Deal with scale
*Since we have scaled both SCRisk and SCSentiment up by 100,000 in the Python code (following Hassan et al., 2019),
*Now we scale them down by 100
*The overall effect is that both SCRisk and SCSentiment are scaled up by a factor of 1,000

replace lag_SCUncertainty=lag_SCUncertainty/100
replace lag_SCSentiment=lag_SCSentiment/100
replace SupplyChainUncertainty=SupplyChainUncertainty/100
replace SupplyChainSentiment=SupplyChainSentiment/100
replace lag_firm2_scriskIV2=lag_firm2_scriskIV2/100


la var SupplyChainUncertainty "SCRisk"
la var SupplyChainSentiment "SCSentiment"

la var ln_at "Size" 
la var mean_supplier_ind "Average number of suppliers industry" 
la var m_share_sic2_sale "Market share" 
la var tobinq1 "Tobin's Q" 

la var lag_cash "Cash holdings" 
la var lag_ln_at "Size" 
la var lag_tobinq1 "Tobin's Q" 
la var lag_profit1 "Cash flow" 


la var num_supplier "Number of suppliers" 
la var number_supplier_same_cont "Number of suppliers in the same continent" 
la var number_supplier_us "Number of U.S. suppliers" 
la var number_supplier_diff_cont2 "Number of suppliers in different continents" 
la var number_supplier_above_med3 "Number of industry leader suppliers" 
la var diff_cont_frac "Different continents" 
la var instown_perc "Institutional ownership"
la var lag_firm2_scriskIV2 "SCRisk - supplier (IV)" 

drop num_input_ma_any num_output_ma_any num_unrelated_ma 
save Output_clean.dta,replace


erase _temp_compu.dta
erase _temp_gvkey_year_revere.dta
erase _temp_sdc_cleaned.dta








