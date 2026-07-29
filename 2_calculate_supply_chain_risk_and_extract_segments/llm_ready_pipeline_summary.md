# 供應鏈風險分數與 snippet 擷取流程整理

這份流程的目標，是從新聞文本中，找出與供應鏈風險相關的片段，並產出兩種資料：

1. snippet-level 資料：每個命中的供應鏈詞彙片段一列，適合後續做主題模型或 LLM 輸入。
2. article/company-level 資料：每篇文章對每個公司實體一列，適合做公司層級分析。

---

## 1. 最一開始的處理邏輯

### 1.1 讀入字典
流程一開始先讀入兩個字典：

- 供應鏈字典：包含 bigram 與對應權重
- 風險字典：包含風險詞集合

其中供應鏈字典的格式會被轉成二元組形式，例如：

- `(supply, chain)`
- `(supplier, risk)`

這些 bigram 會被用來判斷文章中哪些詞彙是供應鏈相關的。

### 1.2 讀入總表 CSV
接著讀入總表 CSV，這份資料包含每篇文章的基本資訊，以及這篇文章對應到的公司實體。

在這一步會先做兩種去重：

- 文章層級去重：以 `RP_DOCUMENT_ID` 去重，因為文字處理是以文章為單位。
- 公司層級去重：以 `RP_DOCUMENT_ID` + `RP_ENTITY_ID` 去重，因為公司層級分析要保留每個公司實體的資料。

---

## 2. 每篇文章的內部處理流程

### 2.1 讀取文本並清洗
對每篇文章對應的 txt 檔，先讀進來，然後做以下處理：

- 去掉非字母與空白的符號
- 轉成小寫
- 拆成 tokens
- 依序生成 bigram 序列

例如原文經過清洗後變成 token 序列，接著會變成：

- `(word1, word2)`
- `(word2, word3)`
- `(word3, word4)`

這些 bigram 會作為後續計算分數與擷取片段的基礎。

### 2.2 找出風險詞位置
接著檢查每個 bigram 中，是否有任一詞出現在風險詞集合中。

如果某個 bigram 中包含風險詞，則把它的 index 記錄下來，形成一組風險詞位置。

這些位置代表文章中「可能存在風險事件」的區域。

### 2.3 計算供應鏈風險分數
以風險詞位置為中心，設定一個 scoring window，預設為 10。

也就是說：

- 從每個風險詞位置往前後各 10 個 bigram 的範圍內
- 只要該 bigram 命中供應鏈字典，就把權重加進來

最後的分數計算方式為：

$$
\text{sc\_risk\_score} = \frac{\text{weighted\_sum}}{\text{total\_bigrams}}
$$

其中：

- `weighted_sum` 是所有命中供應鏈詞彙權重的總和
- `total_bigrams` 是全文切出來的 bigram 總數

### 2.4 擷取 LLM 用的上下文 snippet
除了算分數之外，流程也會把有意義的上下文抓出來。

對每個命中的供應鏈 bigram，會再以一個 context window（預設 50）來擷取前後上下文，形成一個 snippet。

也就是說，某一個命中的 bigram 會對應一個獨立的上下文片段，後續可以拿去做分類或 LLM 輸入。

---

## 3. 兩種最終資料的產出邏輯

### 3.1 snippet-level 資料
這份資料的單位是「每個 snippet 一列」，也就是一篇文章如果有多個命中的供應鏈詞彙，就會拆成多列。

#### 主要欄位

- `TIMESTAMP_UTC`：文章時間
- `event_type`：事件類型
- `file_name`：文章檔名（`RP_DOCUMENT_ID`）
- `sc_risk_score`：文章層級的供應鏈風險分數
- `weighted_sum`：命中 bigram 的權重總和
- `total_bigrams`：全文 bigram 總數
- `snippet_index`：該 snippet 在文章中的序號
- `matched_index`：命中 bigram 在全文中的 index
- `matched_bigram`：命中的 bigram，格式為 `word1_word2`
- `llm_input_text`：送進 LLM 的上下文文字

#### 這份資料的用途
- 後續做主題模型
- 做 LLM 分類
- 作為文本片段級的分析資料

### 3.2 article/company-level 資料
這份資料的單位是「每篇文章對每個公司實體一列」，所以如果一篇文章對應多家公司，就會產出多列。

#### 主要欄位

- `TIMESTAMP_UTC`：文章時間
- `event_type`：事件類型
- `file_name`：文章檔名
- `RP_ENTITY_ID`：公司實體 ID
- `ENTITY_NAME`：公司名稱
- `sc_risk_score`：文章的供應鏈風險分數
- `weighted_sum`：命中 bigram 的權重總和
- `total_bigrams`：全文 bigram 總數
- `is_first_mention`：是否為第一次提及
- `mention_basis`：判斷依據是 `event` 還是 `title`
- `is_chain_update`：是否為 chain update
- `chain_update_count`：同一條 chain 的更新次數
- `novelty_bucket`：新穎度分桶

#### 這份資料的用途
- 做公司層級分析
- 觀察不同公司在同一篇文章下的風險表現
- 串接後續的實體層級研究

---

## 4. 兩份資料的核心差異

| 資料類型 | 粒度 | 主要用途 |
|---|---|---|
| snippet-level | 每個 snippet 一列 | LLM / 主題模型 / 文本片段分析 |
| article/company-level | 每篇文章對每個公司實體一列 | 公司層級分析 |

### 4.1 共同點
- 都是由同一篇文章先算出風險分數
- 都使用同一套字典與文本清洗流程
- 都依賴相同的供應鏈風險判斷邏輯

### 4.2 不同點
- snippet-level 更偏向「文本片段」
- article/company-level 更偏向「文章與公司實體」

---

## 5. 整體流程總結

整個流程可以概括為：

1. 讀入字典
2. 讀入總表與文章對應關係
3. 逐篇文章讀文本、切 bigram
4. 找出風險詞位置
5. 以風險詞為中心計算供應鏈風險分數
6. 擷取上下文 snippet
7. 輸出兩種資料：
   - snippet-level
   - article/company-level

---

## 6. 你現在可以怎麼理解這份流程

如果把流程簡化成一句話，可以理解為：

> 先用風險詞定位文章中可能有風險的區域，再用供應鏈詞彙字典在附近區間計算分數，最後把有價值的上下文片段與公司層級資訊輸出成兩份資料。
