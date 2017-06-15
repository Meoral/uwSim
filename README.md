# Underwater Image Systems Simulation

<p text-align="justify">
Digital cameras are ubiquitus and are slowly finding their way in niche application areas, such
as imaging below the surface of the sea. Underwater imaging is becoming popular among
consumers (GoPro action cameras) as well as professionals (underwater exploration). 

Underwater imaging faces many more challenges than imaging on the ground, for example excessive 
absorption of the red light component or sever backscattering. Realistic simulations enable 
to explore some of those limitations without the need for troublesome experiments.

This project provides a set of tools to realisticly simualte the appearance of underwater scenes
in a variety of water conditions. Simulated images faciliate evaluation, and comparisons across 
different underwater imaing systems and correction algorithms.
</p>

<p align="center"> 
<img src="https://github.com/hblasins/uwSim/blob/master/Figures/scatter_default.png">
<img src="https://github.com/hblasins/uwSim/blob/master/Figures/scatter_direct.png">
</p>


If you use these tools please cite the following
```
@inproceedings{blasinski2017cmf,
    title={Underwater Image Systems Simulation},
    author={Blasinski, Henryk and Lian, Trisha and Farrell, Joyce},
    booktitle={Imaging and Applied Optics Congress},
    year={2017},
    organization={OSA}
}
```

## Dependencies

To succesffuly run the scripts in this project the following dependencies need to be 
installed.

* [RenderToolbox4](http://rendertoolbox.org) - a set of Matlab tools to create, manipulate and
render complex 3D scene files.
* [Docker](https://www.docker.com) - RenderToolbox4 uses either Mitsuba or PBRT renderers to 
produce final images. Rather than install these programs we provide their dockerized implementations.
A cross-platform Docker engine is required to run these.
* [CVX](http://cvxr.com/) - a Matlab toolbox for convex optimization.
* [ISET](http://imageval.com) - Image Systems Engineering Toolbox for camera sensor simulations.

## Data

In order to reproduce the results from our publications please download the input data (underwater
images, 3D models) from [Stanford Digital Repository].

## Directory structure

* **Code** contains all the Matlab source code.
  * **Code/Utilities** a number of 'unrelated' functions we use thourghout the project (for example XML file parsing)
  * **Code/Remodellers** functions used by RenderToolbox4 to change the scene geometry or other properties. Please refer to [RenderToolbox4 docummentation](https://github.com/RenderToolbox/RenderToolbox4/wiki/Flythrough) for details.
  * **Code/VideosAndFigures** functions to generate sample images, figures and videos used in presentations and publications.
* **Figures** images and movies that were generated from the simulation results. For example 
the two figures on top of this page.
* **Parameters** contains calibration data for different cameras and light sources. For example
the spectral responsivities of the Canon G7X used in the experiments.
* **Scenes** 3D scene files used in simulations. We usually generate these scenes in [Blender](https://www.blender.org)

## Installation

Please clone the repository to your local drive. From MATLAB run `Code/install.m` function 
to correctly set up MATLAB PATH in your environment. 

## Getting started

To get you started please have a look (and run) at the `Code/renderUnderwaterChart.m` script. This is a simple script that renders an image of a Macbeth chart submertged in water. You can specify a number of parameters that affect the final image appearance :
* depth
* camera to chart distance
* chlorophyl concentraion
* color dissolved organic matter (CDOM) concentraion
* small particle concentration
* large particle concentration

Many other scripts in the `Code` directory are a variation on the `renderUnderwaterChart.m` where we simply vary or co-vary different parameters and produce a large number of output images.


