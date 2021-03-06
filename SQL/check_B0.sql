----- check for duplicates for landings
-- total vs EMU
select TYP_NAME , EEL_YEAR, EEL_COU_CODE, EEL_LFS_CODE, EEL_HTY_CODE, 
total.b0 as t_b0, total.nb as t_nb, emu.b0 as e_b0, emu.nb as e_nb FROM
(SELECT TYP_NAME , EEL_YEAR, EEL_COU_CODE, EEL_LFS_CODE, EEL_HTY_CODE , sum(EEL_VALUE) as b0, COUNT(*) as nb
FROM DATAWG.B0 where EEL_EMU_NAMESHORT like '%_total%' and EEL_MISSVALUEQUAL is null
group by TYP_NAME, EEL_YEAR, EEL_COU_CODE, EEL_LFS_CODE, EEL_HTY_CODE  ) as total full outer JOIN
(SELECT TYP_NAME , EEL_YEAR, EEL_COU_CODE, EEL_LFS_CODE, EEL_HTY_CODE  , sum(EEL_VALUE) as b0, COUNT(*) as nb
FROM DATAWG.B0 where EEL_EMU_NAMESHORT not like '%_total%'  and EEL_MISSVALUEQUAL is null
group by TYP_NAME, EEL_YEAR, EEL_COU_CODE, EEL_LFS_CODE, EEL_HTY_CODE  ) as emu 
USING(TYP_NAME , EEL_YEAR, EEL_COU_CODE, EEL_LFS_CODE, EEL_HTY_CODE  )
where total.b0 is not null and emu.b0 is not null; -- landings by EMU and in total
-- where total.landings is null; -- only in EMU
-- where emu.landings is null; -- only in total

-- habitat AL vs others
select TYP_NAME , EEL_YEAR, EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_LFS_CODE, 
total.b0 as t_b0, total.nb as t_nb, emu.b0 as e_b0, emu.nb as e_nb FROM
(SELECT TYP_NAME , EEL_YEAR, EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_LFS_CODE , sum(EEL_VALUE) as b0, COUNT(*) as nb
FROM DATAWG.B0 where EEL_HTY_CODE like '%AL%' and EEL_MISSVALUEQUAL is null
group by TYP_NAME, EEL_YEAR, EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_LFS_CODE  ) as total full outer JOIN
(SELECT TYP_NAME , EEL_YEAR, EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_LFS_CODE  , sum(EEL_VALUE) as b0, COUNT(*) as nb
FROM DATAWG.B0 where EEL_HTY_CODE not like '%AL%'  and EEL_MISSVALUEQUAL is null
group by TYP_NAME, EEL_YEAR, EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_LFS_CODE  ) as emu 
USING(TYP_NAME , EEL_YEAR, EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_LFS_CODE  )
where total.b0 is not null and emu.b0 is not null;

-- nb of B0 per country
select TYP_NAME, EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_LFS_CODE, eel_hty_code, count(*) from datawg.b0
group by TYP_NAME, EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_LFS_CODE, eel_hty_code
having count(*) >1
order by EEL_COU_CODE, EEL_EMU_NAMESHORT;

select * from datawg.b0 where EEL_EMU_NAMESHORT = 'LT_total'
