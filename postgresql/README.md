#DB Backup에 관해서 스크립트 정리 하였습니다.(현재 full backup과 schema 별 백업이 정리되어 있습니다.)

작업전고려 사항



백업이 가능한 충분한 용략이 확보 되어 있는지 확인 (압축 백업이라 원본의 20-30% 정도의 size가 나옵니다.)
DB 사이즈 구하기 : select PG_SIZE_PRETTY(pg_database_size('omop')); -- 이 sql실행시키면 DB용량을 확인 할수 있습니다.


서버의 어느 위치에 백업할지 확인하시고 바랍니다.
