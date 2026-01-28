* ====================================================================.
* SYNTAX LENGKAP ANALISIS SUS - ChatGPT (OpenAI).
* Untuk IBM SPSS Statistics 26.
* ====================================================================.

* ====================================================================.
* LANGKAH 0: IMPORT DATA DARI CSV.
* ====================================================================.

GET DATA
  /TYPE=TXT
  /FILE="SUS_ChatGPT_Cleansed.csv"
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
    Q1 F1.0
    Q2 F1.0
    Q3 F1.0
    Q4 F1.0
    Q5 F1.0
    Q6 F1.0
    Q7 F1.0
    Q8 F1.0
    Q9 F1.0
    Q10 F1.0.
CACHE.
EXECUTE.

* Labeling variabel.
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
    Q1 'Saya ingin sering menggunakan sistem ini'
    Q2 'Sistem terlalu kompleks'
    Q3 'Sistem mudah digunakan'
    Q4 'Butuh bantuan teknis untuk menggunakan'
    Q5 'Fungsi terintegrasi dengan baik'
    Q6 'Banyak inkonsistensi dalam sistem'
    Q7 'Orang lain akan cepat belajar'
    Q8 'Sistem sangat rumit digunakan'
    Q9 'Percaya diri menggunakan sistem'
    Q10 'Harus belajar banyak sebelum menggunakan'.

VALUE LABELS Q1 Q2 Q3 Q4 Q5 Q6 Q7 Q8 Q9 Q10
    1 'Sangat Tidak Setuju'
    2 'Tidak Setuju'
    3 'Netral'
    4 'Setuju'
    5 'Sangat Setuju'.

* ====================================================================.
* LANGKAH 1: NORMALISASI DATA (WAJIB DILAKUKAN DULU!).
* ====================================================================.

* Item Positif (Ganjil: 1, 3, 5, 7, 9) - Rumus: Skor - 1.
COMPUTE N_Q1 = Q1 - 1.
COMPUTE N_Q3 = Q3 - 1.
COMPUTE N_Q5 = Q5 - 1.
COMPUTE N_Q7 = Q7 - 1.
COMPUTE N_Q9 = Q9 - 1.

* Item Negatif (Genap: 2, 4, 6, 8, 10) - Rumus: 5 - Skor.
COMPUTE N_Q2 = 5 - Q2.
COMPUTE N_Q4 = 5 - Q4.
COMPUTE N_Q6 = 5 - Q6.
COMPUTE N_Q8 = 5 - Q8.
COMPUTE N_Q10 = 5 - Q10.

EXECUTE.

* Labeling untuk variabel hasil normalisasi.
VARIABLE LABELS
N_Q1 'Q1 Normalized - Saya ingin sering menggunakan sistem ini'
N_Q2 'Q2 Normalized - Sistem terlalu kompleks (reversed)'
N_Q3 'Q3 Normalized - Sistem mudah digunakan'
N_Q4 'Q4 Normalized - Butuh bantuan teknis (reversed)'
N_Q5 'Q5 Normalized - Fungsi terintegrasi dengan baik'
N_Q6 'Q6 Normalized - Banyak inkonsistensi (reversed)'
N_Q7 'Q7 Normalized - Orang lain cepat belajar'
N_Q8 'Q8 Normalized - Sistem sangat rumit (reversed)'
N_Q9 'Q9 Normalized - Percaya diri menggunakan'
N_Q10 'Q10 Normalized - Harus belajar banyak dulu (reversed)'.

* ====================================================================.
* LANGKAH 2: HITUNG SKOR AKHIR SUS (SETELAH NORMALISASI).
* ====================================================================.

COMPUTE SUS_Score = (N_Q1 + N_Q2 + N_Q3 + N_Q4 + N_Q5 + 
                     N_Q6 + N_Q7 + N_Q8 + N_Q9 + N_Q10) * 2.5.
EXECUTE.

VARIABLE LABELS SUS_Score 'Skor Akhir System Usability Scale (0-100)'.

* ====================================================================.
* LANGKAH 3: VERIFIKASI HASIL (CEK APAKAH BENAR).
* ====================================================================.

* Tampilkan beberapa data untuk verifikasi.
LIST VARIABLES=Q1 N_Q1 Q2 N_Q2 SUS_Score /CASES=5.

