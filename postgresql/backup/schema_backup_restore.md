
# postgresql backup 및 restore 방법 입니다.(schema백업&복원)

## 1. 현재 서버에 postgresql 이 설치 되어 있는지 확인합니다. 설치되어 있으면 3번부터 보세요

> psql -V

- 이 커맨드를 쳐서 없다고 나오면  postgresql 을 설치합니다.


## 2. yum list를 확인하여 설치하려는 버전이 있는지 우선 찾아 봅니다. (우리는 10버전대를 쓰니 10버전으로) 

 >   yum list postgresql*

![image](https://user-images.githubusercontent.com/42956663/57428070-a066da00-7261-11e9-883b-4423b6178797.png)



- 10버전이 없으면 설치 합니다.

>    rpm -Uvh https://yum.postgresql.org/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm



- yum list postgresql* 를 다시 확인해 보고 10버전이 생겼는지 확인후 인스톨 합니다.

>    yum install postgresql10.x86_64 postgresql10




- 설치후 psql -V  커맨드를 실행 시켜서 버전이 확인되면 정상 설치된 상태 입니다.

## 3. 백업 스크립트  
- 아래 스크립트에서 ip와 dump를 저장할 디렉토리를 지정합니다. (/data/db.dump.schema 이부분 입니다. tschema는 스키마명  tdb는 DB명입니다.)

> sudo pg_dump -h localhost -U user -Fd -f /data/db.dump.schema -j 20  -n tdb tschema


- 스크립트 실행이 완료 되면 백업 경로에 (/data/db.dump.schema) 압축된 파일이 있는지 확인 하면 backup은 종료 됩니다.

  
## 4. 복원 스크립트 
- 아래 스크립트에서 ip와 dump가 있는 디렉토리를 지정합니다. (/data/db.dump.schema 이부분 입니다)
> sudo pg_restore  -h DB서버ip  -U user -j 20 -d tdb /data/db.dump.schema

