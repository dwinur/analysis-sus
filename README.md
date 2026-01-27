# Analysis SUS - System Usability Scale Data Cleansing

This repository contains tools for cleansing System Usability Scale (SUS) survey data for GenAI mobile applications.

## Files

- **UX GEN AI (Jawaban) - Form Responses 1.csv**: Original survey response data (125 respondents)
- **cleanse_sus_data.py**: Python script to cleanse and format SUS data
- **SUS_Cleansed_Data.csv**: Cleansed data with demographic information and SUS question responses

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

### Running the Data Cleansing Script

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

### Output Format

The output CSV file (`SUS_Cleansed_Data.csv`) contains:

- **Respondent_ID**: Unique identifier for each respondent
- **Timestamp**: Survey submission timestamp
- **Demographic fields**: Nama, Usia, Jenis_Kelamin, Pendidikan, Pekerjaan
- **Usage fields**: Aplikasi_GenAI, Perangkat, Frekuensi_Penggunaan, Durasi_Penggunaan
- **SUS_Q1 to SUS_Q10**: Individual SUS question responses (1-5)

**Note**: This output contains only the raw data and demographic information. SUS score calculation is not included and can be done separately using the standard SUS formula if needed.

## Data Summary

Based on the cleansing of 125 respondents:

- **Total Respondents**: 125
- **Applications**: ChatGPT (OpenAI) - 88 respondents (70.4%), Gemini (Google) - 37 respondents (29.6%)
- **Output Fields**: 21 columns (11 demographic/usage + 10 SUS questions)

## Data Quality

The data cleansing process confirmed:
- ✓ No duplicate responses
- ✓ No missing values in SUS questions
- ✓ All SUS responses are valid (1-5 scale)
- ✓ All 125 responses processed successfully

## Requirements

- Python 3.x
- No external dependencies required (uses standard library only)

## License

This is an analysis project for educational purposes.
