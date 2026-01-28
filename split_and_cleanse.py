#!/usr/bin/env python3
"""
Script to split and cleanse CSV data for SUS (System Usability Scale) analysis.

This script:
1. Reads the original survey data
2. Separates responses by application (ChatGPT vs Gemini)
3. Cleanses the data
4. Creates separate CSV files for each application
"""

import csv
import sys
from typing import List, Tuple


def read_csv_data(filename: str) -> Tuple[List[str], List[List[str]]]:
    """Read CSV file and return headers and data rows."""
    with open(filename, 'r', encoding='utf-8') as f:
        reader = csv.reader(f)
        headers = next(reader)
        rows = list(reader)
    return headers, rows


def cleanse_and_split_data(input_file: str, chatgpt_output: str, gemini_output: str):
    """
    Cleanse data and split into separate CSV files for ChatGPT and Gemini.
    
    Args:
        input_file: Path to input CSV file
        chatgpt_output: Path to output CSV file for ChatGPT data
        gemini_output: Path to output CSV file for Gemini data
    """
    print(f"Reading data from: {input_file}")
    headers, rows = read_csv_data(input_file)
    
    print(f"Total rows: {len(rows)}")
    print(f"Total columns: {len(headers)}")
    
    # Define indices for data extraction
    # SUS questions are in columns 10-19 (0-indexed)
    sus_question_indices = list(range(10, 20))
    app_column_index = 6  # Column for application type
    
    # Create output headers (using simple Q1-Q10 names for SPSS compatibility)
    output_headers = [
        'Respondent_ID',
        'Timestamp',
        'Nama',
        'Usia',
        'Jenis_Kelamin',
        'Pendidikan',
        'Pekerjaan',
        'Aplikasi_GenAI',
        'Perangkat',
        'Frekuensi_Penggunaan',
        'Durasi_Penggunaan',
        'Q1',
        'Q2',
        'Q3',
        'Q4',
        'Q5',
        'Q6',
        'Q7',
        'Q8',
        'Q9',
        'Q10'
    ]
    
    # Process and split data
    chatgpt_rows = []
    gemini_rows = []
    skipped_rows = 0
    chatgpt_id = 0
    gemini_id = 0
    
    for row_idx, row in enumerate(rows):
        try:
            # Skip if row is incomplete
            if len(row) < 20:
                print(f"Warning: Skipping row {row_idx + 1} - incomplete data")
                skipped_rows += 1
                continue
            
            # Extract and validate SUS responses
            sus_responses = []
            for col_idx in sus_question_indices:
                value = row[col_idx].strip()
                if value == '':
                    raise ValueError(f"Missing SUS response at column {col_idx}")
                try:
                    sus_value = int(value)
                    if sus_value < 1 or sus_value > 5:
                        raise ValueError(f"SUS response out of range: {sus_value}")
                    sus_responses.append(sus_value)
                except ValueError:
                    raise ValueError(f"Invalid SUS response at column {col_idx}: {value}")
            
            # Determine application type
            app_type = row[app_column_index].strip()
            
            # Create base row data (without ID - will be added later)
            base_row = [
                None,  # Placeholder for Respondent ID
                row[0],  # Timestamp
                row[1].strip(),  # Nama
                row[2].strip(),  # Usia
                row[3].strip(),  # Jenis Kelamin
                row[4].strip(),  # Pendidikan
                row[5].strip(),  # Pekerjaan
                row[6].strip(),  # Aplikasi GenAI
                row[7].strip(),  # Perangkat
                row[8].strip(),  # Frekuensi Penggunaan
                row[9].strip(),  # Durasi Penggunaan
            ] + sus_responses
            
            # Route to appropriate list based on application
            if 'ChatGPT' in app_type:
                chatgpt_id += 1
                base_row[0] = chatgpt_id
                chatgpt_rows.append(base_row)
            elif 'Gemini' in app_type:
                gemini_id += 1
                base_row[0] = gemini_id
                gemini_rows.append(base_row)
            else:
                print(f"Warning: Unknown application type at row {row_idx + 1}: {app_type}")
                skipped_rows += 1
                continue
            
        except Exception as e:
            print(f"Warning: Error processing row {row_idx + 1}: {e}")
            skipped_rows += 1
            continue
    
    # Write ChatGPT output CSV
    print(f"\nWriting ChatGPT data to: {chatgpt_output}")
    with open(chatgpt_output, 'w', encoding='utf-8', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(output_headers)
        writer.writerows(chatgpt_rows)
    
    # Write Gemini output CSV
    print(f"Writing Gemini data to: {gemini_output}")
    with open(gemini_output, 'w', encoding='utf-8', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(output_headers)
        writer.writerows(gemini_rows)
    
    # Print summary statistics
    print(f"\n=== Data Split and Cleansing Summary ===")
    print(f"Total input rows: {len(rows)}")
    print(f"Rows skipped: {skipped_rows}")
    print(f"\nChatGPT (OpenAI):")
    print(f"  - Total respondents: {len(chatgpt_rows)}")
    print(f"  - Output file: {chatgpt_output}")
    print(f"\nGemini (Google):")
    print(f"  - Total respondents: {len(gemini_rows)}")
    print(f"  - Output file: {gemini_output}")
    print(f"\nOutput columns: {len(output_headers)}")
    print(f"  - Demographic fields: 11")
    print(f"  - SUS question responses: 10")
    
    print(f"\nSplit and cleansing complete!")


def main():
    """Main function."""
    import argparse
    
    parser = argparse.ArgumentParser(
        description='Split and cleanse CSV data for SUS (System Usability Scale) analysis'
    )
    parser.add_argument(
        '--input',
        default='UX GEN AI (Jawaban) - Form Responses 1.csv',
        help='Input CSV file (default: UX GEN AI (Jawaban) - Form Responses 1.csv)'
    )
    parser.add_argument(
        '--chatgpt-output',
        default='SUS_ChatGPT_Cleansed.csv',
        help='Output CSV file for ChatGPT data (default: SUS_ChatGPT_Cleansed.csv)'
    )
    parser.add_argument(
        '--gemini-output',
        default='SUS_Gemini_Cleansed.csv',
        help='Output CSV file for Gemini data (default: SUS_Gemini_Cleansed.csv)'
    )
    
    args = parser.parse_args()
    
    try:
        cleanse_and_split_data(args.input, args.chatgpt_output, args.gemini_output)
    except FileNotFoundError:
        print(f"Error: Input file '{args.input}' not found.")
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == '__main__':
    main()
