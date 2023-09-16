--
-- GutterSynthesis
-- 
-- norns wrapper for Tom Mudd's
-- GutterSynthesis
-- 
-- K1 -
-- K2 - Switch control pages
-- K3 - Switch control params
--
-- E1/E2/E3 - Adjust respective
-- control
--
-- Originally by Tom Mudd in
-- Max/MSP / Java
--
-- SuperCollider implementation
-- by Mads Kjeldgaard and
-- Scott Carver

local UI = require "ui"
engine.name = 'GutterSynthesis'

function init()
  params:add_separator()
  params:add_control("amp", "amp", controlspec.new(0, 4, "lin", 0.1, 1))
  params:set_action("amp", function(v) engine.amp(v) end)
  
  params:add_separator()
  params:add_control("mod", "mod", controlspec.new(0, 10, "lin", 0.1, 0.1))
  params:set_action("mod", function(v) engine.mod(v) end)
  
  params:add_control("omega", "omega", controlspec.new(0, 1, "lin", 0.01, 0.01))
  params:set_action("omega", function(v) engine.omega(v) end)
  
  params:add_control("damp", "damp", controlspec.new(0, 1, "lin", 0.01, 0.01))
  params:set_action("damp", function(v) engine.damp(v) end)
  
  params:add_control("rate", "rate", controlspec.new(0.01, 5, "exp", 0.01, 0.3))
  params:set_action("rate", function(v) engine.rate(v) end)
  
  params:add_control("gain", "gain", controlspec.new(0, 3.5, "lin", 0.1, 1))
  params:set_action("gain", function(v) engine.gain(v) end)
  
  params:add_control("smoothing", "smoothing", controlspec.new(0, 5, "lin", 0.1, 0.1))
  params:set_action("smoothing", function(v) engine.smoothing(v) end)
  
  params:add_separator("filter bank settings")
  params:add_control("pitch", "pitch", controlspec.new(0, 5, "lin", 0.01, 1))
  params:set_action("pitch", function(v) engine.pitch(v) end)
  
  params:add_control("q", "q", controlspec.new(10, 800, "lin", 10, 30))
  params:set_action("q", function(v) engine.q(v) end)
  
  params:add_control("scale1", "bank 1 scale", controlspec.new(0, 9, "lin", 1, 0))
  params:set_action("scale1", function(v) engine.scale1(v) end)
  
  params:add_control("scale2", "bank 2 scale", controlspec.new(0, 9, "lin", 1, 0))
  params:set_action("scale2", function(v) engine.scale2(v) end)
  
  params:add_control("gain1", "gain1", controlspec.new(0, 2.5, "lin", 0.1, 1))
  params:set_action("gain1", function(v) engine.gain1(v) end)
  
  params:add_control("gain2", "gain2", controlspec.new(0, 2.5, "lin", 0.1, 1))
  params:set_action("gain2", function(v) engine.gain2(v) end)
  params:bang()
  
  -- track current page (out of 2)
  page = 0
  -- track block on current page (out of 3)
  block = 0
  -- scale names
  scales = {"12tet","24tet","maj","min","hMaj","hMin","p_o1","p_u1","dim","bark"}
end

function redraw()
  screen.clear()
  screen.level(15)
  
  screen.font_face(2)
  screen.move(0,7)
  screen.text("GutterSynthesis")
  
  screen.line_width(1)
  screen.move(55,7)
  screen.line(126,7)
  screen.close()
  screen.stroke()
  
  --screen.font_face(0)
  if page == 0 then
     --screen.move(0,7)
     --screen.text("amp: " .. params:get("amp"))
     
     screen.move(4,17)
     screen.text("mod")
     UI.Slider.new(5,22,5,33,params:get("mod"),0,10,{0}):redraw()
     
     screen.move(24,17)
     screen.text("omg")
     UI.Slider.new(25,22,5,33,params:get("omega"),0,1,{0}):redraw()
  
     screen.move(44,17)
     screen.text("dmp")
     UI.Slider.new(45,22,5,33,params:get("damp"),0,1,{0}):redraw()
  
     screen.move(64,17)
     screen.text("rate")
     UI.Slider.new(65,22,5,33,params:get("rate"),0,5,{0}):redraw()
  
     screen.move(84,17)
     screen.text("gain")
     UI.Slider.new(85,22,5,33,params:get("gain"),0,3.5,{0}):redraw()
  
     screen.move(104,17)
     screen.text("smooth")
     UI.Slider.new(105,22,5,33,params:get("smoothing"),0,5,{0}):redraw()
  else
     --screen.move(0,7)
     --screen.text("amp: " .. params:get("amp"))
     
     screen.move(4,17)
     screen.text("pitch")
     UI.Slider.new(5,22,5,33,params:get("pitch"),0,3,{0}):redraw()
     
     screen.move(20,30)
     screen.text("SCALE:")
     
     screen.move(20,42)
     screen.text("1. " .. scales[params:get("scale1")+1])
     
     screen.move(20,52)
     screen.text("2. " .. scales[params:get("scale2")+1])
  
     screen.move(64,17)
     screen.text("Q")
     UI.Slider.new(65,22,5,33,params:get("q"),10,800,{0}):redraw()
  
     --screen.move(84,19)
     --screen.text("gain1")
     UI.Dial.new(89,14,10,params:get("gain1"),0,2.5,0.01,0,{},"gain1"):redraw()
  
     --screen.move(104,19)
     --screen.text("gain2")
     UI.Dial.new(89,36,10,params:get("gain2"),0,2.5,0.01,0,{},"gain2"):redraw()
  end
  
  -- line at bottom indicates active controls
  if block == 0 then
    screen.line_width(1)
    screen.move(0,60)
    screen.line(56,60)
    screen.close()
    screen.stroke()
  else
    screen.line_width(1)
    screen.move(59,60)
    screen.line(116,60)
    screen.close()
   screen.stroke()
  end
  
  screen.update()
end

function key(n,z)
  local a = n
  if n == 2 and z == 1 then
    page = (page + 1) % 2 
    block = 0
  elseif n == 3 and z == 1 then
    block = (block + 1) % 2
  end
  redraw()
  return(n)
end

function enc(n,d)
  
  if n == 1 and page == 0 and block == 0 then
    params:delta("mod",d)
  elseif n == 1 and page == 0 and block == 1 then
    params:delta("rate",d)
  elseif n == 1 and page == 1 and block == 0 then
    params:delta("pitch",d)
  elseif n == 1 and page == 1 and block == 1 then
    params:delta("q",d)
  end
  
  if n == 2 and page == 0 and block == 0 then
    params:delta("omega",d)
  elseif n == 2 and page == 0 and block == 1 then
    params:delta("gain",d)
  elseif n == 2 and page == 1 and block == 0 then
    params:delta("scale1",d)
  elseif n == 2 and page == 1 and block == 1 then
    params:delta("gain1",d)
  end
  
  if n == 3 and page == 0 and block == 0 then
    params:delta("damp",d)
  elseif n == 3 and page == 0 and block == 1 then
    params:delta("smoothing",d)
  elseif n == 3 and page == 1 and block == 0 then
    params:delta("scale2",d)
  elseif n == 3 and page == 1 and block == 1 then
    params:delta("gain2",d)
  end
  redraw()
end
