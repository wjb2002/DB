- postgresql의 파라미터들에 대해서 정리중입니다.


##### #default_statistics_target

이것은 통계와 관련이 있습니다. PostgreSQL 쿼리 플래너는 개별 테이블에 통계를 필요로 합니다. 
만약 이 값이 적다면, 쿼리 플래너의 결과가 달라집니다. 
대신 이 값이 너무 높으면 PostgreSQL 는 개별테이블의 통계를 수집하는데 많은 시간을 사용하게 됩니다.
만약 ‘LIKE’ 쿼리를 자주 사용한다면, 이값을 증가시켜줄 필요가 있습니다.  하지만 기본적인  값으로도 괜찮습니다.



##### #maintenance_work_mem

maintenance 연산은 ‘CREATE INDEX, ALTER TABLE ADD FOREIGN KEY’ 그리고 ‘VACUUM’ 와 깊이 연관이 있습니다. 
SELECT 전용으로만 사용한다면 VACUUM은 필요가 없습니다. 
하지만 덤프 파일을 Restore 할때에 인덱스를 생성하거나 ALTER TABLE 를 많이 사용되게 됩니다.
따라서 만약, 덤프 파일을 가지고 빠른 Restore 를 하고 싶다면 이 값을 조정해줘야 합니다. 
단, 이 값은 work_mem 보다 항상 높아야 합니다. 그리고 이 값은 autovacuum_max_workers 값과 관련이 높습니다.
통상적으로 이값은 전체 메모리의 5% 정도로 잡습니다. 만약 32GB 라면 이값은 1600MB 입니다.



##### #constraint_exclusion

이 값은 파티션 테이블과 관련이 깊습니다. 만약 파티션 테이블을 사용한다면, 반드신 설정을 해줘야 합니다. 
성능향상을 위해서 상속이나 파티션된 테이블을 자주 사용됩니다.



##### #checkpoint_completion_target

0.9 가 기본값인데, 대부분 괜찮습니다.



##### #effective_cache_size

이 크기는 리눅스 시스템에서 모든 애플리케이션을 끈 상태에서 cache 메모리 크기를 봐야 합니다. 
이 크기만큼 보통 할당을 합니다. 예를들어 리눅스 캐쉬 사용량이 22GB 라고한다면 이값을 22GB 정도 주면 됩니다.
이렇게 값을 준다고해서 실제로 메모리가 할당이 되지 않습니다. 
쿼리 플래너가 작업을 할때에 잠깐사용 합니다. 
만약 이를 값이 적다면 리눅스는 파일 시스템을 사용하게 되어서 성능이 저하됩니다.



##### #max_connections  

동시 접속자 수 설정은 work_mem 값을 설정 시 고려해야 할 값으로 max_connections 값이 클수록 work_mem 을 낮게 잡게 됩니다. 서비스 클라이언트 수를 고려하여 적당히 설정하는 것이 중요합니다. 이 서비스의 경우는 connections 수가 많지 않다고 하셨기 때문에 기본값인 100 으로 설정하시길 권고 드립니다. (DB restart 가 필요) 



##### #work_mem

이 메모리는 복잡한 sort가 많이 사용되거나 큰 sort 가 필요하다면 이 값을 증가 시켜줄 필요가 있습니다. 
Hash Join, Merge join, Bitmp 작업등을 할때 사용
한가지 조심해야 할 것은 이 값은 각 사용자 세션별로 할당이 됩니다. 
따라서 이 값을 정할때에 PostgreSQL 의 최대 접속자를 고려해야 합니다.
이 값을 대략 다음과 같이 계산을 합니다.
( OS cache memory / connections ) * 0.5
만약 OS cache memory 사용량이 28GB 이거나 접속량이 20 이라면 다음과 같습니다.
(28000/20)*0.5 = 700MB
(총메모리 - shared_buffers - maintenance_work_mem) / max_connections



##### #shared_buffers

전체 메모리의 25% 정도가 적당합니다. 만일 32GB 메모리를 사용한다면 대략 8GB 정도면 충분합니다.



##### #wal_buffers 

