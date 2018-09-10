----- check for duplicates for sigmaa
-- total vs EMU
select TYP_NAME , EEL_YEAR, EEL_COU_CODE, EEL_LFS_CODE, EEL_HTY_CODE, 
total.sigmah as t_sigmah, total.nb as t_nb, emu.sigmah as e_sigmah, emu.nb as e_nb FROM
(SELECT TYP_NAME , EEL_YEAR, EEL_COU_CODE, EEL_LFS_CODE, EEL_HTY_CODE , sum(EEL_VALUE) as sigmah, COUNT(*) as nb
FROM DATAWG.sigmah where EEL_EMU_NAMESHORT like '%_total%' and EEL_MISSVALUEQUAL is null
group by TYP_NAME, EEL_YEAR, EEL_COU_CODE, EEL_LFS_CODE, EEL_HTY_CODE  ) as total full outer JOIN
(SELECT TYP_NAME , EEL_YEAR, EEL_COU_CODE, EEL_LFS_CODE, EEL_HTY_CODE  , sum(EEL_VALUE) as sigmah, COUNT(*) as nb
FROM DATAWG.sigmah where EEL_EMU_NAMESHORT not like '%_total%'  and EEL_MISSVALUEQUAL is null
group by TYP_NAME, EEL_YEAR, EEL_COU_CODE, EEL_LFS_CODE, EEL_HTY_CODE  ) as emu 
USING(TYP_NAME , EEL_YEAR, EEL_COU_CODE, EEL_LFS_CODE, EEL_HTY_CODE  )
where total.sigmah is not null and emu.sigmah is not null; -- landings by EMU and in total
-- where total.landings is null; -- only in EMU
-- where emu.landings is null; -- only in total

-- habitat AL vs others
select TYP_NAME , EEL_YEAR, EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_LFS_CODE, 
total.sigmah as t_sigmah, total.nb as t_nb, emu.sigmah as e_sigmah, emu.nb as e_nb FROM
(SELECT TYP_NAME , EEL_YEAR, EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_LFS_CODE , sum(EEL_VALUE) as sigmah, COUNT(*) as nb
FROM DATAWG.sigmah where EEL_HTY_CODE like '%AL%' and EEL_MISSVALUEQUAL is null
group by TYP_NAME, EEL_YEAR, EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_LFS_CODE  ) as total full outer JOIN
(SELECT TYP_NAME , EEL_YEAR, EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_LFS_CODE  , sum(EEL_VALUE) as sigmah, COUNT(*) as nb
FROM DATAWG.sigmah where EEL_HTY_CODE not like '%AL%'  and EEL_MISSVALUEQUAL is null
group by TYP_NAME, EEL_YEAR, EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_LFS_CODE  ) as emu 
USING(TYP_NAME , EEL_YEAR, EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_LFS_CODE  )
where total.sigmah is not null and emu.sigmah is not null;

-- lifestage YS vs Y + S / AL vs others

select TYP_NAME , EEL_YEAR, EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_HTY_CODE, 
total.sigmah as t_sigmah, total.nb as t_nb, emu.sigmah as e_sigmah, emu.nb as e_nb FROM
(SELECT TYP_NAME , EEL_YEAR, EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_HTY_CODE , sum(EEL_VALUE) as sigmah, COUNT(*) as nb
FROM DATAWG.sigmah where EEL_LFS_CODE like '%YS%' and EEL_MISSVALUEQUAL is null
group by TYP_NAME, EEL_YEAR, EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_HTY_CODE  ) as total full outer JOIN
(SELECT TYP_NAME , EEL_YEAR, EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_HTY_CODE  , sum(EEL_VALUE) as sigmah, COUNT(*) as nb
FROM DATAWG.sigmah where EEL_LFS_CODE in ('Y','S')  and EEL_MISSVALUEQUAL is null
group by TYP_NAME, EEL_YEAR, EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_HTY_CODE  ) as emu 
USING(TYP_NAME , EEL_YEAR, EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_HTY_CODE  )
where total.sigmah is not null and emu.sigmah is not null;


select TYP_NAME , EEL_YEAR, EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_HTY_CODE, 
total.sigmah as t_sigmah, total.nb as t_nb, emu.sigmah as e_sigmah, emu.nb as e_nb FROM
(SELECT TYP_NAME , EEL_YEAR, EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_HTY_CODE , sum(EEL_VALUE) as sigmah, COUNT(*) as nb
FROM DATAWG.sigmah where EEL_LFS_CODE like '%AL%' and EEL_MISSVALUEQUAL is null
group by TYP_NAME, EEL_YEAR, EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_HTY_CODE  ) as total full outer JOIN
(SELECT TYP_NAME , EEL_YEAR, EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_HTY_CODE  , sum(EEL_VALUE) as sigmah, COUNT(*) as nb
FROM DATAWG.sigmah where EEL_LFS_CODE not like '%AL%'  and EEL_MISSVALUEQUAL is null
group by TYP_NAME, EEL_YEAR, EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_HTY_CODE  ) as emu 
USING(TYP_NAME , EEL_YEAR, EEL_COU_CODE, EEL_EMU_NAMESHORT, EEL_HTY_CODE  )
where total.sigmah is not null and emu.sigmah is not null;