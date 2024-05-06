import argparse
from Bio import SeqIO

def interleave_fastq(input_read1, input_read2, output_file):
    reads1 = SeqIO.parse(input_read1, "fastq")
    reads2 = SeqIO.parse(input_read2, "fastq")
    with open(output_file, "w") as out_handle:
        for read1, read2 in zip(reads1, reads2):
            SeqIO.write(read1, out_handle, "fastq")
            SeqIO.write(read2, out_handle, "fastq")
    print(f"Interleaving {input_read1} and {input_read2} to {output_file} completed.")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Interleave paired-end FASTQ files')
    parser.add_argument('input_read1', help='Input FASTQ file for read 1')
    parser.add_argument('input_read2', help='Input FASTQ file for read 2')
    parser.add_argument('output_file', help='Output interleaved FASTQ file')
    args = parser.parse_args()
    interleave_fastq(args.input_read1, args.input_read2, args.output_file)