트랜잭션 로그 버퍼
공유 버퍼 조정으로 디스크 캐싱하여 성능이 확보 되었다면, 신뢰성을 보장하는 트랜잭션 로그에 대한 설정도 필요
데이터를 업데이트 할 때 어떤 변경을 할 것 인지를 남기는 로그이며, PostgreSQL에서는 WAL(Write Ahead Log)이라 명칭함
손실된 데이터 복원에 아주 중요한 역할
config파일에서 wal_buffers 값 변경, 일반적으로 shared_buffers의 1/32 크기로 지정
postgresql.conf 내 wal_buffers 설정



##### #checkpoint_timeout 

체크포인트 간격 시간을 지정하는 값으로 현재는 기본값인 5min으로 설정되어 있습니다. 체크포인트가 자주 발생하게 되면 DB에 부하 및 성는저하를 유발할 수 있기 때문에 체크포인트 수행을 좀 더디게 발생시키도록 15min~20min 정도로 설정하시길.



##### #random_page_cost  

기본값은 4.0으로 이 값이 낮을수록 optimizer 가 실행계획 수립 시 인덱스를 사용하게 되는데, 현재 이 서비스의 경우는 pk 외에 인덱스는 거의 생성하지 않는 것으로 확인 하였습니다. 값을 1.1로 설정하여 인덱스 스캔에 유리할 것으로 보이나 경우에 따라 풀 스캔이 성능이 더 빠를 수 있기 때문에 이 값은 테스트 후 적절히 조절하시길 권고 드립니다. 



##### #logging_collector

DB 로그 수집 여부를 지정하는 파라미터로 현재는 off 설정입니다. DB 로그는 문제 발생 시 로그 분석을 통해 원인을 파악에 도움이 될 수 있으므로 반드시 설정해 주시길 권고드립니다. (DB restart 가 필요) 



#####  #log_min_duration_statement 

쿼리 중 설정한 시간 이상 수행 된 Slow 쿼리를 로깅하여 쿼리튜닝 대상을 선정할 때 도움이 될 수 있습니다. 너무 낮은 값 설정으로 로그가 너무 많이 발생하게 되면 로그 분석 시 가독성이 떨어질 수 있으므로 적절한 설정 값이 필요합니다. 현재는 -1 로 disable 설정이며, 필요하지 않으시면 현재설정 그대로 사용하시면 됩니다.  

ex) log_min_duration_statement = 5s 



##### #synchronous_commit 

WAL recored 의 디스크 write 완료 리턴 여부를 설정하는 값으로 기본값은 on입니다. 안정성을 위하여 일반적으로는 on으로 설정하며 성능이 중요한 서비스의 경우 off 설정 시 성능개선에 큰 영향을 줍니다. 인스턴스 전체에 설정하거나, 성능이 중요한 쿼리 수행 앞단에 세션 Level 로 off 설정 후 쿼리를 수행할 수도 있습니다. 



##### #max_worker_processes / max_parallel_workers / max_parallel_workers_per_gather 

 max_parallel_workers_per_gather 값은 max_parallel_workers 값에 제한되며, max_parallel_workers 은  max_worker_processes 값에 제한됩니다. (max_worker_processes > max_parallel_workers > max_parallel_workers_per_gather) 기본값은 0이 아니므로 병렬쿼리 사용 가능한 설정 입니다. 
인스턴스 전체에서 실행 가능한 병렬 프로세스는 수는 max_parallel_workers 값이고  세션의 병렬 작업에 사용 가능한 프로세스는 최대 max_parallel_workers_per_gather 값 입니다.  
이 파라미터는 특정한 권고값이 있다기 보다는 수행되는 쿼리와 오브젝트 크기에 따라서 세션에서 사용되는 병렬 프로세스 수가 달라질 수 있기 때문에 이 두 값을 변경하면서 최적의 값을 찾아야 할 것으로 보입니다. 
max_worker_processes 값은 restart 가 필요한 값인데,  max_parallel_workers 와 max_parallel_workers_per_gather 값은 reload로 변경가능 하기 때문에  max_worker_processes 값은 CPU 코어 보다는 작은 값으로 설정하여 초기 구동하시고 나머지 두 파라미터 값 조절로 적정한 값을 찾으시길 권고 드립니다. 

##### #log_filename

로그 파일을 설정합니다. 아래와 같이 작성하면 일자별로 로그가 생성됩니다.  
log_filename = 'postgresql-10-main-%Y-%m-%d.log'
