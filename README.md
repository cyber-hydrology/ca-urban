# CA-urban

cellular automata for urban catchment

<br>

## About the project

본 프로젝트는 CA(Cellular Automata)기반 고해상도 물순환, 침수 연계 해석 framework의 개발 방향 및 도심지에 적용한 CA기반 prototype 모형의 장단점을 평가합니다. 또한  최적의 지표수 흐름 방향 알고리즘 선정을 위해 3개의 다중 흐름 방향 알고리즘(D4, D8, 4+4N)을 정량적으로 비교하여 분석합니다.

<br>

## CA proto-type model 

CA-based water circulation and inundation proto-type model

<p align="left">
    <img src="https://user-images.githubusercontent.com/99592576/170301234-4406eafe-e1b9-46ab-8bbf-e50ee23ca435.png" width="600px" height="auto"/>
</p>

- 격자 별 침수 깊이, 침투, 토양수분 저류, 지표 유출 등 물순환 요소 모의가 가능
- fast reservoir와 slow reservoir를 통해 지표-지표하 상태 구현 및 단순화된 물수지 모형과 흐름 방향 알고리즘을 적용하여 실제 현장에서 발생하는 다중 피크 형태의 지표 유출 모사

<br>

## Study Area
미국 Oregon 주, Portland시 Downtown 일부 (2.2km2)

<p align="left">
    <img src="https://user-images.githubusercontent.com/99592576/170301319-5ea2ea3f-d716-4d34-b009-6d536046b725.png" width="400px" height="auto"/>
</p>
<br>

## Install

The package can be installed from CRAN :

```r
install.packages("raster")
install.packages("tictoc")
install.packages("sp")
```

Using function codes

```r
source('Neighbor_mat_OCC.R');
source('STRG_surflow2.R');
source('Transition_fun2.R')
```




