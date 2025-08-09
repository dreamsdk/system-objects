#!/usr/bin/env python3
"""
Windows Recycle Bin File Deletion Script

This script reads a list of files and directories from a text file
and moves them to the Windows Recycle Bin instead of permanently deleting them.

Requirements:
- Windows OS
- send2trash library (pip install send2trash)

Usage:
python recycle_deleter.py input_file.txt
"""

import os
import sys
import argparse
from pathlib import Path

try:
    from send2trash import send2trash
except ImportError:
    print("Error: send2trash library is required.")
    print("Install it with: pip install send2trash")
    sys.exit(1)


def read_file_list(input_file):
    """
    Read the list of files and directories from the input file.
    
    Args:
        input_file (str): Path to the input file containing the list
        
    Returns:
        list: List of file/directory paths to delete
    """
    if not os.path.exists(input_file):
        print(f"Error: Input file '{input_file}' not found.")
        return []
    
    paths = []
    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            for line_num, line in enumerate(f, 1):
                line = line.strip()
                if line and not line.startswith('#'):  # Skip empty lines and comments
                    # Convert to absolute path if relative
                    path = os.path.abspath(line)
                    paths.append(path)
                    
    except Exception as e:
        print(f"Error reading input file: {e}")
        return []
    
    return paths


def move_to_recycle_bin(paths, dry_run=False):
    """
    Move files and directories to the Windows Recycle Bin.
    
    Args:
        paths (list): List of file/directory paths to delete
        dry_run (bool): If True, only show what would be deleted without actually doing it
        
    Returns:
        tuple: (success_count, error_count)
    """
    success_count = 0
    error_count = 0
    
    if not paths:
        print("No valid paths found to delete.")
        return success_count, error_count
    
    print(f"{'DRY RUN - ' if dry_run else ''}Processing {len(paths)} items:")
    print("-" * 50)
    
    for path in paths:
        try:
            if not os.path.exists(path):
                print(f"WARNING: Path does not exist: {path}")
                error_count += 1
                continue
            
            if os.path.isfile(path):
                item_type = "FILE"
            elif os.path.isdir(path):
                item_type = "DIRECTORY"
            else:
                item_type = "UNKNOWN"
            
            if dry_run:
                print(f"[{item_type}] Would delete: {path}")
                success_count += 1
            else:
                send2trash(path)
                print(f"[{item_type}] Moved to Recycle Bin: {path}")
                success_count += 1
                
        except Exception as e:
            print(f"ERROR: Failed to delete '{path}': {e}")
            error_count += 1
    
    return success_count, error_count


def main():
    """Main function to handle command line arguments and execute the deletion."""
    parser = argparse.ArgumentParser(
        description="Move files and directories to Windows Recycle Bin from a list file",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python recycle_deleter.py files_to_delete.txt
  python recycle_deleter.py files_to_delete.txt --dry-run
  
Input file format:
  One file or directory path per line
  Lines starting with # are treated as comments
  Relative and absolute paths are supported
        """
    )
    
    parser.add_argument(
        'input_file',
        help='Text file containing list of files/directories to delete (one per line)'
    )
    
    parser.add_argument(
        '--dry-run',
        action='store_true',
        help='Show what would be deleted without actually deleting anything'
    )
    
    args = parser.parse_args()
    
    # Check if running on Windows
    if os.name != 'nt':
        print("Warning: This script is designed for Windows. Recycle Bin functionality may not work properly on other systems.")
    
    # Read the file list
    paths_to_delete = read_file_list(args.input_file)
    
    if not paths_to_delete:
        print("No valid paths found in the input file.")
        return
    
    # Show summary before processing
    if not args.dry_run:
        print(f"About to move {len(paths_to_delete)} items to Recycle Bin.")
        response = input("Continue? (y/N): ").lower().strip()
        if response != 'y':
            print("Operation cancelled.")
            return
    
    # Process the deletions
    success_count, error_count = move_to_recycle_bin(paths_to_delete, args.dry_run)
    
    # Print summary
    print("-" * 50)
    if args.dry_run:
        print(f"DRY RUN COMPLETE - {success_count} items would be deleted, {error_count} errors")
    else:
        print(f"OPERATION COMPLETE - {success_count} items moved to Recycle Bin, {error_count} errors")
    
    if error_count > 0:
        sys.exit(1)


if __name__ == "__main__":
    main()