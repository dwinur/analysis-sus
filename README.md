# Analysis SUS - System Usability Scale Analysis

This repository contains tools for analyzing System Usability Scale (SUS) survey data for GenAI mobile applications.

## Files

- **UX GEN AI (Jawaban) - Form Responses 1.csv**: Original survey response data (125 respondents)
- **cleanse_and_calculate_sus.py**: Python script to cleanse data and calculate SUS scores
- **SUS_Calculation_Results.csv**: Cleansed data with calculated SUS scores

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

### SUS Score Calculation

The SUS score is calculated using the following formula:

1. For **odd-numbered questions** (Q1, Q3, Q5, Q7, Q9):
   - Score contribution = scale position - 1
   - Example: Response of 4 contributes 3 points

2. For **even-numbered questions** (Q2, Q4, Q6, Q8, Q10):
   - Score contribution = 5 - scale position
   - Example: Response of 2 contributes 3 points

3. Sum all contributions and multiply by 2.5 to get the final SUS score (0-100)

### SUS Score Interpretation

- **Above 68**: Above average usability
- **Below 68**: Below average usability
- **80+**: Excellent usability
- **50-68**: OK/Good usability
- **Below 50**: Poor usability

## Usage

### Running the Cleansing Script

```bash
python3 cleanse_and_calculate_sus.py
```

This script will:
1. Read the original survey data
2. Validate all SUS responses (must be 1-5)
3. Calculate individual SUS scores for each respondent
4. Generate statistics (average, min, max)
5. Create a new CSV file with cleansed data and calculated scores

### Output Format

The output CSV file (`SUS_Calculation_Results.csv`) contains:

- **Respondent_ID**: Unique identifier for each respondent
- **Timestamp**: Survey submission timestamp
- **Demographic fields**: Nama, Usia, Jenis_Kelamin, Pendidikan, Pekerjaan
- **Usage fields**: Aplikasi_GenAI, Perangkat, Frekuensi_Penggunaan, Durasi_Penggunaan
- **SUS_Q1 to SUS_Q10**: Individual SUS question responses (1-5)
- **SUS_Score**: Calculated SUS score (0-100)

## Results Summary

Based on the analysis of 125 respondents:

- **Average SUS Score**: 70.04 (Above average)
- **Minimum SUS Score**: 45.00
- **Maximum SUS Score**: 100.00
- **Total Respondents**: 125

The average SUS score of 70.04 indicates that the GenAI mobile applications have **above average** usability according to the respondents.

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
