# README.md

## About

This repository was setup to be a container of experimental data (along with reports that analyze this data) obtained in the course of my MSc. degree pursuit.

## Context of the Work

The broader context of the work is _High-performance Computing_.

Current high-performance machines may possess thousands of processors. Hence, imbalance in load distribution among them may lead to significant resource waste which will then result in significant and, due to the scale of parallel machines today, possibly crippling financial and energetic waste. Narrowing the context further, the specific backdrop of this study is that of irregular parallel applications that, given their irregularity, have a dynamic behavior with regards to load distribution among the computation participants.

## Problem Under Scrutiny

Load balancing is the process of distributing computational workload among the participants of a computation (e.g. threads, processes, machines). This process has the goal of optimizing resource usage in a way that increases performance (i.e. decreases response time). _Load imbalance_ - the phenomenon where different computational elements possess different workloads - can have significant impact on performance and, consequently, in energy consumption and financial cost.

Given all this, accurately quantifying load imbalance as the application progresses is of utmost importance since it is required to properly act on the issue when necessary - by redistributing load - and, thus, avoid the aforementioned waste. A few load balancing metrics have been proposed but no study has ever dissected them to understand how well they describe the dynamic load patterns in parallel applications.

## Research Proposal

Study already proposed load imbalance metrics to understand if they represent reliable indicators of dynamic load distributions in parallel applications. In other words, the goal is to analyze how well existing load balancing metrics describe the evolving pattern of load distribution in irregular parallel applications.

## Contents

* `conf/`

    Contains configuration files used by tools deployed either when generating the data or in the process of analyzing the data.

    * `conf/yajp` contains configuration files used by [YAJP](https://github.com/flavioalles/yajp).

* `lfs.tar.bz2`

    Data container (i.e. `csv` traces extracted from [Pajé](http://paje.sourceforge.net/download/publication/lang-paje.pdf) traces with [`pj_dump`](https://github.com/schnorr/pajeng/wiki/pj_dump)).

* `img`

    Plots repository. These plots were generated with the `plots.jl` script located in this repository (executed using the `plots.csv` file as input). 

* `notebook.ipynb`

    Notebook with analysis on the data. The notebook was made through interactive computing capabilities of [Jupyter](http://jupyter.org) using the [IJulia](https://github.com/JuliaLang/IJulia.jl) package as the kernel.

## `nbviewer`

[`nbviewer`](http://nbviewer.jupyter.org) is a web service that allows one to share static `HTML` versions of publicly available Jupyter notebooks. Thus, to make it easier to view the notebook contained in this repository, follow the link below.

* [`flavioalles/data/notebook.ipynb`](http://nbviewer.jupyter.org/github/flavioalles/data/blob/master/notebook.ipynb)
