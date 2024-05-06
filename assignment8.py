from Bio import SeqIO
import argparse
import sys
        
def interleave_fastq(forward_file, reverse_file, output_file):
    # I used SeqIO.parse() fucntion to read and iterate over forward and backward files
    forward_iter = SeqIO.parse(forward_file, "fastq")
    reverse_iter = SeqIO.parse(reverse_file, "fastq")
       
    # opening output file in write mode    
    with open(output_file, "w") as output_handle:
        
        for (fwd, rev) in zip(forward_iter, reverse_iter):
            # writing both forward and backward reads to output file
            SeqIO.write(fwd, output_handle, "fastq")
            SeqIO.write(rev, output_handle, "fastq")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Interleave Paired-End FASTQ Files')
    parser.add_argument('forward_file', help='Forward reads FASTQ file')
    parser.add_argument('reverse_file', help='Reverse reads FASTQ file')
    parser.add_argument('output_file', help='Output interleaved FASTQ file')
    args = parser.parse_args()
    interleave_fastq(args.forward_file, args.reverse_file, args.output_file)