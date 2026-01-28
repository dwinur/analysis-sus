* ============================================================.
* SPSS Version 26 Syntax for SUS Analysis - Gemini (Google).
* System Usability Scale (SUS) Data Analysis.
* ============================================================.

* ============================================================.
* SECTION 1: DATA IMPORT.
* ============================================================.

* Read the cleansed CSV data file.
GET DATA
  /TYPE=TXT
  /FILE="SUS_Gemini_Cleansed.csv"
  /ENCODING='UTF8'
  /DELIMITERS=","
  /QUALIFIER='"'
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /DATATYPEMIN PERCENTAGE=95.0
  /VARIABLES=
    Respondent_ID F3.0
    Timestamp A20
    Nama A100
    Usia A20
    Jenis_Kelamin A15
    Pendidikan A50
    Pekerjaan A50
    Aplikasi_GenAI A20
    Perangkat A20
    Frekuensi_Penggunaan A30
    Durasi_Penggunaan A25
    SUS_Q1 F1.0
    SUS_Q2 F1.0
    SUS_Q3 F1.0
    SUS_Q4 F1.0
    SUS_Q5 F1.0
    SUS_Q6 F1.0
    SUS_Q7 F1.0
    SUS_Q8 F1.0
    SUS_Q9 F1.0
    SUS_Q10 F1.0.
CACHE.
EXECUTE.

* ============================================================.
* SECTION 2: VARIABLE LABELS.
* ============================================================.

VARIABLE LABELS
    Respondent_ID 'ID Responden'
    Timestamp 'Waktu Pengisian'
    Nama 'Nama Responden'
    Usia 'Usia'
    Jenis_Kelamin 'Jenis Kelamin'
    Pendidikan 'Pendidikan Terakhir'
    Pekerjaan 'Pekerjaan/Profesi'
    Aplikasi_GenAI 'Aplikasi GenAI'
    Perangkat 'Perangkat'
    Frekuensi_Penggunaan 'Frekuensi Penggunaan'
    Durasi_Penggunaan 'Durasi Penggunaan'
    SUS_Q1 'Q1: Keinginan menggunakan secara rutin'
    SUS_Q2 'Q2: Rumit dan membingungkan (R)'
    SUS_Q3 'Q3: Mudah digunakan'
    SUS_Q4 'Q4: Butuh bantuan ahli (R)'
    SUS_Q5 'Q5: Fitur terintegrasi baik'
    SUS_Q6 'Q6: Terlalu banyak ketidakkonsistenan (R)'
    SUS_Q7 'Q7: Mudah dipelajari'
    SUS_Q8 'Q8: Sulit dan merepotkan (R)'
    SUS_Q9 'Q9: Percaya diri saat menggunakan'
    SUS_Q10 'Q10: Perlu belajar banyak (R)'.

* ============================================================.
* SECTION 3: VALUE LABELS FOR SUS QUESTIONS.
* ============================================================.

VALUE LABELS SUS_Q1 SUS_Q2 SUS_Q3 SUS_Q4 SUS_Q5 SUS_Q6 SUS_Q7 SUS_Q8 SUS_Q9 SUS_Q10
    1 'Sangat Tidak Setuju'
    2 'Tidak Setuju'
    3 'Netral'
    4 'Setuju'
    5 'Sangat Setuju'.

* ============================================================.
* SECTION 4: SUS SCORE CALCULATION.
* ============================================================.

* SUS Calculation Formula:
* - For odd questions (Q1, Q3, Q5, Q7, Q9): Score = (response - 1)
* - For even questions (Q2, Q4, Q6, Q8, Q10): Score = (5 - response)
* - Total SUS Score = Sum of all 10 adjusted scores * 2.5.

