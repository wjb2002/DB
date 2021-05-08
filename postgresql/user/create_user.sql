/*  
 * 유저 생성용 스크립트
 * 
 * */
CREATE ROLE test_user;  -- role생성


create schema test_schema; --test_user 스키마


/* 스키마 접근 권한을 준다 */
GRANT USAGE ON SCHEMA test_schema TO test_user; 






------------------------------------------------------- 
-- 해당 스키마에 권한 주기
GRANT ALL  on SCHEMA test_schema TO test_user;;

---------------------------------------------------
-- 해당 스키마에  모든 권한 주기  
GRANT all  ON ALL tables in  SCHEMA test_schema TO test_user;;



CREATE USER test_user01 PASSWORD '1qaz2wsx' IN ROLE test_user;  -- user 생성 추후 필요 하면 더 생성 하면 됩니다. test_user01, test_user02 등등

