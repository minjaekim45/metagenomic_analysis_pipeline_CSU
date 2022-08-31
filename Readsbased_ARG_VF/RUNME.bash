#!/bin/bash

if [[ "$1" == "" || "$1" == "-h" ]] ; then
   echo "
   Usage: ./RUNME.bash folder queue
   Prerequisite: Need to run Diversity Pipeline. 

   folder	Path to the folder containing the 04.trimmed_fasta folder. The
		trimmed reads must be in interposed FastA format & separated pairs format in case you have paire-end reads
                , and filenames must follow the format: <name>.CoupledReads.fa, where <name> is
		the name of the sample & in case of paire-end reads, you also need to have 
                <name>.1.fa and <name>.2.fa. If non-paired, the filenames must follow
		the format: <name>.SingleReads.fa.  
   partition	select a partition (if no provided, shas will be used)
   qos			select a quality of service (if no provided, normal will be used)

   To change any other options for blast, deepARG, and MicrobeCensus, please modify your commands in run.pbs.

   " >&2 ;
   exit 1 ;
fi ;

QUEUE=$2
if [[ "$QUEUE" == "" ]] ; then
   QUEUE="shas"
fi ;

QOS=$3
if [[ "$QOS" == "" ]] ; then
   QOS="normal"
fi ;

dir=$(readlink -f $1)
pac=$(dirname $(readlink -f $0))
cwd=$(pwd)

cd $dir
if [[ ! -e 04.trimmed_fasta ]] ; then
   echo "Cannot locate the 04.trimmed_fasta directory, aborting..." >&2
   exit 1
fi ;

for i in 10.deepARG 11.VFDB 12.MicrobeCensus ; do
   [[ -d $i ]] || mkdir $i
done

# Launch jobs

for i in $dir/04.trimmed_fasta/*.CoupledReads.fa ; do
   b=$(basename $i .CoupledReads.fa)
   OPTS="SAMPLE=$b,FOLDER=$dir"
   if [[ -s $dir/04.trimmed_fasta/$b.SingleReads.fa ]] ; then
      OPTS="$OPTS,FA=$dir/04.trimmed_fasta/$b.SingleReads.fa"
   else
      OPTS="$OPTS,FA=$dir/04.trimmed_fasta/$b.CoupledReads.fa"
   fi
   # Launch job
   sbatch --export="$OPTS" -J "ARG_VF-$b" --partition=$QUEUE --qos=$QOS --error "$dir"/"ARG_VF-$b"-%j.err -o "$dir"/"ARG_VF-$b"-%j.out  $pac/run.pbs | grep .;
done ;

echo 'Done' 
