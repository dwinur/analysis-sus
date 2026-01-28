# Analysis SUS - System Usability Scale Data Cleansing

This repository contains tools for cleansing System Usability Scale (SUS) survey data for GenAI mobile applications.

## Files

### Data Files
- **UX GEN AI (Jawaban) - Form Responses 1.csv**: Original survey response data (125 respondents)
- **SUS_Cleansed_Data.csv**: Combined cleansed data with demographic information and SUS question responses
- **SUS_ChatGPT_Cleansed.csv**: Cleansed data for ChatGPT (OpenAI) users only (88 respondents)
- **SUS_Gemini_Cleansed.csv**: Cleansed data for Gemini (Google) users only (37 respondents)

### Python Scripts
- **cleanse_sus_data.py**: Python script to cleanse and format SUS data (combined)
- **split_and_cleanse.py**: Python script to split and cleanse data by application type (ChatGPT/Gemini)

### SPSS Syntax Files (Version 26)
- **SUS_Analysis_ChatGPT.sps**: SPSS 26 syntax for analyzing ChatGPT user data
- **SUS_Analysis_Gemini.sps**: SPSS 26 syntax for analyzing Gemini user data

## SUS (System Usability Scale) Method

The System Usability Scale (SUS) is a widely used standardized questionnaire for measuring the usability of a system. It consists of 10 questions with responses on a 5-point Likert scale (1 = Strongly Disagree, 5 = Strongly Agree).

### SUS Questions in the Survey

1. Saya memiliki keinginan yang tinggi untuk menggunakan Aplikasi GenAI mobile ini secara rutin
2. Saya merasa Aplikasi GenAI mobile ini rumit dan membingungkan untuk digunakan
3. Saya merasa Aplikasi GenAI mobile ini mudah digunakan
4. Saya merasa membutuhkan bantuan dari orang yang ahli teknologi untuk dapat menggunakan Aplikasi GenAI mobile ini
5. Saya merasa berbagai fitur dalam Aplikasi GenAI mobile ini terintegrasi dengan baik
6. Saya merasa ada terlalu banyak ketidakkonsistenan dalam Aplikasi GenAI mobile ini
7. Saya merasa kebanyakan orang akan mudah mempelajari cara menggunakan Aplikasi GenAI mobile ini dengan cepat
8. Saya merasa Aplikasi GenAI mobile ini sangat sulit dan merepotkan untuk digunakan
9. Saya merasa sangat percaya diri saat menggunakan Aplikasi GenAI mobile ini
10. Saya perlu mempelajari banyak hal sebelum dapat menggunakan Aplikasi GenAI mobile ini dengan lancar

## Usage

### 1. Running the Split and Cleanse Script (Recommended)

This script separates the data by application type and cleanses it:

**Basic usage (with default filenames):**
```bash
python3 split_and_cleanse.py
```

**With custom input/output files:**
```bash
python3 split_and_cleanse.py --input mydata.csv --chatgpt-output chatgpt.csv --gemini-output gemini.csv
```

**View help:**
```bash
python3 split_and_cleanse.py --help
```

This script will:
1. Read the original survey data
2. Validate all SUS responses (must be 1-5)
3. Separate data by application type (ChatGPT vs Gemini)
4. Extract demographic information
5. Extract the 10 SUS question responses
6. Create separate cleansed CSV files for each application

### 2. Running the Combined Data Cleansing Script

**Basic usage (with default filenames):**
```bash
python3 cleanse_sus_data.py
```

**With custom input/output files:**
```bash
python3 cleanse_sus_data.py --input mydata.csv --output cleansed.csv
```

**View help:**
```bash
python3 cleanse_sus_data.py --help
```

This script will:
1. Read the original survey data
2. Validate all SUS responses (must be 1-5)
3. Extract demographic information
4. Extract the 10 SUS question responses
5. Create a cleansed CSV file ready for SUS analysis

### 3. Using SPSS Syntax Files (Version 26)

The SPSS syntax files are designed for IBM SPSS Statistics Version 26. To use them:

1. Open IBM SPSS Statistics Version 26
2. Go to **File → Open → Syntax**
3. Select the appropriate syntax file:
   - `SUS_Analysis_ChatGPT.sps` for ChatGPT data analysis
   - `SUS_Analysis_Gemini.sps` for Gemini data analysis
4. Make sure the corresponding CSV file is in the same directory:
   - `SUS_ChatGPT_Cleansed.csv` for ChatGPT syntax
   - `SUS_Gemini_Cleansed.csv` for Gemini syntax
5. Run the entire syntax file (Run → All) or select specific sections to run

**The SPSS syntax files include:**
- Data import and variable labeling
- SUS score calculation (using the standard SUS formula)
- SUS grade classification (A-F scale)
- SUS acceptability classification (Acceptable/Marginal/Not Acceptable)
- Descriptive statistics
- Frequency analysis
- Reliability analysis (Cronbach's Alpha)
- Cross-tabulation analysis by demographics
- Histogram and visualizations
- Normality tests
- One-sample t-test against acceptability threshold (68)
- Data export to SPSS .sav format and CSV

### Output Format

The output CSV files (`SUS_ChatGPT_Cleansed.csv` and `SUS_Gemini_Cleansed.csv`) contain:

- **Respondent_ID**: Unique identifier for each respondent (per application)
- **Timestamp**: Survey submission timestamp
- **Demographic fields**: Nama, Usia, Jenis_Kelamin, Pendidikan, Pekerjaan
- **Usage fields**: Aplikasi_GenAI, Perangkat, Frekuensi_Penggunaan, Durasi_Penggunaan
- **SUS_Q1 to SUS_Q10**: Individual SUS question responses (1-5)

**Note**: The cleansed CSV files contain only the raw data and demographic information. SUS score calculation is performed in the SPSS syntax files using the standard SUS formula.

## Data Summary

Based on the cleansing of 125 respondents:

| Application | Respondents | Percentage |
|-------------|-------------|------------|
| ChatGPT (OpenAI) | 88 | 70.4% |
| Gemini (Google) | 37 | 29.6% |
| **Total** | **125** | **100%** |

- **Output Fields**: 21 columns (11 demographic/usage + 10 SUS questions)

## Data Quality

The data cleansing process confirmed:
- ✓ No duplicate responses
- ✓ No missing values in SUS questions
- ✓ All SUS responses are valid (1-5 scale)
- ✓ All 125 responses processed successfully

## Requirements

- Python 3.x (no external dependencies required)
- IBM SPSS Statistics Version 26 (for running SPSS syntax files)

## License

This is an analysis project for educational purposes.
