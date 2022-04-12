  1: 
  2: drop table if exists law_keys ;
  3: drop table if exists law_doument_hist ;
  4: drop table if exists law_doument ;
  5: drop table if exists law_case_hist ;
  6: drop table if exists law_case ;
  7: 
  8: create table if not exists law_case (
  9:     case_id         serial primary key not null,
 10:     case_name         text not null,
 11:     case_desc         text not null,
 12:     deleted         varchar(1) not null default 'n',
 13:     updated         timestamp,                                                             
 14:     created         timestamp default current_timestamp not null                     
 15: );
 16: 
 17: create table if not exists law_case_hist (
 18:     case__hist_id     serial primary key not null,
 19:     activity         text not null,
 20:     case_id         int not null,
 21:     case_name         text not null,
 22:     case_desc         text not null,
 23:     deleted         varchar(1) not null,
 24:     updated         timestamp,                                                             
 25:     created         timestamp
 26: );
 27: 
 28: create table if not exists law_doument (
 29:     document_id     serial primary key not null,
 30:     case_id         int references law_case(case_id),
 31:     document_name     text,
 32:     document_desc     text,
 33:     hash             text,
 34:     file_id         text,
 35:     file_signature    text,
 36:     tx                text,
 37:     deleted         varchar(1) not null default 'n',
 38:     updated         timestamp,                                                             
 39:     created         timestamp default current_timestamp not null                     
 40: );
 41: 
 42: create table if not exists law_doument_hist (
 43:     document_hist_id serial primary key not null,
 44:     activity         text not null,
 45:     document_id     int not null,
 46:     case_id         int references law_case(case_id),
 47:     document_name     text,
 48:     document_desc     text,
 49:     hash             text,
 50:     file_id         text,
 51:     file_signature    text,
 52:     tx                text,
 53:     deleted         varchar(1) not null,
 54:     updated         timestamp,                                                             
 55:     created         timestamp
 56: );
 57: 
 58: create table if not exists law_keys (
 59:     keys_id serial primary key not null,
 60:     case_id int references law_case(case_id),
 61:     key_enc text not null,
 62:     deleted varchar(1) not null default 'n'
 63: );
