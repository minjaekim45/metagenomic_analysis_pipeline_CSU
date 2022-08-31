@author: Minjae Kim (minjaekim45 at gmail dot com)

@update: AUG-31-2020

# IMPORTANT

Please see the reference for deepARG for other options and tasks. 

# PURPOSE

Performs deepARG and blastx search against VFDB. It also performs microbecensus to calculate genome equivalent and normalize 
results from deepARG and blastx with VFDB as genome equivalent.

# HELP

1. Files preparation:

   1.1. Using the conda environment on Summit. For the setup please see this link 
   		(https://curc.readthedocs.io/en/latest/software/python.html?highlight=anaconda)
   		After setup the conda environment, conda create/install deeparg with the environment name "deeparg_env" (https://bitbucket.org/gusphdproj/deeparg-ss/src/master/)
   		conda create/install microbecensus with the environment name "microbecensus"
   		Download VFDB fasta file and make the blastdb.
   		Run enveomics/Scripts/FastA.length.pl VFDB_setA_pro.fas > VFDB_setA_pro.gene.length 
   		
   1.1. change the paths of the directory in run.pbs (from line 11-17)
   
   1.2. Prepare the trimmed reads (e.g., use Trim_Pipeline) in interposed FastA format. Files
      must be raw, not zipped or packaged. Filenames must conform the format:
      <name>.CoupledReads.fa or <name>.SingledReads.fa, where <name> is the name of the sample. Locate all the
      files within a folder named 04.trimmed_fasta, within your project folder. If you
      used Trim_Pipeline, no further action is necessary.
   
2. Pipeline execution:
   
   2.1. Simply execute `./RUNME.bash <dir>`, where <dir> is the folder containing
      the 04.trimmed_fasta folder.

3. What to expect:

   By the end of the run, you should find the following folders:
   
   3.1. *10.deepARG*: deepARG output files.
   
   3.2. *11.VFDB*: blastx output files including bestmatch and filtered with bitscore 60

   3.3. *12.MicrobeCensus*: microbecensus output files

   3.4. *10.deepARG/Norm*: Normalized output files for ARG. You need to merge the output files into one table.
						   For example, you want to run script "Table.merge.pl" in the enveomics collection
						   (e.g., Table.merge.pl *.class.csv > merged.class.txt
   3.4. *11.VFDB/Norm*: Normalized output files for VFs. You also want to merge the results like deepARG.
   


