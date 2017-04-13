# Nimbix Developer Summit (NDS) 2017: PushToCompute Workshop

This is a tutorial prepared for the 2017 Nimbix Developer Summit (NDS) PushToCompute Workshop hosted in Plano, TX. In this guide, you will learn how to use Github and Dockerhub to deploy an application on JARVICE.

The tutorial covers the main components of deploying an application on JARVICE that is capable of using any the hardware available in the Nimbix Cloud, including NVIDIA GPUs, IBM POWER architecture machines, Intel, and of course, the Infiniband fabric that is part of the default architecture.

These notes are available on Github, and the latest version can be downloaded using:
`git clone git@github.com:nimbix/nds17.git`

To follow along with this tutorial, you'll accounts on the following services:
 * [JARVICE](https://mc.jarvice.com)
 * [DockerHub](https://www.dockerhub.com)
 * [Github](https://www.github.com)

# PushToCompute Overview
PushToCompute is a product for deploying application workflows to the JARVICE Application Marketplace. Applications in the Nimbix catalog are available on JARVICE in the Material Compute portal located at https://mc.jarvice.com.

The main components of deploying an application are:

### 1. DEFINE and PACKAGE

Use *Docker* and *Git* to PACKAGE your application environment as a docker image (i.e., operating system and application binaries). JARVICE is able to import Docker images for use with Nimbix's proprietary container runtime.

Use the JARVICE *AppDef Format* to DEFINE the specific way your application can be run on JARVICE. This includes the exact command to run, how to run it (with a GUI, in batch mode, or as a long-running service), and run-time parameters that can be selected by a user (GPU machine type, multinode cluster, etc...).

### 2. BUILD

Use JARVICE's Docker build service to build your application and push it to a Docker registry.

### 3. DEPLOY

DEPLOY a Docker image by importing it into JARVICE. It will be ready to run in the cloud using Nimbix's high-performance container runtime on its high performance, accelerated hardware.

### 4. RELEASE on Material Compute

RELEASE the workflow to public users who can run it on demand. They can focus on leveraging your application's features, and will never need to compile or install your code. 

The most important details here include how to get an application certified by Nimbix, community contributed applications, and options for app monetization.

## Tutorial

Today we are going to use Git and Docker to build a workflow with two command endpoints that do the following:

 1. Use a pre-built image that has `TORCH` and `neural-style` ready to run.
 2. Create a batch endpoint to "stylize" an image using https://github.com/jcjohnson/neural-style
 3. Run a cloud Desktop GUI application that displays the image. (This is a simplistic example to demonstrate interactive applications on JARVICE)
 4. Define the workflows using the Nimbix AppDef to run on certain GPU machine types

We will then build it and deploy it on JARVICE using PushToCompute. By the end of this tutorial, you will know how to:
 1. DEFINE and PACKAGE an application workflow for use on JARVICE
 2. BUILD a docker-based application image
 3. DEPLOY a workflow on JARVICE by pulling it from your favorite Docker registry.
 4. RELEASE a workflow on JARVICE, and optionally monetize it.

### Step 0: Prerequisites
   In order to follow along in this tutorial, you'll need accounts on the following services:
 1. [JARVICE](https://mc.jarvice.com)
 1. [DockerHub](http://dockerhub.com)
 1. [Github](http://www.github.com)

### Step 1: "Hello, JARVICE"
Pull an image from DockerHub and run it on JARVICE with the default AppDef.
 1. Click "New" to create a new PushToCompute App
 1. In the Docker Reigstry, enter `nimbix/ubuntu-desktop:trusty`
 1. Monitor the status of the pull in the History Window
 1. Once the image finishes pulling, click the app card and select "batch".
 1. Enter "echo hello" and select the n0 machine type. Observe the output.
 1. Try running another batch command, `cat /etc/JARVICE/cores` or `cat /etc/JARVICE/nodes`
 1. (Exercise) Try running "Server" and connecting to the Nimbix desktop interactively.

The commands created for the workflow are part of the default AppDef. You can download this JSON file as a template for use in the next stepf.

### Step 2: Build an application from an app repository on Github

 1. Navigate to the PushToCompute page (Right Nimbix Menu -> PushToCompute -> Left Hamburger Menu -> input Docker Registry credentials)
 1. Connect to your DockerHub account by logging in with your credentials.
 1. Create a new app with the following:
  1. Enter docker repo to be `YourDockerHubUserName/nds17`. Your repo will be pushed to a DockerHub image here. (Note that if you want it to be a private image on DockerHub, you'll need to pre-create it on DockerHub.)
  1. Enter the git repo to be `git@github.com:nimbix/nds17.git` (**Note**: If you would like to follow along editing the repository, please fork the repo and change `nimbix` to your Github username)
 1. Select the hamburger menu on the app card and click "build and pull"
 1. Now check the commands - they are now different because there is a new AppDef in /etc/NAE/AppDef.json.
 1. Notice there is a custom screenshot. This is defined in /etc/NAE/screenshot.png

Check the [Dockerfile](https://github.com/nimbix/nds17/blob/master/Dockerfile) and [AppDef](https://github.com/nimbix/nds17/blob/master/NAE/AppDef.json)

*Note*: If you are familiar with docker and have the app locally, this step is equivalent to running `docker build -t username/imagename .` in the project repository directory, then pushing it to DockerHub using `docker push username/imagename`. JARVICE has a Docker build service with PushToCompute, which can build the application on Intel x86 or IBM POWER (ppc64le) architecture and push it to your favorite Docker registry. It can then be pulled into JARVICE to be run with Nimbix's high performance container runtime.

### Step 3: Customize your Dockerfile

Nimbix has many base images. `docker search nimbix`

Common base images include:
 * nimbix/ubuntu-desktop
 * nimbix/base-ubuntu-nvidia (NVIDIA CUDA base images with Nimbix extras)
 * nimbix-ubuntu-base
 * nimbix/centos-desktop
 * nimbix/centos-base

We've built a special base image for the Nimbix Developer Summit (NDS) '17 workshop: `jarvice/base-nds17`

It is ready to run with GPU acceleration, and has two important pieces of software that we will PushToCompute:

 * [Torch](http://torch.ch/) is a library that is popular for scientific computing and deep learning. We have built a special Torch base image that is pre-configured for use on NIMBIX with GPU-capable Torch.
 * [jcjohnson/neural-style](Neural Style) An implementation of image stylization in Torch. It is open source at <a href="https://github.com/jcjohnson/neural-style">https://github.com/jcjohnson/neural-style</a>

Now you can create your own git repository, or fork the NDS17 workshop repository and study the Dockerfile. In your Dockerfile, use `FROM jarvice/base-nds17`, which has all of the application bits already installed into an Ubuntu 14.04 base environment configured to run with the CUDA 8.0 runtime. Commit this change, and push it to Github.

### Step 4: Define the application workflows

We want to be able to run the following command:

`th neural_style.lua -style_image <image.jpg> -content_image <image.jpg> -output_image /data/output.png`

So, let's build an AppDef that does this.

```javascript

        "stylize": {
            "path": "/usr/local/scripts/stylize.sh",
            "interactive": false,
            "name": "Stylize an Image",
            "description": "Style an image using TORCH-based Neural Style",
            "parameters": {
                "-style_image": {
                    "type": "FILE",
                    "required": true,
                    "name": "Style image",
                    "description": "The image to base the new style on"
                },
                "-content_image": {
                    "type": "FILE",
                    "required": true,
                    "name": "Content image",
                    "description": "The image that will be stylized"
                }
            },
            "machines": [
                "ng*"
            ]
        }
```

A wrapper script isn't always necessary, but in this case we want to set the working directory in the wrapper script.

```bash
#!/bin/bash

. /usr/local/torch/install/bin/torch-activate

cd /usr/local/neural-style/neural-style

th neural_style.lua -backend cudnn -output_image /data/stylized.png $@

exit 0
```

### Step 5: A Better Workflow

We may want to guide the users to use a set of standard stylization images without requiring them to provide it.


```javascript

        "stylize": {
            "path": "/usr/local/scripts/stylize.sh",
            "interactive": false,
            "name": "Stylize an Image",
            "description": "Style an image using TORCH-based Neural Style",
            "parameters": {
                "-style_image": {
                    "type": "selection",
                    "required": true,
                    "name": "Style image",
                    "description": "The image to base the new style on",
                    "values": [
                      "Starry Night",
                      "Picasso",
                      "8-bit JARVICE"
                    ],
                    "mvalues": [
                      "/usr/local/styles/starry_night.png",
                      "/usr/local/styles/picasso.png",
                      "/usr/local/styles/jarvice.png"
                    ],                    
                },
                "-content_image": {
                    "type": "FILE",
                    "required": true,
                    "name": "Content image",
                    "description": "The image that will be stylized",
                    "filter": "*.png|*.jpg"
                }
            },
            "machines": [
                "ng*"
            ]
        }
```

### Step 6: Releasing on JARVICE

#### Ensure that your application has all of the proper metadata set:
 1. /etc/NAE/AppDef.json
 1. /etc/NAE/screenshot.png
 1. /etc/NAE/help.html
 1. Categories set in the AppDef

#### Monetization Options
 
 If you would like to monetize your application with a license fee that is passed through to you as an application owner. License "uplift" pricing is applied by the cost of the machine type, and proportionally to the number of total CPU cores. License uplifts can be applied to any application for pass-through revenue distribution.

#### Community Apps vs Certified Apps

 * Certified Apps: Nimbix provides first-line support for Certified applications. This requires a business agreement, test cases to verify the application's exisiting workflows and information on how to use the application.
 * Community Apps: Community apps are apps whose support is provided by the application owner.


### Appendix A: Comments about using GPUs

Writing a `Dockerfile` is very similar to writing a shell script. A few things to keep in mind when deploying docker images to JARVICE:
 * When using Docker ENV, the environment variables will not be set on JARVICE. You can set variables in the `variables` section of the AppDef, or provide an environment script to source automatically.
 * If you are inheriting from an Ubuntu or CentOS, but not using a Nimbix base image, the Nimbix desktop will not be automatically installed.
 * There is no need to install the NVIDIA drivers inside of a docker image. JARVICE will handle this. However, your container must have `insmod` installed (via `module-init-tools`).
 * For GPU-powered applications, we recommend using `nimbix/base-ubuntu-nvidia`
 * To enable SSH access, start the service manually in the entry point command script.
 * To do a "full boot," you can run `/sbin/init` as the main command. If your image starts SSH as part of a standard init, then SSH will be available. When using the Nimbix base images, the Nimbix Desktop will be the default connect URL.

### Appendix B: Reference Documentation

 * [Github Tutorial](https://github.com/nimbix/nds17)
 * [JARVICE Portal - Material Compute](https://mc.jarvice.com)
 * [PushToCompute Workflow Deployment Guide](https://www.nimbix.net/pushtocompute-work-flow-deployment-guide/)
 * [PushToCompute Docs](http://jarvice.readthedocs.io/en/latest/public/)
 * [Nimbix Developer Forum](https://groups.google.com/forum/#!forum/nimbix-developer-forum)
