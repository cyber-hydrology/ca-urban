# CA-urban

cellular automata for urban catchment

<br>

## About The Project

본 프로젝트는 CA(Cellular Automata)기반 고해상도 물순환, 침수 연계 해석 framework의 개발 방향 및 도심지에 적용한 CA기반 prototype 모형의 장단점을 평가합니다. 또한  최적의 지표수 흐름 방향 알고리즘 선정을 위해 3개의 다중 흐름 방향 알고리즘(D4, D8, 4+4N)을 정량적으로 비교하여 분석합니다.

<br>

## CA Proto-Type Model 

CA-based water circulation and inundation proto-type model

<p align="left">
    <img src="https://user-images.githubusercontent.com/99592576/170301234-4406eafe-e1b9-46ab-8bbf-e50ee23ca435.png" width="600px" height="auto"/>
</p>

- 격자 별 침수 깊이, 침투, 토양수분 저류, 지표 유출 등 물순환 요소 모의가 가능합니다.
- fast reservoir와 slow reservoir를 통해 지표-지표하 상태 구현 및 단순화된 물수지 모형과 흐름 방향 알고리즘을 적용하여 실제 현장에서 발생하는 다중 피크 형태의 지표 유출을 모사합니다.

<br>

## Study Area
미국 Oregon 주, Portland시 Downtown 일부 (2.2km2)

<p align="left">
    <img src="https://user-images.githubusercontent.com/99592576/170301319-5ea2ea3f-d716-4d34-b009-6d536046b725.png" width="400px" height="auto"/>
</p>
<br>

## Getting Started

Here's how to set up a project locally. 
To create a local copy and run the  `CA_cal_portland_revised_220412.R` file, perform the following steps.

<p style="margin-bottom:30px;"> </p>

### Installation

1. Clone the repo

    ```bash
    git clone https://github.com/cyber-hydrology/ca-urban.git
    ```

2. Open  `CA_cal_portland_revised_220412.R` file

3. Install packages

    ```r
    install.packages("raster")
    install.packages("tictoc")
    install.packages("sp")
    ```

### Contribution

This study was conducted as part of the open innovation R&D (21-BC-001) project of the Korea Water Resources Corporation (K-water).



<!--<p style="margin-top:10px;">
</p>  -->

<!--  
<p style="margin-top:20px;">
Using function R codes

```r
source('Neighbor_mat_OCC.R');
source('STRG_surflow2.R');
source('Transition_fun2.R')
```
</p>

<br>

## Code description
* 본인의 working directory 설정
```r
setwd('directory path')
```
* Cellular Automata Setting 
-->
