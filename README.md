# CA-urban

<p align="left">
    <img src="https://user-images.githubusercontent.com/99592576/195240212-fb84d91a-45cf-4c99-9e70-84e313a0a201.png" width="200px" height="auto"/>
</p>
This project has been supported  by K-water.

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

<br>

# Getting Started

Here's how to set up a project locally. 
To create a local copy and run the  `CA_cal_portland_revised_221123.R` file, perform the following steps.

<p style="margin-bottom:30px;"> </p>

## **Settings**
Copy the code from the project to your local environment and set up the environment so that the code can run. Run the code after setup to obtain a simulated result for the sample input.


<br>

1. Clone the repo (If you don't use Git, download the code zip file.)

    ```bash
    git clone https://github.com/cyber-hydrology/ca-urban.git
    ```

2. Open  `CA_cal_portland_revised_221114.R` file

3. Install packages

    ```r
    install.packages("raster")
    install.packages("tictoc")
    install.packages("sp")
    ```

4. Working directory setting
    ```r
    p_work <- "{your working directory path}"
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
