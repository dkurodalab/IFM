# IFM
IFM method general procedure
1.	Run the cMD for the probe into the selected solvent. Here, an example for NMA in water, for which a short trajectory containing five frames is provided (nma_h2o_short_traj.pdb file), where the trajectory has been wrapped around the NMA.
2.	From the g(r) of the cMD run, select the desired number of solvation shells for the molecular probe. In this example, three salvation shells are selected (122 molecules for this example).
3.	Obtain the *.xyz files for the solvation shells with the desired number of solvent molecules. For this you can use the provided Tcl code that runs in VMD (frames_prep.tcl). Usage: 

Example steps to perform the IMF method

A.	Load the trajectory to VMD, either you can use the command line:

vmd nma_h2o_short_traj.pdb

or the menu File>New Molecule.

B.	Run the procedure, you must first load the procedure in the TK console:
1-	click Extensions>Tk console; a new window will open
2-	Change the folder (for example cd C:/my_files/)
3-	Load procedure by running

source frames_prep.tcl

4-	Run the procedure using the following command:  
solvation_shell test 122 
This comes from using solvation_shell name #mol, where name is the name of the file and the variable #mol corresponds to the desired number of molecules, for which it will create a xyz files per each frame. The script produces a file called “name”.dat which contains a list of the residues for the closest water molecules to the NMA and their distances to it. 
Here, the example should produce the files named
test.dat; 0.xyz; 1.xyz; 2.xyz; 3.xyz; 4.xyz 
This can be compared to the results files (\example_results\), where the xyz files are located and test.dat should be the same as nma_wat_example.dat. The only difference is in the name of the hydrogen atoms see next step.

C.	Replace the hydrogen atoms of water for deuterium.
For the NMA in water example the N-H and water hydrogen atoms were changed to deuterium atoms in linux using bash by replacing the H symbol with the sed command:

sed –i '10s/H/D/g;15,380s/H/D/g' frame#.xyz

or in windows using the notepad and the replace command (Edit>Replace). Note that you don’t have to replace the methyl group hydrogen atoms of NMA. 

D.	Optimize and calculate frequencies using GFN2-xTB
To optimize and perform the frequency calculation on the frames uses the following command in linux. Note that you must have installed GFN2-xTB (see https://xtb-docs.readthedocs.io/en/latest/). For these calculations, you need the given *inp files to be in the folder with the selected frames. These files fix the solvent coordinates during the optimization (xtb_instuctions_opt.inp), and assigned the mass of the deuterium atoms to be 2 amu for the frequency calculations (xtb_instuctions_freq.inp).
The first step will do the optimization:

xtb  0.xyz --input xtb_instuctions_opt.inp --opt --namespace opt_0

The second step will do the frequency calculation:

xtb opt_0.xtbopt.xyz --input xtb_instuctions_freq.inp --hess --namespace freq_0

This calculation produces several files per frame, where the frequencies are contained into the *.g98.out files. If everything goes according to the procedure, the following amide-I frequencies should be produced (Table 1) and can be compared with those in the zip file within the folder (\example_results\).
Frame #	Amide-I frequency cm-1
0	1695.41
1	1687.86
2	1709.22
3	1683.42
4	1687.39
