# 供應鏈風險論文複製包 — 閱讀筆記

> **論文**：Ersahin, N., Giannetti, M., & Huang, R.
> *"Supply Chain Risk: Changes in Supplier Composition and Vertical Integration"*
> *Journal of International Economics*（已接受）
>
> **本筆記涵蓋**：`egh_Online_Appendix_shorter_paper.pdf`（33 頁）、`ReplicationPackge_EGH_v2/` 全部程式碼與資料、7 個主題詞雲 CSV
> **整理日期**：2026-07-29

---

## 目錄

**Part I — 論文與複製包全覽**
1. [這是什麼](#一這是什麼)
2. [核心研究問題與邏輯鏈](#二核心研究問題與邏輯鏈)
3. [關鍵變數的建構](#三關鍵變數的建構)
4. [實證設計：識別策略](#四實證設計識別策略)
5. [五張主表](#五五張主表在說什麼)
6. [Figure 1 與七個主題](#六figure-1-與七個主題)
7. [附錄 19 張表的角色](#七附錄-19-張表的整體角色)
8. [資料與程式碼流程](#八資料與程式碼流程)
9. [使用時的注意事項](#九-使用這個包時必須注意的事)

**Part II — 主題分類方法深究**
10. [包裡有什麼、缺什麼](#十先釐清包裡有什麼缺什麼)
11. [方法判定：STM](#十一方法是什麼stm結構化主題模型)
12. [完整管線還原](#十二完整管線還原)
13. [資料瑕疵](#十三我在-csv-裡發現的兩個瑕疵)
14. [自己重做的作法](#十四如果要自己重做這套流程)
15. [可延伸的研究方向](#十五可延伸的研究方向)

---

# Part I — 論文與複製包全覽

## 一、這是什麼

這是一篇已被 **Journal of International Economics** 接受的論文的**複製包（replication package）**。EGH = 三位作者姓氏縮寫（Ersahin, Giannetti, Huang）。

資料夾裡**沒有論文正文**，只有：

- **線上附錄**：`egh_Online_Appendix_shorter_paper.pdf`（33 頁，Appendix A + Figure IA.1–2 + Table IA.1–19）
- **完整程式碼與資料字典**：`ReplicationPackge_EGH_v2/`
- `ReplicationPackge_EGH.zip` 與已解壓的 `_v2` 資料夾內容**完全相同**（zip 多一個空的 `TablesAndFigures/` 輸出目錄）

---

## 二、核心研究問題與邏輯鏈

### 研究問題

> **當一家公司感受到供應鏈風險升高時，它會怎麼做？**

疫情、地緣政治、天災、缺料讓供應鏈風險成為顯學，但過去缺乏「公司層級、逐年變動」的風險衡量。作者先造一把尺，再用這把尺回答上面的問題。

### 完整邏輯鏈（五個環節，對應五張表）

```
[測量]   用財報電話會議文本 → 建構公司-年度的 SCRisk
   ↓
[Table 2] 什麼樣的公司 SCRisk 高？（驗證這把尺量到的是真東西）
   ↓
[Table 3] SCRisk ↑ → 供應商數量增加（分散化 / 建立冗餘）
   ↓
[Table 4] SCRisk ↑ → 與上下游的垂直併購機率上升（垂直整合）
   ↓
[Table 5] 股市對「高風險時期的垂直併購」反應更正面（價值創造，非代理問題）
```

### 核心結論

面對供應鏈風險，公司採取**兩種互補的因應策略**：

1. **廣度上分散** — 找更多供應商，尤其是本土與產業龍頭
2. **深度上內化** — 直接把上下游買下來

而市場認可後者是對的決策。

---

## 三、關鍵變數的建構

### 1. SCRisk（供應鏈風險）— 論文的靈魂

方法完全**沿用 Hassan et al. (2019, QJE) 的政治風險衡量法**，換成供應鏈情境：

| 步驟 | 內容 |
|---|---|
| **Step 1 建訓練庫** | 從供應鏈管理教科書／文獻抽出代表「供應鏈」的 bigram（雙字詞組）並給權重。附錄 `Table IA.1` 列出權重最高的 100 個：`supply_chain`(761.63)、`the_supply`(281.15)、`lead_time`(98.79)、`transportation_cost`(64.41)、`demand_uncertainty`(36.99)… |
| **Step 2 建風險詞典** | 從牛津辭典抓 "risk / risky / uncertain / uncertainty" 的所有同義詞，共 **136 個**（`Table IA.2`：ambivalence、hazard、jeopardy、precarious、volatile…） |
| **Step 3 計算** | 掃描每場財報電話會議逐字稿，當**供應鏈 bigram 出現、且其前後 10 個字內出現風險同義詞**時計 1 次（加權），再除以逐字稿總字數 → 標準化為公司-年度的 SCRisk |

**SCSentiment（供應鏈情緒）** 用同樣結構，但把「風險詞」換成「正負面情緒詞」，計算淨情緒。

> 🔑 **SCSentiment 是論文的關鍵控制變數**，用來把「風險（第二動差／不確定性）」和「壞消息（第一動差／水準）」分開。

`Table IA.3` 提供實際逐字稿摘錄佐證，例如 Mercury Systems（2020/4/28）談 COVID 導致供應商財務脆弱與停工風險；IEC Electronics（2018/5/9）談全球電子零件缺貨與交期拉長。這是質性上的「臉面效度」檢查。

### 2. 其他核心變數

| 變數 | 來源與定義 |
|---|---|
| **供應商組成** | FactSet Revere 客戶-供應商關係（從 10-K、投資人簡報、新聞稿爬取）。在 `_1_Code_To_Prepare.do:39-71` 由關係層級 `egen sum(...), by(gvkey_customer year)` 加總成公司-年度的：總供應商數、同洲供應商數、美國供應商數、異洲供應商數、產業龍頭供應商數 |
| **垂直併購** | SDC Platinum 併購案 **×** BEA 投入產出表。若併購方產業從標的產業採購 → `pct_input` 有值 → `ma_input_d=1`（與供應商併購）；反之為 `ma_output_d`（與客戶併購）。兩者皆無、且產業不同 → `ma_nonrelated_d`（無關併購，**安慰劑組**） |
| **CAR** | Eventus 算的併購宣告 3 日 `[-1,+1]` 累積異常報酬，市場模型估計窗 `[-255,-31]` |
| **財務變數** | Compustat：Size、Tobin's Q、Cash holdings、Cash flow、市占率、機構持股、Whited-Wu / Hadlock-Pierce 融資限制指標 |

---

## 四、實證設計：識別策略

### 內生性問題

「SCRisk 高 → 買供應商」可能是：
- **反向因果**：打算併購所以電話會議上多談供應鏈
- **遺漏變數**：公司前景惡化，同時導致風險討論與併購行為

### 解法：工具變數（IV）

> **用「該公司所有供應商中，SCRisk 最高者」當作焦點公司 SCRisk 的工具變數。**

程式碼在 `_1_Code_To_Prepare.do:75-76`：

```stata
egen firm2_scriskIV2 = max(scrisk_supplier), by(gvkey_customer year)
bys gvkey_customer (year): gen lag_firm2_scriskIV2 = firm2_scriskIV2[_n-1]
```

- **相關性**：供應商自己的供應鏈風險會沿鏈條傳導給你 → 第一階段係數 **0.0102\*\*\***，**F = 13.384**（`Table IA.10`）
- **排除限制**：供應商的風險除了「透過提高你自己的供應鏈風險」之外，不應直接影響你要不要去買別家公司／要不要多找供應商

> ⚠️ **值得注意的弱點**
> F = 13.38 僅略高於傳統 10 的門檻，以現代標準（Lee et al. 2022 建議 F > 104）算是**偏弱的工具變數**。
> 而 `Table IA.11`（同時對 SCRisk 和 SCSentiment 兩者都做工具化）的 **F 只有 2.628**，已屬明顯弱工具——作者把它放在附錄而非正文，是合理但保守的處理。

### 固定效果與標準誤

所有主要迴歸都是：

```stata
reghdfe Y lag_SCUncertainty lag_SCSentiment [controls], ///
    absorb(gvkey sic2#year) vce(cluster gvkey)
```

- **公司固定效果**：只用「同一家公司隨時間的變動」來識別，吃掉所有不隨時間變的公司特質
- **產業×年度固定效果**：吃掉「某產業在某年整體的景氣／衝擊」，識別來自**同產業同年度內、公司之間的相對風險差異**
- **標準誤 cluster 在公司層級**
- **時序上**：解釋變數全部取 t-1 落後項（`lag_`），被解釋變數在 t → 至少排除同期反向因果

### 樣本處理

- 期間 **2002–2021**（`scrisk.dta` 共 51,865 個公司-年度觀測）
- 剔除**金融業**（sic2 60–69）與**公用事業**（sic2 = 49）— `_1_Code_To_Prepare.do:211-212`
- 所有連續變數 **winsorize 於 1%**
- 有併購紀錄但無 Revere 供應商資料者，供應商數補 0（而非遺漏值）
- 主要 IV 迴歸樣本 **N = 24,139**

---

## 五、五張主表在說什麼

### 📊 Table 1 — 敘述統計

`_2_Code_for_Regressions_Main.do:35-53`。先用一條完整迴歸產生 `used = e(sample)` 旗標，**確保後續所有表用的是同一個樣本**，避免欄位間樣本不一致——這是很嚴謹的做法。

### 📊 Table 2 — 什麼樣的公司供應鏈風險高？

`_2_Code_for_Regressions_Main.do:68-87`。逐欄加入控制變數（10 欄），檢驗 SCRisk 的**效度**。

- 核心自變數 `diff_cont_frac`（跨洲供應商佔比）：供應鏈越國際化、地理越分散 → SCRisk 越高
- `Relative size`（自己相對供應商的規模）為負：**相對供應商越小 → 議價力越弱 → 風險越高**

這是「合理性檢查」：如果一把尺量出來的東西跟直覺完全無關，後面都不用談了。

**相關附錄佐證**：

| 表 | 內容 |
|---|---|
| `IA.6` | **投入品專用性越高、越不是原物料（crude dummy 為負）→ SCRisk 越高**。完全符合交易成本理論（Williamson）——專用性資產才有套牢問題 |
| `IA.7` | 變異數分解：加入公司固定效果後 R² 從 0.13 跳到 0.31 → **SCRisk 有大量公司層級的獨特變異**，不只是產業共同衝擊，正當化了「用公司層級衡量」的必要性 |
| `IA.8` | SCRisk 高 → 實現波動度高；SCSentiment 高 → 前期異常報酬高。且**控制了 Hassan et al. 政治風險與 Sautner et al. 氣候風險後仍成立** |

### 📊 Table 3 — 供應鏈風險 → 供應商組成

`_2_Code_for_Regressions_Main.do:112-144`。5 個被解釋變數 ×（OLS 欄 1-5 / IV 欄 6-10）。

附錄 `Table IA.12` 給出 IV 估計數值：

| 被解釋變數 | IV 係數 |
|---|---|
| 總供應商數 | **+2.8039\*\*\*** |
| 同洲供應商數 | +1.0988\*\* |
| **美國供應商數** | **+0.8981\*\*** |
| 異洲供應商數 | +0.5907\*\* |
| 產業龍頭供應商數 | +1.1505\*\*\* |

**邏輯解讀**：

- **所有類別都增加** → 這是**建立冗餘（redundancy）與多元化**的策略，不是單純的「回流／近岸外包」
- 但**美國供應商 (+0.90) 增幅大於異洲供應商 (+0.59)** → 隱含**供應鏈相對地在地化**的傾向
- 「產業龍頭供應商」增加 → 不只是找更多家，還要找**更可靠、更有能力承受衝擊**的對象（品質面的調整）
- **IV 係數遠大於 OLS**（2.80 vs 0.019）→ 典型的衰減偏誤（attenuation bias）修正，反映文本衡量本身有測量誤差；但也可能反映 LATE 的性質（只對「受供應商風險傳導影響」的那群公司有效）

### 📊 Table 4 — 供應鏈風險 → 垂直併購（論文的主要貢獻）

`_2_Code_for_Regressions_Main.do:162-186`。附錄 `Table IA.13` 數值（IV）：

| 被解釋變數 | IV 係數 |
|---|---|
| 與**供應商**併購 | **+0.0603\*\*** |
| 與**客戶**併購 | **+0.0542\*\*** |
| **無關**併購 | **−0.0171\*** |

> 🎯 **這是全文最漂亮的識別設計**
> 第三欄是**內建的安慰劑檢定**。如果 SCRisk 只是在捕捉「公司有錢／有企圖心所以愛併購」，那三欄應該一起變正。但實際上**只有垂直方向的併購增加，無關併購反而減少**——強烈支持「這是針對供應鏈的、有目的性的垂直整合，而非泛泛的併購衝動」。

**理論對應**：Williamson 的交易成本經濟學 + 不完全契約理論（Grossman-Hart-Moore）。當外部市場交易的不確定性升高、契約無法完備涵蓋所有狀態時，**用所有權（垂直整合）取代市場交易**變得相對划算。

**機制檢定**：附錄 `Table IA.15` 中，SCRisk × 融資限制的交互項**顯著為負**（HP 指標 −0.0017\*\*、WW 指標 −0.0016\*\*）。意思是**受融資限制的公司想整合也整合不起來**。這反過來佐證：垂直整合是一項**需要真金白銀的實體投資反應**，而不是文本雜訊或機械性關聯。

### 📊 Table 5 — 市場反應：這些併購創造價值嗎？

`_3_Code_for_return.do:53-58`。核心是**交互項**：

```stata
gen interaction = vertical * lag_SCUncertainty
reghdfe car11 lag_SCUncertainty vertical interaction [controls], ///
    absorb(sic2 year) vce(robust)
```

**問這個問題的必要性**：Table 4 只證明公司「會這麼做」，但公司經理人可能是在**帝國建立（empire building）**或恐慌下亂投資。Table 5 用股市反應做福利判斷——**如果交互項為正，代表投資人認為「在高供應鏈風險下做垂直併購」特別有價值**，這才能把整篇文章從「描述行為」升級成「這是理性且有效率的因應」。

---

## 六、Figure 1 與七個主題

`R/Figure1.R` 用 `wordcloud` 套件畫 7 個主題（來自 `stm` 結構化主題模型），每個主題一個 CSV。

| 主題 | 高頻詞（實際 CSV 內容） | 對 SCRisk 的貢獻（`Table IA.4`） |
|---|---|---|
| **氣候風險與疫情** | environment, covid, china, demand, challenge | **0.9179\*\*\*（最強）** |
| **成本與原物料價格** | price, cost, oil, gas, variable | **0.6848\*\*\*** |
| **技術與網路攻擊** | technology, system, network, competit | **0.4951\*\*\*** |
| **流動性** | capital, risk, loan, balance, rate | 0.3843\*\*\* |
| **投資與併購** | venture, joint, invest, opportunity | 0.2419\*\*\* |
| **市場不確定性與區域** | uncertainties, market, china, material | 0.2035\*\*\* |
| **分析師與財務議題** | earnings, cfo, analyst, ceo, guidance | **−0.0421（不顯著）** ✅ |

> 🔑 **這張表是效度驗證的關鍵**
> 最後一列「分析師與財務議題」不顯著，證明 SCRisk **沒有被財報電話會議裡無所不在的一般財務閒聊污染**。而排名第一的是氣候與疫情——完全符合樣本期間（2002–2021）涵蓋 COVID 的事實。

**產業排序佐證**（`Table IA.5`）：

| SCRisk 最高 10 產業 | SCRisk 最低 10 產業 |
|---|---|
| 紡織、家具、金屬、機械、電子設備、運輸設備、卡車倉儲、耐久財批發、汽車維修 | 菸草、印刷出版、通訊、餐飲、個人服務、電影、教育服務、娛樂休閒 |
| ⟵ 全是**實體製造與物流業** | ⟵ 全是**服務業** |

這是非常有說服力的「面向效度」證據。

---

## 七、附錄 19 張表的整體角色

線上附錄的結構本身就有清楚邏輯，分成兩大塊。

### A. 「這把尺是好尺」（IA.1 – IA.9）

建構細節（bigram、同義詞）→ 質性佐證（逐字稿摘錄）→ 成分分解（主題迴歸）→ 產業排序 → 理論一致性（投入專用性、生產階段）→ 變異數分解 → 與股價／波動的關聯 → SCSentiment 的對照檢驗

### B. 「結果很穩健」（IA.10 – IA.19）

| 表 | 挑戰什麼 | 怎麼回應 |
|---|---|---|
| IA.10 | 工具變數強嗎？ | 第一階段 F = 13.38 |
| IA.11 | 情緒也內生怎麼辦？ | 同時工具化兩者（但 F 掉到 2.628，弱工具） |
| IA.12–13 | 主結果完整版 | OLS 與 IV 並陳 |
| IA.14 | 垂直關係的定義門檻是否敏感？ | 改用「≥1% 投入／產出」重新定義 → 結果不變 |
| IA.15 | 機制是什麼？ | 融資限制公司做不到 → 是實體投資反應 |
| **IA.16** | **是不是只是政治風險／氣候風險的替身？** | **控制 Hassan et al. (2019) 政治風險與 Sautner et al. (2023) 氣候風險 → 兩者皆不顯著，SCRisk 依然顯著** ✅ |
| **IA.17** | **是不是只是「公司心情好壞」？** | **控制整場電話會議的 overall sentiment → SCRisk 不受影響** ✅ |
| IA.18–19 | 文本雜訊 | 把「≥75% 供應鏈片段其實在談財務／流動性」的觀測值，分別（a）替換成產業中位數、（b）直接刪除 → 結果不變 |

> **IA.16 和 IA.17 是最重要的兩張穩健性表**，因為它們直接回應了審稿人最可能的質疑：「你這個 SCRisk 是不是只是既有風險衡量或一般情緒的重新包裝？」答案是否定的。

---

## 八、資料與程式碼流程

```
scrisk.dta ────────────────────┐  (SCRisk, SCSentiment，公司-年度，2002-2021，51,865 obs)
                               │  ← 唯一的「真實」資料
sdc.dta ──[併購案彙總成年度]───┤
 (7,781 筆併購案)              │
                               ├──► _1_Code_To_Prepare.do ──► Output_clean.dta
customer_supplier_year_revere ─┤     · 建變數                  (45,993 × 34 欄)
 (797,200 筆關係-年度)         │     · merge 1:1 gvkey-year
                               │     · 剔除金融/公用事業
Compu.dta ─────────────────────┘     · winsorize 1%
 (Compustat 財務)                    · 取落後項、調整縮放
                                            │
                        ┌───────────────────┴─────────────────┐
                        ▼                                     ▼
       _2_Code_for_Regressions_Main.do              _3_Code_for_return.do
              → Table 1, 2, 3, 4                     + CAR.dta → Table 5

       R/Figure1.R + 7 個 CSV → Figure 1（詞雲）
```

### 資料集規模

| 檔案 | 維度 | 說明 |
|---|---|---|
| `scrisk.dta` | 51,865 × 4 | **唯一真實資料**，2002–2021 |
| `Compu.dta` | 51,865 × 15 | 模擬 |
| `customer_supplier_year_revere.dta` | 797,200 × 14 | 模擬 |
| `sdc.dta` | 7,781 × 7 | 模擬 |
| `CAR.dta` | 51,865 × 3 | 模擬 |
| `Output_clean.dta` | 45,993 × 34 | 由上述合併產生 |

### ⚠️ 縮放的細節（容易看漏）

`_1_Code_To_Prepare.do:237-246`：

- Python 階段依 Hassan et al. 慣例**放大 100,000 倍**
- Stata 階段再**縮小 100 倍**
- → **淨效果是放大 1,000 倍**

解讀係數大小時必須記住這一點。

---

## 九、⚠️ 使用這個包時必須注意的事

1. **只有 `scrisk.dta` 是真實資料。** `Compu.dta`、`customer_supplier_year_revere.dta`、`sdc.dta`、`CAR.dta` 全部是**模擬（simulated）資料**——因為 Compustat、FactSet Revere、SDC Platinum、Eventus 都有保密協議，作者不能公開。**跑出來的數字絕對不會等於論文中的數字**，Readme 第 7 頁明確警告了這點。這些檔案的用途是**讓你看懂程式碼結構**，不是複製結果。

2. **`Output_clean.dta` 是模擬資料的產物**，同樣不能用來驗證論文數字。

3. **`Figure1.R` 的路徑寫死了** `~/ReplicationPackge_JIE/R`（注意：是 `_JIE` 不是 `_EGH`，資料夾改名時漏改），要跑必須先改 `setwd()` 和 7 處 `read.csv` / `pdf()` 的絕對路徑。而且腳本裡有 `install.packages()`，跑之前建議註解掉。

4. **`TablesAndFigures/` 目錄不存在於解壓後的資料夾**（只在 zip 裡有空目錄）。所有 do 檔開頭都寫 `global out .\TablesAndFigures\`，**執行前必須先手動建立這個資料夾**，否則 `outreg2` 會全部失敗。

5. **SCRisk 的 Python 建構程式碼並未包含在這個包裡**。Readme 只列出用了哪些 Python 套件（bs4、nltk、pandas、html5lib、pdfplumber），但沒附上實際程式碼——如果你想把這套方法**套用到別的情境**（例如台灣上市公司法說會、或改成「地緣政治風險」），得自己根據 Hassan et al. (2019) 重寫。這也是這個包最大的缺口。

6. **需要的 Stata 套件**：`reghdfe`、`ivreghdfe`、`outreg2`、`winsor`
   （`winsor` Readme 沒列，但 `_1_:220` 有用到，需另外 `ssc install winsor`）

---

# Part II — 主題分類方法深究

> 針對「**他怎麼把 snippet 作為輸入資料，產出主題分類**」的深入分析。

## 十、先釐清：包裡有什麼、缺什麼

| 管線階段 | 程式碼在包裡嗎？ |
|---|---|
| ① 抓逐字稿、切出 snippet、算 SCRisk | ❌ **不在**（Python，只列出用了 bs4 / nltk / pandas / html5lib / pdfplumber） |
| ② snippet → 主題模型 | ❌ **不在**（Readme 只說用了 R 套件 `stm`） |
| ③ 主題輸出 → 7 個 CSV | ❌ 不在（CSV 是成品） |
| ④ CSV → 詞雲圖 | ✅ `R/Figure1.R` |
| ⑤ 主題機率 → Table IA.4 迴歸 | ❌ 不在（Stata do 檔沒有這段） |

**「怎麼從 snippet 產出主題分類」正好落在缺失最嚴重的區段。** 不過從三處線索可以相當確定地重建：Readme 的套件清單、附錄表格的註解文字、以及 CSV 本身留下的指紋。

---

## 十一、方法是什麼：STM（結構化主題模型）

### 判定依據

**直接證據**：Readme 第 1 頁明列 R 4.2.0 使用的套件為 `stm` 與 `wordcloud`。`wordcloud` 只負責畫圖，所以**主題建模就是 `stm` 做的**。

**CSV 的指紋佐證**（實際驗證結果）：

#### 1. 同一個詞出現在多個主題裡

210 個詞位中只有 **177 個相異詞**：

| 詞 | 出現在幾個主題 |
|---|---|
| `risk` | **5** |
| `china`、`market`、`statement` | 3 |
| `covid`、`global`、`demand`、`cost`、`quarter`、`financial`、`new`、`capital`、`growth`… | 2 |

> 🔑 **這是混合成員模型（mixed-membership）的決定性特徵**
> 如果是 k-means、字典法或任何硬分類，詞彙會被**切割成互斥集合**。只有 LDA / STM 這類模型才會讓每個詞在每個主題下都有非零機率。

#### 2. 詞彙是 unigram 且經過詞幹化（stemming）

`continu`(continue)、`complet`(complete)、`competit`(competitive)、`energi`(energy)、`pandemy`(pandemic)、`oblig`(obligation)、`vari`(various) — 這是 Porter/Snowball stemmer 的典型輸出，全部小寫、無標點。

> ⚠️ **一個關鍵區分**
> SCRisk 的計算用的是 **bigram**（`supply_chain`、`lead_time`，見 Table IA.1），
> 但**主題模型用的是 unigram**（7 個 CSV 裡沒有任何底線或空白，全是單字）。
> 這是兩套不同的文本表示，服務兩個不同目的。

#### 3. 每個 CSV 恰好 30 列

= `Figure1.R` 裡的 `max.words=30`，且 `freq` 嚴格遞減排序。

---

## 十二、完整管線還原

```
【Python 階段】                          【R 階段】              【Stata 階段】
逐字稿 → snippet → 前處理 ──────────► STM(K=7) ──┬─► β → 詞雲 (Figure 1)
                                                 │
                                                 └─► θ → 聚合到公司-年度
                                                          ├─► Table IA.4 迴歸
                                                          └─► Table IA.18/19 去噪
```

### Step 1：切出 snippet（Python，程式碼缺失）

沿用 Hassan et al. (2019, QJE) 的作法：掃描每份財報電話會議逐字稿，**當某個供應鏈 bigram（Table IA.1 的訓練庫）出現時，把它前後各 10 個字的窗口切下來**，這段文字就是一個 **snippet**。

- 這些 snippet 就是「這家公司在這場電話會議裡談供應鏈的所有片段」
- SCRisk = 這些 snippet 中**有風險同義詞（Table IA.2 的 136 個詞）共現的**加權次數 ÷ 逐字稿總字數
- **同一批 snippet 同時是主題模型的輸入語料**

> 🔑 **這一點是理解整件事的關鍵**
> 主題模型不是跑在整份逐字稿上，而是跑在**已經篩選出來的供應鏈片段**上。
> 所以 7 個主題回答的問題是「**公司談供應鏈時，具體在談什麼**」，
> 而不是「電話會議整體在談什麼」。

**如何確認 snippet 是分析單位？** 附錄 `Table IA.18 / IA.19` 的註解寫得很明白：

> "We … replace firm-year observations of SCRisk in which **more than 75% of the snippets** that incorporate supply chain risk discussions are associated with **probability of** general financial or analyst and liquidity issues **in the top quartile** …"

這句話透露了三件事：

- **(a)** 分析單位是 snippet
- **(b)** 每個 snippet 有一組**主題機率**（而非單一標籤）
- **(c)** 存在 snippet → 公司-年度的比例式聚合

### Step 2：文本前處理（Python nltk，程式碼缺失）

從 CSV 的詞彙形態逆推，做了標準的：轉小寫 → 移除標點數字 → 移除停用詞 → **詞幹化** → 建 document-term matrix。**文件（document）= 一個 snippet**。

### Step 3：跑 STM，K = 7（R，程式碼缺失）

#### STM 是什麼？跟 LDA 差在哪？

STM 是 Roberts、Stewart、Tingley 開發的 **LDA 擴充版**，核心生成結構相同：

- **每個文件是主題的混合**，比例向量 **θ**（theta），維度 D×K，每列加總為 1
- **每個主題是詞彙的機率分布**，矩陣 **β**（beta），維度 K×V，每列加總為 1
- 一個詞的產生：先從 θ 抽一個主題，再從該主題的 β 抽一個詞

**STM 相對 LDA 的關鍵差異**：

| | LDA | STM |
|---|---|---|
| θ 的先驗 | 對稱 Dirichlet | **邏輯常態（logistic normal）**，均值為 **Xγ** |
| 能否納入共變數 | ❌ | ✅ **prevalence 共變數**（如年度、產業）可移動主題比例；**content 共變數**可讓 β 隨組別變化 |
| 主題間相關 | ❌ 假設獨立 | ✅ 允許主題相關（邏輯常態有完整共變異矩陣） |
| 估計方法 | Gibbs 抽樣 / 變分 | **變分 EM**（semi-collapsed） |

**為什麼這篇用 STM 而非 LDA 是合理的？**

因為語料橫跨 2002–2021 二十年，而供應鏈討論的內容**本身就隨時間劇烈變化**（2020 年 COVID 主題爆量）。STM 可以把**年度（甚至產業）當作 prevalence 共變數**放進模型，讓「主題流行度隨時間變動」成為模型的一部分，而不是事後才發現的殘差。這在長時間跨度的財經文本上是標準選擇。

> ⚠️ **但要誠實說**
> 作者**沒有公開他們實際放了哪些共變數、K 怎麼選、用什麼初始化**。這些都是會實質影響結果的自由度。
> K=7 是怎麼決定的（`searchK` 的 held-out likelihood？semantic coherence vs. exclusivity 的取捨？還是人工判讀？）在附錄裡完全沒有交代——這是這篇文章方法揭露上的一個真實缺口。

#### 主題的「命名」是人工的

STM 只會輸出 7 組**沒有名字**的詞彙分布。「Climate risk and pandemics」、「Costs and commodity price risk」這些**標籤是作者讀了高權重詞之後自己取的**，這是主題模型的標準實務，但也意味著存在研究者的詮釋空間。

**完整詞表**（各主題前 30 詞，依權重遞減）：

| 標籤 | 詞表 |
|---|---|
| **Costs & commodity price** | price, cost, impact, business, quarter, year, oil, million, gas, revenue, variable, increase, supplies, model, sale, issue, margin, lease, chief, cost, volume, part, expenses, capacity, inventories, second, first, plant, energi, executive |
| **Technology & cyberattack** | technology, system, customer, network, service, competit, industries, ability, market, larger, order, change, demand, new, offer, product, risk, brand, solution, condition, expand, new, also, grow, digital, develop, client, effect, general, provide |
| **Climate risk & pandemics** | environment, covid, continue, remain, growth, global, economy, given, demand, challenge, china, positive, europe, level, pandemy, overall, believe, see, confident, still, outlook, region, covid, end, industries, spend, near, consumer, face, active |
| **Market uncertainty & regions** | uncertainties, market, result, statement, china, expect, future, material, actual, cause, time, forward, look, security, risk, act, companies, statement, current, exchange, factor, litigation, private, reform, manage, global, financial, perform, plan, risk |
| **Liquidity** | capital, risk, file, balance, loan, rate, look, factor, forward, form, statement, investor, oblig, asset, refer, annual, release, portfolio, inform, public, date, undertake, available, credit, sec, quarter, interest, financial, inform, update |
| **Analysts & financial issues** | earnings, cfo, analyst, ceo, result, anticipate, president, guidance, forecast, conference, will, bank, question, thank, chairman, share, today, corporate, period, comment, vari, forth, made, expect, follow, yes, will, various, director, good |
| **Investment & acquisitions** | venture, joint, invest, opportunity, capital, acquisition, cash, positive, return, growth, million, continu, partner, flow, project, facility, focus, china, believe, complet, announce, long, develop, risk, generate, market, grow, asset, addition, shareholder |

### Step 4：STM 的兩個輸出，走向兩條路

#### 路徑 A：β（主題-詞分布）→ Figure 1 詞雲

取每個主題 β 值最高的 30 個詞，存成 CSV，交給 `Figure1.R` 畫圖：

```r
wordcloud(words = data$word, freq = data$freq,
          max.words = 30, random.order = FALSE, rot.per = 0.35,
          colors = brewer.pal(8, "Dark2"))
```

CSV 裡的 `freq` **不是機率**（每個主題加總約 1,158–1,938，範圍 33–148），而是被縮放過的權重。由於 `wordcloud()` 只用 freq 決定**相對字級**，絕對尺度無所謂——但也因此**無從得知他們用的是原始 β、還是 stm 的 FREX / lift / score 排序**。這四種排序法給出的詞表可以差很多，是一個未揭露的細節。

#### 路徑 B：θ（文件-主題比例）→ 定量分析

**Table IA.4** 的註解說明了作法：

> "We calculate the probability of each topic and **regress SCRisk and SCSentiment on the topics' probabilities**… The topic probabilities are **standardized** by subtracting the mean and dividing by the standard deviation."

也就是把 snippet 層級的 θ **聚合到公司-年度**（最合理的作法是對該公司該年所有 snippet 的 θ 取平均），標準化後跑：

```
SCRisk_it = Σ(k=1..7) β_k · θ̃_k,it + α_i + δ_j×t + ε_it
```

含公司固定效果與產業×年度固定效果，**N = 36,430**。

> **這條迴歸的目的不是預測，而是「拆解」**——回答「我這把尺量到的風險，成分是什麼？」
> 最關鍵的結果是：**「分析師與財務議題」係數 −0.0421 且不顯著**，
> 證明 SCRisk 沒有被電話會議裡無所不在的一般財務閒聊污染。

**Table IA.18 / IA.19** 則把 θ 當成**去噪工具**：

1. 對每個 snippet，看它在「分析師與財務議題」和「流動性」兩個主題上的機率是否落在**全樣本最高四分位**
2. 若某公司-年度**超過 75% 的 snippet 都是這種**，判定該觀測值的 SCRisk 主要來自財務閒聊而非真實供應鏈風險
3. 兩種處理：
   - **IA.18** 替換成產業中位數（N 維持 24,139）
   - **IA.19** 直接刪除（N 降至 23,519）
4. 結果：主要係數皆不變 → 說明主結果不是文本雜訊驅動的

> 🎯 這是很聰明的設計：**主題模型在這裡不只是描述性的展示，而是被拿來做內生的測量誤差診斷**。這比單純畫個詞雲有價值得多。

---

## 十三、我在 CSV 裡發現的兩個瑕疵

驗證 CSV 時發現兩個問題，如果要引用這些檔案需注意。

### 1. `order` 欄位不可信

它**不是一致的詞彙索引**：

- `acquisition.csv` 和 `market_uncertainty.csv` 的整個 order 欄位**逐列完全相同**（495…61861），但對應的詞完全不同（`33256` 在一個檔是 `venture`、在另一個是 `uncertainties`）
- 全部 7 個檔案共有 **42 處 order→word 對應衝突**

這顯然是匯出時的複製貼上失誤。**這欄應該直接忽略**，反正 `Figure1.R` 也沒用到它。

### 2. 每個主題檔內有 1–2 個重複詞

| 檔案 | 重複的詞 |
|---|---|
| `costs` | `cost` ×2 |
| `market_uncertainty` | `statement` ×2、`risk` ×2 |
| `climate_risk` | `covid` ×2 |
| `liquidity` | `inform` ×2 |
| `analyst` | `will` ×2 |
| `tech` | `new` ×2 |

> **一個可能但無法證實的解釋**：
> 如果 STM 用了 **content 共變數**，`stm` 物件的 `beta$logbeta` 會是一個**列表，每個共變數層級一個 β 矩陣**。若作者從兩個層級各抽 top words 再串接，就會產生這種重複。這也可以解釋 order 欄位的錯亂。
> 但程式碼不在，只能是推測。

---

## 十四、如果要自己重做這套流程

由於原始碼缺失，要複製這個方法得自己寫。骨架大致如下。

### Python 端（切 snippet）

```python
from nltk.tokenize import word_tokenize

# 對每份逐字稿
tokens = word_tokenize(transcript.lower())
snippets = []
for i in range(len(tokens) - 1):
    if f"{tokens[i]}_{tokens[i+1]}" in supply_chain_bigrams:   # Table IA.1 訓練庫
        window = tokens[max(0, i-10) : i+12]                    # 前後 10 字窗口
        snippets.append(" ".join(window))
        # SCRisk 計數：window 內是否有 Table IA.2 的風險同義詞共現
```

### R 端（跑 STM）

```r
library(stm)

proc <- textProcessor(snippets$text,
                      metadata = snippets[, c("year", "sic2", "gvkey")])
out  <- prepDocuments(proc$documents, proc$vocab, proc$meta, lower.thresh = 10)

# K 的選擇 —— 這步原文沒交代，你應該自己做並報告
kres <- searchK(out$documents, out$vocab, K = c(5, 7, 10, 15),
                prevalence = ~ s(year) + factor(sic2), data = out$meta)
plot(kres)   # 看 semantic coherence vs. exclusivity 的取捨

mod <- stm(out$documents, out$vocab, K = 7,
           prevalence = ~ s(year) + factor(sic2),    # 主題比例隨年度/產業變動
           data = out$meta,
           init.type = "Spectral")                    # 確定性初始化，可重現

labelTopics(mod, n = 30)              # 看詞表來命名主題
theta <- mod$theta                    # D × 7，snippet 層級的主題比例
beta  <- exp(mod$beta$logbeta[[1]])   # 7 × V，主題-詞機率 → 拿來畫詞雲
```

### 兩個建議比原作做得更完整的地方

1. **報告 K 的選擇依據**（`searchK` 的結果圖）——原文完全沒交代
2. **明確說明詞雲用的是 β 還是 FREX**，並固定隨機種子；用 `init.type = "Spectral"` 可避免變分 EM 的初始值敏感性

---

## 十五、可延伸的研究方向

這篇論文的**方法論骨架非常容易移植**，值得參考的三個設計：

### 1. 「訓練庫 bigram × 風險同義詞的共現」文本衡量法

可換成任何主題（ESG 風險、AI 顛覆風險、關稅風險…），只要能建出一個主題訓練庫。

### 2. 「三欄安慰劑」設計

上游 / 下游 / 無關 —— 用第三欄證明效果**有方向性**而非泛泛。這是非常廉價又有力的識別輔助。

### 3. 「用交易對手的風險當工具變數」

在任何有網絡結構的資料（供應鏈、銀行借貸、董事連結）都適用。
但要小心兩件事：**排除限制的說服力**、以及**工具變數強度**（本文 F ≈ 13 已經偏弱）。

---

## 附錄：檔案清單

```
Data for Supply Chain Risk Changes in Supplier Composition and Vertical Integration/
├── egh_Online_Appendix_shorter_paper.pdf      線上附錄（33 頁）
├── ReplicationPackge_EGH.zip                  與下方資料夾內容相同
├── EGH_供應鏈風險_複製包閱讀筆記.md            ← 本檔案
└── ReplicationPackge_EGH_v2/
    ├── Readme.pdf                             資料與程式碼揭露文件（7 頁）
    ├── _1_Code_To_Prepare.do                  資料清理與合併
    ├── _2_Code_for_Regressions_Main.do        Table 1–4
    ├── _3_Code_for_return.do                  Table 5
    ├── scrisk.dta                             ★ 唯一真實資料
    ├── Compu.dta                              模擬（Compustat）
    ├── customer_supplier_year_revere.dta      模擬（FactSet Revere）
    ├── sdc.dta                                模擬（SDC Platinum）
    ├── CAR.dta                                模擬（Eventus）
    ├── Output_clean.dta                       _1_ 的輸出
    └── R/
        ├── Figure1.R                          詞雲繪圖
        ├── {7 個主題}.csv                      STM 的 top-30 詞（成品）
        └── {7 個主題}.pdf                      已產生的詞雲圖
```