* Calculate adjusted scores for each question.
COMPUTE SUS_Q1_Adj = SUS_Q1 - 1.
COMPUTE SUS_Q2_Adj = 5 - SUS_Q2.
COMPUTE SUS_Q3_Adj = SUS_Q3 - 1.
COMPUTE SUS_Q4_Adj = 5 - SUS_Q4.
COMPUTE SUS_Q5_Adj = SUS_Q5 - 1.
COMPUTE SUS_Q6_Adj = 5 - SUS_Q6.
COMPUTE SUS_Q7_Adj = SUS_Q7 - 1.
COMPUTE SUS_Q8_Adj = 5 - SUS_Q8.
COMPUTE SUS_Q9_Adj = SUS_Q9 - 1.
COMPUTE SUS_Q10_Adj = 5 - SUS_Q10.
EXECUTE.

* Calculate total SUS Score (0-100 scale).
COMPUTE SUS_Total = (SUS_Q1_Adj + SUS_Q2_Adj + SUS_Q3_Adj + SUS_Q4_Adj + 
    SUS_Q5_Adj + SUS_Q6_Adj + SUS_Q7_Adj + SUS_Q8_Adj + SUS_Q9_Adj + SUS_Q10_Adj) * 2.5.
EXECUTE.

VARIABLE LABELS SUS_Total 'Total SUS Score (0-100)'.

* ============================================================.
* SECTION 5: SUS GRADE CLASSIFICATION.
* ============================================================.

* Create SUS Grade based on score.
* A: 90-100 (Excellent)
* B: 80-89 (Good)
* C: 70-79 (Acceptable)
* D: 60-69 (Poor)
* F: Below 60 (Unacceptable).

STRING SUS_Grade (A1).
IF (SUS_Total >= 90) SUS_Grade = 'A'.
IF (SUS_Total >= 80 AND SUS_Total < 90) SUS_Grade = 'B'.
IF (SUS_Total >= 70 AND SUS_Total < 80) SUS_Grade = 'C'.
IF (SUS_Total >= 60 AND SUS_Total < 70) SUS_Grade = 'D'.
IF (SUS_Total < 60) SUS_Grade = 'F'.
EXECUTE.

VARIABLE LABELS SUS_Grade 'SUS Grade Classification'.

VALUE LABELS SUS_Grade
    'A' 'Excellent (90-100)'
    'B' 'Good (80-89)'
    'C' 'Acceptable (70-79)'
    'D' 'Poor (60-69)'
    'F' 'Unacceptable (<60)'.

* ============================================================.
* SECTION 6: SUS ACCEPTABILITY CLASSIFICATION.
* ============================================================.

* Create Acceptability classification.
* Acceptable: SUS >= 68
* Marginal: SUS 52-67
* Not Acceptable: SUS < 52.

RECODE SUS_Total (LOWEST THRU 51.99=1) (52 THRU 67.99=2) (68 THRU HIGHEST=3) INTO SUS_Acceptability.
EXECUTE.

VARIABLE LABELS SUS_Acceptability 'SUS Acceptability Classification'.

VALUE LABELS SUS_Acceptability
    1 'Not Acceptable (Below 52)'
    2 'Marginal (52-67)'
    3 'Acceptable (68 and above)'.

* ============================================================.
* SECTION 7: DESCRIPTIVE STATISTICS.
* ============================================================.

* Descriptive statistics for raw SUS questions.
TITLE 'Descriptive Statistics - Raw SUS Question Responses'.
DESCRIPTIVES VARIABLES=SUS_Q1 SUS_Q2 SUS_Q3 SUS_Q4 SUS_Q5 SUS_Q6 SUS_Q7 SUS_Q8 SUS_Q9 SUS_Q10
  /STATISTICS=MEAN STDDEV MIN MAX.

* Descriptive statistics for SUS Total Score.
TITLE 'Descriptive Statistics - SUS Total Score'.
DESCRIPTIVES VARIABLES=SUS_Total
  /STATISTICS=MEAN STDDEV MIN MAX.

* ============================================================.
* SECTION 8: FREQUENCY ANALYSIS.
* ============================================================.

* Frequency distribution for each SUS question.
TITLE 'Frequency Distribution - SUS Question Responses'.
FREQUENCIES VARIABLES=SUS_Q1 SUS_Q2 SUS_Q3 SUS_Q4 SUS_Q5 SUS_Q6 SUS_Q7 SUS_Q8 SUS_Q9 SUS_Q10
  /ORDER=ANALYSIS.

