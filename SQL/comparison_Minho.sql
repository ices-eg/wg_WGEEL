with MiPo as (SELECT 
	das_value as "MiPo_value",       
	das_year,
	das_comment as "MiPo_comment"
	/* 
	-- below those are data on effort, not used yet
	
	das_effort, 
	ser_effort_uni_code,       
	das_last_update,
	*/
	
	from datawg.t_dataseries_das 
	join datawg.t_series_ser on das_ser_id=ser_id
	left join ref.tr_lifestage_lfs on ser_lfs_code=lfs_code
	left join ref.tr_faoareas on ser_area_division=f_division
	where ser_typ_id=1
	and ser_nameshort in ('MiPo')),
MiSp AS (SELECT 
	das_value as "MiSp_value",       
	das_year,
	das_comment as "MiSp_comment"
	/* 
	-- below those are data on effort, not used yet
	
	das_effort, 
	ser_effort_uni_code,       
	das_last_update,
	*/
	
	from datawg.t_dataseries_das 
	join datawg.t_series_ser on das_ser_id=ser_id
	left join ref.tr_lifestage_lfs on ser_lfs_code=lfs_code
	left join ref.tr_faoareas on ser_area_division=f_division
	where ser_typ_id=1
	and ser_nameshort in ('MiSp'))
select "MiSp_value","MiPo_value", MiPo.das_year,"MiSp_comment","MiPo_comment" from MiPo join MiSp on (MiPo.das_year=MiSp.das_year)
