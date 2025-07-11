# How to run

One can reproduce the simulation results in the latest version of our paper https://arxiv.org/abs/2404.04576:

The extended report is available in this repository; see `paper_long_v3.pdf`.

Stabilization case: `sim_stab_random_systems.m` (for 200 randomly generated systems)

H infinity control case with Complib: `sim_Hinf_complib.m` (for models from Complib)

Data of System matrices can be found in `A_matrices_{stab,Hinf}.m` and  `B_matrices_{stab,Hinf}.m`. The additional simulation results for randomly generated systems can be reproduced by `sim_Hinf_random_systems.m` (for H infinity optimal control; Fig 4) and `sim_subHinf_random_systems.m` (for H infinity "sub"optimal control; Table 4).
 
The initial version is https://github.com/WatanabeYuto/LMI-Based_Distributed_Controller_Design_with_Non-Block-Diagonal_Lyapunov_Functions.
Acknowledgement: The Complib library is from http://www.complib.de/. Thank Dr. Leibfritz for the library. 
