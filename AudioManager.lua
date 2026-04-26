local AudioManager = {sounds = {}}

function AudioManager:initialize()
  self.sounds.Texplosion = love.audio.newSource("assets/sounds/tank Explosion.wav", "static");
  self.sounds.Rexplosion = love.audio.newSource("assets/sounds/rocket explosion.wav", "static")
  self.sounds.music = love.audio.newSource("assets/sounds/lasha.ogg", "stream");
  self.sounds.music:setLooping(true);
end

function AudioManager:playMusic()
    self.sounds.music:play();
end

function AudioManager:Texplosion()
    self.sounds.Texplosion:play();
end

function AudioManager:Rexplosion()
    self.sounds.Rexplosion:play();
end

function AudioManager:stopMusic()
    self.sounds.music:stop();
end

return AudioManager;