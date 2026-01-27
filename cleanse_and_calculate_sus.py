#!/usr/bin/env python3
"""
Script to cleanse CSV data and create a new CSV for SUS (System Usability Scale) calculations.

SUS Calculation Formula:
- For odd-numbered questions (1, 3, 5, 7, 9): score contribution = scale position - 1
- For even-numbered questions (2, 4, 6, 8, 10): score contribution = 5 - scale position
- Total SUS score = sum of all contributions * 2.5
- SUS scores range from 0 to 100
"""

import csv
import sys
from typing import List, Dict, Tuple


def read_csv_data(filename: str) -> Tuple[List[str], List[List[str]]]:
    """Read CSV file and return headers and data rows."""
    with open(filename, 'r', encoding='utf-8') as f:
        reader = csv.reader(f)
        headers = next(reader)
        rows = list(reader)
    return headers, rows


def calculate_sus_score(sus_responses: List[int]) -> float:
    """
    Calculate SUS score from 10 SUS question responses.
    
    Args:
        sus_responses: List of 10 responses (values 1-5)
    
    Returns:
        SUS score (0-100)
    """
    if len(sus_responses) != 10:
        raise ValueError(f"Expected 10 SUS responses, got {len(sus_responses)}")
    
    total = 0
    for i, response in enumerate(sus_responses):
        if response < 1 or response > 5:
            raise ValueError(f"Invalid SUS response: {response}. Must be 1-5.")
        
        # Odd-numbered questions (index 0, 2, 4, 6, 8): contribution = response - 1
        # Even-numbered questions (index 1, 3, 5, 7, 9): contribution = 5 - response
        if i % 2 == 0:  # Odd questions (1st, 3rd, 5th, etc.)
            total += response - 1
        else:  # Even questions (2nd, 4th, 6th, etc.)
            total += 5 - response
    
    # Multiply by 2.5 to get final SUS score
    sus_score = total * 2.5
    return sus_score


def cleanse_data_and_create_sus_csv(input_file: str, output_file: str):
    """
    Cleanse data and create new CSV with SUS calculations.
    
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
    
    # Create output headers
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
        'SUS_Q10',
        'SUS_Score'
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
            
            # Extract SUS responses
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
            
            # Calculate SUS score
            sus_score = calculate_sus_score(sus_responses)
            
            # Create output row
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
            ] + sus_responses + [sus_score]
            
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
    
    if output_rows:
        sus_scores = [row[-1] for row in output_rows]
        avg_sus = sum(sus_scores) / len(sus_scores)
        min_sus = min(sus_scores)
        max_sus = max(sus_scores)
        
        print(f"\n=== SUS Score Statistics ===")
        print(f"Average SUS Score: {avg_sus:.2f}")
        print(f"Minimum SUS Score: {min_sus:.2f}")
        print(f"Maximum SUS Score: {max_sus:.2f}")
        print(f"Number of responses: {len(sus_scores)}")
        
        # SUS score interpretation
        print(f"\n=== SUS Score Interpretation ===")
        print(f"SUS scores above 68 are considered above average")
        print(f"SUS scores below 68 are considered below average")
        if avg_sus >= 68:
            print(f"Result: The average SUS score ({avg_sus:.2f}) is ABOVE AVERAGE")
        else:
            print(f"Result: The average SUS score ({avg_sus:.2f}) is BELOW AVERAGE")
    
    print(f"\nCleansing complete! Output saved to: {output_file}")


def main():
    """Main function."""
    input_file = 'UX GEN AI (Jawaban) - Form Responses 1.csv'
    output_file = 'SUS_Calculation_Results.csv'
    
    try:
        cleanse_data_and_create_sus_csv(input_file, output_file)
    except FileNotFoundError:
        print(f"Error: Input file '{input_file}' not found.")
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == '__main__':
    main()
