
drop table if exists law_keys ;
drop table if exists law_doument_hist ;
drop table if exists law_doument ;
drop table if exists law_case_hist ;
drop table if exists law_case ;

create table if not exists law_case (
	case_id 		serial primary key not null,
	case_name 		text not null,
	case_desc 		text not null,
	deleted 		varchar(1) not null default 'n',
	updated 		timestamp,									 						
	created 		timestamp default current_timestamp not null 					
);

create table if not exists law_case_hist (
	case__hist_id 	serial primary key not null,
	activity 		text not null,
	case_id 		int not null,
	case_name 		text not null,
	case_desc 		text not null,
	deleted 		varchar(1) not null,
	updated 		timestamp,									 						
	created 		timestamp
);

create table if not exists law_doument (
	document_id 	serial primary key not null,
	case_id 		int references law_case(case_id),
	document_name 	text,
	document_desc 	text,
	hash 			text,
	file_id 		text,
	file_signature	text,
	tx				text,
	deleted 		varchar(1) not null default 'n',
	updated 		timestamp,									 						
	created 		timestamp default current_timestamp not null 					
);

create table if not exists law_doument_hist (
	document_hist_id serial primary key not null,
	activity 		text not null,
	document_id 	int not null,
	case_id 		int references law_case(case_id),
	document_name 	text,
	document_desc 	text,
	hash 			text,
	file_id 		text,
	file_signature	text,
	tx				text,
	deleted 		varchar(1) not null,
	updated 		timestamp,									 						
	created 		timestamp
);

create table if not exists law_keys (
	keys_id serial primary key not null,
	case_id int references law_case(case_id),
	key_enc text not null,
	deleted varchar(1) not null default 'n'
);