* Frequency distribution for SUS Grade.
TITLE 'Frequency Distribution - SUS Grade'.
FREQUENCIES VARIABLES=SUS_Grade
  /ORDER=ANALYSIS.

* Frequency distribution for Acceptability.
TITLE 'Frequency Distribution - SUS Acceptability'.
FREQUENCIES VARIABLES=SUS_Acceptability
  /ORDER=ANALYSIS.

* ============================================================.
* SECTION 9: DEMOGRAPHIC FREQUENCY ANALYSIS.
* ============================================================.

TITLE 'Demographic Analysis'.
FREQUENCIES VARIABLES=Usia Jenis_Kelamin Pendidikan Pekerjaan Perangkat Frekuensi_Penggunaan Durasi_Penggunaan
  /ORDER=ANALYSIS.

* ============================================================.
* SECTION 10: RELIABILITY ANALYSIS (CRONBACH'S ALPHA).
* ============================================================.

* Reliability analysis for SUS scale.
* Note: For proper Cronbach's Alpha calculation, we should reverse-code items first.

TITLE 'Reliability Analysis - Cronbach Alpha'.
RELIABILITY
  /VARIABLES=SUS_Q1_Adj SUS_Q2_Adj SUS_Q3_Adj SUS_Q4_Adj SUS_Q5_Adj 
             SUS_Q6_Adj SUS_Q7_Adj SUS_Q8_Adj SUS_Q9_Adj SUS_Q10_Adj
  /SCALE('SUS Scale') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

* ============================================================.
* SECTION 11: CROSS-TABULATION ANALYSIS.
* ============================================================.

* SUS Grade by Demographics.
TITLE 'Cross-tabulation: SUS Grade by Gender'.
CROSSTABS
  /TABLES=SUS_Grade BY Jenis_Kelamin
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ
  /CELLS=COUNT ROW COLUMN TOTAL.

TITLE 'Cross-tabulation: SUS Grade by Age Group'.
CROSSTABS
  /TABLES=SUS_Grade BY Usia
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ
  /CELLS=COUNT ROW COLUMN TOTAL.

TITLE 'Cross-tabulation: SUS Grade by Education'.
CROSSTABS
  /TABLES=SUS_Grade BY Pendidikan
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ
  /CELLS=COUNT ROW COLUMN TOTAL.

* ============================================================.
* SECTION 12: HISTOGRAM AND VISUALIZATION.
* ============================================================.

* Histogram of SUS Total Score.
TITLE 'Histogram - SUS Total Score Distribution'.
GRAPH
  /HISTOGRAM(NORMAL)=SUS_Total.

* Bar chart of SUS Grade.
TITLE 'Bar Chart - SUS Grade Distribution'.
GRAPH
  /BAR(SIMPLE)=COUNT BY SUS_Grade.

* ============================================================.
* SECTION 13: NORMALITY TEST.
* ============================================================.

TITLE 'Normality Test - SUS Total Score'.
EXAMINE VARIABLES=SUS_Total
  /PLOT BOXPLOT STEMLEAF HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

* ============================================================.
* SECTION 14: ONE-SAMPLE T-TEST.
* ============================================================.

* Test if SUS score is significantly different from 68 (acceptability threshold).
TITLE 'One-Sample T-Test: SUS Score vs Acceptability Threshold (68)'.
T-TEST
  /TESTVAL=68
  /MISSING=ANALYSIS
  /VARIABLES=SUS_Total
  /CRITERIA=CI(.95).

* ============================================================.
* SECTION 15: SAVE PROCESSED DATA.
* ============================================================.

* Save the dataset with computed variables.
SAVE OUTFILE='SUS_Gemini_Analysis_Results.sav'
  /COMPRESSED.

* Export results to CSV for backup.
SAVE TRANSLATE OUTFILE='SUS_Gemini_Analysis_Results.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.

* ============================================================.
* END OF SYNTAX FILE.
* ============================================================.

TITLE 'Gemini SUS Analysis Complete'.
