import 'text'

MessageBox = {}
class('MessageBox').extends(gfx.sprite)

function MessageBox:init(width, height)
	MessageBox.super.init(self)
	self:setCenter(0, 0)
	self:setZIndex(90)
	self:setSize(width, height)

	local margin = math.min(height % 14, 5)
	self.textRect = Rect.new(margin, margin, width - margin * 2, height - margin * 2)
end

function MessageBox:setDark(dark)
	self.dark = dark
	if dark then
		self.textRect.y = self.textRect.x + 1
	else
		self.textRect.y = self.textRect.x
	end
	self:markDirty()
end

function MessageBox:setText(text)
	self.text = text
	self:markDirty()
end

function MessageBox:draw(x, y, width, height)
	gfx.setLineWidth(1)
	gfx.setStrokeLocation(gfx.kStrokeInside)

	local offset = 0
	if self.dark then
		gfx.setColor(gfx.kColorBlack)
		gfx.fillRect(0, self.height - 5, self.width, 5)
		offset = 1
	end
	self:drawRoundedBox(0, offset, self.width, self.height - offset)

	if self.text then
		if self.dark then
			gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
		end
		local w, h, trunc = gfx.drawTextInRect(self.text, self.textRect)
		if trunc then
			print("Rendered text was truncated!", self.text)
		end
		if self.dark then
			gfx.setImageDrawMode(gfx.kDrawModeCopy)
		end
	end
end

function MessageBox:drawRoundedBox(x, y, w, h)
	local rad = 4
	if self.dark then
		gfx.setColor(gfx.kColorBlack)
	else
		gfx.setColor(gfx.kColorWhite)
	end
	gfx.fillRoundRect(x, y, w, h, rad)
	if self.dark then
		gfx.setColor(gfx.kColorWhite)
	else
		gfx.setColor(gfx.kColorBlack)
	end
	gfx.drawRoundRect(x, y, w, h, rad)
	if self.dark then
		gfx.setColor(gfx.kColorBlack)
		gfx.drawRoundRect(x - 1, y - 1, w + 2, h + 2, rad + 1)
	end
end
