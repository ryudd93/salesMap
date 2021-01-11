<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>script07</title>

    <!-- 구글맵 SDK 로드 -->
    <script defer
    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBWuoUaCXypGiO679_LuXoDu23USAqZ9ew&callback=initMap">
    </script>

    <style>
        #map {
        height: 50%;
        width: 50%;
        margin: 0 auto;
        }
        html, body {
        height: 100%;
        margin: 0;
        padding: 0;
        }
        body h2 {text-align: center;}
    </style>

</head>
<body>
    <!--
    서울 데이터 포탈
    1. API인증키 받기 - 506e57786e72797536374e5753654d
    2. 문서를 확인하고 요청 인자값을 검토해야함
    3. 데이터 처리량을 확인 (최대 1000건까지)
    4. 선택적 옵션 사용
     -->

    <h2>서울시 공공 와이파이 위치</h2>
    
    <select class="gu">
        
    </select>


    <!-- 맵이 저장될 곳 -->
    <div id="map"></div>
    


    <script>
        // 내 중심좌표 멤버 변수
        const myLatLng = { lat: "", lng: "" };

        function getFetch(gu) {
            fetch("http://openAPI.seoul.go.kr:8088/506e57786e72797536374e5753654d/json/PublicWiFiPlaceInfo/1/1000/" + gu)
            .then(function(response) {
                // console.log(response);
                return response.json();
            }).then(function(jsonData) {
                console.log(jsonData);

                
                // 지도의 맵을 생성하는 코드
                const map = new google.maps.Map(document.getElementById("map"), {
                    zoom: 15,
                    center: myLatLng,
                });
                
                
                // 데이터가 없는 경우. 함수의 종료
                if(jsonData.PublicWiFiPlaceInfo === undefined) return;

                // json 데이터 정보를 분해
                var data = jsonData.PublicWiFiPlaceInfo.row;
                console.log(data);
                

                // 지도의 데잍에 대한 마커를 찍어주는 구문
                for(var i = 0; i < data.length; i++) {
                    // 데이터의 좌표값
                    var latLng = {lat : data[i].INSTL_Y, lng : data[i].INSTL_X};

                    const marker = new google.maps.Marker({
                        position: latLng,   // 좌표값
                        map: map,
                        title: data[i].PLACE_ADDR
                    });
                }
            })
        }

        // 3. 셀렉트 이벤트
        var handleSelect = document.querySelector(".gu");
        handleSelect.addEventListener("change", function() {
            console.log(event.target.value);
            // console.log(this.value); // 3개 모두 동일
            // console.log(handleSelect.value);

            getFetch(event.target.value);   //이벤트가 발생할때, 비동기 함수 호출
        });

        // 2. 구 생성 구문
        function createGu() {
            var guList = new Array("종로구", "중구", "용산구", "성동구", "광진구", "동대문구",
                                    "중랑구", "성북구", "강북구", "도봉구", "노원구", "은평구",
                                    "서대문구", "마포구", "양천구", "강서구", "구로구", "금천구",
                                    "영등포구", "동작구", "관악구", "서초구", "강남구", "송파구",
                                    "강동구");
            guList.sort();
            guList.unshift("선택");

            console.log(guList);

            var gu = document.querySelector(".gu");
            for(var i = 0; i < guList.length; i++) {
                var option = document.createElement("option");
                option.innerHTML = guList[i];
                gu.appendChild(option);
            }
        }

        // 위치 정보 성공 함수
        function coordSuccess(position) {    //첫번째 매개변수의 사용자의 위치 정보
            myLatLng.lat = position.coords.latitude;
            myLatLng.lng = position.coords.longitude;
            console.log("내 위치 정보 : ", myLatLng.lat, myLatLng.lng);

            getFetch();
        }

        function coordFail(position) {    //첫번째 매개변수의 사용자의 위치 정보
            
        }


        //1. 지도 API시작
        function initMap() {
            createGu();
            // getFetch();

            // 네비게이터 객체를 이용해서 나의 위치 정보를 받는 코드(success함수에서는 위도, 경도만 출력)
            navigator.geolocation.getCurrentPosition(coordSuccess, coordFail);
        };
    </script>
</body>
</html>