* ====================================================================.
* LANGKAH 4: UJI VALIDITAS DAN RELIABILITAS.
* ====================================================================.

RELIABILITY
  /VARIABLES=N_Q1 N_Q2 N_Q3 N_Q4 N_Q5 N_Q6 N_Q7 N_Q8 N_Q9 N_Q10
  /SCALE('System Usability Scale') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE CORR
  /SUMMARY=TOTAL MEANS VARIANCE COV.

* ====================================================================.
* LANGKAH 5: STATISTIK DESKRIPTIF SKOR SUS.
* ====================================================================.

DESCRIPTIVES VARIABLES=SUS_Score
  /STATISTICS=MEAN STDDEV MIN MAX.

FREQUENCIES VARIABLES=SUS_Score
  /FORMAT=NOTABLE
  /STATISTICS=MEAN MEDIAN MODE STDDEV MIN MAX
  /HISTOGRAM NORMAL
  /ORDER=ANALYSIS.

* ====================================================================.
* LANGKAH 6: STATISTIK DESKRIPTIF PER ITEM.
* ====================================================================.

DESCRIPTIVES VARIABLES=Q1 Q2 Q3 Q4 Q5 Q6 Q7 Q8 Q9 Q10
  /STATISTICS=MEAN STDDEV MIN MAX.

* ====================================================================.
* LANGKAH 7: FREKUENSI DEMOGRAFI.
* ====================================================================.

FREQUENCIES VARIABLES=Usia Jenis_Kelamin Pendidikan Pekerjaan Perangkat Frekuensi_Penggunaan Durasi_Penggunaan
  /ORDER=ANALYSIS.

* ====================================================================.
* LANGKAH 8: KLASIFIKASI SUS GRADE.
* ====================================================================.

* Klasifikasi Grade berdasarkan skor SUS.
* A: 90-100 (Excellent)
* B: 80-89 (Good)  
* C: 70-79 (Acceptable)
* D: 60-69 (Poor)
* F: Below 60 (Unacceptable).

STRING SUS_Grade (A1).
IF (SUS_Score >= 90) SUS_Grade = 'A'.
IF (SUS_Score >= 80 AND SUS_Score < 90) SUS_Grade = 'B'.
IF (SUS_Score >= 70 AND SUS_Score < 80) SUS_Grade = 'C'.
IF (SUS_Score >= 60 AND SUS_Score < 70) SUS_Grade = 'D'.
IF (SUS_Score < 60) SUS_Grade = 'F'.
EXECUTE.

VARIABLE LABELS SUS_Grade 'Klasifikasi Grade SUS'.

VALUE LABELS SUS_Grade
    'A' 'Excellent (90-100)'
    'B' 'Good (80-89)'
    'C' 'Acceptable (70-79)'
    'D' 'Poor (60-69)'
    'F' 'Unacceptable (<60)'.

FREQUENCIES VARIABLES=SUS_Grade
  /ORDER=ANALYSIS.

* ====================================================================.
* LANGKAH 9: KLASIFIKASI ACCEPTABILITY.
* ====================================================================.

* Klasifikasi Acceptability:
* Acceptable: SUS >= 68
* Marginal: SUS 52-67
* Not Acceptable: SUS < 52.

RECODE SUS_Score (LOWEST THRU 51.99=1) (52 THRU 67.99=2) (68 THRU HIGHEST=3) INTO SUS_Acceptability.
EXECUTE.

VARIABLE LABELS SUS_Acceptability 'Klasifikasi Acceptability SUS'.

VALUE LABELS SUS_Acceptability
    1 'Not Acceptable (Below 52)'
    2 'Marginal (52-67)'
    3 'Acceptable (68 and above)'.

FREQUENCIES VARIABLES=SUS_Acceptability
  /ORDER=ANALYSIS.

* ====================================================================.
* LANGKAH 10: SIMPAN HASIL ANALISIS.
* ====================================================================.

SAVE OUTFILE='SUS_ChatGPT_Analysis_Results.sav'
  /COMPRESSED.

* ====================================================================.
* SELESAI - HASIL LENGKAP ADA DI OUTPUT VIEWER.
* ====================================================================.

TITLE 'Analisis SUS ChatGPT (OpenAI) Selesai'.
