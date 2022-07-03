font11 = gfx.font.new('fonts/font-Bitmore')
font11:setTracking(1)
font11bold = gfx.font.new('fonts/font-Bitmore-Bold')
fontFamily11 = {
	[gfx.font.kVariantNormal] = font11,
	[gfx.font.kVariantBold] = font11bold,
}

-- font12 = gfx.font.new('fonts/font-pedallica')
-- font12:setTracking(1)
-- fontFamily12 = {
-- 	[gfx.font.kVariantNormal] = font12,
-- }

font14 = gfx.font.new('fonts/font-pedallica-ren-14')
font14bold = gfx.font.new('fonts/font-pedallica-ren-14-bold')
fontFamily14 = {
	[gfx.font.kVariantNormal] = font14,
	[gfx.font.kVariantBold] = font14bold,
}

font15 = gfx.font.new('fonts/Oklahoma-Bold')
font15:setTracking(1)
font15italic = gfx.font.new('fonts/Oklahoma-Bold-Italic')
font15italic:setTracking(1)
fontFamily15 = {
	[gfx.font.kVariantNormal] = font15,
	[gfx.font.kVariantItalic] = font15italic,
}

-- font16 = gfx.font.new('fonts/font-pedallica-fun-16')
-- font16:setTracking(1)
-- fontFamily16 = {
-- 	[gfx.font.kVariantNormal] = font16,
-- }

-- font24 = gfx.font.new('fonts/Roobert-24-Medium')
font24round = gfx.font.new('fonts/Asheville-Rounded-24-px')
font24round:setTracking(1)
-- fontFamily24 = {
-- 	[gfx.font.kVariantNormal] = font24,
-- }

gfx.setFontFamily(fontFamily14)

function sampleFonts()
	gfx.drawText('Lv12  EXP  11 / 18 Bitmore',   10, 10, fontFamily11)
	gfx.drawText('*Lv12  EXP  11 / 18 Bitmore Bold*', 10, 35, fontFamily11)
	-- gfx.drawText('Lv12  EXP  12 / 18 Pedallica', 10, 60, fontFamily12)
	gfx.drawText('Lv12  EXP  15 / 18 Oklahoma',  10, 90, fontFamily15)
	-- gfx.drawText('_Lv12  EXP  15 / 18 Oklahoma Italic_',  10, 120, fontFamily15)
	gfx.drawText('Lv12  EXP  14 / 18 Pedallica', 10, 150, fontFamily14)
	gfx.drawText('*Lv12  EXP  14 / 18 Pedallica Bold*', 10, 180, fontFamily14)
	-- gfx.drawText('Lv12  EXP  16 / 18 Pedallica', 10, 210, fontFamily16)
end
