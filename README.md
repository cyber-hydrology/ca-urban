# CA-Urban

Cellular Automata for Urban catchment

<br>

## About The Research

개발된 CA-Urban 모형은 CA 기법을 사용하는 2차원 도시 침수 해석 모형으로 이웃 격자들의 평균 높이를 이용하여 물의 흐름 방향을 결정하고 가중치에 기반한 표면 흐름을 계산하여 격자 간에 전달되는 물의 양을 추정합니다.

본 연구는 CA(Cellular Automata)기반 고해상도 물순환, 침수 연계 해석 framework의 개발 및 도심지에 적용한 CA-Urban 모형의 장단점을 평가합니다.

<br>

## CA-Urban Model

Cellular Automata based water circulation and inundation model

<p align="center">
    <img src="https://user-images.githubusercontent.com/99592576/217591878-95f0f4d1-6309-4a16-8106-e586bb5ce116.png" width="450px" height="auto"/>
</p>

-   격자 별 침수 깊이, 침투, 토양수분 저류, 지표 유출 등 물순환 요소 모의가 가능합니다.
-   fast reservoir와 slow reservoir를 통해 지표-지표하 상태 구현 및 단순화된 물수지 모형과 흐름 방향 알고리즘을 적용하여 실제 현장에서 발생하는 다중 피크 형태의 지표 유출을 모사합니다.
-   가중치 기반 시스템을 사용하여 격자간 전달되는 물의 양을 추정하여 중앙셀에서 이웃셀로의 표면 흐름을 계산합니다.

<br>

## Study Area

Part of Downtown Portland, Oregon, USA

<p align="center">
    <img src="https://user-images.githubusercontent.com/99592576/217592909-1be89bb3-dc10-44fb-bc01-48f2a60ba017.png" width="400px" height="auto"/>
</p>
<br>

## Getting Started

Here's how to set up a project locally.
To create a local copy and run the  `CA_cal_portland_revised_230208.R` file, perform the following steps.

<p style="margin-bottom:30px;"> </p>

### Installation

1. Clone the repo

    ```bash
    git clone https://github.com/cyber-hydrology/ca-urban.git
    ```

2. Open `CA_cal_portland_revised_230208.R` file

3. Install packages

    ```r
    install.packages("raster")
    install.packages("tictoc")
    install.packages("sp")
    install.packages("RColorBrewer")
    ```

4. Working directory and input data setting

    ```r
    p_work <- "{your working directory path}" # Working directory
    dem_filename <- "fundem-9m-small" # Enter the file name for the desired resolution
    rainfall_filename <- "runoffEvent_120928_sample_1h" # Rainfall file
    resolution <- "9m" #Write down the resolution
    ```

5. Now you are ready. Go to run.

<br>

## **Custom input data**

User's DEM(DSM) data and rainfall data can be used as input data for code.

<br>

> DEM(DSM) data

1. Put your file(.asc) in the `input` folder (just ASCII file)<br>
   ▫️ You can put an input file with various resolutions for the area you want.

2. Modify the name of your DEM(DSM) data in the code
    ```r
    dem_filename <- "{your DEM or DSM file name without extention}"
    ```

<br>

> Rainfall data

1. Put your file(.csv) in the `input` folder (just csv file) <br>
   ▫️ You can download rainfall data for the region and period you want from [WAMIS](http://wamis.go.kr/) and [기상자료개방포털](https://data.kma.go.kr/cmmn/main.do).

2. Modify the name of your rainfall data in the code
    ```r
    raianfall_filename <- "{your rainfall file name without extention}"
    ```

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

## Acknowledgement

-   This research has been performed as Project No Open Innovation R&D (21-BC-001) and supported by K-water
-   This work was supported by the National Research Foundation of Korea(NRF) grant funded by the Korea government(MSIT) (No. 2022R1A4A5028840).

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
