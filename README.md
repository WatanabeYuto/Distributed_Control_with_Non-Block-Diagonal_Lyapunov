# How to run

This repository provides the code for the numerical simulations in the following paper:

Yuto Watanabe, Sotaro Fushimi, and Kazunori Sakurama, "Convex Reformulation of LMI-Based Distributed Controller Design
with a Class of Non-Block-Diagonal Lyapunov Functions," IEEE Transactions on Automatic Control, 2026 (to appear).

One can reproduce the simulation results in the latest version of our paper: https://arxiv.org/abs/2404.04576.

Stabilization case: `sim_stab_random_systems.m` (for 200 randomly generated systems)

H infinity control case with Complib: `sim_Hinf_complib.m` (for models from Complib)

Data of System matrices can be found in `A_matrices_{stab,Hinf}.m` and  `B_matrices_{stab,Hinf}.m`. The additional simulation results for randomly generated systems can be reproduced by `sim_Hinf_random_systems.m` (for H infinity optimal control; Fig 4) and `sim_subHinf_random_systems.m` (for H infinity "sub"optimal control; Table 4).
 
The initial version is https://github.com/WatanabeYuto/LMI-Based_Distributed_Controller_Design_with_Non-Block-Diagonal_Lyapunov_Functions.
Acknowledgement: The Complib library is from http://www.complib.de/. Thank Dr. Leibfritz for the library. 
