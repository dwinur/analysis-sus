#!/usr/bin/env python3
"""
Script to cleanse CSV data for SUS (System Usability Scale) analysis.

This script cleanses the survey data and creates a new CSV with:
- Demographic information
- SUS question responses (raw scores 1-5)
- No calculation, just data cleansing and formatting
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


def cleanse_data_and_create_sus_csv(input_file: str, output_file: str):
    """
    Cleanse data and create new CSV with demographic and SUS scoring data only.
    
    Args:
        input_file: Path to input CSV file
        output_file: Path to output CSV file
    """
    print(f"Reading data from: {input_file}")
    headers, rows = read_csv_data(input_file)
    
    print(f"Total rows: {len(rows)}")
    print(f"Total columns: {len(headers)}")
    
    # Define indices for data extraction
    # SUS questions are in columns 10-19 (0-indexed)
    sus_question_indices = list(range(10, 20))
    
    # Create output headers - NO SUS_Score column
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
        'SUS_Q1',
        'SUS_Q2',
        'SUS_Q3',
        'SUS_Q4',
        'SUS_Q5',
        'SUS_Q6',
        'SUS_Q7',
        'SUS_Q8',
        'SUS_Q9',
        'SUS_Q10'
    ]
    
    # Process data
    output_rows = []
    skipped_rows = 0
    
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
                except ValueError as e:
                    raise ValueError(f"Invalid SUS response at column {col_idx}: {value}")
            
            # Create output row - NO SUS score calculation
            output_row = [
                row_idx + 1,  # Respondent ID (1-indexed)
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
            ] + sus_responses  # Just append the raw SUS responses
            
            output_rows.append(output_row)
            
        except Exception as e:
            print(f"Warning: Error processing row {row_idx + 1}: {e}")
            skipped_rows += 1
            continue
    
    # Write output CSV
    print(f"\nWriting cleansed data to: {output_file}")
    with open(output_file, 'w', encoding='utf-8', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(output_headers)
        writer.writerows(output_rows)
    
    # Print summary statistics
    print(f"\n=== Data Cleansing Summary ===")
    print(f"Total input rows: {len(rows)}")
    print(f"Rows processed successfully: {len(output_rows)}")
    print(f"Rows skipped: {skipped_rows}")
    print(f"Output columns: {len(output_headers)}")
    print(f"  - Demographic fields: 11")
    print(f"  - SUS question responses: 10")
    
    print(f"\nCleansing complete! Output saved to: {output_file}")


def main():
    """Main function."""
    import argparse
    
    parser = argparse.ArgumentParser(
        description='Cleanse CSV data for SUS (System Usability Scale) analysis'
    )
    parser.add_argument(
        '--input',
        default='UX GEN AI (Jawaban) - Form Responses 1.csv',
        help='Input CSV file (default: UX GEN AI (Jawaban) - Form Responses 1.csv)'
    )
    parser.add_argument(
        '--output',
        default='SUS_Cleansed_Data.csv',
        help='Output CSV file (default: SUS_Cleansed_Data.csv)'
    )
    
    args = parser.parse_args()
    
    try:
        cleanse_data_and_create_sus_csv(args.input, args.output)
    except FileNotFoundError:
        print(f"Error: Input file '{args.input}' not found.")
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == '__main__':
    main()
