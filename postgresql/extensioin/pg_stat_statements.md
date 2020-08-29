# pg_extension 관련

pg_stat_statements extension 을 설치하면 
DB에서 실행된 쿼리를 조회 할수 있다

##  pg_stat_statements 설치 하기 
  
    1. pg_stat_statements  가 설치되어 있는지 확인


   - select * from pg_extension;  을 실행해서  아래와 같이 나오면 설치가 안되어 있는 상태 입니다.
![image](https://user-images.githubusercontent.com/42956663/58227844-8ea82b00-7d67-11e9-9322-defb2b441996.png)

 - SSH 로 CDM DB 서버로 접속하여 postgresql.conf 파일을 수정하여 줍니다. 
   경로-> /data/psql/postgresql.conf  꼭 이경로가 아닐수 있으니 확인 바래요

-- 아래 항목 추가 

shared_preload_libraries = 'pg_stat_statements'

pg_stat_statements.max = '30000'

pg_stat_statements.track = 'all'

track_activity_query_size= 65536


이부분 추가 후 저장합니다.
![image](https://user-images.githubusercontent.com/42956663/58228040-4b01f100-7d68-11e9-846a-933ee2eb90e1.png)

- docker exec -it psql bash 로 docker접속후 postgresql restart

![image](https://user-images.githubusercontent.com/42956663/58228199-e2674400-7d68-11e9-86d6-dee60b199750.png)

- create extension pg_stat_statements; 으로 설치 합니다.
![image](https://user-images.githubusercontent.com/42956663/58231930-2a8b6400-7d73-11e9-914f-44cdb5eaa051.png)


-  다시 select * from pg_extension;  실행 아래와 같이 조회  되면 설치 성공 - 짝짝짝 

![image](https://user-images.githubusercontent.com/42956663/58228227-fad75e80-7d68-11e9-9d18-0df466c84a1a.png)

- select * from pg_stat_statements;; 으로 내용 확인

![image](https://user-images.githubusercontent.com/42956663/58228273-2bb79380-7d69-11e9-84fc-22ab75e3f722.png)
